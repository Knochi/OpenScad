thick=7;
rad=thick/2;
fudge=0.1;
$fn=50;

difference(){
  intersection(){
    plate();
    rotate(90) plate();
  }
  for (ix=[-1,1],iy=[-1,1])
    translate([ix*80/2,iy*80/2,-thick-fudge/2]){
      cylinder(d=3.5,h=thick+fudge);
      cylinder(d1=8,d2=3.5,h=3.5);
  }
}
module plate(){
  rotate([90,0,0]) linear_extrude(110,center=true){
    difference(){
      hull() for (ix=[-1,1]) translate([ix*(110/2-rad*2),0]) circle(rad*2);
      translate([0,thick/2]) square([110,thick],true);
      }
    
  }
}
