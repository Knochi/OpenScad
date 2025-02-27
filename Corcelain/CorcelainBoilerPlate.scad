use <threads.scad>

screwDia=41.8;
screwCtnrHoleDia=36.5;

test=true;


translate([0,-90.9+(90.9-49.1)/2,0]) import("corcelain_screw_long_V0100.stl");
*translate([0,-141.9+(141.9-100.1)/2,0]) import("corcelain_screw_short_V0100.stl");

%rotate(108) metric_thread (diameter=screwDia, pitch=7.5, thread_size=7.5, angle=45, length=65, test=test);


