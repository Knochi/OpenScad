use <eCAD/connectors.scad>
use <keystonePlate.scad>
include <eCAD/KiCADColors.scad>

PCBDims=[16.5,39,1.58];
PCBOffset=[0,17.5,-PCBDims.z/2];


/* [show] */
showPCB=true;
showKsFront=true;
showKsTop=true;
showKsBottom=true;
showKsTemplate=false;
showKsPlate=false;

/* [Assembly] */
startPos=PCBOffset+[0,7,10];
showAnim=false;
frame=0; //[0:10]

/* [Hidden] */
$fn=20;
fudge=0.1;

if (showKsPlate)
  color("grey")translate([-22.9/2,0,-14.25]) rotate([-90,-90,0]) keystone();

if (showPCB) 
  color("lightblue") 
    translate(PCBOffset) rotate(90) import("A2BCouplerPCB.stl");

if (showKsTemplate) 
  %translate([-14.5/2,40.51,-8.11-16.3/2]) rotate([90,0,0]) import("Keystone_cover.stl");

A2BkeyStone();
module A2BkeyStone(){
  ksWdth=14.5;
  ksHght=16.3;
  topHkPos=[0,8.7,11.05];
  botHkPos=[0,8.1,-8.15];
  retYPos=10; //Y-Position of the "retainer bars"
  frntThck=4;
  dClikDims=[8,7,6.3];
  //mounting slots in PCB
  sltDims=[1.5,3.2];
  sltClrnc=1.5; //clearance around slots
  topDims=[ksWdth,PCBOffset.y-frntThck+sltDims.y/2+sltClrnc,3];
  spcng=0.1;
  
  //hooks to connect front and top
  hkDims=[(ksWdth-dClikDims.x-spcng*2)/4,frntThck/2,topDims.z]; //hooks to join front in top piece
  hkPos=[(ksWdth/2-hkDims.x),frntThck-hkDims.y,(ksHght)/2-topDims.z];
  hkFillet=0.3;
  hkSpcng=0.05;
  
  color("darkslategrey"){
    
    if (showKsFront) front();
    if (showKsTop) top();
    if (showKsBottom) bottom();
  }
  
  
  module front(){
    pcbThck=1.6;
    cntrOffset=[0,0];
    flapDims=[9.6,pcbThck];
    LEDpos=[6.05,2.54+pcbThck/2];
    
    LEDDia=2;

    rotate([-90,0,0]) linear_extrude(frntThck) 
      difference(){
        translate([0,topDims.z/2+hkSpcng/2]) square([ksWdth,ksHght-topDims.z-hkSpcng],true);
        mirror([0,1]) translate(LEDpos) circle(d=LEDDia+spcng*2);
        mirror([1,0]) translate(LEDpos) circle(d=LEDDia+spcng*2);
        translate([0,(dClikDims.z+pcbThck)/2]) offset(spcng) square([dClikDims.x,dClikDims.z],true);
        mirror([0,1]) translate([0,(dClikDims.z+pcbThck)/2]) offset(spcng) square([dClikDims.x,dClikDims.z],true);
        offset(spcng) square(flapDims,true);
      }
    //hooks
    for (im=[0,1])
      mirror([im,0,0]) translate(hkPos) 
        linear_extrude(hkDims.z) offset(hkFillet) offset(-hkFillet) square([hkDims.x,hkDims.y],true);
  }
  
  module top(){
    retainerDims=[16.5,PCBOffset.y-retYPos+sltDims.y/2+sltClrnc,1];
    cutOutLen=dClikDims.y;
    
    difference(){
      translate([0,(topDims.y+frntThck)/2,(ksHght-topDims.z)/2])
        cube(topDims+[0,frntThck,0],true);
                
        //cutout for duraClik
        translate([0,-fudge,(dClikDims.z+PCBDims.z)/2]) 
          rotate([-90,0,0]) linear_extrude(cutOutLen+fudge) offset(spcng) square([dClikDims.x,dClikDims.z],true);
        //cutouts for hooks
        for (im=[0,1])
          mirror([im,0,0]) translate(hkPos) 
            linear_extrude(hkDims.z+fudge) offset(hkFillet+hkSpcng) offset(-hkFillet) square([hkDims.x,hkDims.y],true);
      }
   
    translate([0,(PCBOffset.y+retYPos+sltDims.y/2+sltClrnc)/2,(ksHght-1)/2]) cube(retainerDims,true);
    springHook();
    screwDome(true);
    mirror([1,0]) screwDome(true);
  }
*bottom();
  module bottom(){
    retainerDims=[16.5,PCBOffset.y-retYPos+sltDims.y/2+sltClrnc,1];
    cutOutLen=PCBOffset.y-sltDims.y/2-sltClrnc;
    difference(){
      translate([0,topDims.y/2+frntThck,-(ksHght-topDims.z)/2])        
          cube(topDims,true);
        //cutout for duraClik
        translate([0,-fudge,-(dClikDims.z+PCBDims.z)/2]) 
          rotate([-90,0,0]) linear_extrude(cutOutLen+fudge) offset(spcng) square([dClikDims.x,dClikDims.z],true);
      }
    translate([0,(PCBOffset.y+retYPos+sltDims.y/2+sltClrnc)/2,-(ksHght-1)/2]) cube(retainerDims,true);
     hook();
    mirror([0,0,1]){
      screwDome();
      mirror([1,0,0]) screwDome();
    }
   
  }
  
  module springHook(){
    //the springed hook
    tngThck=1.2; //thickness of spring tongue
    tngLen=11.35; //length of the tongue
    tngDist=1.7; //distance to body
    hkHght=1; //height of the hook
    hkLen=2.6; //length of the hook
    poly=[[0,0],[0,hkHght],[hkLen,0],[hkLen,-tngThck],[-tngLen,-tngThck],[-tngLen,0]];
    translate(topHkPos) rotate([90,0,-90]) linear_extrude(ksWdth,center=true) polygon(poly);
    translate(topHkPos+[0,tngLen,-tngThck-tngDist/2]) 
      rotate([0,90,0]) rotate_extrude(angle=180) 
        translate([(tngDist+tngThck)/2,0]) square([tngThck,ksWdth],true);
    translate(topHkPos+[0,0,-tngDist-tngThck*1.5]) rotate([-90,0,0]) linear_extrude(tngLen) square([ksWdth,tngThck],true);
  }
  *screwDome(true);
  module screwDome(inlay=false){
    //match slots
    if (inlay) translate([PCBDims.x/2-sltDims.x,PCBOffset.y,-PCBDims.z/2]) linear_extrude(PCBDims.z) 
        difference(){
          union(){
            difference(){
              circle(d=sltDims.y);
              translate([sltDims.y/2,0]) square([sltDims.y,sltDims.y],true);
            }
            translate([sltDims.x/2,0]) square([sltDims.x,sltDims.y],true);
          }
          circle(d=1.75);
      }
      
    translate([0,0,PCBDims.z/2]) linear_extrude(ksHght/2-PCBDims.z/2)
      translate([PCBDims.x/2-sltDims.x,PCBOffset.y,0]){
        difference(){
          union(){
            difference(){
              circle(d=sltDims.y+sltClrnc*2);
              translate([sltDims.y/2,0]) square([sltDims.y,sltDims.y+sltClrnc*2],true);
            }
            translate([sltDims.x/2,0]) square([sltDims.x,sltDims.y+sltClrnc*2],true);
          }
          circle(d=1.75);
      }
    }
  }
  
  module hook(){
    //the bottom hook
    hkHght=1.5;
    hkLen=1.9;
    poly=[[0,0],[0,-hkHght],[hkLen,0]];
    translate(botHkPos) rotate([90,0,-90]) linear_extrude(ksWdth,center=true) polygon(poly);
    
  }
}




