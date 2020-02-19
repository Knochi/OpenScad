$fn=20;
/* [Dimensions]  */
fudge=0.1;

Midas69x16();

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