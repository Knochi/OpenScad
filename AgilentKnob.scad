ovDims=[12.35,8.4,9.1];
faceDims=[11.85,7.9];
crnRad=1;
//holes
crossDims=[5,1];
sqDim=3.2;

holeDia=1.8;
holeDist=[6.6-holeDia,6.9-holeDia];
slotDist=8.75;
slotDims=[1,4];
deep=8;

//features
showSquare=true;
showCross=true;
showHoles=false;
showSlots=false;

fudge=0.1;
spcng=0.1;

$fn=20;
sqSpcng=[spcng*2,spcng*2];

difference(){
  linear_extrude(ovDims.z,scale=[faceDims.x/ovDims.x,faceDims.y/ovDims.y])
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(ovDims.x/2-crnRad),iy*(ovDims.y/2-crnRad)]) circle(crnRad);
  translate([0,0,-fudge]) linear_extrude(deep+fudge){
    if (showSquare) square(sqDim+spcng*2,true);
    if (showCross) {
      square(crossDims+sqSpcng,true);
      rotate(90) square(crossDims+sqSpcng,true);
    }
    if (showHoles) for (ix=[-1,1],iy=[-1,1])
      translate([ix*holeDist.x/2,iy*holeDist.y/2]) circle(d=holeDia);
    if (showSlots) for (ix=[-1,1])
      translate([ix*slotDist/2,0]) square(slotDims,true);
  }
  
}
