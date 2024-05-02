$fn=50;
%translate([-1.46,+2.55,0]) rotate([10,-11.5,-11.9+90]) scale(100) import("STL_Model/C3_BB_PrintModel_redox.stl");

//outer sphere
*translate([0,0,11.15]) sphere(7.74);

//front hole
translate([0,0,11.15]) rotate([90,0,0]) cylinder(d=6.2,h=8);
