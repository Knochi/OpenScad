

/* [Dimensions] */
fudge=0.1;
$fn=20;
screwDia=3;
wallThck=2.6;
screwDK=6;
screwK=1.8;
spcng=0.3;

/* [show] */
showDummy=true;
showHolder=true;



ankerPP5();


module ankerPP5(){
  //Anker Power Port 5
  ovDims=[58,27,90.2];
  rad=4;
  
  
  outRad=rad+spcng+wallThck;
  bdyHght=ovDims.z+wallThck+spcng;
  slotDims=[22,ovDims.y+wallThck+spcng*2+fudge,bdyHght+fudge];
  wallYOffset=ovDims.y/2+spcng+wallThck/2;
  if (showDummy) translate([0,0,0.01]) color("ivory") dummy();
    
  if (showHolder){
    difference(){
      body();
      //front and bottom slot
      translate([0,-(wallThck+fudge)/2,-wallThck-spcng+(bdyHght)/2]) 
        cube(slotDims,true);
      translate([0,-wallYOffset,ovDims.z-rad/2]) 
        cube([rad*2+slotDims.x,wallThck+fudge,rad+fudge],true);
      //screw holes
      for (iz=[-1,1])
        translate([0,wallYOffset,ovDims.z/2+iz*ovDims.z/3]){
          rotate([90,0,0]) cylinder(d=screwDia+spcng,h=wallThck+fudge,center=true);
          translate([0,-wallThck/2,0]) rotate([-90,0,0]) screwHd();
        }
    }
    for (ix=[-1,1])
      translate([ix*(slotDims.x/2+rad),-wallYOffset,ovDims.z-rad]) 
        rotate([90,0,0]) cylinder(r=rad,h=wallThck,center=true);
  }
 module body(){ 
  translate([0,0,-wallThck-spcng])  
    difference(){
      linear_extrude(ovDims.z+wallThck+spcng) offset(wallThck+spcng) shape();
      translate([0,0,wallThck]) linear_extrude(ovDims.z+spcng+fudge) 
        offset(spcng) shape();
    }
  }
  
  module dummy(){
    difference(){
      linear_extrude(ovDims.z) shape();
      translate([0,0,(11-fudge)/2]) cube([22,11.9,11+fudge],true);
    }
  }
  
  module shape(){
    hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(ovDims.x/2-rad),iy*(ovDims.y/2-rad),0]) circle(r=rad);
  }
}

*coin();
module coin(dia=10, h=3){
  rotate_extrude(){
    translate([(dia-h)/2,0]) circle(d=h);
    translate([0,-h/2]) square([(dia-h)/2,h]);
  }
}

*screwHd();
module screwHd(offset=spcng){
  cylinder(d1=screwDK+offset,d2=screwDia+offset,h=screwK+offset);
}