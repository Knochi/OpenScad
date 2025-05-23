use <eCAD/packages.scad>

$fn=50;
scale(20) LED5050();

rotate([90,0,0]) import("../BambuLabMakerSupply/RGBW Puck - KC007.stl");

module LED5050(pins=4){
  // e.g. WS2812(B)
  dims=[5,5,1.5];
  pitch= (pins==6) ? 0.9 : 1.8;
  grvHght=1;
  marking=[0.7,0.2]; //width,height
  fudge=0.1;
  
  //body
  color("ivory")
    difference(){
      translate([0,0,(dims.z+0.1)/2]) cube(dims-[0,0,0.1],true);
      translate([0,0,dims.z-grvHght]) cylinder(d1=3.2,d2=4,h=grvHght+0.01);
      //marking
      translate([dims.x/2,dims.y/2,dims.z-marking[1]]) linear_extrude(marking[1]+fudge)      
        polygon([[-marking.x-fudge,fudge],[fudge,fudge],[fudge,-marking.x-fudge]]);
    }
  *color("grey",0.6)
    translate([0,0,dims.z-grvHght]) cylinder(d1=3.2,d2=4,h=grvHght);
  
  //leads
  color("silver")
    for (i=[-pins/2+1:2:pins/2],r=[-90,90])
      rotate([0,0,r]) translate([dims.x/2,i*pitch,0]){
        translate([-1.1/2+0.2,0,0.1]) cube([1.1,1.0,0.2],true);
        translate([0.1,0,0.45]) cube([0.2,1.0,0.9],true);
      }
  
}