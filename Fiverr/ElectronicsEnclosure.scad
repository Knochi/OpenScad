/* Electronics enclosure for Fiverr Customer robokorn
  by fiverr.com/Knochi
*/

/* [Dimensions] */
baseDims=[100,50,30];
lidHght=5;
cornerRadius=3;
wallThck=2;

/* [Screw Bosses] */
bossDist=[80,30];
bossDrillDia=3;
bossHeight=5;
bossCntrOffset=[0,0];

/* [Screw Domes] */
domeDrillDiaThrough=3.2;
domeDrillDiaScrew=3;
domeBaseLen=10;
screwHeadDia=6;
screwHeadHeight=3;
screwHeadSpcng=0.2;

/* [Features] */
quality=50;
addBosses=true;
addSeal=true;
sealDia=1;
sealCompression=0.8;
sideCutout="left";//["none","left","right"]
sideCutDims=[10,5];
sideCutRad=2;
sideCutCenterOffset=[0,0];
addLidCut=true;
lidCutDims=[60,20];
lidCutRad=0;
lidCutCenterOffset=[0,0];

/* [Hidden] */
$fn = ceil(quality/4) * 4; //round to next dividable by 4
fudge=0.1;

/* [show] */
showBase=true;
showLid=true;
export="none"; //["none","base","lid"]

//ASY
if (export=="none"){
  if (showBase)
    base();
  if (showLid)
    translate([0,0,baseDims.z+lidHght]) rotate([180,0,0]) lid();
}
else if (export=="base")
  base();
else if (export=="lid")
  lid();


module base(){
  difference(){
    union(){
      box();
      // screw Domes
      for (mx=[0,1],my=[0,1])
        mirror([0,my]) mirror([mx,0]) 
          translate([-baseDims.x/2+wallThck,-baseDims.y/2+wallThck,baseDims.z-domeBaseLen]) 
            cornerDome(height=domeBaseLen, float=true);
    }
    if (addSeal)
      translate([0,0,baseDims.z-sealDia*sealCompression+sealDia/2]) seal();
    if (sideCutout != "none"){
      pos= sideCutout=="left" ? [-(baseDims.x-wallThck)/2,sideCutCenterOffset.x,baseDims.z/2+sideCutCenterOffset.y] : 
            [(baseDims.x-wallThck)/2,sideCutCenterOffset.x,baseDims.z/2+sideCutCenterOffset.y];
           
      translate(pos) rotate([90,0,90]) cutOut([sideCutDims.x,sideCutDims.y,wallThck+fudge],sideCutRad);
    }
  }
  // screw bosses
  if (addBosses)
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*bossDist.x/2,iy*bossDist.y/2,wallThck]) boss();
  
}

*lid();
module lid(){
  difference(){
    union(){
      box([baseDims.x,baseDims.y,lidHght]);
      //domes
      for (mx=[0,1],my=[0,1])
        mirror([0,my]) mirror([mx,0])
          translate([-(baseDims.x/2-wallThck),-(baseDims.y/2-wallThck),wallThck])
            cornerDome(drillDia=domeDrillDiaThrough, height=lidHght-wallThck, float=false);
    }
    translate([0,0,wallThck/2]) cutOut([lidCutDims.x,lidCutDims.y,wallThck+fudge],lidCutRad);
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*(baseDims.x/2-wallThck*2),iy*(baseDims.y/2-wallThck*2),-fudge/2]){
        cylinder(d=domeDrillDiaThrough,h=wallThck+fudge);
          linear_extrude(screwHeadHeight) circle(d=screwHeadDia+screwHeadSpcng,true);
      }
  }
  if (addSeal)
    translate([0,0,lidHght]) seal([sealDia*sealCompression*0.8,sealDia*(1-sealCompression)*2]);
  
}

*cutOut();
module cutOut(size=[10,5,wallThck+fudge],rad=2){
  linear_extrude(size.z,center=true) offset(rad) square(size-[rad,rad],true);
}

*seal();
module seal(size=[sealDia,sealDia]){
  //create a circumfence ring with square crosssection
  for (im=[0,1]) {
        //front and back
        mirror([0,im]) translate([0,(baseDims.y-wallThck)/2,0])
          cube([baseDims.x-cornerRadius*2,size.x,size.y],true);
        //left and right
        mirror([im,0]) translate([(baseDims.x-wallThck)/2,0,0])
          cube([size.x,baseDims.y-cornerRadius*2,size.y],true);
        //front cornes
        mirror([im,0]) translate([(baseDims.x/2-cornerRadius),(baseDims.y/2-cornerRadius),0])
            rotate_extrude(angle=90) translate([cornerRadius-wallThck/2,0]) 
              square(size,true);
        //back corners
        mirror([im,0]) translate([(baseDims.x/2-cornerRadius),-(baseDims.y/2-cornerRadius),0])
            rotate(-90) rotate_extrude(angle=90) translate([cornerRadius-wallThck/2,0]) 
              square(size,true);
      }
}

module box(size=baseDims, rad=cornerRadius){  
  difference(){
    linear_extrude(size.z) offset(rad) 
      square([size.x-rad*2,size.y-cornerRadius*2],true);
    translate([0,0,wallThck]) linear_extrude(size.z) offset(-wallThck) offset(rad) 
      square([size.x-rad*2,size.y-rad*2],true);
  }
}

*boss();
module boss(drillDia=bossDrillDia, wallThck=wallThck, height=bossHeight ){
  dia=drillDia + wallThck*2;
  filletRad= height > dia ? dia/3 : height /3;
  
  //fillet
  rotate_extrude() translate([dia/2,0]) difference(){
    square(filletRad);
    translate([filletRad,filletRad]) circle(filletRad);
  }
  //boss
  linear_extrude(height) difference(){
    circle(d=dia);
    circle(d=drillDia);
  }
} 

*cornerDome();
module cornerDome(pos=[wallThck,wallThck],drillDia=3,wallThck=2, height=10, float=true){
  //float adds an inverse cone for supportless print
  
  dia=drillDia + wallThck*2;
  
  linear_extrude(height,convexity=2) difference(){
    domeShape();
    translate(pos) circle(d=drillDia);
  }
  if (float)
    mirror([0,0,1]) linear_extrude(dia+max(pos.x,pos.y),scale=0) domeShape();
  
  module domeShape(){
    intersection(){
      square([dia,dia]+pos);
      translate(pos) 
        circle(d=dia);
    }
    square([pos.x+dia/2,pos.y]);
    square([pos.x,pos.y+dia/2]);
  }
}
 