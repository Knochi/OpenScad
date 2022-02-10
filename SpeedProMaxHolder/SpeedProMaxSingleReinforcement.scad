
!translate([-86.33-77.35/2,-149.64,0]) import("SpeedproMaxSingleHolder.stl");
//close the logo
translate([0,1,31.5]) cube([18*2,2,8],true);


translate([0,0.5,0]) rotate([90,0,-90]) wedge();
module wedge(){
  poly=[[0,0],[42,0],[42,26],[0,38]];
  smallPoly=[[0,0],[42,0],[42,26-2],[0,38-2]]; //to create chamfered wedge
  hull(){
    linear_extrude(8,center=true) 
      polygon(poly);
    translate([0,0,4]) linear_extrude(2) polygon(smallPoly);
    translate([0,0,-4]) mirror([0,0,1]) linear_extrude(2) polygon(smallPoly);
  }
}