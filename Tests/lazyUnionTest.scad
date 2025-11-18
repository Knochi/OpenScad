$fn=20;

color("green")
  translate([0,0,5]) difference(){
    cube(10,true);
    cylinder(d=5,h=20,center=true);
  }

color("red") cylinder(d=5,h=15);