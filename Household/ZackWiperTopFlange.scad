$fn=100;

ovHght=9.1;
fudge=0.1;

intersection(){
  difference(){
    union(){
      cylinder(d=17.4,h=6);
      translate([0,0,6]) cylinder(d=15.8,h=1);
      translate([0,0,ovHght-2.1]) cylinder(d=11.9,h=2);
    }
    translate([0,0,-fudge/2]) cylinder(d=6.1,h=ovHght+fudge);
    translate([0,0,-fudge]) cylinder(d=9.1,h=ovHght-6.6);
  }
  translate([0,0,ovHght/2]) rotate([90,0,0]) cylinder(d=17.8,h=ovHght*2,center=true);
}