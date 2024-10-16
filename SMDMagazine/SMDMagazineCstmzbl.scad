// Customizable Version of SMD Magazine by robin7331
// https://www.thingiverse.com/thing:3952021

// Another version at Hackaday
// https://hackaday.io/project/169398-modified-smd-tape-magazines

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
  ovDims=[63,65,width];
  
  //nodge 
  rghtNodge=[
    [ovDims.x/2,4],
    [ovDims.x/2-5,4+1],
    [ovDims.x/2-5,4+1+5],
    [ovDims.x/2,4+7]
  ];
  
  //hook
  hook=[];
  
  poly=concat([
    [-ovDims.x/2,11],
    [-ovDims.x/2+5,11],
    [-ovDims.x/2+5,11-4],
    [-ovDims.x/2+5+4,0],
    [ovDims.x/2-4,0]],
    rghtNodge,
    [[ovDims.x/2,ovDims.y],
    [-ovDims.x/2,ovDims.y]
  ]);
  
  minWallThck=2.5;
  d1=22;
  d2=60; //inner Diameter
  d3=3;
  
 
  difference(){
    translate([0,0,-1]) linear_extrude(ovDims.z,convexity=2) polygon(poly);
    translate([0,ovDims.y/2,0]) cylinder(d=d2,h=ovDims.z-1+fudge);
    //channel (sketch#2)
      translate([0,ovDims.y-minWallThck-gap,0]) cube([ovDims.x/2+fudge,gap,ovDims.z-1+fudge]);
      translate([ovDims.x/2-14,ovDims.y,0]) 
        linear_extrude(ovDims.z-1+fudge) 
          polygon([[fudge,fudge],[-3.5+fudge,fudge],[-6.5-fudge,-2.5-fudge],[-3-fudge,-2.5-fudge]]);
    
  }
  /*
  
     translate([-27.4-d1/2,50.75,-1-fudge/2]) cylinder(d=d1,h=width+fudge); 
      //center diameter
      translate([0,ovDims.y/2,0]) cylinder(d=d2,h=ovDims.z-1+fudge);
      //channel (sketch#2)
      translate([0,ovDims.y-minWallThck-gap,0]) cube([ovDims.x/2+fudge,gap,ovDims.z-1+fudge]);
      translate([ovDims.x/2-14,ovDims.y,0]) 
        linear_extrude(ovDims.z-1+fudge) 
          polygon([[fudge,fudge],[-3.5+fudge,fudge],[-6.5-fudge,-2.5-fudge],[-3-fudge,-2.5-fudge]]);
      //hook (sketch#3)
      
    }//diff
  */
}

module springMag(){
  %translate([0,32.5,0]) rotate([90,0,0]) %import("SMD_Magazine_v1_-_15-2.0.stl");
}