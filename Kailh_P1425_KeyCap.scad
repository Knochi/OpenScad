// Kailh PG1425 Keycap
$fn=20;
capDims=[16.5,16.5,1.2];
crnRad=1;
fudge=0.1;

showDummy=false; //render a dumy for 3dPrint


translate([0,0,2.5+2]) PG1426Cap();
if (showDummy) translate([0,0,2.5+2/2]) cube([14,14,2],true);
PG1426body();

module PG1426body(){
  bdyDims=[14,14.8,2.5];
  difference(){
    union(){
      linear_extrude(bdyDims.z) rndRect([bdyDims.x,bdyDims.x],0.5); //square body
      translate([0,0,bdyDims.z-0.9]) linear_extrude(0.9) rndRect([bdyDims.x,bdyDims.y],0.5);
      translate([-1.1+4/2,0,-0.6]) linear_extrude(0.6) rndRect([4,5],0.25);
      for (ixy=[-1,1])
        translate([ixy*5.5,ixy*5.5,-0.6]) cylinder(d=1.2,h=0.6);
    }
    translate([2.9+3.6/2,0,-fudge/2]) linear_extrude(bdyDims.z+fudge) square([3.6,5],true);
  }
  //pins
  if (!showDummy){
    color("gold") translate([-2.9,-3.4,-2/2]) cube([0.9,0.2,2],true);
    color("gold") translate([2.0,-3.4,-2/2]) cube([0.2,0.6,2],true);
  }
  
  
}


module PG1426Cap(){

  hookOffset=[capDims.x/2-4.15,10.35/2,0];
  clipOffset=[hookOffset.x+0.5-10.1,hookOffset.y,0];
  //frame
  translate([0,0,-capDims.z/2]) linear_extrude(capDims.z/2) difference(){
    rndRect([capDims.x,capDims.y],crnRad);
    offset(-capDims.z/2) rndRect([capDims.x,capDims.y],crnRad);
  }
  //cap with fillet
  hull() for (ix=[-1,1],iy=[-1,1]){
    rot= ix>0 && iy>0 ? 0   :
         ix>0 && iy<0 ? -90 :
         ix<0 && iy>0 ? 90 :
         180;
    translate([ix*(capDims.x/2-crnRad),iy*(capDims.y/2-crnRad),0]) 
      rotate(rot) roundCorner(fillet=capDims.z/2,radius=crnRad);
  }
  //hooks
  
  translate(hookOffset) hook();
  mirror([0,1,0]) translate(hookOffset) hook();
  
  //clips
  translate(clipOffset) clip();
  mirror([0,1,0]) translate(clipOffset) clip();
}

*roundCorner();
module roundCorner(fillet=0.5, radius=2, facets=10){
  rotate_extrude(angle=90,$fn=facets*4){
    translate([radius-fillet,0])
      intersection(){
        circle(fillet);
        square(fillet+0.1);
      }
    square([radius-fillet,fillet]);
  }
}

module rndRect(size=[10,10],rad=3){
  hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(r=rad,$fn=40);
}

*hook();
module hook(){
  translate([1.4,0,0]) rotate([180,0,180]) difference(){
    cube([1.4,1,1.26]);
    translate([-0.1,-0.1,-0.1]) cube([0.9+0.1,0.75+0.1,0.86+0.1]);
  }
}

*clip();
module clip(){
  gap=0.65;
  dia=0.86;
  translate([0,0,-1.2+dia/2]) rotate([-90,0,0]) linear_extrude(0.75){
    for (ix=[-1,1])
      translate([ix*(gap+dia)/2,0]){
        circle(d=dia,$fn=40);
        translate([ix*-(0.5-dia)/2,-(1.2-dia/2)/2]) square([0.5,1.2-dia/2],true);
      }
  }
}