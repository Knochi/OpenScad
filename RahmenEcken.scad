
$fn=50;

ovDims=[40,40,15];
thick=5;


*color("grey")
  translate([-66.5,-91.5,6.3]) corner();
*color("ivory") frame();

for (i=[0:3])
  translate([i*thick*1.7,i*thick*1.7,0]) corner();

module corner(){
  translate([thick/2,thick/2,0]) linear_extrude(ovDims.z){
    hull() for (ix=[0,1]) translate([ix*(ovDims.x-thick/2),0]) circle(d=thick);
    hull() for (iy=[0,1]) translate([0,iy*(ovDims.y-thick/2)]) circle(d=thick);
  }
}

module frame(){
  ovDims=[155,205,36];
  wallThck=10.7;
  frntWdth=18.5;
  frntThck=6.3;
  
  linear_extrude(frntThck) difference(){
    square([ovDims.x,ovDims.y],true);
    square([ovDims.x-frntWdth*2,ovDims.y-frntWdth*2],true);
  }
  translate([0,0,frntThck]) linear_extrude(ovDims.z-frntThck) difference(){
    square([ovDims.x,ovDims.y],true);
    square([ovDims.x-wallThck*2,ovDims.y-wallThck*2],true);
  }
}