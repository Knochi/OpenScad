/* SO package adapter */
$fn=40;
/* [Dimensions] */
ovDims=[12,15,5];
cntrHoleDia=3;
recessHght=1.85;

icBdyDims=[3.9,5.01,1.44];
icOvWdth=6.18;
icSpcng=0.1;
icPitch=1.25;
icLeadWdth=0.5;
icLeadThck=0.27;
icPins=8;

probeDia=0.75;
probeAngInner=10;
probeAngOuter=20;
probeZOffset=0.1;

*import("SOIC8_Holder.STL");

//base
linear_extrude(ovDims.z-recessHght) difference(){
  square([ovDims.x,ovDims.y],true);
  circle(d=cntrHoleDia);
}

//recess
difference(){
  translate([0,0,ovDims.z-recessHght]) linear_extrude(recessHght) difference(){
    square([ovDims.x,ovDims.y],true);
    icShape();
  }
  translate([0,0,ovDims.z-recessHght+icLeadThck+probeZOffset+probeDia/2]) probeChannels();
}


module icShape(){
  offset(icSpcng) square([icBdyDims.x,icBdyDims.y],true);
  for (iy=[-(icPins/2-1)/2:(icPins/2-1)/2])
    translate([0,iy*icPitch]) offset(icSpcng) square([icOvWdth,icLeadWdth],true);
}

module probeChannels(){
for (im=[0,1]) mirror([im,0,0]) {
  translate([icOvWdth/2-probeDia/2,icPitch*1.5]) rotate([0,90,probeAngOuter]) cylinder(d=probeDia,h=ovDims.x/2);
  translate([icOvWdth/2-probeDia/2,icPitch/2]) rotate([0,90,probeAngInner]) cylinder(d=probeDia,h=ovDims.x/2);
  translate([icOvWdth/2-probeDia/2,-icPitch/2]) rotate([0,90,-probeAngInner]) cylinder(d=probeDia,h=ovDims.x/2);
  translate([icOvWdth/2-probeDia/2,-icPitch*1.5]) rotate([0,90,-probeAngOuter]) cylinder(d=probeDia,h=ovDims.x/2);
  }
}