use <eCad/Displays.scad>
use <eCad/Connectors.scad>
use <eCad/packages.scad>
include <eCad/KiCADColors.scad>

$fn=20;


/* [Positions] */

batPos=[0,11,0];
batRot=[0,90,0];
pcbPos=[0,-9.1,-0.5];
pcbRot=[52,0,0];
LD8133();

//prismatic battery
*translate(batPos) cube([35,12,4],true);
//
translate(batPos) rotate(batRot) cylinder(d=10.1,h=43.2,center=true);

translate(pcbPos) rotate(pcbRot) PCB();
%housing();

module housing(){
  cube([45,30,11],true);
}

*PCB();
module PCB(){
  pcbDims=[38,10,1.6];
  
  usbCPos=[-16.3,0,0];
  usbCRot=-90;
  
  //line driver Toshiba TBD62786 (SSOP18)
  for (ix=[-1,1])
    translate([ix*(pcbDims.x/2-4),-0.2,-pcbDims.z]) rotate([180,0,90]) SSOP(18);
  
  
  translate([10,0,0]) QFN(32);
  translate(usbCPos) rotate(usbCRot) usbC();
  
  color(pcbGreenCol) translate([0,0,-pcbDims.z]) linear_extrude(pcbDims.z){
    difference(){
      square([pcbDims.x,pcbDims.y],true);
      circle(d=4);
    }    
  }
}