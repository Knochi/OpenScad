$fn=48;
*translate([-1,0,0]) rotate([0,90,0]){
  cylinder(d=14,h=48.3,center=true);
  translate([0,0,48.3/2]) cylinder(d=4,h=2);
}
difference(){
  translate([0,0,-4]) cube([67,20,15],true);
  for (ix=[-1,1])
    translate([ix*27.3,0,0]) rotate([90,0,0]) cylinder(d=4,h=22,center=true);
  translate([0,0,-2]) cube([62,15,14.2],true);
}