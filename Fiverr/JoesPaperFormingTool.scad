/* [Quality] */
$fn=50; //[20:100]
/* [Dimensions] */
baseHght=95;
baseWdth=115;
topPlaneHght=65;
topPlaneWdth=85;
crnrRad=3;
foldedHght=30;
thickness=10;
ntchCrnrDist=30;
ntchCutDist=4;
mntHoleDist=45;
mntHoleDia=9;

/* [Hidden] */
modelHght=0.75*foldedHght;
fudge=0.1;
mntHoleChamfer=thickness/2;

formingTool();

module formingTool(){
  difference(){
    //loftOuter
    hull(){
      rndRectPlane([baseWdth,baseHght],crnrRad);
      translate([0,0,modelHght]) mirror([0,0,1]) 
        rndRectPlane([topPlaneWdth,topPlaneHght],crnrRad);
    }
    //loftInner
    translate([0,0,-fudge/2]) hull(){
      rndRectPlane([baseWdth-thickness*2,baseHght-thickness*2],crnrRad);
      translate([0,0,modelHght-thickness]) mirror([0,0,1]) 
        rndRectPlane([topPlaneWdth-thickness*2,topPlaneHght-thickness*2],crnrRad);
    }
  
    //notches
    translate([0,0,(ntchCutDist-fudge)/2]){ 
      cube([baseWdth-ntchCrnrDist*2,baseHght+fudge,ntchCutDist+fudge],true);
      cube([baseWdth+fudge,baseHght-ntchCrnrDist*2,ntchCutDist+fudge],true);
    }
    
    //mounting holes
    for (i=[-1,1]){
      translate([i*mntHoleDist/2,0,-fudge/2]){
        cylinder(d=mntHoleDia,h=modelHght+fudge);
        translate([0,0,modelHght-mntHoleChamfer]) 
          cylinder(d1=mntHoleDia,d2=mntHoleDia+mntHoleChamfer*2,h=mntHoleChamfer+fudge);
      }
      translate([0,i*mntHoleDist/2,-fudge/2]){
        cylinder(d=mntHoleDia,h=modelHght+fudge);
        translate([0,0,modelHght-mntHoleChamfer]) 
          cylinder(d1=mntHoleDia,d2=mntHoleDia+mntHoleChamfer*2,h=mntHoleChamfer+fudge);
      }
    }
    //vent holes in corners
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*((topPlaneWdth-mntHoleDia)/2-thickness),iy*((topPlaneHght-mntHoleDia)/2-thickness),-fudge/2]) 
        cylinder(d=mntHoleDia,h=modelHght+fudge);
    //center vent hole
    translate([0,0,-fudge/2])
      cylinder(d=mntHoleDia,h=modelHght+fudge);
  }
}


module rndRectPlane(size=[30,30],rad=3){
  //a 3D plane
  linear_extrude(0.2,scale=0.1) hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
}