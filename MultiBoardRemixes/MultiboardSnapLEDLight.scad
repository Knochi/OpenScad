$fn=50;
pcbDia=18.6;
fudge=0.1;
latSpcng=0.25;
zSpcng=0.1;
sectionCut=true;

//lid
difference(){
  intersection(){
    solidSnap();
    rotate(180/8) cylinder(d=21.6,h=3,$fn=8);
  }
  *translate([0,0,1])
    rotate([180,0,0]) translate([-17.5/2,-18.6/2,-5.83]) 
      import("D18X6.5MM KC012-13.STL",convexity=3);
  translate([+0,0,1.5+fudge/2]) cube([4,20,1+fudge],true);
  translate([+0,0,2.5+fudge/2]) cube([18,20,1+fudge],true);
  translate([0,0,1]) cylinder(d=pcbDia-1,h=1+fudge);
  rotate(158) translate([8.4,0,1.5+fudge/2]) cube([1.4,3,1+fudge],true);
  rotate(233) translate([8.4,0,1.5+fudge/2]) cube([1.4,3,1+fudge],true);
}

//snap
difference(){
  solidSnap();
  translate([0,0,-fudge]) rotate(180/8) cylinder(d=21.6+latSpcng,h=3+fudge+latSpcng,$fn=8);
  cylinder(d=16.6,h=10);
  for (iy=[-1,1])
    translate([0,iy*8,6.5/2]) cube([3,3,6.5],true);
  if (sectionCut) color("darkRed") translate([0,(6+fudge/2),4.5]) cube([24+fudge,12+fudge,9+fudge],true);
}
  
module solidSnap(){
  import("Multiboard Snap.stl",convexity=3);
  rotate(180/8) cylinder(d=19,h=8.8,$fn=8);
}

color("darkgreen") translate([0,0,1+fudge])
  rotate([180,0,0]) translate([-17.5/2,-18.6/2,-5.83]) 
    import("D18X6.5MM KC012-13.STL");

