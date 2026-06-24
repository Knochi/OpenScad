rampWdth=130;
rampAng=35;

$fn=50;


rotate([rampAng+90,0,0]) translate([-rampWdth/2,0,0]) import("Ejector-ramp-rail_v02_ramp.stl");
#translate([rampWdth/2-10,50,0]) linear_extrude(50) circle(10);