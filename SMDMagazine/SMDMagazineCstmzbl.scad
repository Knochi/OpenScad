// Customizable Version of SMD Magazine by robin7331
// https://www.thingiverse.com/thing:3952021

$fn=50;

/* [Dimensions] */
width=15;
gap=2;

/* [Advanced] */


/* [Hidden] */
fudge=0.1;

compliantMag();
module compliantMag(){
  %import("Compliant_SMD_Magazine_15_2.stl");
  
  rad=4;
  ovDims=[31.5*2,65,width];
  minWallThck=2.5;
  d1=22;
  d2=60;
  d3=3;
  difference(){
    union(){
      translate([0,ovDims.y/2,-1])
        hull() for (iy=[-1,1])
          translate([(ovDims.x/2-rad),iy*(ovDims.y/2-rad),0]) cylinder(r=rad,h=ovDims.z);
        translate([-22.5,0,-1]) cube([22.5+ovDims.x/2-rad,ovDims.y,ovDims.z]);
        translate([0,ovDims.y/2,0]) cylinder(d=d2+3,h=ovDims.z-1);
        translate([-31.7+d3/2,60.6,-1]) cylinder(d=d3,h=width);
      }
    
      *translate([-27.4-d1/2,50.75,-1-fudge/2]) cylinder(d=d1,h=width+fudge);
      //center diameter
      translate([0,ovDims.y/2,0]) cylinder(d=d2,h=ovDims.z-1+fudge);
      //channel (sketch#2)
      translate([0,ovDims.y-minWallThck-gap,0]) cube([ovDims.x/2+fudge,gap,ovDims.z-1+fudge]);
      translate([ovDims.x/2-14,ovDims.y,0]) 
        linear_extrude(ovDims.z-1+fudge) 
          polygon([[fudge,fudge],[-3.5+fudge,fudge],[-6.5-fudge,-2.5-fudge],[-3-fudge,-2.5-fudge]]);
      //hook (sketch#3)
      
    }//diff
}

module springMag(){
  %translate([0,32.5,0]) rotate([90,0,0]) %import("SMD_Magazine_v1_-_15-2.0.stl");
}