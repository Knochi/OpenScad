//checkerboard
for (ix=[0:4],iy=[0:4]){
  color("darkSlateGrey"){
    translate([ix*20,iy*20]) cube(10);
    translate([ix*20+10,iy*20+10]) cube(10);
    }
  color("ivory"){
    translate([ix*20+10,iy*20]) cube(10);
    translate([ix*20,iy*20+10]) cube(10);
    }
  }
  #translate([50,50,0]) cylinder(d=1.2,h=11,$fn=20);