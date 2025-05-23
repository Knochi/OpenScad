/* This is a remix of the dupont wire organizer from greenribbit on printables
  https://www.printables.com/model/1304455-dupont-wire-organizer-minimalist-small-footprin
*/
$fn=30;
chanDims=[8,10];
chanRadius=6;
chanLen=7;
slotWdth=1.5;
minWallThck=1.6;


/* [Hidden] */
bodyDims=[chanRadius*2+chanDims.x+minWallThck*2,
          chanRadius+chanDims.x/2+chanLen+minWallThck,
          chanDims.y+minWallThck*2];
tempChanOpnTriHght=7; //Hight of the triangle to open channel
          
//original
rotate(180) translate([-102.79-(126.18-102.79)/2,-116.8,4.8]) import("dupont-wire-organizer.stl");

//attach multiboard snap
rotate([90,0,180]) MBpushFit(isHorizontal=true);

//reverse engineering
*channel();
*body();

module body(){
  translate([0,bodyDims.y/2,bodyDims.z/2]) cube(bodyDims,true);
}


echo(norm([ 6.46, 1.59, 14.32 ]-[ 5.10, 2.03, 14.87 ]));
module channel(){
  //straight part
  for (ix=[-1,1])
    translate([ix*chanRadius,0,chanDims.y/2+minWallThck]) rotate([90,0,180])
      linear_extrude(chanLen) shape();
  //round part
  translate([0,chanLen,chanDims.y/2+minWallThck]) rotate_extrude(angle=180) 
    translate([chanRadius,0]) shape();
  *shape();
  module shape(){
    poly=[[-chanDims.x/2,0],[0,tempChanOpnTriHght],[chanDims.x/2,0]];
    polygon(poly);
    hull() for (iy=[-1,1])
      translate([0,iy*(chanDims.y-chanDims.x)/2]) circle(d=chanDims.x);
    
  }
}

*MBpushFit(isHorizontal=false);
module MBpushFit(isPositive=true, isHorizontal=true, extend=0, center=false){
  pFbotIRad=6.75;
  pFbotORad=ri2ro(pFbotIRad,8);
  pFbotHght=1;
  pFtopHght=0.5;
  pFtopIRad=6.62;
  pFtopORad=ri2ro(pFtopIRad,8);
  pFovHght=8.4;
  // -- horizontal --
  horMidOffset= isHorizontal ? pFbotIRad : 0;
  horTopOffset= isHorizontal ? pFtopIRad-pFbotIRad : 0;
  
  sFac=pFtopIRad/pFbotIRad;
  
  
  cntrOffset= center ? [0,0,0] : [0,0,pFbotIRad];
  cntrRot = center ? [0,0,0] : [90,0,0];
  
  translate(cntrOffset) rotate(cntrRot){
      //bot
    translate([0,0,-extend]) linear_extrude(pFbotHght+extend) rotate(180/8) circle(r=pFbotORad,$fn=8);
    //mid
    translate([0,-horMidOffset,pFbotHght]) 
      linear_extrude(pFovHght-pFtopHght-pFbotHght,scale=[sFac,sFac]) 
        translate([0,horMidOffset,0]) 
          rotate(180/8) circle(r=pFbotORad,$fn=8);
    //top
    difference(){        
      translate([0,horTopOffset,pFovHght-pFtopHght])
        linear_extrude(pFtopHght,scale=0.93) rotate(180/8) circle(r=pFtopORad,$fn=8);
      translate([0,-4.55,pFovHght-0.1]) linear_extrude(0.2) printDirIcon();
      }
    }
}

module printDirIcon(){
  square([1.6,0.4],true);
  translate([0,1.29]) rotate(30) circle(d=1.4,$fn=3);
}


// -- helper Functions -- 
function ri2ro(ri,N)=ri/cos(180/N);
function ri2a(ri,N)=2*ri*tan(180/N);