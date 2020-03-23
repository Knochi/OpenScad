$fn=50;
ovDim=[30,25,3];
rad=2;
hOffset=[(239.5-202)/2,5];
conDim=([13,7*2.54,2.54]);
fudge=0.1;

color("orange",0.5) linear_extrude(ovDim.z) difference(){
  hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(ovDim.x/2-rad),iy*(ovDim.y/2-rad)]) circle(r=rad);
  translate([ovDim.x/2-hOffset.x,ovDim.y/2-hOffset.y]) circle(d=3);
  translate([rad,-rad]-[ovDim.x/2,-ovDim.y/2]) circle(d=1);
  translate([ovDim.x/2-conDim.x/2,0]) square([conDim.x+fudge,conDim.y],true);
}

translate([0,0,-ovDim.z]) linear_extrude(ovDim.z) difference(){
  hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(ovDim.x/2-rad),iy*(ovDim.y/2-rad)]) circle(r=rad);
  translate([ovDim.x/2-hOffset.x,ovDim.y/2-hOffset.y]) circle(d=2.4);
  translate([rad,-rad]-[ovDim.x/2,-ovDim.y/2]) circle(d=1);
  translate([-ovDim.x/2,-ovDim.y/2]) square([ovDim.x-conDim.x+rad+fudge,conDim.y]);
}

