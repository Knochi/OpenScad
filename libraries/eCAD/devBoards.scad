use <connectors.scad>

$fn=20;
fudge=0.1;

// Colors
boardGreenCol=[0.07,0.3,0.12]; //from KiCAD
goldPinsCol=[0.859,0.738,0.496];
piPico();

module piPico(){
  //dimension took from official STP model
  //https://datasheets.raspberrypi.org/pico/Pico-R3-step.zip
  
  sqrPads=[3,8,13,18,23,28,33,38];
  
  pcbDims=[21,51,1];
  holeDist=[11.4,pcbDims.y-4];
  
  translate([0,0,-pcbDims.z/2]){
    PCB();
    pads();
  }
  translate([0,pcbDims.y/2-1,0]) rotate(180) mUSB();
  
  module pads(){
    //pads
  for (ix=[-1,1],iy=[-(20-1)/2:(20-1)/2]){
    PadNo= (ix<0) ? iy+(20-1)/2+1 : iy+20+(20-1)/2+1;
    translate([ix*(pcbDims.x/2-1.61),iy*2.54]) 
      rotate(90-ix*90) picoPad(sqrPad=search(PadNo,sqrPads));
  }
  for (ix=[-1,1],iy=[-1,1])
      translate([ix*holeDist.x/2,iy*holeDist.y/2,0]) drillPad();
  
  for (ix=[-1,1])
    translate([ix*2.54,-pcbDims.y/2+1.61]) rotate(-90) picoPad(false);
    translate([0,-pcbDims.y/2+1.61]) rotate(-90) picoPad(true);
  }
  
  module PCB(){
    //PCB with cutouts
    difference(){
      color(boardGreenCol) cube(pcbDims,true);
      for (ix=[-1,1],iy=[-(20-1)/2:(20-1)/2]){
        PadNo= (ix<0) ? iy+(20-1)/2+1 : iy+20+(20-1)/2+1;
        translate([ix*(pcbDims.x/2-1.61),iy*2.54]) 
          rotate(90-ix*90) picoPad(sqrPad=search(PadNo,sqrPads),cut=true);
      }
      for (ix=[-1,1])
        translate([ix*2.54,-pcbDims.y/2+1.61]) rotate(-90) picoPad(false,true);
      translate([0,-pcbDims.y/2+1.61]) rotate(-90) picoPad(true,true);
      
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*holeDist.x/2,iy*holeDist.y/2,0]) cylinder(d=3.8,h=pcbDims.z+fudge,center=true);
    }
  }
  
  module drillPad(){
    color(goldPinsCol) difference(){
      cylinder(d=3.8,h=pcbDims.z,center=true);
      cylinder(d=2.1,h=pcbDims.z+fudge,center=true);
    }
  }
  
  module picoPad(sqrPad=true,cut=false){
    dims= cut ? [2.41,1.6] : [2.41,1.6];
    thick= cut ? pcbDims.z+fudge : pcbDims.z;
    xOffset= cut ? fudge : 0;
    color(goldPinsCol) difference(){
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
  cntrOffset= center ? [0,0,0] : [size.x/2,size.y/2,size.z/2];
  
  translate(cntrOffset)
    hull() for (ix=[-1,1],iy=[-1,1]){
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]) cylinder(r=rad,h=size.z,center=true);
    }
  }