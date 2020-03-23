$fn=20;
/* [Dimensions]  */
fudge=0.1;

Midas69x16();

translate([100,0,0]) LCD_20x4();
translate([200,0,0]) LCD_16x2();
translate([320,0,0]) FutabaVFD();

module Midas69x16(orientation="flat",center=true){
  glassThck=0.55;
  flxRad=0.25; //edge rad of Panel
  flxPnl=1.2; //width of Flex on Panel
  flxDimTap=[[10.5,6.8,4],[7.5,9],0.1];
  bend=1.6;
  panelDim=[26.3,8,1.3];
  polDim=[21.7,7,0.2];
  AADim=[17.26,3.18,0.01]; //active Area
  AAPos=[2.275,panelDim.y-1.8-AADim.y,polDim.z];
  capSize=22.7;
  pitch=0.62;
  padDim=[2,0.32,0.01];
  pads=14;
  
  cntrOffset= (center) ? -(AAPos + [AADim.x/2,AADim.y/2,-panelDim.z-flxDimTap.z]) : [0,0,0];
  
  flxPoly=//[[-flxDimTap.x[0]-flxPnl+flxRad,flxDimTap.y[0]/2],
           [[-flxDimTap.x[1],flxDimTap.y[0]/2],
           [-flxDimTap.x[2],flxDimTap.y[1]/2],
           [-flxRad,flxDimTap.y[1]/2],
           [-flxRad,-flxDimTap.y[1]/2],
           [-flxDimTap.x[2],-flxDimTap.y[1]/2],
           [-flxDimTap.x[1],-flxDimTap.y[0]/2]];
           //[-flxDimTap.x[0]-flxPnl+flxRad,-flxDimTap.y[0]/2]];
  
  translate(cntrOffset){
  //Active Area
  color("SlateGrey") translate(AAPos) cube(AADim);
  //Polarizer
  color("grey",0.5)
    translate([0.5,0.5,0]) cube(polDim);
  //topGlass
  color("lightgrey",0.5) 
    translate([0,0,-glassThck]) cube([panelDim.x,panelDim.y,glassThck]);
  //btmGlass
  color("lightgrey",0.5)
    translate([0,0,-glassThck*2]) cube([capSize,panelDim.y,glassThck]);
  //IC
  color("darkSlateGrey")
    translate([23.6,(8-6.8)/2,-glassThck-0.3]) cube([0.8,6.8,0.3]);
  flex();
  }
  
  module flex(){
    //flex straight
    if (orientation=="straight") color("orange"){
      flxBrdg=[flxDimTap.x[0]+flxPnl-flxRad-flxDimTap.x[1],flxDimTap.y[0],flxDimTap.z];
      translate([36.8,panelDim.y/2,-flxDimTap.z-glassThck]){
        difference(){
          union(){
            linear_extrude(flxDimTap.z)
              polygon(flxPoly);
            translate([-flxDimTap.x[0]+flxBrdg.x/2-flxPnl+flxRad,0,0])
              cube(flxBrdg,true);
            hull() for (iy=[-1,1])
              translate([-flxDimTap.x[0]+flxRad-flxPnl,iy*(flxDimTap.y[0]/2-flxRad),0]) cylinder(r=flxRad,h=flxDimTap.z);
            hull() for (iy=[-1,1])
              translate([-flxRad,iy*(flxDimTap.y[1]/2-flxRad),0]) cylinder(r=flxRad,h=flxDimTap.z);
          }
          for (iy=[-1,1])
            translate([-6.1,iy*6.2/2,-fudge/2]) cylinder(d=0.8,h=flxDimTap.z+fudge);
        }
      }
    }
     if (orientation=="flat"){
       flxBrdg=[1.6-glassThck/2+flxPnl-flxRad,flxDimTap.y[0],flxDimTap.z];
       translate([0,panelDim.y/2,-glassThck]){
         translate([19.271,0,-glassThck]) rotate([0,180,0]) {
          color("orange"){
            linear_extrude(flxDimTap.z) polygon(flxPoly);
          hull() for (iy=[-1,1])
          translate([-flxRad,iy*(flxDimTap.y[1]/2-flxRad),0]) cylinder(r=flxRad,h=flxDimTap.z);       
         }
          //pads
          color("silver")
          for (iy=[-(pads-1)*pitch/2:pitch:(pads-1)*pitch/2],iz=[flxDimTap.z,0])
            translate([-padDim.x/2,iy,iz]) 
              cube(padDim,true);
         }
         color ("orange") {
         translate([panelDim.x+flxDimTap.x[0],0,-flxDimTap.z])
          hull() for (iy=[-1,1])
            translate([-flxDimTap.x[0]+flxRad-flxPnl,iy*(flxDimTap.y[0]/2-flxRad),0]) cylinder(r=flxRad,h=flxDimTap.z);
         //bend flex
         translate([panelDim.x+1.6-glassThck/2,0,-(glassThck+flxDimTap.z)/2]) rotate([90,90,0]) 
            rotate_extrude(angle=180) translate([glassThck/2,0]) square([flxDimTap.z,flxDimTap.y[0]],true);
         //bridges
         translate([panelDim.x+flxBrdg.x/2-flxPnl+flxRad,0,-flxDimTap.z/2])
              cube(flxBrdg,true);
         translate([panelDim.x+flxBrdg.x/2-flxPnl+flxRad,0,-flxDimTap.z/2-glassThck])
              cube(flxBrdg,true);
        }
       }
     }
   } //module Flex    
}



module LCD_16x2(){
  chars=[16,2];
  chrDim=[2.95,4.35];
  chrPitch=[chrDim.x+0.7,chrDim.y+0.7];
  PCBDim=[80,36,1.6];
  dispDim=[71.3,26.8,8.9];
  viewArea=[64.5,13.8,0.5];
  dispOffset=[PCBDim.x/2-40,PCBDim.y/2-19.2,0]; //offset from lower left edge

  //PCB
  color("darkgreen") translate([0,0,-PCBDim.z/2]) cube(PCBDim,true);

  //Display
  difference(){
    color("darkSlateGrey") translate(dispOffset+[0,0,dispDim.z/2]) cube(dispDim,true);
    color("blue")translate(dispOffset+[0,0,(dispDim.z-viewArea.z/2)])  
      cube(viewArea+[0,0,fudge],true);    
  }
  //segments
  translate(dispOffset+[0,0,dispDim.z-viewArea.z]) 
    for (ix=[-(chars.x-1)/2:(chars.x-1)/2],iy=[-(chars.y-1)/2:(chars.y-1)/2])
      translate([ix*chrPitch.x,iy*chrPitch.y]) color("lightblue") square(chrDim,true);
}

module LCD_20x4(){
  chars=[20,4];
  chrDim=[2.95,4.75];
  chrPitch=[chrDim.x+0.6,chrDim.y+0.6];
  PCBDim=[98,60,1.6];
  dispDim=[96.8,39.3,9];
  viewArea=[77,25.2,0.5];
  dispOffset=[PCBDim.x/2-49,PCBDim.y/2-39.3/2-10.35,0]; //offset from lower left edge

  //PCB
  color("darkgreen") translate([0,0,-PCBDim.z/2]) cube(PCBDim,true);

  //Display
  difference(){
    color("darkSlateGrey") translate(dispOffset+[0,0,dispDim.z/2]) cube(dispDim,true);
    color("blue")translate(dispOffset+[0,0,(dispDim.z-viewArea.z/2)])  
      cube(viewArea+[0,0,fudge],true);    
  }
  //segments
  translate(dispOffset+[0,0,dispDim.z-viewArea.z]) 
    for (ix=[-(chars.x-1)/2:(chars.x-1)/2],iy=[-(chars.y-1)/2:(chars.y-1)/2])
      translate([ix*chrPitch.x,iy*chrPitch.y]) color("lightblue") square(chrDim,true);
}


module FutabaVFD(){
  // Type M162MD07AA-000 
  chars=[16,2];
  chrDim=[3.7,8.46];
  chrPitch=[4.95,9.74];
  PCBDim=[122,44,1.6];
  dispDim=[106.2,33.5,8];
  viewArea=[77.95,18.2,0.5];
  //offset from lower left edge of PCB to Display center
  dispOffset=[-(PCBDim.x-dispDim.x)/2,-(PCBDim.y-dispDim.y)/2,0]+[7.9,6.25,1.8]; 

  //PCB
  color("darkgreen") translate([0,0,-PCBDim.z/2]) cube(PCBDim,true);

  //Display
  difference(){
    color("darkSlateGrey") translate(dispOffset+[0,0,dispDim.z/2]) cube(dispDim,true);
    color("blue")translate(dispOffset+[0,0,(dispDim.z-viewArea.z/2)])  
      cube(viewArea+[0,0,fudge],true);    
  }
  //segments
  translate(dispOffset+[0,0,dispDim.z-viewArea.z]) 
    for (ix=[-(chars.x-1)/2:(chars.x-1)/2],iy=[-(chars.y-1)/2:(chars.y-1)/2])
      translate([ix*chrPitch.x,iy*chrPitch.y]) color("lightblue") square(chrDim,true);
}

module HCS12SS(){
  ovDim=[100,20.5,6.3];
  //Samsung VFD module 
  color("darkSlateGrey") translate([0,0,ovDim.z/2]) cube(ovDim,true);
  for (ix=[-11/2:11/2]) translate([ix*(74/11),0,ovDim.z]) pattern();

  module pattern(){
    pxDim=0.45;
    tilt=3;
    pitch=0.6;
    xyOffset=[tan(tilt)*pitch,pitch]; //tan(a)=GK/AK
    frm=[tan(tilt)*4.5,4.5];
    color("cyan") linear_extrude(0.1) 
      polygon([[-4.3/2+frm.x,frm.y],[4.3/2+frm.x,frm.y],
               [4.3/2-frm.x,-frm.y],[-4.3/2-frm.x,-frm.y]]);

    *translate(xTilt(1,tilt)) for (i=[0:4])
      translate(xyOffset*i) square(pxDim,true);
  }
}



function xTilt(dist,ang)=[tan(ang)*dist,dist]; 