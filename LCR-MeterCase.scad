use <eCAD/connectors.scad>
include <eCAD/KiCADColors.scad>

// new parametric housing for LCR meter
$fn=20;
fudge=0.1;

/* [Meter Dimensions] */
pcbDims=[72.9,59.8,1.6];
holeDia=3.2;
holeDist=[67.5,37.6];
holeOffset=[0,-holeDia/2+(pcbDims.y-holeDist.y)/2-1.3];//1.3+3.2/2
wirePos=[-pcbDims.x/2+2.8,pcbDims.y/2-31.6,0]; //31.6 from top on left side 2.8
wireDia=1.3;
wireLen=5;
displayDims=[58.4,38.5,5];
displayPos=[0,(pcbDims.y-displayDims.y)/2,pcbDims.z+displayDims.z/2]; //centered on the top
socketDims=[32.9,14.9,11.5];
socketPos=[-(pcbDims.x-socketDims.x)/2,-(pcbDims.y-socketDims.y)/2,pcbDims.z]; //lower left corner
btnPos=[(pcbDims.x-13)/2,-(pcbDims.y-13.5)/2,pcbDims.z];;//lower right corner
padsDims=[8.2,11,0.05];
padsPos=[pcbDims.x/2-27.75,-pcbDims.y/2+14.9-padsDims.y/2,pcbDims.z];
  

/* [case Dimensions] */
minWallThck=1.2;
cornerRad=3;


LCRmeter();
translate([37,57,0]) rotate(180) LX_LCBST();

module LCRmeter(){
 
  //pcb
  color(yellowBodyCol) linear_extrude(pcbDims.z) difference(){
    square([pcbDims.x,pcbDims.y],true);
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*holeDist.x/2+holeOffset.x,iy*holeDist.y/2+holeOffset.y]) circle(d=holeDia);
    translate(wirePos) circle(d=3);
  }
  
  //display
  color(whiteBodyCol) translate(displayPos) cube(displayDims,true);
  
  //display Flex
  translate([displayPos.x,pcbDims.y/2+displayDims.z/2,displayPos.z])
    rotate([0,90,0]) cylinder(d=displayDims.z ,h=11,center=true);
  translate([displayPos.x,pcbDims.y/2+displayDims.z/4,displayPos.z]) 
    cube([11,displayDims.z/2,displayDims.z],true);
  
  //socket
  translate(socketPos) socket();
  
  //button
  translate(btnPos) button();
  
  //pads
  color(metalSilverCol) translate(padsPos) linear_extrude(padsDims.z) square([padsDims.x,padsDims.y],true);
  
  //battery wires
  for (ix=[-1,1])
    translate(wirePos+[0,ix*wireDia/2,-wireLen]) cylinder(d=wireDia,h=wireLen+pcbDims.z+wireDia);
  
  module button(){
    color("#222222") linear_extrude(4) square(12,true);
    //stem
    color("grey") cylinder(d=6.9,h=6.75);
    //cap
    translate([0,0,6.75]) color(blueBodyCol){
      cylinder(d=12.9,h=1.4);
      cylinder(d=11.4,h=5.8);
      }
  }
  
  module socket(closed=true){
    //body
    rot = closed ? -90 : 0;
    translate([-socketDims.x/2,-socketDims.y/2,0]){
      color("lightblue") difference(){
        cube(socketDims);
        translate([-fudge,-fudge,socketDims.z-6]) cube([5.7+fudge,2+fudge,6+fudge]);
        }
    //lever
    translate([5.7-1.7/2,2-1.7/2,6.5]) rotate([0,rot,0]) cylinder(d=1.7,h=18.3);
    }
  }
}

module caseBot(){
  
}


module LX_LCBST(){
  //https://de.aliexpress.com/item/1005005656423941.html
  // Charger/Boost Module 
  pcbDims=[18,23,1.6];
  linear_extrude(pcbDims.z) difference(){
    square([pcbDims.x,pcbDims.y]);
    //mount
    translate([pcbDims.x-14.8,pcbDims.y]) circle(d=2);
    translate([pcbDims.x-14.8,0]) circle(d=2);
    }
    //USB-C
    translate([0,6.25,pcbDims.z]) rotate(-90) usbC();
}

