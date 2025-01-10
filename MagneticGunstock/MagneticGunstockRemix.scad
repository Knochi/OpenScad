use <threads.scad>

/* [General Dimensions] */
$fn=20;
pipeDia=21.6;
threadLen=16.5;
spcng=0.2;

/* [Stock Dimensions] */
stockLen=120;
stockOuterDia=36;
stockPositions=5;

/* [show] */
showBody=false;
showBarrel=false;
showCoupler=false;
showStock=true;

/* [Hidden] */
fudge=0.1;

//Body Variants
if (showBody){
  import("./Sanlaki_20/Body-INT-2.stl");
  translate([50,0,0]) import("./Sanlaki_21/B_Body_v08_1.stl");
  translate([100,0,0]) import("./Sanlaki_22/Body_v08_03.stl");
  import("./RobiWan/Body_with_Barrel.stl");
  }


//Barrel Variants
if (showBarrel){
  translate([0,40.55-111.95,185-23.41]) import("./Sanlaki_20/Barrel-INT.stl");
  translate([50,0,0]) import("./Sanlaki_21/B_Barrel_v2_2.stl");
  translate([100,0,0]) import("./Sanlaki_22/VARIANT_Barrel v2_5.stl");
}

//Couplers
if (showCoupler){
  translate([0,40.55-111.95,185-23.41]) import("./Sanlaki_20/Coupler-INT.stl");
  translate([106,0,0]) import("./Sanlaki_21/B_coupler_v4_1.stl");
}

//Stock
if (showStock){
  *rotate(180) translate([3.4-21.5/2,52.75-21.5/2,0]) import("./RobiWan/Adjustable_Stock_Original_Design.stl");
  cstmStock();
  }
 

module cstmStock(){
  nudgeChamfer=[6.16,10];
  nudgeWdth=12;
  nudgePoly=[[0,0],[0,stockLen],[stockOuterDia/2,stockLen],[stockOuterDia/2+nudgeChamfer.x,stockLen-nudgeChamfer.y],[stockOuterDia/2+nudgeChamfer.x,0]];
  
  slotWdth=8;
  holeDepth=8.95;
  slotDepth=3.95;
  slotLen=83;
  slotOffset=11.85;
  //stockbody
  difference(){
    cylinder(d=stockOuterDia,h=stockLen);
    translate([0,0,threadLen-fudge*2]) cylinder(d=pipeDia+spcng*2,h=stockLen);
    translate([0,0,-fudge]) pipeThread();
    slot();
    }
  //nudge
  difference(){
    rotate([90,0,0]) linear_extrude(nudgeWdth,center=true) polygon(nudgePoly);
    translate([0,0,-fudge/2]) cylinder(d=stockOuterDia,h=stockLen+fudge);
    slot();
    }
  module slot(){
    translate([stockOuterDia/2+nudgeChamfer.x+fudge,0,0]) rotate([0,-90,0]) translate([slotOffset,0,0]){
      linear_extrude(slotDepth+fudge) hull(){
        translate([slotWdth/2,0]) circle(d=slotWdth);
        translate([slotLen-slotWdth/2,0]) circle(d=slotWdth);
      }
      for (ix=[0:stockPositions-1])
        translate([ix*((slotLen-slotWdth)/(stockPositions-1))+slotWdth/2,0]) cylinder(d=slotWdth,h=holeDepth);
      }
  }
} 

module pipeThread(){
  english_thread (diameter=(pipeDia+spcng*2)/25.4, threads_per_inch=14, length=threadLen/25.4, taper=1/16,internal=true);
}

*import("./RobiWan/Muzzle.stl");
