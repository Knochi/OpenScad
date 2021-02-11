fudge=0.1;
$fn=100;

difference() {
  sphere(d=30);
  cube(15.1);
  translate([15/2,-15-fudge/2,15/2]) rotate([-90,0,0]){
    cylinder(d=3,h=15.1);
    cylinder(d=6,h=10);
    translate([0,0,10-0.01]) cylinder(d1=6,d2=0.1,h=3);
  }
  rotate([45,-35,45]) translate([15,0,0]) cube([9,30,30],true);
 
}