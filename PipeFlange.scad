$fn=50;

linear_extrude(3) difference(){
  circle(d=16.5);
  circle(d=6.1);
}

linear_extrude(8) difference(){
  circle(d=9.8);
  circle(d=6.1);
  translate([9.8/2,0]) circle(d=2);
}

difference(){
  translate([0,0,8]) cylinder(d1=9.8,d2=8,h=1);
  linear_extrude(10){
    translate([9.8/2,0]) circle(d=2);
    circle(d=6.1);
  }
}