showSectionCut=true;


translate([-127.4+17/2,-95+17/2,-10.5]) import("gl_flashlight_2.stl",convexity=3);

difference(){
  translate([-85.95-16.5/2,-78.85-15/2,0]) import("gl_flashlight_3.stl",convexity=3);
  cylinder(d=5,h=1);
  if (showSectionCut) translate([0,0,-0.1]) color("darkRed") cube(35);
}
color("darkgreen") rotate([0,180,0]) translate([-7.68/2,-7.6/2,-6.65]) import("KC005.stl");

