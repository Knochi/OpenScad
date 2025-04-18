/* Electronics enclosure for Fiverr Customer robokorn
  by fiverr.com/Knochi
*/

/* [Dimensions] */
baseDims=[100,50,30];
lidHght=5;
cornerRadius=3;
wallThck=2;
spcng=0.1;

/* [PCB Screw Bosses] */
addPCBBosses=true;
bossDist=[80,30];
bossDrillDia=3;
bossHeight=5;
bossCntrOffset=[0,0];

/* [Screw Domes] */
//drill dia in Lid
domeDrillDiaThrough=3.2;
//drill dia for threat or insert
domeDrillDiaScrew=3;
domeBaseLen=10;
screwHeadDia=6;
screwHeadHeight=3;
screwHeadSpcng=0.2;

/* [Seal] */
addSeal=true;
sealDia=1;
//how much the seal should be compressed
sealCompression=0.2;

/* [Connector] */
sideCutout="left";//["none","left","right"]
sideCutDims=[10,5];
sideCutRad=2;
sideCutCenterOffset=[0,0];

/* [LCD] */
addLidCut=true;
lidCutDims=[60,20];
lidCutRad=0;
lidCutCenterOffset=[0,0];
// should be bigger than cutout
lidBossesDist=[70,30];
//offset from cutout
lidBossesCenterOffset=[0,0];
lidBossesHeight=5;
lidBossesDrillDia=2.6;

/* [wallBrackets] */
addBracket=true;
bracketDims=[120,40,5];
bracketDrillDia=4;

/* [show] */
quality=50;
showBase=true;
showLid=true;
showTest=true;
showSeal=true;
export="none"; //["none","base","lid"]

/* [Hidden] */
$fn = ceil(quality/4) * 4; //round to next dividable by 4
fudge=0.1;
baseColor="grey";
bracketColor="grey";
//screw hole offset from corners
maxDia=max(screwHeadDia,domeDrillDiaThrough, domeDrillDiaScrew, wallThck*2);
screwCrnrOffset= maxDia/2;

testDims=[maxDia+wallThck*2+fudge,maxDia+wallThck*2+fudge,baseDims.z+lidHght+fudge];

//ASY
if (export=="none"){
  intersection(convexity){
    union(){
      if (showBase)
        base();
      if (showLid)
        translate([0,0,baseDims.z+lidHght+spcng]) rotate([180,0,0]) lid();
    }
    if (showTest){
      color("darkRed") testBody();
    }
  }
  if (showSeal){
    intersection(){
      color("#222222") translate([0,0,baseDims.z]) rotate([180,0,0]) seal(showSeal=true);
      if (showTest)
        color("#333333") translate([fudge,fudge,0]) testBody();
    }
  }
}

else if (export=="base")
  intersection(){
    base();
    if (showTest)
      color("darkRed") testBody();
  }
    
    
else if (export=="lid")
  intersection(){
    lid();
    if (showTest)
      color("darkRed") testBody();
  }

module testBody(){
  //a body to intersect with for test prints
  translate([baseDims.x/2-testDims.x+fudge,baseDims.y/2-testDims.x+fudge,-fudge/2]) cube(testDims);
}

*lid();
module lid(){
  difference(){
    union(){
      box([baseDims.x,baseDims.y,lidHght]);
      //Screw domes
      for (mx=[0,1],my=[0,1])
        mirror([0,my]) mirror([mx,0])
          translate([-(baseDims.x/2-wallThck),-(baseDims.y/2-wallThck),wallThck])
            cornerDome(drillDia=domeDrillDiaThrough, 
                       height=lidHght-wallThck, float=false);
      //lcd bosses
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(lidBossesDist.x)/2,iy*(lidBossesDist.y)/2,wallThck]+
                   [lidCutCenterOffset.x,lidCutCenterOffset.y]+
                   [lidBossesCenterOffset.x,lidBossesCenterOffset.y]) 
          linear_extrude(lidBossesHeight) difference(){
            circle(d=lidBossesDrillDia+wallThck*2);
            circle(d=lidBossesDrillDia);
          }
    }
    //cutout for LCD
    if (addLidCut)
      translate([lidCutCenterOffset.x,lidCutCenterOffset.y,wallThck/2]) 
        cutOut([lidCutDims.x,lidCutDims.y,wallThck+fudge],lidCutRad);
    //screw Head cutouts
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*(baseDims.x/2-screwCrnrOffset-wallThck),iy*(baseDims.y/2-screwCrnrOffset-wallThck),-fudge/2]){
        cylinder(d=domeDrillDiaThrough,h=wallThck+fudge);
          linear_extrude(screwHeadHeight) circle(d=screwHeadDia+screwHeadSpcng,true);
      }
  }
  
  if (addSeal)
    translate([0,0,lidHght]) seal([sealDia-spcng*2,sealDia*sealCompression/2*2]);
}

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
      translate([0,0,baseDims.z]) seal([sealDia,sealDia*(1-sealCompression/2)*2]);
    if (sideCutout != "none"){
      pos= sideCutout=="left" ? [-(baseDims.x-wallThck)/2,sideCutCenterOffset.x,baseDims.z/2+sideCutCenterOffset.y] : 
            [(baseDims.x-wallThck)/2,sideCutCenterOffset.x,baseDims.z/2+sideCutCenterOffset.y];
           
      translate(pos) rotate([90,0,90]) cutOut([sideCutDims.x,sideCutDims.y,wallThck+fudge],sideCutRad);
    }
  }
  // screw bosses
  if (addPCBBosses)
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*bossDist.x/2+bossCntrOffset.x,iy*bossDist.y/2+bossCntrOffset.y,wallThck]) boss();
  // wall bracket
  if (addBracket)
    color(bracketColor) bracket();
}

module bracket(){
  linear_extrude(bracketDims.z, ,convexity=3) 
    difference(){ 
      hull() for (ix=[-1,1],iy=[-1,1]){
        translate([ix*(baseDims.x/2-cornerRadius),
                   iy*(baseDims.y/2-cornerRadius)]) 
          circle(cornerRadius);
        translate([ix*(bracketDims.x/2-cornerRadius),
                   iy*(bracketDims.y/2-cornerRadius)]) 
          circle(d=bracketDrillDia+wallThck*2);
        }
        //remove the center
        offset(-wallThck) offset(cornerRadius+fudge) 
          square([baseDims.x-cornerRadius*2,baseDims.y-cornerRadius*2],true);
        //and the screw holes
        for (ix=[-1,1],iy=[-1,1]){
        translate([ix*(bracketDims.x/2-cornerRadius),
                   iy*(bracketDims.y/2-cornerRadius)]) 
          circle(d=bracketDrillDia);
          }
    }
}



*cutOut();
module cutOut(size=[10,5,wallThck+fudge],rad=2){
  linear_extrude(size.z,center=true) offset(rad) square(size-[rad,rad],true);
}

*seal();
module seal(crossSection=[sealDia,sealDia],showSeal=false){
  //create a circumfence ring with square crosssection
  zOffset= showSeal ? crossSection.y/2 : 0;
  for (im=[0,1]) {
        //front and back
        mirror([0,im]) translate([0,(baseDims.y-wallThck)/2,0])
          if (showSeal)
            translate([0,0,crossSection.y/2]) rotate([90,0,90]) 
              cylinder(h=baseDims.x-cornerRadius*2,d=crossSection.x,center=true);
          else 
            cube([baseDims.x-cornerRadius*2,crossSection.x,crossSection.y],true);
        //left and right
        mirror([im,0]) translate([(baseDims.x-wallThck)/2,0,0])
          if (showSeal)
            translate([0,0,crossSection.y/2]) rotate([90,0,0])
              cylinder(h=baseDims.y-cornerRadius*2,d=crossSection.x,center=true);
          else
            cube([crossSection.x,baseDims.y-cornerRadius*2,crossSection.y],true);
        //front cornes
        mirror([im,0]) translate([(baseDims.x/2-cornerRadius),(baseDims.y/2-cornerRadius),zOffset])
            rotate_extrude(angle=90) translate([cornerRadius-wallThck/2,0]) 
              if (showSeal)
                translate([0,0,crossSection.y/2]) circle(d=crossSection.x);
              else
                square(crossSection,true);
        //back corners
        mirror([im,0]) translate([(baseDims.x/2-cornerRadius),-(baseDims.y/2-cornerRadius),zOffset])
            rotate(-90) rotate_extrude(angle=90) translate([cornerRadius-wallThck/2,0]) 
              if (showSeal)
                circle(d=crossSection.x);
              else
                square(crossSection,true);
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
  linear_extrude(height,convexity=3) difference(){
    circle(d=dia);
    circle(d=drillDia);
  }
} 

*cornerDome();
module cornerDome(drillDia=domeDrillDiaScrew,wallThck=2, height=10, float=true){
  //float adds an inverse cone for supportless print
  pos = [screwCrnrOffset,screwCrnrOffset];
  dia=drillDia + wallThck*2;
  
  linear_extrude(height,convexity=2) difference(){
    domeShape();
    translate(pos) circle(d=drillDia);
  }
  if (float)
    color("brown") mirror([0,0,1]) linear_extrude(dia+max(pos.x,pos.y),scale=0) domeShape();
  
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
 