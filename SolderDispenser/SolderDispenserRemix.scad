$fn=50;

// solder dispenser remix
// https://www.thingiverse.com/thing:5768220

import("Case-Half-A.STL");

translate([49.2,20.3,7]) rotate([-90,0,0])  motorD6();
translate([18,27,0]) rotate([0,0,45]) vapeBat();
charger();
module motorD6(){
  //using the same motor 3.7V, 420rpm
  //https://www.aliexpress.com/item/4000053270585.html
  //motor
  color("silver") cylinder(d=6,h=12);
  //gearbox
  color("darkSlateGrey") translate([0,0,12]) cylinder(d=6,h=21-12);
  //D-shaft
  color("ivory") translate([0,0,21]) linear_extrude(2) difference(){
    circle(d=2);
    translate([0,1.5]) square(2,true);
  }
}

module vapeBat(){
  //primatic battery from a Vape 550mAh, 3.7V
  //XB801640
  ovDims=[40,16,8];
  color("silver") translate([0,0,0]) cube(ovDims,true);
}

module charger(){
  //USB-C charger module
  pcbDims=[18,14,1.6];
  color("darkSlateGrey") linear_extrude(pcbDims.z) square([pcbDims.x,pcbDims.y],true);
  //USB-C jack
  
}