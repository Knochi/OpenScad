height=20;
botWdth=10.5;
topWdth=8.8;
crnRad=5;
slope=2;

$fn=500;


difference(){
  rotate_extrude(angle=15) translate([192.5,0])   import("tBinRingShape.svg");

  rotate(1) translate([192,0,10]) rotate([0,90,0]) cylinder(d=2,h=10);
  rotate(14) translate([192,0,10]) rotate([0,90,0]) cylinder(d=2,h=10);
}
    