ovDims=[74,150,35];
difference(){
  union(){
    import("SpoolStand.stl",convexity=4);
    translate([ovDims.x/2,3.94,3.00]) cube([29,3.2,4],true);
  }
  color("darkred") translate([ovDims.x,ovDims.y/2,ovDims.z/2]) cube(ovDims+[0.1,0.1,0.1],true);
  translate([ovDims.x/2,2.6,4]) cube([28,1.2,5],true);
  translate([ovDims.x/2,5.05,3.89]) rotate([-25,0,0]) cube([28,1.2,5],true);
}