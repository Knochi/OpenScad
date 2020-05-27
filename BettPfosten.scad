$fn=50;

wallThck=2;
fudge=0.1;

difference(){
  union(){
    cylinder(d=28.3,h=30);
    translate([0,0,30]) cylinder(d=25,h=25);
  }
  translate([0,0,5]) cylinder(d=25-4,h=30+25);
  translate([0,0,-fudge/2]) cylinder(d=6.1,h=5+fudge);
}