$fn=50;

dia=19;
width=37.2;
wallThck=1.6;
fudge=0.1;
spcng=0.1;

difference(){
  translate([0,-15,0]) rotate([-90,0,0]) shell();
  translate([0,0,-dia/2+fudge]) linear_extrude(dia+wallThck+fudge,convexity=5) 
    offset(spcng) projection(true) translate([0,0,fudge]) switch();
}
*translate([0,0,dia/2+wallThck]) switch();

module shell(){
  difference(){
    linear_extrude(30,convexity=5) difference(){
      offset(wallThck) hull() for (ix=[-1,1])
        translate([ix*(width-dia)/2,0]) circle(d=19);
      square([width-dia+wallThck,dia],true);
    }
    translate([0,0,-fudge]) linear_extrude(7+fudge) hull() for (ix=[-1,1])
        translate([ix*(width-dia)/2,0]) circle(d=19);
    translate([0,0,30-2]) linear_extrude(7+fudge) hull() for (ix=[-1,1])
        translate([ix*(width-dia)/2,0]) circle(d=19);
    for (ix=[-1,1])
      translate([ix*(width/2-wallThck*3),0,30-10]) cylinder(d=2,h=10);
  }
}


module switch(){
  color("darkSlateGrey"){
    translate([0,0,-13.5/2]) cube([18.75,12.7,13.5],true);
    translate([0,0,1]) cube([21,15,2],true);
    translate([0,0,-13.5/2]) cube([21,5,13.5],true);
  }
  color("silver") for (ix=[0,1])
    translate([ix*7.4,0,-6.9/2-13.5]) cube([0.7,4.9,6.9],true);
}