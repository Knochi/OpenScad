use <rndRect2.scad>

/* [Dimensions] */
stemDist=[62,44];
stemDia=5;
stemZOffset=6.2; //12.2-6

sStemDist=[47,29];
sStemDia=5.25;
sStemZOffset=9.2; //12.2-1.1-1.9;

/* [show] */
showTop=true;
showBottom=true;
showPCB=true;
showCut=false;

/* [Hidden] */
pcbDims=[sStemDist.x+sStemDia,sStemDist.y+sStemDia,1.6];

difference(){
  union(){
    if (showTop) import("Z127_top.stl",convexity=3);
    if (showBottom) color("ivory") import("Z127_bottom.stl",convexity=3);
    if (showPCB) translate([0,0,-sStemZOffset]) import("PCB_V1.stl",convexity=3);
  }
  color("darkRed") translate([90,0,0]) cube([180,100,55],true);  
}
/*
translate([40,0,-6]) rotate([90,0,0]) color("salmon") cylinder(d=10.5,h=44.55,center=true);
translate([51,0,-6]) rotate([90,0,0]) color("salmon") cylinder(d=10.5,h=44.55,center=true);
translate([0,0,-sStemZOffset+pcbDims.z]) color("darkGreen") PCB();
*/


module PCB(){
  rndRect(pcbDims,sStemDia/2,2.6,center=true);
}