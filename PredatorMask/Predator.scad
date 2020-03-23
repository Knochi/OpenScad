showEyes=false;


difference(){
  rotate([0,180,0]) translate([-124.6,-170-25,0]) import("predator_1.stl");
  translate([0,-105,-120]) cube([90,105,121]);
}

*import("predator_2.stl");
eyeDist=71;


if (showEyes)
for (ix=[-1,1])
  color("ivory") translate([ix*eyeDist/2,0,-10]) sphere(20);