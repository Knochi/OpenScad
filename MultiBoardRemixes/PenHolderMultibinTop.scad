/* [Dimensions] */
penDia=14;
spcng=0.2;
wallThck=1;
ovHght=10;
edgeOffset=+0;

/* [Hidden] */
$fn=50;
innerWdth=39.95;
innerChamfer=4.4;
lidThck=2;
fudge=0.1;
*import("1x1 - Multibin Top - STL Remixing File.stl");
*import("1x1 - Sharpie Holder - Multibin Top.stl");

penHolder();

module penHolder(){
  difference(){
    import("1x1 - Multibin Top - STL Remixing File.stl",convexity=4);
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*((innerWdth-penDia)/2-wallThck-edgeOffset),iy*((innerWdth-penDia)/2-wallThck-edgeOffset),-fudge/2])
        linear_extrude(ovHght+fudge) rotate(180/8) circle(d=ri2ro(penDia,8),$fn=8);
  }
  beamDims=[innerWdth-penDia*2-wallThck*4,wallThck,ovHght-lidThck,];
  linear_extrude(ovHght) for (ix=[-1,1],iy=[-1,1])
    translate([ix*((innerWdth-penDia)/2-wallThck-edgeOffset),iy*((innerWdth-penDia)/2-wallThck-edgeOffset)]) cell();
  for (ix=[-1,1])
    translate([ix*(innerWdth/2-penDia/2-wallThck),0,beamDims.z/2+lidThck]) rotate(90) filletBeam(size=beamDims, center=true);
  for (iy=[-1,1])
    translate([0,iy*(innerWdth/2-penDia/2-wallThck),beamDims.z/2+lidThck]) filletBeam(size=beamDims, center=true);
}

*filletBeam(center=true);
module filletBeam(size=[10,2,2],fillet=1,center=false){
  cntrOffset= center ? [0,0,0] : [size.x/2,0,0];
  //a beam with fillet ends
  translate(cntrOffset) linear_extrude(size.z,center=center){
      square([size.x,size.y],true);
    difference(){
    for (ix=[-1,1])
      translate([ix*(size.x-fillet)/2,0]) square([fillet,size.y+fillet*2],true);
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-fillet),iy*(size.y/2+fillet)]) circle(fillet);
    }
  }
}

module cell(){
  rotate(180/8) difference(){
    offset(wallThck) circle(d=ri2ro(penDia,8),$fn=8);
    circle(d=ri2ro(penDia,8),$fn=8);
  }
}
 

function ri2ro(r=1,n=8)=r/cos(180/n);
function ro2ri(r=1,n=8)=r*cos(180/n);