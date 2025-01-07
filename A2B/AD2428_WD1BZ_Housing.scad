include <ecad/kicadcolors.scad>
use <ecad/connectors.scad>

/* [Dimensions] */
$fn=50;
pcbDims=[4.2*25.4,3.925*25.4,1.6];
drillOffset=[3.175,3.175];
drillDia=3.175;
pcbClrncBot=3;
pcbClrncTop=9.0;
wallThck=2;
crnrRad=2;
M3RivetDia=4.1;
M3ScrwHdThck=3;
M3ScrwHdDia=5.5;
spcng=0.2;
fudge=0.1;

probePos=[65,34,21];
probeRot=[0,-20,0];

/* [show] */
showHsngTop=true;
showPCB=true;
showHsngBot=true;
showProbe=true;

/* [Hidden] */
drillDist=[pcbDims.x-drillOffset.x*2,pcbDims.y-drillOffset.y*2];

if (showHsngBot)
  housingBottom();
if (showHsngTop)
  housingTop();
if (showPCB)
  WD1BZ_PCB();
if (showProbe)
  translate(probePos) rotate(probeRot) ZD1500();


module housingTop(){
  chamf=1;
  hoodOffset=[40,34,pcbClrncTop+pcbDims.z-fudge/2];
  sFact=[(pcbDims.x+wallThck*2-chamf*2)/(pcbDims.x+wallThck*2),
         (pcbDims.y+wallThck*2-chamf*2)/(pcbDims.y+wallThck*2)];
  
  difference(){
    union(){
      //circumfence
      translate([0,0,pcbDims.z]) linear_extrude(pcbClrncTop,convexity=3) difference(){
        hsngShape();
        offset(spcng) square([pcbDims.x,pcbDims.y]);
      }
      //roof
      difference(){
        translate([pcbDims.x/2,pcbDims.y/2,pcbClrncTop+pcbDims.z]) 
          linear_extrude(wallThck,scale=sFact,convexity=3) hsngShape(true);
      //drill
        for (ix=[0,1],iy=[0,1])
          translate([drillOffset.x+ix*drillDist.x,drillOffset.x+iy*drillDist.y,pcbDims.z+pcbClrncTop]) 
            cylinder(d=6,h=wallThck+fudge);
     
      }
      //hood for probe
      translate(hoodOffset) probeHood(false);
      //stand
      translate(hoodOffset+[38,+0,0]) probeStand();
    }
    //cutouts for PCB
    color("darkred") WD1BZ_PCB(true);
    //cutout for probe
      translate(hoodOffset) 
        probeHood(true);
    //cutout stand
    translate(probePos) rotate(probeRot) ZD1500(0.2);
  }
  //screw studs
  scrwHdOffset=pcbClrncTop+wallThck-M3ScrwHdThck;
  
  for (ix=[0,1],iy=[0,1])
    translate([drillOffset.x+ix*drillDist.x,drillOffset.x+iy*drillDist.y,pcbDims.z]){
      linear_extrude(scrwHdOffset) difference(){
        circle(d=7);
        circle(d=3.5);
      }
      translate([0,0,scrwHdOffset-wallThck]) linear_extrude(M3ScrwHdThck+wallThck) difference(){
        circle(d=M3ScrwHdDia+wallThck);
        circle(d=M3ScrwHdDia+spcng*2);
      }
    }
  *probeHood();
  module probeHood(cut=false){
    
    dia= cut ? 3 : 3+wallThck*2;
    hoodLen= cut ? 25+fudge : 25;
    hoodzOffset=-10; //before rotation
    hoodWdth=7;
    
    difference(){
      rotate([0,70,0]) 
        translate([0,0,hoodzOffset]) 
          linear_extrude(hoodLen) 
            hull() for (iy=[-1,1])
              translate([0,iy*(hoodWdth-3)/2]) circle(dia);
      if (!cut) translate([3,0,-7.5+fudge/2]) cube([40,20,15],true);
    }
  }
  *probeStand();
  module probeStand(){
    ovDims=[30,20,10];
    crnrRad=2;
    difference(){
      translate([-ovDims.x/2,-ovDims.y/2,0]) hull(){
        translate([0,0,ovDims.z-crnrRad]) rotate([0,-20,0]) hull(){
          for (ix=[0,1],iy=[0,1])
            translate([ix*(ovDims.x-crnrRad*2)+crnrRad,iy*(ovDims.y-crnrRad*2)+crnrRad]) sphere(crnrRad);
        }
        hull(){
          for (ix=[0,1],iy=[0,1])
            translate([ix*(ovDims.x-crnrRad*2)+crnrRad,iy*(ovDims.y-crnrRad*2)+crnrRad]) sphere(crnrRad);
        }
      }
     translate([0,0,-(crnrRad)/2]) cube([ovDims.x,ovDims.y,crnrRad+fudge],true);
    }
  }
}

module housingBottom(){
  chamf=1;
  
  sFact=[(pcbDims.x+wallThck*2-chamf*2)/(pcbDims.x+wallThck*2),
         (pcbDims.y+wallThck*2-chamf*2)/(pcbDims.y+wallThck*2)];
  
    //floor
  translate([0,0,-pcbClrncBot-wallThck]) difference(){
    mirror([0,0,1]) translate([pcbDims.x/2,pcbDims.y/2,-wallThck]) linear_extrude(wallThck,scale=sFact,convexity=3) hsngShape(true);
    translate([0,0,-fudge/2]) linear_extrude(wallThck+fudge) for (ix=[0,1],iy=[0,1])
      translate([drillOffset.x+ix*drillDist.x,drillOffset.y+iy*drillDist.y]) circle(d=4);
  }
  
  //pcbSupport
  translate([0,0,-pcbClrncBot]) linear_extrude(pcbClrncBot) difference(){
    hsngShape();
    offset(-2) square([pcbDims.x,pcbDims.y]);
    for (ix=[0,1],iy=[0,1])
      translate([drillOffset.x+ix*drillDist.x,drillOffset.y+iy*drillDist.y]) circle(d=4);
  }
  //studs for M3 rivets
  for (ix=[0,1],iy=[0,1])
    translate([drillOffset.x+ix*drillDist.x,drillOffset.x+iy*drillDist.y,-pcbClrncBot]) 
      linear_extrude(pcbClrncBot) difference(){
        circle(d=7);
        circle(d=4);
      }
  //pcbFrame
  difference(){
    linear_extrude(pcbDims.z+spcng) difference(){
      hsngShape();
      offset(spcng) square([pcbDims.x,pcbDims.y]);
    }
    WD1BZ_PCB(cut=true);
  }

}

module hsngShape(center=false){
    cntrOffset= center ? [-(pcbDims.x/2),-(pcbDims.y/2)] : [0,0,0];
    translate(cntrOffset) hull() for (ix=[0,1],iy=[0,1]) 
      translate([-wallThck+crnrRad+ix*(pcbDims.x+wallThck-crnrRad),-wallThck+crnrRad+iy*(pcbDims.y+wallThck-crnrRad)]) 
        circle(crnrRad);
  }
  
module WD1BZ_PCB(cut=false){
  //Analog Devices AD2428WD1BZ Eval Board  
  pads2scadMil=[-250,250]; //Offset from pads Origin to openscad origin
  ovDims=pcbDims;
  
  
  dClickPosMil=[[1200,3675],[1775,3675]];
  boxHdrPosMil=[3100,2225];
  probePointPosMil=[1200,2487.5];
  audioJackPosMil=[[1250,-250],[2025,-250]];
  SPDIFPosMil=[[2725,-250],[3250,-250]];
  DCJackPosMil=[3300,3675];
  
  
  translate([0,0,ovDims.z]){
        
    for (pos=dClickPosMil)
      if (cut)
        translate(mil2mm(pos+pads2scadMil)) rotate([90,0,180]) linear_extrude(wallThck+fudge) duraClikRA(cut=true);
      else
        translate(mil2mm(pos+pads2scadMil)) rotate(180) duraClikRA();
    for (pos=audioJackPosMil)
      color(blackBodyCol) translate(mil2mm(pos+pads2scadMil)) rotate(0) audioJack(cut);
    for (pos=SPDIFPosMil)
      color(blackBodyCol) translate(mil2mm(pos+pads2scadMil)) rotate(0) SPDIFCon(cut);
    if (cut)
      translate(mil2mm(boxHdrPosMil+pads2scadMil)) 
        translate([0,0,(pcbClrncTop+wallThck+fudge)/2]) cube([10,21.6,pcbClrncTop+wallThck+fudge],true);
    else
      translate(mil2mm(boxHdrPosMil+pads2scadMil)) rotate(90) boxHeader(10,center=true);
    color(blackBodyCol) translate(mil2mm(DCJackPosMil+pads2scadMil)) rotate(180) DCJack(cut);
    
    if (!cut)
      color("red") translate(mil2mm(probePointPosMil+pads2scadMil)) sphere(d=2);
  }
  
  if (!cut) color(pcbGreenCol) linear_extrude(ovDims.z) difference(){
   square([ovDims.x,ovDims.y]);
    for (ix=[0,1],iy=[0,1])
      translate([drillOffset.x+ix*drillDist.x,drillOffset.y+iy*drillDist.y]) circle(d=drillDia);
  }
}

*audioJack(true);
module audioJack(cut=false){
  if (cut){
    translate([0,0,5.9/2]) rotate([90,0,0]) cylinder(d=6+spcng*2,h=2);
    translate([0,-1,5.9/2-(3+spcng)/2]) cube([6+spcng*2,2,3+spcng],true);
  }
  else{
    translate([0,6,5.7/2]) cube([12,12,5.7],true);
    translate([0,0,5.9/2]) rotate([90,0,0]) cylinder(d=5.9,h=2);
  }
}

module SPDIFCon(cut=false){
  cutSpcng= cut ? spcng : 0;
  if (cut)
    translate([0,-(wallThck+fudge)/2,5]) cube([9.7+cutSpcng*2,wallThck+fudge,10],true);
 
  translate([0,13.4/2+cutSpcng,5+cutSpcng/2]) cube([9.7+cutSpcng*2,13.4+cutSpcng*2,10+cutSpcng],true);
}

*DCJack(true);
module DCJack(cut=false){
  cutSpcng= cut ? spcng : 0;
  
  if (cut){
    translate([0,-(wallThck+fudge)/2,11/2]) cube([9,wallThck+fudge,11],true);
  }
  
  translate([0,3.5/2+cutSpcng,(11+cutSpcng)/2]) 
    cube([9+cutSpcng*2,3.5+cutSpcng*2,11+cutSpcng],true);
  translate([0,14.2/2+cutSpcng,(10.5-7.5/2+cutSpcng)/2]) 
    cube([9+cutSpcng*2,14.2+cutSpcng*2,10.5-7.5/2+cutSpcng],true);
  translate([0,0,10.6-7.5/2]) rotate([-90,0,0]) cylinder(d=7.5+cutSpcng*2,h=14.2+cutSpcng);
}


*ZD1500();
module ZD1500(cutOffset=0){
  //LeCroy ZD1500 differential probe
  
  ovDims=[100,12,7]; //without gnd connection
  tipLen=12;
  tailLen=27;
  bdyLen=ovDims.x-tipLen-tailLen;
  crnrRad=2;
  pitch=2.54;
  conDia=1.6;
  conLen=0.5;
  
  
  //body
  rotate([90,0,90]) linear_extrude(bdyLen) bodyShape();
  
  //gnd
  gndDia=3;
  translate([0,0,ovDims.z/2]) rotate([0,90,0]){
    cylinder(d=gndDia,h=11-gndDia/2);
    translate([0,0,11-gndDia/2]) sphere(d=gndDia);
  }
  
  //tip
  translate([-tipLen,0,-ovDims.z/2+2.2]) rotate([0,90,0])
    for (iy=[-1,1])
      linear_extrude(conLen) translate([0,iy*pitch/2,0]) circle(d=conDia);
    
  translate([-tipLen+conLen,0,-ovDims.z/2+2.2]) rotate([0,90,0])
    hull() for (iy=[-1,1])
      linear_extrude(2) translate([0,iy*pitch/2,0]) circle(d=4);
    
  //body to tip
  difference(){
    hull(){
      translate([-tipLen+conLen+2,0,-ovDims.z/2+2.2]) rotate([0,90,0]) for (iy=[-1,1])
        linear_extrude(0.1,scale=0.1) translate([0,iy*pitch/2,0]) circle(d=4+cutOffset);
      rotate([90,0,90]) linear_extrude(0.1,scale=0.1) bodyShape();
    }
    translate([0,0,ovDims.z/2]) rotate([0,-90,0]) cylinder(d=gndDia,h=tipLen);
  }
    
  //tail
  color("darkGrey") translate([bdyLen,0,0]) rotate([90,0,90]) linear_extrude(13.5) bodyShape();
  hull(){
    translate([bdyLen+13.5,0,0]) rotate([90,0,90]) linear_extrude(0.1,scale=0.1) bodyShape();
    translate([bdyLen+tailLen,0,0]) rotate([90,0,90]) linear_extrude(0.1,scale=0.1) circle(d=5.2);
  }

    
  module bodyShape(){
    hull() for (ix=[-1,1], iy=[-1,1])
    translate([ix*(ovDims.y/2-crnrRad),iy*(ovDims.z/2-crnrRad)]) circle(crnrRad+cutOffset);
  }
}

function mil2mm(mil=[1,1])=[mil.x*0.0254,mil.y*0.0254];