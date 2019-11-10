$fn=50;
fudge=0.1;

use <bend.scad>

*translate([20,0,0]) SE0802();
solenoid();


module solenoid(engaged=false){
  //https://www.sparkfun.com/products/11015
  //small 5V solenoid
  
  sheetThck=1;
  bendRad=1;
  bodyDim=[20.6,11,12.1];
  plungerDim=[29.1,4,4];
  plungerOffset=7.8;
  faceOffset=0.3;
  stroke= (engaged) ? 3.6 : 0;
  
  //translate([0,bodyDim.y,0]) rotate(-90) 
  color("silver") difference(){  
    shell();
    translate([(bodyDim.y-5.6)/2,-fudge/2,-fudge/2]) 
      cube([5.6,sheetThck+faceOffset+fudge,bodyDim.z+fudge]);
  }
  //faceplate
  color("silver") difference(){
    union(){
      translate([0,faceOffset,sheetThck+fudge/2]) 
        cube([bodyDim.y,sheetThck,bodyDim.z-sheetThck*2-fudge]);
      translate([(bodyDim.y-5.6+fudge)/2,0.3,-fudge/2]) cube([5.6-fudge,sheetThck,bodyDim.z]);
    }
    translate([bodyDim.y/2,faceOffset-fudge/2,bodyDim.z/2]) 
      rotate([-90,0,0]) cylinder(d=4+fudge,h=sheetThck+fudge);
  }
  
 //coil
  color("blue")
  translate([bodyDim.y/2,sheetThck+faceOffset+fudge/2,bodyDim.z/2])
    rotate([-90,0,0]) cylinder(d=bodyDim.y,h=bodyDim.x-sheetThck*2-faceOffset-fudge);
  
  //plunger
    translate([bodyDim.y/2,faceOffset-plungerOffset+stroke,bodyDim.z/2])
      rotate([-90,0,0]) plunger();
  
  module plunger(){
    color("silver"){
      cylinder(d=4,h=1.5);
      cylinder(d=3,h=3);
      translate([0,0,1.5+0.7]) cylinder(d=4,h=plungerDim.x-stroke-sheetThck-1.1-1.5-0.7);
      translate([0,0,plungerDim.x-stroke-sheetThck-1.1]) 
        cylinder(d=1.6,h=stroke+sheetThck);
      translate([0,0,plungerDim.x-1.1])
        cylinder(d=3,h=1.1);
    }
    color("darkSlateGrey")
      translate([0,0,1.5+fudge/2]) difference(){
        cylinder(d=7,h=0.6);
        translate([-0.3,-0.3,-fudge/4]) cube([7,7,0.6+fudge/2]);
        translate([0,0,-fudge/4]) cylinder(d=3,h=0.6+fudge/2);
      }
  }
  
  module shell(){
    cube([bodyDim.y,bodyDim.x-bendRad,sheetThck]);
      translate([0,bodyDim.x-bendRad,0]) 
        bend([bodyDim.y,bodyDim.z,sheetThck],90,bendRad)
          cube([bodyDim.y,bodyDim.z-bendRad*2,sheetThck]);
    
    translate([0,bodyDim.x,bodyDim.z-bendRad])
      rotate([90,0,0])
      bend([bodyDim.y,bendRad,sheetThck],90,bendRad)
      cube([bodyDim.y,bodyDim.x-bendRad,sheetThck]);
  }
  
}

module SE0802(){
  
  //body
  translate([0,0,7.7-5]) difference(){
    union(){
      color("darkSlateGrey")cylinder(d=10.5,h=4);
      color("Crimson") translate([0,0,4]){ cylinder(d=10.5,h=0.5);
      translate([0,0,0.5]) cylinder(d1=10.5,d2=10,h=0.5);
      }
    }
    color("black") translate([0,0,-fudge/2]) cylinder(d=9,h=4+fudge);
    color("Crimson") for (r=[0:360/5:360-360/5]){
      rotate(r) translate([6.5/2,0,-fudge/2]) cylinder(d=2.4,h=5+fudge);
    }
  }
  
  
  color("Crimson") cylinder(d=4.2,h=3);
  //axis
  color("silver"){
  translate([0,0,-(14.9-7.7-5.9)]){
    cylinder(d=1,h=14.9);
    cylinder(d=1.4,h=9.8);
  }
  translate([0,0,-0.8]) cylinder(d=1.65,h=0.8);
}
  //flange
 color("Crimson") difference(){
    union(){
      cylinder(d=5,h=1);
      cylinder(d=8,h=1);
      for (r=[0:120:240])
        rotate(r) translate([3.3,0,0]) cylinder(r=1.34,h=1);
    }
    for (r=[0:120:240]){
      rotate(r+60) translate([2.5+8.2,0,-fudge/2]) cylinder(r=8.2,h=1+fudge);
      rotate(r) translate([6.6/2,0,-fudge/2]) cylinder(d=1.4,h=1+fudge);
    }
  }
}