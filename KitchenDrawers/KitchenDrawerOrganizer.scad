$fn=50;
partOrigWdth=30;
 
*rotate(-90) scale(1.5) translate([0,5,0]) import("45mm, side part.stl");
*scale(1.5) translate([-145.5,-150,0]) import("T-joint.stl");
scale (1.5) rotate(180) translate([-159.65,-150,0]) import("T-joint, side part.stl");

#translate([-32,0,0]) rotate([90,0,0]) linear_extrude(partOrigWdth*1.5,center=true) import("DrawersSlope.svg");

//support stub
translate([-4,0,45-9.8/2]) rotate([90,0,0]) cylinder(d=9.8,h=partOrigWdth*1.5,center=true);
translate([-2,0,45-9.8/2]) cube([(9.8/2+4)/2,partOrigWdth*1.5,9.8],center=true);