$fn=20;

!union(){
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