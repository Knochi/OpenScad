pcbOffset=[0,0,16.8-1.6/2];

color("darkslateGrey") mirror([0,1,0]) translate([0,-16,0]) rotate(90) import("AkkuCarrierv8.stl");

//color("darkgrey") translate([0,0,13.5/2+1]) rotate([0,90,0]) cylinder(d=13.5,h=70,center=true);
color("silver") translate([0,0,9.5/2+1]) cube([43,24,9.5],true);
color("darkGreen") translate(pcbOffset) cube([39*2-0.5,12*2-0.5,1.6],true);
color("gold") translate([-28,-4,pcbOffset.z+1.6/2]) cylinder(d=4,h=2,$fn=20);
color("gold") translate([-28-8,-4,pcbOffset.z+1.6/2]) cylinder(d=4,h=2,$fn=20);

