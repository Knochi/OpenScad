frntFeedDist=109.4;
frntFeedYOffset=9;
baseThck=5;
fudge=0.1;


//A1 Mini build Plate dimensions
*translate([-180/2,0,0]) linear_extrude(0.1) square([180,180]);
difference(){
  rotate(180) translate([97.95+(237.35-97.95)/2,18.41,0]) import("polisher-1-base.stl",convexity=3);
  //cut away old feet
  for (i=[0,1])
    mirror([i,0]) translate([74.7,-fudge,-fudge/2]) cube([20,40,baseThck+fudge]);
}
for (ix=[-1,1])
  color("#333333") translate([144.79+ix*frntFeedDist/2,-177.9+frntFeedYOffset,-10]) import("polisher-2v1-foot_flex_x4.stl");
  
import("N20 Reduction Gear Motor - LA002 LA003 LA004.stl");