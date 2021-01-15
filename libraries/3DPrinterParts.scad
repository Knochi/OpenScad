$fn=20;

E3DV6();

fudge=0.1;

module E3DV6(){
  blockOffset=-13.5;
  nozzleOffset=-6;
  heatBreakOffset=-7;
  color("silver") V6HeatSink();
  color("silver") translate([0,0,blockOffset]) V6Block();
  color("gold") translate([0,0,blockOffset+nozzleOffset]) V6Nozzle();
  color("grey") translate([0,0,heatBreakOffset]) V6HeatBreak();
}

module V6HeatSink(){
  ovHght=42.7;
  
  difference(){
    body();
    translate([0,0,-fudge]){
     cylinder(d=6,h=15.1+fudge);
     cylinder(d=7,h=10+fudge);
     cylinder(d=4.2,h=ovHght+fudge*2);
    }
    translate([0,0,ovHght-6.5+fudge]) cylinder(d=8,h=6.5+fudge);
  }
  
  module body(){
    //fins
    cylinder(d=22.3,h=1);
    for (iz=[1:10])
      translate([0,0,iz*2.5]) cylinder(d=22,h=1);
    translate([0,0,11*2.5]) cylinder(d=16,h=1);
    
    //mount
    translate([0,0,ovHght-3.7]) cylinder(d=16,h=3.7);
    translate([0,0,ovHght-3.7-6]) cylinder(d=12,h=6);
    translate([0,0,ovHght-3.7-6-3]) cylinder(d=16,h=3);
    
    //core
    cylinder(d1=10,d2=8,h=30);
  }
}

*V6Block();
module V6Block(){
  dims=[23,16,11.5];
  blockOffset=[-dims.x+8,-8,0];
  translate(blockOffset) difference(){
    cube(dims);
    translate([dims.x-20.5,8,-fudge/2]) cylinder(d=3,h=dims.z+fudge);
    translate([dims.x-2,8,-fudge/2]) cylinder(d=3,h=5.75);
    translate([dims.x-8,8,-fudge/2]) cylinder(d=6,h=dims.z+fudge);
    translate([dims.x-14.5,-fudge/2,4]) rotate([-90,0,0]) cylinder(d=6,h=dims.y+fudge);
    translate([-fudge/2,-fudge/2,4-0.5]) cube([dims.x-14.5+fudge,dims.y+fudge,1]);
  }
}

*V6Nozzle();
module V6Nozzle(){
  ovHght=12.5;
  translate([0,0,ovHght-6]) cylinder(d=6,h=6);
  translate([0,0,ovHght-7.5]) cylinder(d=5,h=1.5);
  translate([0,0,ovHght-10.5]) cylinder(d=7/0.866,h=3,$fn=6);
  cylinder(d1=1,d2=5,h=2);
}

module V6HeatBreak(){
  cylinder(d=6,h=5);
  translate([0,0,5]) cylinder(d=2+2*0.48,h=2.1);
  translate([0,0,5+2.1]) cylinder(d=7,h=15);
}