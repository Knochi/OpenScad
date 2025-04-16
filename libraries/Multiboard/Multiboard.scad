//remodelling MultiBoard Remix Components to produce consistent models

/* [push Fit Dimensions] */
pFbotIRad=6.75;
pFbotORad=ri2ro(pFbotIRad,8);
pFbotHght=1;
pFtopHght=0.5;
pFtopIRad=6.62;
pFtopORad=ri2ro(pFtopIRad,8);
pFovHght=8.4;

/* [Multibin Dimensions] */
// one Multibin unit
mBunit=50; 
mBdrawerOffset=[-7,-7,-1];
mBhandleWdth=8;
mBminWallThck=1;

/* [Multipoint Dimensions] */


/* [show] */
showPushFit=false;
showMultiBinDrawer=false;

/* [Hidden] */
fudge=0.1;
// -- Stage --
//show
if (showPushFit)
  MBpushFit();
if (showMultiBinDrawer)
  simpleDrawer();

// -- Multiboard Push-Fits --
// - imports -
*import("./Push-Fits/Push-Fit - Horizontal, Positive.stl"); // done!


  
module MBpushFit(isPositive=true, isHorizontal=true, extend=0, center=false){
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

// -- Multipoints --
// - import -
*import("./Multipoints/Lite Multipoint - Negative.stl");
*import("./Multipoints/Lite Multipoint - Horizontal, Negative.stl");
*import("./Multipoints/Multipoint - Horizontal, Negative.stl");
*import("./Multipoints/Multipoint - Negative.stl");


*MultiPointRail();
module MultiPointRail(lite=true){
  %import("./Multipoints/Lite Multipoint Rail - Negative.stl");  
  botRad=ri2ro(7,8);
  botHght=0.4;
  topRad=ri2ro(8.5,8);
  topHght=0.3;
  midHght=1.5;
  ovHght=botHght+midHght+topHght;
  topSideLen= ri2a(8.5,8);
  
  rotate(180/8){
    cylinder(r=botRad,h=botHght,$fn=8);
    translate([0,0,botHght]) cylinder(r1=botRad,r2=topRad,h=midHght,$fn=8);
    translate([0,0,botHght+midHght]) cylinder(r=topRad,h=topHght,$fn=8);
  }
  
}

*MultiPointSlot();
module MultiPointSlot(){
  *import("./Multipoints/Multipoint Slot - Negative.stl");
  botRad=ri2ro(6,8);
  botHght=0.4;
  topRad=ri2ro(8.5,8);
  topHght=0.3;
  midHght=2.5;
  ovHght=botHght+midHght+topHght;
  topSideLen= ri2a(8.5,8);
  echo(topSideLen);
  //slot
  rotate(180/8){
    cylinder(r=botRad,h=botHght,$fn=8);
    translate([0,0,botHght]) cylinder(r1=botRad,r2=topRad,h=midHght,$fn=8);
    translate([0,0,botHght+midHght]) cylinder(r=topRad,h=topHght,$fn=8);
  }
  //opening
  translate([0,-6,0]) rotate(180/8){
     cylinder(r=topRad,h=ovHght,$fn=8);
  }
  translate([0,-14.5,3.2]) 
    rotate([90,180,0]) linear_extrude(0.4,scale=[0.887,0.715]) 
      translate([-topSideLen/2,0]) square([topSideLen,1.4]);
  
}

// -- Multibin Drawers --
// Units width x hght x dpth
// width: 1 => 43  mm, height: 1 => 43mm,  depth: 1 => 49mm
// width: 2 => 93  mm, height: 2 => 93mm,  depth: 2 => 99mm
// width: 3 => 143 mm, height: 3 => 143mm, depth: 3 => 149mm
// w = N* 50mm - 7mm
// h = N* 50mm - 7mm
// d = N* 50mm - 1mm
// One Unit is 50mm but of course we need to substract a bit to make it fit INTO the bins

// - imports -
*translate([21.5,157-mBhandleWdth,0]) import("./MultiBins/1x1x3-Deep - Multibin Simple Drawer.stl");
*import("./MultiBins/2x1x3-Deep - Multibin Simple Drawer.stl");
*import("./MultiBins/3x1x3-Deep - Multibin Simple Drawer.stl");
*translate([21.5,107,0]) import("./MultiBins/2x2x2-Deep - Multibin Simple Drawer.stl");


module simpleDrawer(size=[1,1,3]){
  //Size is in units wdth x hght x dpth
  ovDims=[size.x*mBunit+mBdrawerOffset.x,
          size.z*mBunit+mBdrawerOffset.z,
          size.y*mBunit+mBdrawerOffset.y];
  crnrDim=5.27;//corners of the irregular octagon
  
  front();
  back();
  body();
  
  module body(){
    poly=[[0,0],[136,0],[137,1],[137,crnrDim-1],[138,crnrDim],[138,crnrDim+fudge],[0,crnrDim+fudge]];
    difference(){
      translate([ovDims.x/2,2,ovDims.z/2]) rotate([-90,0,0])  linear_extrude(ovDims.y-3,convexity=3) difference(){
        shape();
        offset(delta=-mBminWallThck) shape();
      }
      translate([0,2,ovDims.z-crnrDim]) rotate([90,0,90]) linear_extrude(ovDims.x+fudge) polygon(poly);
    }
  }
  
  module front(){
    translate([ovDims.x/2,2,ovDims.z/2]) rotate([90,0,0]) face();
  }
  
  module back(){
    topPoly=[[-8.2-fudge,ovDims.z/2+fudge],[-3,ovDims.z/2-5.3],[3,ovDims.z/2-5.3],[8.2+fudge,ovDims.z/2+fudge]];
    inPoly=[[-ovDims.z/2+9.25,-fudge],[-ovDims.z/2+9.25,0],
            [-ovDims.z/2+13.25,1],[ovDims.z/2+fudge,1],[ovDims.z/2+fudge,-fudge]];
    translate([ovDims.x/2,ovDims.y-2,ovDims.z/2]) rotate([-90,0,0]) 
      difference(){
        face();
        translate([0,0,-fudge/2]) rotate(180) linear_extrude(2+fudge) polygon(topPoly);
        rotate([90,0,90]) linear_extrude(ovDims.x+fudge,center=true) polygon(inPoly);
      }
  }
  
  module face(){
    chmfrScale=(ovDims.x-2)/ovDims.x;
    linear_extrude(1) shape();
    translate([0,0,1]) linear_extrude(1,scale=chmfrScale) shape();
  }
  
  module shape(){
    poly=[[-(ovDims.x/2-crnrDim),-ovDims.z/2],[(ovDims.x/2-crnrDim),-ovDims.z/2],
          [ovDims.x/2,-(ovDims.z/2-crnrDim)],[ovDims.x/2,(ovDims.z/2-crnrDim)],
          [ovDims.x/2-crnrDim,ovDims.z/2],[-(ovDims.x/2-crnrDim),ovDims.z/2],
          [-ovDims.x/2,ovDims.z/2-crnrDim],[-ovDims.x/2,-(ovDims.z/2-crnrDim)]];
    polygon(poly);
  }
}



// -- Symbols --

module printDir(){
  square([1.6,0.4],true);
  translate([0,1.29]) rotate(30) circle(d=1.4,$fn=3);
}

// -- helper Functions -- 
function ri2ro(ri,N)=ri/cos(180/N);
function ri2a(ri,N)=2*ri*tan(180/N);