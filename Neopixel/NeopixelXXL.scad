use <eCAD/packages.scad>

$fn=50;
scale(20) LED5050();

*translate([0,0,0]) rotate([90,0,0]) import("../BambuLabMakerSupply/RGBW Puck - KC007.stl");

module LED5050(){
  // e.g. WS2812(B)
  dims=[4.95,4.95,1.5];
  pitch= 3.2;
  grvHght=1;
  marking=[0.7,0.2]; //width,height
  spcng=0.2;
  fudge=0.1;
  
  botHoleRad=0.57;
  botHoleDepth=0.15;
  
  //body
  color("ivory")
    difference(){
      translate([0,0,(dims.z)/2+spcng]) cube(dims,true);
      translate([0,0,dims.z-grvHght+spcng]) cylinder(d1=3.2,d2=4,h=grvHght+0.01);
      //marking
      translate([dims.x/2,dims.y/2,dims.z-marking[1]+spcng]) linear_extrude(marking[1]+fudge)      
        polygon([[-marking.x-fudge,fudge],[fudge,fudge],[fudge,-marking.x-fudge]]);
      //botHole
      cylinder(r=botHoleRad,h=spcng+botHoleDepth);
    }
  *color("grey",0.6)
    translate([0,0,dims.z-grvHght]) cylinder(d1=3.2,d2=4,h=grvHght);
  
  //leads
  color("silver")
    for (i=[-1,1],r=[-90,90])
      rotate([0,0,r]) translate([dims.x/2,i*pitch/2,0]){
        translate([-1.1/2+0.2,0,0.1]) cube([1.1,1.0,0.2],true);
        translate([0.1,0,0.45]) cube([0.2,1.0,0.9],true);
      }
  
}