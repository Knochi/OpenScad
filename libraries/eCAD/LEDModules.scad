
$fn=20;
fudge=0.1;

LEDButton();

module dualLED(){
//https://datasheet.lcsc.com/lcsc/2311141648_MEIHUA-MHK2310GEBTD_C7470875.pdf
  translate([1.27,10/2-8.59,10/2]) cube([4.6,10,10],true);
  for (iz=[-1,1]){
    col = (iz<1) ? "red" : "green";
    color(col) translate([1.27,-8.59,10/2+iz*2.5]) rotate([90,0,0]){
      cylinder(d=2.9,h=2.8-2.9/2);
      translate([0,0,2.8-2.9/2]) sphere(d=2.9);
      }
    }
  color("grey") for (ix=[-1,1],iy=[0,-1])
    translate([ix*1.27+1.27,iy*2.54,-3]) linear_extrude(3) square(0.5,true);
}

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