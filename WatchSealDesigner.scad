/* [Cross Section] */
csThck=0.65;
csWdth=0.65;
csShape="square"; //["square","round"]

/* [Dimensions (cntrLine)] */
ovWdth=27.5;
ovHght=29.3;
chamfer=2;
cornerStyle="chamfer";

$fn=50;

if (csShape=="square")
  if (cornerStyle=="chamfer")
    linear_extrude(csThck) difference(){
      offset(delta=csWdth/2,chamfer=false) chamfSquare([ovWdth,ovHght],chamfer);
      offset(delta=-csWdth/2,chamfer=false) chamfSquare([ovWdth,ovHght],chamfer);
      }
  
module chamfSquare(size=[10,10],chamfer=2){
  hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(size.x/2-chamfer),iy*(size.y/2-chamfer)]) circle(chamfer,$fn=4);
}