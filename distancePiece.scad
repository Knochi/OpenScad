$fn=50;

ovDims=[30,20,3];
rad=2;

difference(){
  linear_extrude(3) difference(){
    hull() for (ix=[-1,1],iy=[-1,1])
       translate([ix*(ovDims.x/2-rad),iy*(ovDims.y/2-rad)]) circle(rad);
    for(ix=[-1,1]) 
      translate([ix*7,0]) circle(d=3.5);
  }
  for(ix=[-1,1]) 
      translate([ix*7,0,0.9]) cylinder(d1=3.5,d2=6.8,h=2.1);
}
