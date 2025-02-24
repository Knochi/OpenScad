/* SO package adapter */

/* [Dimensions] */
ovDims=[15,15,5];
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


//base
linear_extrude(ovDims.z-recessHght) difference(){
  square([ovDims.x,ovDims.y],true);
  circle(d=cntrHoleDia);
}

//recess
translate([0,0,ovDims.z-recessHght]) linear_extrude(recessHght) difference(){
  square([ovDims.x,ovDims.y],true);
  icShape();
}

module icShape(){
  offset(icSpcng) square([icBdyDims.x,icBdyDims.y],true);
  for (iy=[-(icPins/2-1)/2:(icPins/2-1)/2])
    translate([0,iy*icPitch]) offset(icSpcng) square([icOvWdth,icLeadWdth],true);
}