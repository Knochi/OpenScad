// Remixing from https://thangs.com/designer/K2_Kevin/3d-model/MultiBoom%20Arm%20-%20Multiboard%20Boom%20Arm-1031270


//sleek Mount
ovDims=[25,50,34.7];
chamfer=5;
rad=+2;
fudge=0.1;
holeDia=15.4;
opngDims=[ovDims.y,27.7,ovDims.z-11.5];
$fn=50;

*translate([198.820,-270-0.83,-6.4]) import("MultiBOOM_Mount-A_Wall_T-BOLT_STRONG.stl");


//body

difference(){
  intersection(){
    linear_extrude(ovDims.z) offset(delta=chamfer,chamfer=true) square([ovDims.x-chamfer*2,ovDims.y-chamfer*2],true);
    translate([0,0,ovDims.z/2-chamfer]) rotate([90,0,0]) linear_extrude(ovDims.y+fudge,center=true) offset(delta=chamfer*2,chamfer=true) square([ovDims.x-chamfer*4,ovDims.z-chamfer*2],true);
  }

  translate([0,0,23.7]) rotate([90,0,0]) cylinder(d=holeDia,h=ovDims.y+fudge,center=true);
  
  
  translate([0,0,opngDims.z/2+11.5+rad/2]) 
    rotate([0,90,0]) 
      linear_extrude(ovDims.x+fudge,center=true) hull() 
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*(opngDims.z/2-rad/2),iy*(opngDims.y/2-rad)]) circle(rad);
}