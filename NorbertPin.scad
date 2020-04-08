$fn=20;
use <threads.scad>
lngth=60;

//for (id=[[0,6.1],[1,6.2],[2,6.3]])
  !translate([0,0,0]) 
    rotate([180,0,0]) difference(){
      cylinder(d=8.1,h=lngth);
      translate([0,0,-1]) metric_thread (diameter=6.1, pitch=1, length=lngth, internal=true);
      translate([0,0,-0.1]) cylinder(d1=7,d2=5,h=1);
    }

union(){
  translate([0,0,-60+15]) cylinder(d=6,h=60);
  translate([0,0,-39]) cylinder(d=8,h=39+16);
}


translate([0,0,-39.6]) donut();
donut(8,20);
translate([0,0,16]) circle(10);

module donut(di=6.5,do=20)
difference(){
  circle(d=do);
  circle(d=di);
}