ovDims=[12.35,8.4,9.1];
faceDims=[11.85,7.9];
crnRad=1;
//hole
crossDims=[5,1];
sqDim=3.2;
deep=8;
fudge=0.1;
spcng=0.3;

$fn=20;
sqSpcng=[spcng*2,spcng*2];

difference(){
  linear_extrude(ovDims.z,scale=[faceDims.x/ovDims.x,faceDims.y/ovDims.y])
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(ovDims.x/2-crnRad),iy*(ovDims.y/2-crnRad)]) circle(crnRad);
  translate([0,0,-fudge]) linear_extrude(deep+fudge){
    square(sqDim+spcng*2,true);
    square(crossDims+sqSpcng,true);
    rotate(90) square(crossDims+sqSpcng,true);
  }
}
