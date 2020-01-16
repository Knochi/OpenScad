$fn=50;
wallThck=2;
clipThck=9.5;
ovDims=[15,18,80]; //height is clipped height
crnrRad=3;

/* [hidden] */
fudge=0.1;
rad=ovDims.y/2-wallThck;

linear_extrude(ovDims.x) clip();

for (ix=[0,1])
  translate([ix*(wallThck+clipThck),ovDims.z-crnrRad,0]) 
    hull() for (iz=[crnrRad,ovDims.x-crnrRad]) translate([0,0,,iz]) 
      rotate([0,90,0]) cylinder(r=crnrRad,h=wallThck);

module clip(){
  
  difference(){
    union(){
      translate([rad+wallThck,0]) circle(rad+wallThck);
      square([wallThck*2+clipThck,ovDims.z-crnrRad]);
    }
    translate([rad+wallThck,0]) circle(rad);
    translate([wallThck,0]) square([clipThck,ovDims.z-crnrRad+fudge]);
  }
}