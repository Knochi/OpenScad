/* Simple pliers holder for Multiboard 
---
This object is part of Multiboard, a FREE "all in one" organization system with 3000+ parts, that combines pegboard holes, honeycomb snaps, Gridfinity like bins, threads, brakes, and much more.

Explore and build the coolest, most adaptable workshop at https://multiboard.io

*/


/* [Dimensions] */
thck=11;
height=15;
brim=6;
wallThck=2;
rad=2;
ang=55;
$fn=20;

rotate([90,0,0]) linear_extrude(wallThck) tri(h=height+brim,a=ang,r=rad);
translate([0,-wallThck,0]) rotate([90,0,0]) linear_extrude(thck) tri(h=height,a=ang,r=rad);
translate([0,-wallThck-thck]) rotate([90,0,0]) linear_extrude(wallThck) tri(h=height+brim,a=ang,r=rad);
rotate(180) MBpushFit();



*tri();
module tri(h=10,a=45,r=2){
  baseWdth=tan(a/2)*h*2;
  hull(){
    translate([0,h-r]) circle(r);
    translate([-baseWdth/2+r,r]) circle(r);
    translate([baseWdth/2-r,r]) circle(r);
  }
}


module MBpushFit(isPositive=true, isHorizontal=true, extend=0, center=false){
  pFbotIRad=6.75;
  pFbotORad=ri2ro(pFbotIRad,8);
  pFbotHght=1;
  pFtopHght=0.5;
  pFtopIRad=6.62;
  pFtopORad=ri2ro(pFtopIRad,8);
  pFovHght=8.4;
  // -- horizontal --
  sFac=pFtopIRad/pFbotIRad;
  
  cntrOffset= center ? [0,0,0] : [0,0,pFbotIRad];
  cntrRot = center ? [0,0,0] : [90,0,0];
  
  translate(cntrOffset) rotate(cntrRot){
      //bot
    translate([0,0,-extend]) linear_extrude(pFbotHght+extend) rotate(180/8) circle(r=pFbotORad,$fn=8);
    //mid
    translate([0,-pFbotIRad,pFbotHght]) 
      linear_extrude(pFovHght-pFtopHght-pFbotHght,scale=[sFac,sFac]) 
        translate([0,pFbotIRad,0]) 
          rotate(180/8) circle(r=pFbotORad,$fn=8);
    //top
    difference(){        
      translate([0,pFtopIRad-pFbotIRad,pFovHght-pFtopHght])
        linear_extrude(pFtopHght,scale=0.93) rotate(180/8) circle(r=pFtopORad,$fn=8);
      translate([0,-4.55,pFovHght-0.1]) linear_extrude(0.2) printDir();
      }
    }
}

module printDir(){
  square([1.6,0.4],true);
  translate([0,1.29]) rotate(30) circle(d=1.4,$fn=3);
}

// -- helper Functions -- 
function ri2ro(ri,N)=ri/cos(180/N);
function ri2a(ri,N)=2*ri*tan(180/N);