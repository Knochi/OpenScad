$fn=50;

difference(){
  union(){
    cylinder(d=85,h=1);
    cylinder(d=24,h=5);
  }
  translate([0,0,-0.5]) cylinder(d=10,h=6);
  }