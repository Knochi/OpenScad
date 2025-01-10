rbFtDims=[52.5,14.5,1.5];
rbFtSpcng=0.2;
rbFtSpcng=0.5;
shlfDist=30;
shlfThck=15;
wallThck=3;

$fn=20;
crnrRad=rbFtDims.y/2+wallThck+rbFtSpcng;
ovDims=[rbFtDims.x+wallThck*2+rbFtSpcng*2,rbFtDims.y+rbFtSpcng+shlfDist+wallThck,rbFtDims.z];
cutOutWdth=shlfDist-wallThck-rbFtSpcng;

linear_extrude(ovDims.z) difference(){
  translate([crnrRad,-wallThck+ovDims.z/2,0]) offset(crnrRad) square(ovDims+[-crnrRad*2,-crnrRad+wallThck-ovDims.z/2]);
  translate([0,-crnrRad-wallThck+ovDims.z/2]) square([ovDims.x,crnrRad]);
  translate([ovDims.x/2,shlfDist+rbFtDims.y/2]) 
    hull() for(ix=[-1,1])
      translate([ix*(rbFtDims.x-rbFtDims.y)/2,0]) circle(d=rbFtDims.y+rbFtSpcng*2);
  //cutout
  translate([ovDims.x/2,cutOutWdth/2]) 
    hull() for(ix=[-1,1],iy=[-1,1])
      translate([ix*(rbFtDims.x-rbFtDims.y)/2,iy*(cutOutWdth/2-rbFtDims.y/2)]) circle(d=rbFtDims.y);
}

translate([0,-wallThck,ovDims.z/2]) rotate([-90,0,0]) 
  translate([crnrRad,0,0]) linear_extrude(wallThck) difference(){
    offset(crnrRad) square([ovDims.x-crnrRad*2,shlfThck-crnrRad+ovDims.z/2]);
    translate([-crnrRad,-crnrRad]) square([ovDims.x,crnrRad]);
}

translate([0,-wallThck+ovDims.z/2,ovDims.z/2]) rotate([0,90,0]) cylinder(d=rbFtDims.z,h=ovDims.x);