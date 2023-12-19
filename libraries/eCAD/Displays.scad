include <KiCADColors.scad>
use <connectors.scad>
use <MPEGarry.scad>
$fn=20;
/* [Dimensions]  */
fudge=0.1;

Midas96x16();
translate([0,100,0]) EA_W128032(center=true);
translate([100,0,0]) LCD_20x4();
translate([100,60,0]) LCD_16x2();
translate([100,120,0]) FutabaVFD();
translate([200,0,0]) Adafruit128x128TFT();
translate([300,0,0]) AdafruitOLED23();
translate([500,0,0]) raspBerry7Inch();
translate([100,180,0]) EA_DOGS164_A();


//double 7-segment display
*KingbrightACDx03();
module KingbrightACDx03(){
  //https://www.kingbrightusa.com/images/catalog/SPEC/ACDA03-41SEKWA-F01.pdf
  
  bdyDims=[7.2,10,2.95];
  pcbDims=[14.8,12,0.8];
  sgmntDeep=1; //how deep to carve out the segments
  coatThck=0.05; //grey coating
  copperThck=0.035; //copper plating
  pins=20;
  pinDims=[1,1.3,pcbDims.z+copperThck*2];
  pitch=1.5;
  
  //bodies
  translate([0,0,pcbDims.z]) difference(convexity=3){
    union(){
      color(whiteBodyCol) for (ix=[-1,1]) 
        translate([ix*(pcbDims.x-bdyDims.x)/2,0,0]) 
          linear_extrude(bdyDims.z-coatThck,convexity=3)
            square([bdyDims.x,bdyDims.y],true);
      color(greyBodyCol) for (ix=[-1,1]) 
        translate([ix*(pcbDims.x-bdyDims.x)/2,0,bdyDims.z-coatThck]) 
          linear_extrude(coatThck,convexity=3)
            square([bdyDims.x,bdyDims.y],true);
    }
    for (ix=[-1,1]) translate([ix*(pcbDims.x-bdyDims.x)/2,0,bdyDims.z-sgmntDeep]) 
      linear_extrude(sgmntDeep+fudge)
        sevenSegment();
  }
  
  //digits
  color(whiteBodyCol) for (ix=[-1,1])
    translate([ix*(pcbDims.x-bdyDims.x)/2,0,pcbDims.z+bdyDims.z-sgmntDeep]) 
      linear_extrude(sgmntDeep,convexity=3)
        sevenSegment();
  
  //pcb
  color(FR4Col) linear_extrude(pcbDims.z) difference(){
    square([pcbDims.x,pcbDims.y],true);
    for (ix=[-((pins/2-1)/2):((pins/2-1)/2)],iy=[-1,1])
      translate([ix*pitch,iy*pcbDims.y/2]) circle(d=0.65+copperThck);
  }
  //pins
  color(metalGoldPinCol) translate([0,0,-copperThck]) for (ix=[-((pins/2-1)/2):((pins/2-1)/2)],iy=[-1,1])
    linear_extrude(pinDims.z) difference(){
      translate([ix*pitch,iy*(pcbDims.y-pinDims.y+copperThck)/2]) 
        square([pinDims.x,pinDims.y],true);
      translate([ix*pitch,iy*pcbDims.y/2]) circle(d=0.65);
    }
}

*OLED1_3inch4pin();
module OLED1_3inch4pin(center=false){
  //chinese OLED display 4pin 1.3Inch
  //like: https://de.aliexpress.com/item/32844104782.html
  
  //Dimensions of the elements
  PCBDims=[35.4,33.5,1.2];
  glassDims=[35,23,1.5];
  aaDims=[29.42,14.7,0.02]; //active area
  cutOutDims=[14,4.5]; //cutOut at the bottom
  
  //offsets from top of PCB to top of element
  holeYOffset=-2.5;
  glassYOffset=-5.25;
  hdrYOffset=-2;
  aaYOffset=-7.35;
  
  //mounting hole pattern
  holeDist=[30.4,28.5];
  
  //inner and outer diameter of mounting holes (PTH)
  holeDiaIn=3; //drill
  holeDiaOut=4.5; //copper
  
  //microfudge to isolate surfaces
  mfudge=0.1;
  
  cntrOffset= center ? [0,0,0] : [2.54*1.5,-PCBDims.y/2-hdrYOffset,2.5];
  
  translate(cntrOffset){
    *color(pcbBlueCol) linear_extrude(PCBDims.z)
      difference(){
        square([PCBDims.x,PCBDims.y],true);
        //screwholes
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*holeDist.x/2,iy*holeDist.y/2+cntrOffset(holeYOffset,holeDist.y)]) circle(d=holeDiaOut);
        //pins
        for (ix=[-(4-1)/2:(4-1)/2])
          translate([ix*2.54,PCBDims.y/2+hdrYOffset]) circle(d=1.0);
        //cutout
        translate([0,(-PCBDims.y+cutOutDims.y)/2]) square(cutOutDims,true);
        }
        
    /*//glass with active area
    color(glassGreyCol) translate([0,0,PCBDims.z+mfudge])
      linear_extrude(glassDims.z)
      difference(){
        translate([0,cntrOffset(glassYOffset,glassDims.y)])
          square([glassDims.x,glassDims.y],true);
        translate([0,cntrOffset(aaYOffset,aaDims.y),PCBDims.z+glassDims.z+aaDims.z+mfudge]) square([aaDims.x,aaDims.y],true);
        } */
        
    //active area
    translate([0,0,PCBDims.z+mfudge]) 
      color(blackBodyCol)
        linear_extrude(glassDims.z)
          translate([0,cntrOffset(aaYOffset,aaDims.y)]) 
            square([aaDims.x,aaDims.y],true);
        
    //screw holes
    color(metalGoldPinCol) linear_extrude(PCBDims.z) 
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*holeDist.x/2,iy*holeDist.y/2+cntrOffset(holeYOffset,holeDist.y)]) difference(){
            circle(d=holeDiaOut);
            circle(d=holeDiaIn);
          }
          
    //pinHeader
    *translate([-2.54*1.5,PCBDims.y/2+hdrYOffset,0]) rotate([180,0,0]) MPE_087(rows=1,pins=4,A=11.3,markPin1=false);
   
  }
  
  function cntrOffset(yOffset,yDim)=(PCBDims.y-yDim)/2+yOffset;
  
}
*LD8133();
module LD8133(){
  //NEC 9 digit VFD tube
  tbDia=10;
  color("grey",0.6){
    rotate([0,90,0]) cylinder(d=tbDia,h=48,center=true);
    rotate([90,0,0]) cylinder(d=3,h=7+tbDia/2);
  }
}


module raspBerry7Inch(cutOut=false,matThck=3){
  ovDims=[192.96,110.76,5.96+2.5];
  lensDims=[ovDims.x,ovDims.y,0.72];
  aaDims=[154.08,85.92,0.02];
  hsngDims=[166.2,100.6,5.96-lensDims.z];
  cutOutDims=[176.8,102.13,matThck];

  if (cutOut)
    translate([0,0,-(matThck/2)]) cube(cutOutDims,true);
  else{
    color("darkSlateGrey") translate([0,0,lensDims.z/2]) rndRect(lensDims,6.5,0);
    color("grey") translate([0,0,lensDims.z]) cube(aaDims,true);
    color("silver") translate([0,0,-hsngDims.z/2]) cube(hsngDims,true);
    }

}



*Adafruit128x160TFT(cutPanel=false);
module Adafruit128x160TFT(cutPCB=false, centerAA=true, cutPanel=false, cutGlass=false, drillDia=1.6){
  //https://www.adafruit.com/product/358
  PCBDims=[2.2*25.4,1.35*25.4,1.6];
  //drillDist=[PCBDims.x-2.5*2,PCBDims.y-2.5*2];
  drillDist=[25.4*2,25.4*1.15];
  echo(drillDist);
  rad=2.54;
  frameDims=[46.83,34.6];
  activeArea=[35.04,28.03];
  AAOffset=[-(45.83-35.04)/2+2.79,0];
  frameThick=3;
  spcng=0.2;
  cntrOffset= centerAA ? AAOffset : [0,0];
  
  translate(cntrOffset){
    if (cutPCB){
      for (ix=[-1,1],iy=[-1,1])
          translate([ix*drillDist.x/2,iy*drillDist.y/2]) circle(d=drillDia);
      for (i=[-9/2:9/2]) //pins
        translate([PCBDims.x/2-2.54,i*2.54]) circle(d=1);
      *translate(frmOffset) square([frmDims.x+spcng*2,frmDims.y+spcng*2],true);
    }
    
    else if (cutPanel){
      square(frameDims,true);
      for (ix=[-1,1],iy=[-1,1]) //drill
          translate([ix*drillDist.x/2,iy*drillDist.y/2]) circle(d=drillDia);

      translate([PCBDims.x/2-2.54-5,0]) rndRect([2.54+10,10*2.54],2.54/2,0,true);
    }

    else if (cutGlass){
      translate(-AAOffset) square(activeArea,true);
      for (ix=[-1,1],iy=[-1,1]) //drill
          translate([ix*drillDist.x/2,iy*drillDist.y/2]) circle(d=drillDia);
    }
      
    else{
      color("SteelBlue") translate([0,0,-1.6]) linear_extrude(PCBDims.z) difference(){
        PCB();
        for (i=[-9/2:9/2])
          translate([PCBDims.x/2-2.54,i*2.54]) circle(d=1);
      }
        rotate(0) displayTFT(frameDims,activeArea,AAOffset,frameThick);
      translate([-PCBDims.x/2+15.5/2,0,-1.6]) rotate([180,0,90]) uSDCard();  
    }
    
  }
  

  module PCB(){
    difference(){
      rndRect([PCBDims.x,PCBDims.y],rad,0,center=true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*drillDist.x/2,iy*drillDist.y/2]) circle(d=2.1);
    }
  }
}

*Adafruit128x128TFT();
module Adafruit128x128TFT(cut=false){
  //top: https://learn.adafruit.com/assets/19549 
  //bottom: https://learn.adafruit.com/assets/19550
  drillDist=[1.55*25.4,1.5*25.4];
  PCBDims=[1.75*25.4,1.3*25.4,1.6];
  frmDims=[38.2,32.2,3]; //display frame
  frmOffset=[(frmDims.x-PCBDims.x)/2+1,0,1.5];
  
  if (cut){
    for (ix=[-1,1],iy=[-1,1])
        translate([ix*drillDist.x/2,iy*drillDist.y/2]) circle(d=2.5);
    translate(frmOffset) square([frmDims.x,frmDims.y],true);
  }
    
  else{
    translate([0,0,-1.6]) linear_extrude(PCBDims.z) difference(){
      PCB();
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*drillDist.x/2,iy*drillDist.y/2]) circle(d=2.5);
    }
    display();
  }
  
  module PCB(){
    for (ix=[-1,1])
      translate([ix*drillDist.x/2,0])
        hull() for (iy=[-1,1])
          translate([0,iy*drillDist.y/2]) circle(r=2.54);
    square([PCBDims.x,PCBDims.y],true);
  }
 
 module display(){
   color("white") translate(frmOffset) difference(){
      cube(frmDims,true);
      translate([-(33.5-38.2)/2-2,0,0]) cube([33.5,28.9,3+fudge],true);
   }
   translate([-(PCBDims.x-1.13*25.4)/2+0.3*25.4,0,1.5]) color("darkslategrey") cube([1.13*25.4,(0.65-0.11)*2*25.4,3],true);
 } 
}

*displayTFT();
module displayTFT(frameDims=[45.83,34],activeArea=[35.04,28.03],AAOffset=[-(45.83-35.04)/2+2.79,0],thick=3){
  //display with Backlight and Frame
  spcng=0.2; //spacing between frame and AA
     color("ivory") linear_extrude(thick) difference(){
        square(frameDims,true);
        translate(AAOffset) offset(spcng) square(activeArea,true);
     }
     color("darkslategrey") translate([AAOffset.x,AAOffset.y,thick/2]) 
      cube([activeArea.x,activeArea.y,thick],true);
  }
  
module Midas96x16(orientation="flat",center=true){
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
*EastRising128x32();
module EastRising128x32(orientation="flat",center=true){
  glassThck=0.55;
  flxRad=0.25; //edge rad of Panel
  flxPnl=1.2; //width of Flex on Panel
  flxDimTap=[[10.5,6.8,4],[7.5,9],0.1];
  bend=1.6;
  panelDim=[30,11.5,1.3]; //Glass Panel
  polDim=[25.9,8.8,0.2]; //Polarizer
  
  polPos=[0.35,panelDim.y-0.5-polDim.y,0]; //offset from bottom left edge
  AADim=[22.384,5.584,0.01]; //active Area
  AAPos=[2.1,panelDim.y-2.1-AADim.y,polDim.z]; //offset from bottom left edge
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
  color("SlateGrey") translate(AAPos+[0,0,0]) cube(AADim);
  //Polarizer
  color("grey",0.5)
    translate(polPos) cube(polDim);
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

*FutabaVFD();
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
*HCS12SS();
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

*EA_DOGS164_A();
module EA_DOGS164_A(bLight=true){
  //https://www.lcd-module.de/fileadmin/pdf/doma/dogs164.pdf
  panelDims=[40,30,0.7];//big glass
  glassDims=[40,21,0.7]; //cover glass
  pinDims=[0.5,0.3,6];
  pinDist=[2.54,30.48];
  AADims=[32.185,14.865]; //Active Area
  VADims=[37.4,18.0,0.2]; //Viewable Area
  AAyOffset=pinDist.y/2-17.53;
  
  //panel
  color("grey",0.3) translate([0,0,panelDims.z/2]) cube(panelDims,true);
  
  //coverGlass
  color("grey",0.3) translate([0,AAyOffset,panelDims.z+glassDims.z/2]) cube(glassDims,true);
  
  //VA
  color("white",0.6) translate([0,AAyOffset,panelDims.z+glassDims.z+VADims.z/2]) cube(VADims,true);
  
 //pins
  color("grey") for (ix=[-4.5:4.5])
    translate([ix*pinDist.x,pinDist.y/2,0]){
     translate([0,0,-pinDims.z/2]) cube(pinDims,true);
     translate([0,-(1.3-pinDims.y)/2,panelDims.z/2]) cube([1.8,1.3,1.5],true);
    }
  
  color("grey") for (ix=[-4.5,-3.5,3.5,4.5])
    translate([ix*pinDist.x,-pinDist.y/2,0]){
      translate([0,0,-pinDims.z/2]) cube(pinDims,true);
      translate([0,(1.3-pinDims.y)/2,panelDims.z/2]) cube([1.8,1.3,1.5],true);
    }
  //backlight
  color("white") translate([0,0,-2.6]){
    linear_extrude(0.6) difference(){
      square([40,33],true);
      for (ix=[-4.5:4.5])
        translate([ix*pinDist.x,pinDist.y/2]) circle(d=0.8);
      for (ix=[-4.5,-3.5,3.5,4.5])
        translate([ix*pinDist.x,-pinDist.y/2]) circle(d=0.8);
    }
    translate([0,-2.3,0.6+1]) cube([40,21,2],true);
  }
      
}

*EA_W128032(4,center=true);
module EA_W128032(bendHght=3,center=false,cut=false){
  //Electronic Assembly 128x32 px 2.22"
  //https://www.lcd-module.de/fileadmin/eng/pdf/grafik/W128032-XALG.pdf
  
  ovDims=[62,24,2.05];
  panelDims=[ovDims.x,ovDims.y,1.8];//glass Dims
  tapeThck=(ovDims.z-panelDims.z)/2;
  VADims=[57.02,15.1,tapeThck];
  VAOffset=[2.491,2.0];//from top left edge
  AADims=[55.018,13.098];
  
  //flex
  // minimum bend radius=1.5mm
  // minimum length from display 2.0mm (including bend)
  flexDims=[12.5,19.6,0.3];
  padDims=[0.3,3.0,0.05];
  padPitch=0.5;
  padCnt=24;
  flexRad=1.5;//bend radius
  flexOffset=1;//offset for 1st bend
  bendLngth=(2*PI*flexRad)/4; //one quarter of a circle
  quartBends=3; //number of quarter bends
  flexTailLngth=flexDims.y-flexOffset*2-bendLngth*quartBends-bendHght;//length of the tail
  cntrOffset= center ? [0,0,-ovDims.z/2] : panelDims/2;
  
  if (cut){
    hull() for (ix=[-1,1])
      translate([ix*ovDims.x/2,0]) difference(){
        circle(ovDims.z);
        translate([0,-ovDims.z/2]) square([ovDims.z*2,ovDims.z],true);
      }
    translate([0,flexRad*quartBends/2+ovDims.z]) 
      square([flexDims.x+1.0,flexRad*quartBends],true); //tolerances are 0.3mm
  }
  else translate(cntrOffset){
    //panel
    color(glassGreyCol) cube(panelDims,true);
    //front
    color(blackBodyCol) translate([0,(panelDims.y-20.1)/2,(panelDims.z+tapeThck/2)/2]) 
      cube([panelDims.x,20.1,tapeThck/2],true);
    //VA
    
      translate([(VADims.x-panelDims.x)/2+VAOffset.x,
                 (-VADims.y+panelDims.y)/2-VAOffset.y,
                 (panelDims.z/2+tapeThck*0.5)]){ 
        color(darkGreyBodyCol) cube([VADims.x,VADims.y,tapeThck/4],true);
        color(glassOrangeCol) translate([0,0,tapeThck/4]) linear_extrude(tapeThck/4) 
                   pixels([128,32],[0.408,0.388],[0.43,0.41]);
        }
    
    //flex bend 180 degrees
    
      translate([0,-(panelDims.y+flexOffset)/2,(panelDims.z-flexDims.z)/2-0.7]){
        color(polymidCol){ 
        cube([flexDims.x,flexOffset,flexDims.z],true);
        translate([0,-flexOffset/2,-flexRad]) rotate([90,90,-90]) 
          rotate_extrude(angle=180) translate([flexRad,0]) 
            square([flexDims.z,flexDims.x],true);
        translate([0,bendHght/2,-flexRad*2]) 
          cube([flexDims.x,bendHght+flexOffset,flexDims.z],true);
        translate([0,flexOffset/2+bendHght,-flexRad*3]) rotate([90,180,-90]) 
          rotate_extrude(angle=-90) translate([flexRad,0]) 
            square([flexDims.z,flexDims.x],true);
        translate([0,flexOffset/2+bendHght+flexRad,-flexRad*3]) 
          rotate([180,0,0]) linear_extrude(flexTailLngth) 
            square([flexDims.x,flexDims.z],true);
      }
      //pads
        translate([0,flexOffset/2+bendHght+flexRad-flexDims.z/2,-flexRad*3-flexTailLngth+padDims.y/2]){ 
          color(metalGoldPinCol) for (ix=[-(padCnt-1)/2:(padCnt-1)/2])
            translate([ix*padPitch,0,0]) rotate([90,0,0]) cube(padDims,true);
          color(whiteBodyCol){
            translate([-(padCnt-1)/2*padPitch,0,padDims.y/2+fudge]) rotate([90,0,0]) 
              linear_extrude(padDims.z) text("1",size=1,halign="center");
            translate([-(padCnt-1)/2*padPitch,flexDims.z,padDims.y/2+fudge]) rotate([90,0,180]) 
              linear_extrude(padDims.z) text("1",size=1,halign="center");
          }
        }
    }
  }
 
}
 
!VIM_878_DP();
module VIM_878_DP(){
  //VARITRONIX 8x1 14Segment Display
  
  //glass
  frntGlassDims=[52,17,1.1];
  backGlassDims=[52,22,1.1];
  frntPolDims=[50,16,0.15];
  backPolDims=[50,16,0.25];
  // View
  VADims=[48,13];
  //pins
  pinCnt=36;
  pinLength=5;
  pitch=2.54;
  pinThck=0.3;
  pinDist= pinLength<=10 ? 2.54 + backGlassDims.y : 1.75 + backGlassDims.y;
  clampDims=[1.27,1];
  
  
  //glass body
  color(glassGreyCol){
    translate([0,0,-backGlassDims.z-backPolDims.z/2]) cube(backPolDims,true);
    translate([0,0,-backGlassDims.z/2]) cube(backGlassDims,true);
    translate([0,0,frntGlassDims.z/2]) cube(frntGlassDims,true);
    translate([27/2-frntGlassDims.x/2-1,0,0]) linear_extrude(frntGlassDims.z) difference(){
      circle(d=27);
      translate([1+fudge/2,0,0]) square(27+fudge,true);
    }
    translate([0,0,frntGlassDims.z+frntPolDims.z/2]) cube(frntPolDims,true);
    
    
  }
  
  //pins
  for (ix=[-(pinCnt/2-1)/2:(pinCnt/2-1)/2])
    color(metalGreyPinCol) translate([ix*pitch,-backGlassDims.y/2,0]) pin();
  for (ix=[-(pinCnt/2-1)/2:(pinCnt/2-1)/2])
    color(metalGreyPinCol) translate([ix*pitch,backGlassDims.y/2,0]) rotate(180) pin();
    
  module pin(){
    //measured from drawing
    
    kinked();
    translate([0,0,-backGlassDims.z]) mirror([0,0,1]) kinked();
    translate([0,-pinThck/2,-backGlassDims.z/2]) cube([clampDims.x,pinThck,backGlassDims.z+pinThck],true);
    translate([0,-pinThck/2,-1.55-pinThck/2]) cube([clampDims.x/3,pinThck,2-backGlassDims.z],true);
    translate([0,-pinThck/2,-2-pinThck/2]) rotate([0,90,0]) cylinder(d=pinThck,h=clampDims.x/3,center=true);
    translate([0,-pinThck/2,-2-pinThck/2]) rotate([-153,0,0]){
      translate([0,1.24/2,0]) cube([clampDims.x/3,1.24,pinThck],true);
      translate([0,1.24,0]) rotate([0,90,0]) cylinder(d=pinThck,h=clampDims.x/3,center=true);
      translate([0,1.24,0]) rotate([153+180,0,0]) translate([0,0,pinLength/2]) cube([clampDims.x/3,pinThck,pinLength],true);
    }
    
    
    module kinked(){
      translate([0,clampDims.y,pinThck/2]) rotate([35.6,0,0]) translate([0,0.8/2,0]) cube([clampDims.x,0.8,pinThck],true);
      translate([0,clampDims.y,pinThck/2]) rotate([0,90,0]) cylinder(d=pinThck,h=clampDims.x,center=true);
      translate([0,clampDims.y/2-pinThck/4,pinThck/2]) cube([clampDims.x,clampDims.y+pinThck/2,pinThck],true);
      translate([0,-pinThck/2,pinThck/2]) rotate([0,90,0]) cylinder(d=pinThck,h=clampDims.x,center=true);
    }
  }
}

*AdafruitOLED23(true);
module AdafruitOLED23(cut=false){
  //2.3" 128x32px OLED from Adafruit 
  //https://www.adafruit.com/product/2675
  //aka LM230B-128032

  drillDist=[62.6,31.2];
  drillDia=2.6;
  pcbDims=[66.5,35,1];
  displayDims=[63.5,26.1,4.5]; //Dimensions of the metal frame
  AADims=[55.02,13.1];//Active Area
  VADims=[57,15.1];//Viewable area
  AACntrOffset=[0,-(pcbDims.y-AADims.y)/2+13.95];
  
  if (cut){
    offset(0.2) metalFrame();
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*drillDist.x/2,iy*drillDist.y/2]) circle(d=2);
  }
  else{

    //PCB
    color("green") translate([0,0,-pcbDims.z]) linear_extrude(pcbDims.z) difference(){
      square([pcbDims.x,pcbDims.y],true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*drillDist.x/2,iy*drillDist.y/2]) circle(d=drillDia);
    }
    //display
    
      difference(){
        color("darkslategrey") linear_extrude(displayDims.z,convexity=2) metalFrame();
        color("#222222") translate([AACntrOffset.x,AACntrOffset.y,displayDims.z]) rndRect([VADims.x,VADims.y,0.2],1,0,center=true);
      }
      color("cyan") translate([AACntrOffset.x,AACntrOffset.y,displayDims.z-0.1]) linear_extrude(0.1)
        pixels(count=[128,32]);
  }

  module metalFrame(){
    square([displayDims.x,displayDims.y],true);
    translate([0,-displayDims.y/2-0.75]) square([16.22,1.5],true);
  }
}

module rndRect(size, rad, drill=0, center=true){  
  if (len(size)==2) //2D shape
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(d=drill);
    }
  else
    
    linear_extrude(size.z,center=center) 
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(d=drill);
    }
}

*AdafruitOLED();
module AdafruitOLED(size=2.42,cut=false){
  //2.3" 128x32px OLED from Adafruit 
  //https://www.adafruit.com/product/2675
  //2.3" aka LM230B-128032
  //2.42" aka TW2864(1230A03)
  //                            2.3"              2.42"
  drillDist=   (size==2.3) ? [62.6,31.2] :     [66.7,45.7];
  pcbDims=     (size==2.3) ? [66.5,35,1] :     [70.5,49.5,1];
  displayDims= (size==2.3) ? [63.5,26.1,4.5] : [62.5,38.9,3.8]; //Dimensions of the metal frame
  AADims=      (size==2.3) ? [55.02,13.1] :    [55.01,27.49];//Active Area
  VADims=      (size==2.3) ? [57,15.1]    :    [56.9,29.49];//Viewable area
  pxCnt=       (size==2.3) ? [128,32]     :    [123,64]; //x-y pixel count
  pxDims=      (size==2.3) ? [0.41,0.39]  :    [0.4,0.4]; //pixel dimensions
  pxPitch=     (size==2.3) ? [0.43,0.41]  :    [0.43,0.43];
  pxCol=       (size==2.3) ? "cyan"       : "lightgrey";
  drillDia=2.6;
  AACntrOffset=[0,-(pcbDims.y-AADims.y)/2+13.95];
  
  if (cut){
    offset(0.2) metalFrame();
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*drillDist.x/2,iy*drillDist.y/2]) circle(d=2);
  }
  else{

    //PCB
    color("green") translate([0,0,-pcbDims.z]) linear_extrude(pcbDims.z) difference(){
      square([pcbDims.x,pcbDims.y],true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*drillDist.x/2,iy*drillDist.y/2]) circle(d=drillDia);
    }
    //display
    
      difference(){
        color("darkslategrey") linear_extrude(displayDims.z,convexity=2) metalFrame();
        color("#222222") translate([AACntrOffset.x,AACntrOffset.y,displayDims.z]) rndRect([VADims.x,VADims.y,0.2],1,0,center=true);
      }
      color(pxCol) translate([AACntrOffset.x,AACntrOffset.y,displayDims.z-0.1]) linear_extrude(0.1)
        pixels(count=pxCnt,size=pxDims,pitch=pxPitch);
  }

  module metalFrame(){
    square([displayDims.x,displayDims.y],true);
    translate([0,-displayDims.y/2-0.75]) square([16.22,1.5],true);
  }
}

module rndRect(size, rad, drill=0, center=true){  
  if (len(size)==2) //2D shape
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(d=drill);
    }
  else
    
    linear_extrude(size.z,center=center) 
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(d=drill);
    }
}



*sevenSegment();
module sevenSegment(size=[4.22,7.62], width=0.8, tilt=10, dot=true){
  *translate([-size.x/2-0.6,-size.y/2]) %import("./sources/ACDA03-41SEKWA-F01.svg");
  gap=0.2;
  gapOffset=sqrt(2)*gap/2; //for 45°
  xTiltOffset=tan(tilt)*(size.y-width)/2;
  dotPos=[2.6,-3.41]; 
  dotDia=0.9;
  //horizontal segments (a,g,d)
  for (iy=[-1:1])
    translate([iy*xTiltOffset,iy*((size.y-width)/2)]) shape(); //a
  //vertical segments (b,c,e,f)
  for (ix=[-1,1],iy=[-1,1]){
    translate([ix*(size.x-width)/2+iy*(xTiltOffset/2+0.04),iy*(size.y-width)/4]) rotate(90) shape(true);
  }
  //dot
  if (dot)
    translate(dotPos) circle(d=dotDia);
  
  module shape(vertical=false){
    //vertical
    tipYOffset= vertical ? -xTiltOffset : 0;
    topYOffset= vertical ? tan(tilt)*((-size.y+width)/2) : 0;
    //horizontal
    horXOffset= vertical ? 0 : tan(tilt) * width/2; 
    
    
    poly=[[-(size.x-width)/2+gapOffset,-tipYOffset/2], //left
          [-(size.x/2-width)+gapOffset+horXOffset,width/2-topYOffset/2], //top left
          [(size.x/2-width)-gapOffset+horXOffset,width/2+topYOffset/2], //top right
          [(size.x-width)/2-gapOffset,tipYOffset/2], //right
          [(size.x/2-width)-gapOffset-horXOffset,-width/2+topYOffset/2], //bottom right
          [-(size.x/2-width)+gapOffset-horXOffset,-width/2-topYOffset/2]]; //bottom left
    
    polygon(poly);
  }
}

*pixels();
module pixels(count=[16,8],size=[0.41,0.39],pitch=[0.43,0.41]){
  for (ix=[-(count.x-1)/2:(count.x-1)/2],iy=[-(count.y-1)/2:(count.y-1)/2])
    translate([ix*pitch.x,iy*pitch.y]) square(size,true);
}

function xTilt(dist,ang)=[tan(ang)*dist,dist]; 


module uSDCard(showCard=true){
  //push-push by Wuerth 
  //https://www.we-online.de/katalog/datasheet/693071010811.pdf
    translate([0,0,1.98/2]){
      color("silver") difference(){
        cube([14,15.2,1.98],true);
        translate([-(14-11.2+fudge)/2,-(15.2-1.3+fudge)/2,0]) cube([11.2+fudge,1.3+fudge,1.98+fudge],true);
      }
      if(showCard){
        color("darkslateGrey") translate([-(14-11)/2+0.1,-0.6,0.35]) cube([11,15,0.7],true);
        color("darkslateGrey",0.5) translate([-(14-11)/2+0.1,-5,0.35]) cube([11,15,0.7],true);
      }
    }
}