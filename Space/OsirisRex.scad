//https://nasa3d.arc.nasa.gov/detail/osirisrex
// Size 
//  Core Cylinder diameter is ~1.3m
// forward and aft decks "are 2.5m on a side"
// spacecraft without structures is about 1.3m tall
$fn=20;

translate([0,0.2,-8.67]) import("NASA_osiris-rex.stl");

bdyDims=[64.5,62.48,35.87];
bdyCrnrRad=0.4;

body();

module body(){
  translate([0,0,-bdyDims.z/2]) linear_extrude(bdyDims.z) plateShape();
  module plateShape(){
    offset(bdyCrnrRad) 
      difference(){
      square([bdyDims.x-bdyCrnrRad*2,bdyDims.y-bdyCrnrRad*2],true);
      polygon([[-32,10.5],[-18.15,5.3],[-18.15,-4.9],[-32,-10.5]]);
      polygon([[32,-21.17],[25.00,-11.7],[25.0,-10.3],[25.4,-10.3],
               [25.4,10.3],[25,10.3],[25.0,11.5],[32,21.20]]);
      }
  }
}

module solarPanel(){
  panelThck=0.5;
  
}