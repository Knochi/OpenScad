use <connectors.scad>
use <MPEGarry.scad>
use <packages.scad>
use <elMech.scad>
include <KiCADColors.scad>


$fn=20;
fudge=0.1;

// Colors


piPico();

*piZero();

module piZero(){
  //just pinheader and edge
  pcbDims=[65,30];
  HDMIPos=[-pcbDims.x/2+12.4,-pcbDims.y/2];
  
  translate([2.54*9.5,-pcbDims.y/2+3.5+2.54/2,-2.54]){
    color(boardGreenCol) translate([0,0,-1.6]) linear_extrude(1.6)
    difference(){
      rndRect(pcbDims,2.5,true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(pcbDims.x/2-3.5),iy*(pcbDims.y/2-3.5)]) circle(d=3.1);
        translate([0,pcbDims.y/2-3.5]) pinHeader(40,2,diff="pcb",center=true);
    }
    translate([0,pcbDims.y/2-3.5,0]) MPE_087(rows=2,A=11.30, pins=40,center=true);
    translate([-pcbDims.x/2+41.4,-pcbDims.y/2+2,0]) mUSB();
    translate([-pcbDims.x/2+54,-pcbDims.y/2+2,0]) mUSB();
    color(metalGreyPinCol) translate([HDMIPos.x,HDMIPos.y+7.7/2,3.45/2]) 
      cube([11.2,7.7,3.45],true); //mini HDMI (type C)
  }
}

module piPico(showLabels=true){
  //dimension took from official STP model
  //https://datasheets.raspberrypi.org/pico/Pico-R3-step.zip
  
  //these pads will be square, others rounded
  sqrPads=[3,8,13,18,23,28,33,38];
  //signal labels
  labels=["zero","VBUS","VSYS","GND","3V3_EN","3V3","ADC_VREF","GP28_A2","AGND","GP27_A1","GP26_A0","RUN","GP22","GND","GP21","GP20","GP19","GP18","GND","GP17","GP16",
          "GP15","GP14","GND","GP13","GP12","GP11","GP10","GND","GP9","GP8","GP7","GP6","GND","GP5","GP4","GP3","GP2","GND","GP1","GP0"];

  pcbDims=[21,51,1];
  holeDist=[11.4,pcbDims.y-4];
  
  //parts
  MCUPos=[0,0.5,0];
  btnPos=[-pcbDims.x/2+7,pcbDims.y/2-12,0];
  
  translate([0,0,-pcbDims.z/2]){
    PCB();
    pads();
  }
  translate([0,pcbDims.y/2-1,0]) rotate(180) mUSB();
  translate(MCUPos) QFN(54,[7,7,1],0.4,"RP2040");
  translate(btnPos) rotate(90) KMR2();
  
  module pads(){
    //pads 1-40
    for (ix=[-1,1],iy=[-(20-1)/2:(20-1)/2]){
      PadNo= (ix<0) ? -iy+(20-1)/2+1 : iy+20+(20-1)/2+1;//calculate the number of the pad
      txtAlign= (ix<0) ? "left" : "right";
      //echo(str("PadNo:",PadNo,"; ix:",ix,"; iy:",iy));
      translate([ix*(pcbDims.x/2-1.61),iy*2.54]) {
        rotate(90-ix*90) picoPad(sqrPad=search(PadNo,sqrPads)); //if the current padno is found in the square pad array make square
        //labels
        if (showLabels)
          color(whiteBodyCol) translate([ix*-1.6/2,0,-pcbDims.z/2-0.1]) 
            rotate([180,0,0]) linear_extrude(0.1) text(str(labels[PadNo]),size=1,halign=txtAlign,valign="center");
      }
      
    }
    //solder resist removal around NPTH
    for (ix=[-1,1],iy=[-1,1])
        translate([ix*holeDist.x/2,iy*holeDist.y/2,0]) drillPad();
    
    //debug pads
    for (ix=[-1,1]){
      lbl= (ix<0) ? "SWCLK" : "SWDIO";
      translate([ix*2.54,-pcbDims.y/2+1.61]) rotate(-90){
        picoPad(false);
        if (showLabels)
          color(whiteBodyCol) translate([-1.6/2,0,-pcbDims.z/2-0.1]) 
            rotate([180,0,0]) linear_extrude(0.1) text(str(lbl),size=1,halign="right",valign="center");
      }
    }
    translate([0,-pcbDims.y/2+1.61]) rotate(-90){
      picoPad(true);
      if (showLabels)
        color(whiteBodyCol) translate([-1.6/2,0,-pcbDims.z/2-0.1]) 
          rotate([180,0,0]) linear_extrude(0.1) text("GND",size=1,halign="right",valign="center");
    }
  }
  
  module PCB(){
    //PCB with cutouts
    difference(){
      color(pcbGreenCol) cube(pcbDims,true);
      for (ix=[-1,1],iy=[-(20-1)/2:(20-1)/2]){
        PadNo= (ix<0) ? iy+(20-1)/2+1 : iy+20+(20-1)/2+1;
        translate([ix*(pcbDims.x/2-1.61),iy*2.54]) 
          rotate(90-ix*90) picoPad(sqrPad=search(PadNo,sqrPads),cut=true);
      }
      for (ix=[-1,1])
        translate([ix*2.54,-pcbDims.y/2+1.61]) rotate(-90) picoPad(false,true);
      translate([0,-pcbDims.y/2+1.61]) rotate(-90) picoPad(true,true);
      
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*holeDist.x/2,iy*holeDist.y/2,0])  color(pcbGreenCol) cylinder(d=3.8,h=pcbDims.z+fudge,center=true);
    }
  }
  
  module drillPad(){
    color(FR4Col) difference(){
      cylinder(d=3.8,h=pcbDims.z-fudge,center=true);
      cylinder(d=2.1,h=pcbDims.z+fudge,center=true);
    }
  }
  
  module picoPad(sqrPad=true,cut=false){
    dims= cut ? [2.41,1.6] : [2.41,1.6];
    thick= cut ? pcbDims.z+fudge : pcbDims.z;
    xOffset= cut ? fudge : 0;
    color(metalGoldPinCol) difference(){
      if (!sqrPad){
        cylinder(d=dims.y,h=thick,center=true);
        translate([dims.x/2-dims.y/4+xOffset/2,0,0]) cube([dims.x-dims.y/2+xOffset,dims.y,thick],true);
      }
      else{
        hull() for (iy=[-1,1])
          translate([-dims.y/2+0.2,iy*(dims.y/2-0.2),0]) cylinder(r=0.2,h=thick,center=true);
        translate([(dims.x-0.2)/2-dims.y/2+0.2+xOffset/2,0,0]) cube([dims.x-0.2+xOffset,dims.y,thick],true);
      }
      if (!cut){
        cylinder(d=1,h=thick+fudge,center=true);
        translate([1.1+0.5,0,0]) cylinder(d=1,h=thick+fudge,center=true);
      }
    }
}
}
*rndRect();
module rndRect(size=[10,5,1],rad=1,center=false){
  
  if (len(size)<3){
    cntrOffset= center ? [0,0] : [size.x/2,size.y/2];
    translate(cntrOffset)
      hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]) circle(r=rad);
    }
  else{
  cntrOffset= center ? [0,0,0] : [size.x/2,size.y/2,size.z/2];
  translate(cntrOffset)
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]) cylinder(r=rad,h=size.z,center=true);
  }
  }