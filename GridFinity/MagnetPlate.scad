$fn=50;

grid=42;
brim=2;
size=[3,2];
rad=8-brim;
thick=2;

linear_extrude(thick) hull() for (ix=[-1,1],iy=[-1,1])
  translate([ix*(size.x*grid/2-brim-rad),iy*(size.y*grid/2-brim-rad)]) circle(rad);