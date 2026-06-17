length=50;
$fn=50;

difference(){ 
  rotate([90,0,0]) linear_extrude(length,center=true) polygon([[0,0],[0,-5],[45,-5],[45,23]]);
  for (iy=[-1,1])
    translate([45/2,iy*length/3,-5.1]) cylinder(d=4,h=25);
}