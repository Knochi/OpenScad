/* Skadis Collection
Remixed from 
https://www.thingiverse.com/thing:2853261 */

// Cable Holder
/* [Tines] */
tineGapWdth=1.75;
tineWdth=2.5;
tineThck=4.5;
tineMaxLen=19;
tineMinLen=15;
tineTipLen=2.2;
tineRad=1;
tineCount=17; //big: 37, small:27, tiny: 17
tineSharpTips=true;
/* [Options] */
tineLengthVariation="outer"; //["none","outer","alternating"]
/* [general] */
baseWdth=10;


/* [Hidden] */
ovWdth=tineGapWdth*(tineCount-1)+tineWdth*tineCount;
conPitch=25; //connector Pitch for MBoard
conWdth=15;
conHght=15;
fudge=0.1;

//the widest possible distance without protruding and in the grid
conDist=conPitch*floor((ovWdth-conWdth-tineRad*2)/conPitch);

echo(conDist);
$fn=64;


//base
body();
tines();
//Multiboard Snaps
for (ix=[-1,1]) translate([ix*conDist/2,0,0]){
  rotate(180) MBpushFit();
  translate([0,0,tineThck]) conBackPlate();
}
//a backplate for the connectors
*conBackPlate();
module conBackPlate(){
  plateDims=[conWdth+tineRad*2,tineThck,conHght-tineThck];
  intersection(){
    union(){
      linear_extrude(plateDims.z-tineRad) 
        rndRect(size=[plateDims.x,tineThck*2],r=tineRad);
      for (ix=[-1,1])
        translate([ix*(plateDims.x/2-tineRad),0,plateDims.z-tineRad]) 
          rotate([90,0,0])
            rndCyl(d=tineRad*2,h=tineThck*2,r=tineRad);
      translate([0,0,plateDims.z-tineRad])
        rotate([90,0,90]) linear_extrude(center=true,plateDims.x-tineRad*2) 
          rndRect(size=[tineThck*2,tineRad*2],r=tineRad);
      //fillet
        rndRectFillet(size=[plateDims.x,plateDims.y*2],rRect=tineRad,rFillet=tineRad);
      }
      translate([0,-plateDims.y/2-tineRad/2,plateDims.z/2]) 
        cube(plateDims+[tineRad*2,tineRad,0],true);
    }
  
}

module body(){
  translate([0,0,tineThck/2]) 
    difference(){
      rotate([90,0,0]) linear_extrude(baseWdth) 
        rndRect([ovWdth,tineThck],r=tineRad);
     for (ix=[-(tineCount-2)/2:(tineCount-2)/2])
        translate([ix*(tineGapWdth+tineWdth),-baseWdth,0]) bevelObj();
    }
      
  module bevelObj(){
    difference(){
      cylinder(d=tineGapWdth+tineRad*2,h=tineThck+fudge,center=true);
      rotate_extrude() translate([tineThck/2+tineGapWdth/2,0]) 
        rndRect([tineThck,tineThck],tineRad);
    }
  }
}
  
module tines(){
  //tines
  for (ix=[-(tineCount-1)/2:(tineCount-1)/2]){
    tineAltLen = (ceil(ix)%2) ? tineMinLen : tineMaxLen;
    tineOutLen = (abs(ix)==(tineCount-1)/2) ? tineMinLen : tineMaxLen; 
    tineLen=  tineLengthVariation=="outer" ? tineOutLen :
              tineLengthVariation=="alternating" ? tineAltLen : tineMaxLen;
                
    translate([ix*(tineGapWdth+tineWdth),-baseWdth,tineThck/2]) rotate([-90,0,180]) tine(tineLen);
    }
}

*tine();
module tine(tineLen){
  //tine
  linear_extrude(tineLen) rndRect(size=[tineWdth,tineThck],r=tineRad);
  //bend
  translate([0,0,tineLen]) rotate([90,0,90]) 
    translate([-tineThck/2-tineRad,0]) 
      rotate_extrude(angle=45) translate([tineThck/2+tineRad,0]) 
        rndRect(size=[tineThck,tineWdth],r=tineRad);
  //tip
  translate([0,0,tineLen])
    translate([0,-(tineThck/2+tineRad),0]) 
    rotate([45,0,0])
      translate([0,tineThck/2+tineRad,0]){
        linear_extrude(tineTipLen) 
          rndRect(size=[tineWdth,tineThck],r=tineRad);
        translate([0,0,tineTipLen]) rotate([0,90,0]) 
          rndCyl(d=tineThck,h=tineWdth,r=tineRad);
        if (tineSharpTips)
          translate([0,0,tineTipLen]) rotate([0,90,0]) intersection(){
            bvlCube(size=[tineThck,tineThck,tineWdth],r=tineRad);
            rotate(180) translate([0,0,-5]) cube([10,10,10]);
          }
      }
}

*rndRect();
module rndRect(size=[10,10],r=1){
  if (r<min(size.x/2,size.y/2))
    offset(r) square([size.x-2*r,size.y-2*r],true);
  else
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-r),iy*(size.y/2-r)]) circle(r);
}

*rndCyl();
module rndCyl(d=10,h=5,r=1,center=false){
  rotate_extrude() intersection(){
    rndRect([d,h],r);
    translate([d/4,0]) square([d/2,h],true);
  }
}

*bvlCube();
module bvlCube(size=[10,10,10],r=2){
  
  for (r=[0:90:270])
    rotate(r) corner();
  
  module corner(){
    intersection(){
      rotate([0,90,0]) linear_extrude(center=true,size.x) 
        rndRect(size=[size.z,size.y],r=r);
      linear_extrude(center=true,size.z) 
        polygon([[0,0],[-size.x/2,size.y/2],[size.x/2,size.y/2]]);
    }
  }
}

*rndRectFillet();
module rndRectFillet(size=[20,10],rRect=1.0,rFillet=2){
  //a fillet going around a rndrect
  for (ix=[0,1],iy=[0,1])
    mirror([0,iy]) mirror([ix,0]){
      translate([size.x/2-rRect,size.y/2-rRect]) 
        rotate_extrude(angle=90) translate([rRect,0]) filletShape(rFillet);
    }
  for (im=[0,1]){
    mirror([im,0]) translate([size.x/2,0]) rotate([90,0,0]) 
      linear_extrude(center=true,size.y-rRect*2) filletShape(rFillet);
    mirror([0,im]) translate([0,size.y/2]) rotate([0,-90,0]) 
      linear_extrude(center=true,size.x-rRect*2) filletShape(rFillet);
    }
}

module filletShape(r=1){
  difference(){
    square(r);
    translate([r,r]) circle(r);
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