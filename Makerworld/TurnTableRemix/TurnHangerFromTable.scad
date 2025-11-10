// Transformation of a turntable to a turn-hanger

include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/gears.scad>

//Dimensions from original model


/* [overall Dimension] */
platformDims=[140,60,7];
minWallThck=1.2;
platformCornerRad=3;
wirePostDims=[20,10,5];
wireCrossSection = 2.5; //in mm²

/* [MotorBracket] */
boltDistance=0;
baseOffset=[306,90,0];
tRodPos=[[-35.6, 6.5, platformDims.z],[35.8, 36.5, platformDims.z]];
tRodHght=15;
ttMotorPos=[-28,47.3,21.8];
mBracketDims=[91.35,81,24.85];

/* [mechanics] */
bearingDims=[8,22,7]; //inner, outer, thick
bearingSpcng=0.05;
gearThck=bearingDims.z;
centerDia=bearingDims[1];
centerPostDia=14;
gearPitch=3.15;
lGearTeeth=100;
lGearShorten=0.1;
largeSpacing=0.5;

/* [Connection] */
conVariant="cutAway"; //["tunnel"]
solderWickThick=0.5;
solderWickWidth=4;

/* [box] */
rimDist=141;
rimCrossSection=[2,3.5];

/* [show] */
showBearing=true;

/* [Hidden] */
lGearZPos=platformDims.z+mBracketDims.z+largeSpacing;
lGearOd=outer_radius(gearPitch, lGearTeeth, shorten=lGearShorten)*2;
wireDia=sqrt((4/PI)*wireCrossSection);


fudge=0.1;

$fn=200;

//--- imports ---
translate([0,0,platformDims.z]){
  color("ivory") translate(ttMotorPos+[+18.3,12.5,-24.8]) rotate(-66.9) translate([-110,120,3]) import("MotorBracket.stl");
  translate([-70.9,79.35,0]+ttMotorPos) import("tTableGear-10.stl");
  translate(ttMotorPos) TTMotor();
  }

// --- construction ---

color("grey") platform();
color("darkSlateGrey") translate([0,0,lGearZPos]) !lSpurGear();
if (showBearing) 
  color("silver") translate([0,0,lGearZPos]) bearing(bearingDims);

//large spur gear with bearing
module lSpurGear(){ 
  translate([0,0,gearThck/2]) spur_gear(circ_pitch=gearPitch, teeth=lGearTeeth, thickness=gearThck, spin=1.3, backlash=0.2, shorten=lGearShorten, clearance=0.5, shaft_diam=centerDia);
  //posts for copper wire
  
  translate([0,0,gearThck]) difference(){
    linear_extrude(wirePostDims.z,convexity=3) intersection(){
      difference(){
        circle(d=bearingDims[1]+wirePostDims.x/2);
        circle(d=bearingDims[1]-wirePostDims.x/2);
      }
      square([bearingDims[1]+wirePostDims.x/2,wirePostDims.y],true);
    }
    translate([0,0,wirePostDims.z/2]) rotate([0,90,0]) cylinder(d=wireDia,h=bearingDims[1]+wirePostDims.x/2+fudge,center=true);
    translate([0,0,(wireDia+wirePostDims.z)/4+wirePostDims.z/2]) cube([bearingDims[1]+wirePostDims.x/2+fudge,wireDia,(wireDia+wirePostDims.z)/2],center=true);
  }
}


module platform(){
  //threaded rods 
  for (pos = tRodPos){
    translate(pos+[0,0,tRodHght/2]) threaded_rod(d=10,l=15, pitch=1.5);
  }

  //platform base plate
  difference(){
    linear_extrude(platformDims.z, convexity=3) difference(){
      hull(){
        for (pos = tRodPos){
          translate([pos.x,pos.y]) circle(d=10);
        }
        circle(d=bearingDims[1]);
        for (ix=[-1,1],iy=[0,1])
          translate([ix*rimDist/2,iy*platformDims.y]) offset(platformCornerRad) square(rimCrossSection.x*2,true);
      }
      circle(d=bearingDims[0]-minWallThck*2);
    }
    rims(true);
  }

  
  centerPost();
}

*centerPost(true);

// draw the rims
module rims(cut=false){
  spcng = cut ? 0.2 : 0;
  for (ix=[-1,1])
    translate([ix*rimDist/2,0,rimCrossSection.y/2]) rotate([90,0,0]) linear_extrude(200,center=true) offset(spcng) square(rimCrossSection,true);
}


module TTMotor(){
  color("yellow") translate([-11.2,0,-9.9]) 
    rotate([0,-90,-90]) import("TT Motor - LA001.stl");
}

*centerPost();
module centerPost(test=false){
  hght = test ? platformDims.z : lGearZPos;
  postInnerDia=bearingDims[0]-minWallThck*2;
  
  //bearing fitting
  translate([0,0,hght]) linear_extrude(bearingDims.z) difference(){
    circle(d=bearingDims[0]-bearingSpcng*2);
    circle(d=postInnerDia);
    translate([bearingDims[0]/2-bearingSpcng,0,0]) circle(d=0.5);
  }
  //post
  difference(){
    linear_extrude(hght,convexity=3) difference(){
      circle(d=centerPostDia);
      circle(d=bearingDims[0]-minWallThck*2);
    }
    if (!test && (conVariant=="cutAway")){
      translate([centerPostDia/4+fudge/2,0,platformDims.z*1.5]) cube([centerPostDia/2+fudge,centerPostDia,platformDims.z],true);
      translate([(centerPostDia/2+fudge),0,platformDims.z*2])
        linear_extrude(centerPostDia/2,scale=[0,1]) 
          translate([-(centerPostDia/4-fudge/2),0])
            square([centerPostDia/2+fudge,centerPostDia],true);
    }
    else if (!test && (conVariant=="tunnel"))
      translate([0,0,platformDims.z*1.5]) cube([centerPostDia+fudge,postInnerDia,platformDims.z],true);
  }
}

module bearing(dims){
  linear_extrude(dims.z) difference(){
    circle(d=dims[1]);
    circle(d=dims[0]);
  }
}