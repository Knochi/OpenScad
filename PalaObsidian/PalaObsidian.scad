/* [mainPCB] */
pcbCrnrRad=3;
pcbDims=[ 34,48,1];
pcbHoleDist=[28,44];
pcbCutOutDims=[21.85,5.6];
pcbHoleDia=2;
pcbBtnPos=[[17,-3.85,0],[17,-14.2,0]]; //relative to PCB center
btnRot=[0,180,90];
hdrDims=[15.7,5.08,8.7];
hdrPos=[-12.9,-2,0];

/* [ePaper] */
epGlassDims=[31.85,37.4,1];
epFoamThck=2.6;
epCntrOffset=[0,0,0];

/* [GPSModule] */
gpsOvDims=[12.3,16.2,4.9];

/* [shell] */
boundingHullDims=[50,80,25];

/* [Hidden] */
fudge=0.1;
$fn=50;

 mainPCB();
translate([0,36,0]) GPS();
obsidian();
%translate([-50,-40]) scale(0.5) import("Obsidian_shapes.svg");

module mainPCB(){
  color("darkBlue") PCB();
  color("lightGrey") translate([0,0,pcbDims.z]) ePaper();
  color("darkGrey") translate(hdrPos+[0,0,-hdrDims.z/2]) rotate(90) cube(hdrDims,true);
  
  for (pos=pcbBtnPos)
    translate(pos) rotate(btnRot) button();
  
  module PCB(){
    linear_extrude(pcbDims.z) difference(){
      offset(pcbCrnrRad) square([pcbDims.x-pcbCrnrRad*2,pcbDims.y-pcbCrnrRad*2],true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*pcbHoleDist.x/2,iy*pcbHoleDist.y/2]) circle(d=pcbHoleDia);
      translate([0,(pcbDims.y-pcbCutOutDims.y+fudge)/2]) square(pcbCutOutDims+[fudge,0],true);
    }
  }
    
  module ePaper(){
  translate(epCntrOffset+[0,0,epGlassDims.z/2+epFoamThck])
    cube(epGlassDims,true);
  }
  
  module button(){
    bdyDims=[4.6,2.7,3.45];
    knobDia=2;
    knobThck=0.8;
    color("#202020")
      translate([0,bdyDims.y/2,bdyDims.z/2]) 
        cube(bdyDims,true);
    color("ivory") 
      translate([0,0,bdyDims.z/2]) 
        rotate([90,0,0]) 
          cylinder(d=knobDia,h=knobThck);
  }
}

module obsidian(){
  sphDias=[60,50,50,50];
  sphPoss=[
    [23.0,15,17], //0
    [-12.0,23,27],
    [-4.0,-29,27],
    [-44.0,-13,27],
    [14.0,9,27]
    ];
  sphScale=[
    [0.8,1,0.5],
    [1,1,1],
    [1,1,1],
    [1,1,1]
  ];

}

*GPS();
module GPS(){
// FlyFish RC M10
pcbDims=[12.1,16,0.8];
antDims=[11.4,11.4,2];
antRad=1;
antOffset=[0,(pcbDims.y-antDims.y)/2-1.3,pcbDims.z+antDims.z/2];
shldDims=[12,12,1.6];
shldOffset=[0,(pcbDims.y-shldDims.y)/2-0.2,-shldDims.z/2];
coinDia=3.7;
coinHght=1.3;
coinOffset=[pcbDims.x/2-coinDia/2,-pcbDims.y/2+coinDia/2,-coinHght];
ledDims=[1.6,0.8,0.4];
ledOffset=[0,-pcbDims.y/2+2,pcbDims.z];

color("#222222") linear_extrude(pcbDims.z) square([pcbDims.x,pcbDims.y],true);
color("brown") translate(antOffset) linear_extrude(antDims.z,center=true) 
  offset(antRad) square([antDims.x-antRad*2,antDims.y-antRad*2],true);
color("silver") translate(shldOffset)  linear_extrude(shldDims.z,center=true) 
  square([shldDims.x,shldDims.y],true);
color("silver") translate(coinOffset) cylinder(d=coinDia,h=coinHght);
color("white") translate(ledOffset) linear_extrude(ledDims.z) square([ledDims.x,ledDims.y],true);
}

