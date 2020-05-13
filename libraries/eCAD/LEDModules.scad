
$fn=20;
fudge=0.1;

LEDButton();

module LEDButton(dia=9){
  PCBThck=1.5;
  LED5050();
  translate([0,0,-PCBThck]) cylinder(d=dia,h=PCBThck);
  for (ix=[-1,1]) 
    translate([ix*3.5,0,0]) rotate(90) r_SMD();
}

*r_SMD();
module r_SMD(size="0603"){
  //overall dimensions and contact width
  dims= (size=="0805") ? [2.0,1.25,0.50,0.35] : 
        (size=="0603") ? [1.6,0.80,0.45,0.25] : 
        (size=="0402") ? [1  ,0.50,0.35,0.20] :
        (size=="0201") ? [0.6,0.30,0.30,0.10] : [0.4,0.2,0.13,0.10];
  color("darkSlateGrey") translate([0,0,dims.z/2]) cube([dims.x-dims[3]*2,dims.y,dims.z],true);
  color("lightGrey") for (ix=[-1,1]) 
    translate([ix*(dims.x-dims[3])/2,0,dims.z/2]) 
      cube([dims[3],dims.y,dims.z],true);
}

module LED5050(pins=4){
  // e.g. WS2812(B)
  dims=[5,5,1.5];
  pitch= (pins==6) ? 0.9 : 1.8;
  grvHght=1;
  marking=[0.7,0.2]; //width,height
  
  //body
  color("ivory")
    difference(){
      translate([0,0,(dims.z+0.1)/2]) cube(dims-[0,0,0.1],true);
      translate([0,0,dims.z-grvHght]) cylinder(d1=3.2,d2=4,h=grvHght+0.01);
      //marking
      translate([dims.x/2,dims.y/2,dims.z-marking[1]]) linear_extrude(marking[1]+fudge)      
        polygon([[-marking.x-fudge,fudge],[fudge,fudge],[fudge,-marking.x-fudge]]);
    }
  color("grey",0.6)
    translate([0,0,dims.z-grvHght]) cylinder(d1=3.2,d2=4,h=grvHght);
  //leads
  color("silver")
    for (i=[-pins/2+1:2:pins/2],r=[-90,90])
      rotate([0,0,r]) translate([dims.x/2,i*pitch,0]){
        translate([-1.1/2+0.2,0,0.1]) cube([1.1,1.0,0.2],true);
        translate([0.1,0,0.45]) cube([0.2,1.0,0.9],true);
      }
}