$fn=20;
pcbDia=18.6;
fudge=0.1;

!difference(){
  intersection(convexity=4){
    solidSnap();
    rotate(180/8) cylinder(d=20.5,h=2,$fn=8);
  }
  translate([0,0,1])
    rotate([180,0,0]) translate([-17.5/2,-18.6/2,-5.83]) 
      import("D18X6.5MM KC012-13.STL",convexity=3);
  for (iy=[-1,1])
    translate([+0,iy*9.4,1]) cylinder(d=4,h=1+fudge);
  *for (r=[0,120,240])
    #rotate(r) translate([5.75+1.4/2,0,1.5+fudge/2]) cube([1.4,3,1+fudge],true);
}
module solidSnap(){
  import("Multiboard Snap.stl",convexity=3);
  rotate(180/8) cylinder(d=19,h=8.8,$fn=8);
}

color("darkgreen") translate([0,0,1])
  rotate([180,0,0]) translate([-17.5/2,-18.6/2,-5.83]) 
    import("D18X6.5MM KC012-13.STL");

