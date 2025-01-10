/* [Dimensions] */
brickOvDims=[87,29,130];
brickCrnrRad=1;
slotWdth=35;

screwDia=3;
screwHeadDia=6;
screwHeadThck=1.8;

wallThck=2;

spcng=0.3;

/* [show] */
showDummy=true;
showHolder=true;

/* [Hidden] */
fudge=0.1;
$fn=20;



powerBrickWallMount();

module powerBrickWallMount(){  
  
  outerCrnrRad=brickCrnrRad+spcng+wallThck;
  bdyHght=brickOvDims.z+wallThck+spcng;
  slotDims=[slotWdth,brickOvDims.y+wallThck+spcng*2+fudge,bdyHght+fudge];
  wallYOffset=brickOvDims.y/2+spcng+wallThck/2;
  if (showDummy) translate([0,0,0.01]) color("ivory") dummy();
    
  if (showHolder){
    color("grey") difference(){
      body();
      //front and bottom slot
      translate([0,-(wallThck+fudge)/2,-wallThck-spcng+(bdyHght)/2]) 
        cube(slotDims,true);
      translate([0,-wallYOffset,brickOvDims.z-outerCrnrRad/2]) 
        cube([outerCrnrRad*2+slotDims.x,wallThck+fudge,outerCrnrRad+fudge],true);
      //screw holes
      for (iz=[-1,1])
        translate([0,wallYOffset,brickOvDims.z/2+iz*brickOvDims.z/3]){
          rotate([90,0,0]) cylinder(d=screwDia+spcng,h=wallThck+fudge,center=true);
          translate([0,-wallThck/2,0]) rotate([-90,0,0]) screwHd();
        }
    }
    color("grey") for (ix=[-1,1])
      translate([ix*(slotDims.x/2+outerCrnrRad),-wallYOffset,brickOvDims.z-outerCrnrRad]) 
        rotate([90,0,0]) cylinder(r=outerCrnrRad,h=wallThck,center=true);
  }
 module body(){ 
  translate([0,0,-wallThck-spcng])  
    difference(){
      linear_extrude(brickOvDims.z+wallThck+spcng) offset(wallThck+spcng) shape();
      translate([0,0,wallThck]) linear_extrude(brickOvDims.z+spcng+fudge) 
        offset(spcng) shape();
    }
  }
  
  module dummy(){
    difference(){
      linear_extrude(brickOvDims.z) shape();
      translate([0,0,(11-fudge)/2]) cube([22,11.9,11+fudge],true);
    }
  }
  
  module shape(){
    hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(brickOvDims.x/2-brickCrnrRad),iy*(brickOvDims.y/2-brickCrnrRad),0]) circle(r=brickCrnrRad);
  }
}


*screwHd();
module screwHd(offset=spcng){
  cylinder(d1=screwHeadDia+offset,d2=screwDia+offset,h=screwHeadThck+offset);
}