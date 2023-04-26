//deckMate adapter https://deckmate.me/
//steamdeck offizial 3D data https://gitlab.steamos.cloud/SteamDeck/hardware


use <eCAD/elMech.scad>
use <eCAD/devboards.scad>

$fn=20;

/* [show] */
showSection=false;
showPico=false;
export="none";


/* [Dimensions] */
minWallThck=2; //minimum Wallthickness
jogHngOffset=13;

/* [Positons] */
zOffset=0;
latchPivotRot=12; //[0:12]
jogRotations=[[0,0,180],[0,0,180],[0,0,180],[0,0,180]];
        //     index            middle          ring             pinky
jogPositions=[[70,-40,zOffset],[70,-30,zOffset],[70,-20,zOffset],[75,10,zOffset]];

/* [Hidden] */
fudge=0.1;

M3RivetDrill= (export != "none") ? 4.6 : 4;


translate([0,0,-19.03]) rotate([180,0,0])
  import("steamdeck_stl_20220202.stl");

  //Raspberry PICO
  
  if (showPico) translate([0,0,7]) piPico();
  
// --- Deckmate ---
color("darkgrey") rotate([180,0,0]) translate([0,-150,18.9]) import("/Deckmate/Deck_Mate_Marked_02.stl");
translate([0,-6.2,0]) rotate([180,0,0]) DM_mecha(true);

//deckmate mechanism assembly
!DM_mecha(false);
module DM_mecha(showPlate=false){
  rotate([180,0,0]) color("orange"){
    translate([-65.19,-191.9-6.59,18.9]) import("/Deckmate/Deck_Mate_Mechanism_Bot_Print_02.stl");
    translate([-0.19,-6.59,18.91]) import("/Deckmate/Deck_Mate_Mechanism_Top_Print_02.stl");
  }
  
  if (showPlate) color("grey") translate([106.3,-6.5,26-7.7]) import("/Deckmate/Deck_Mate_Universal_02.stl");
}



for (m=[0,1],i=[0:len(jogPositions)-1])
    mirror([m,0,0]) translate(jogPositions[i]) rotate(jogRotations[i]) jogHolder();

*jogHolder();
module jogHolder(){
  
  PCBDims=[5.9*2+0.5,6.1+3,1.6];
  clmpDims=[PCBDims.x+0.1,2.5+1.6+minWallThck*2,PCBDims.y+minWallThck+0.1];
  PCBZOffset=2; 
  hngLen=jogHngOffset-5.9;
  
  translate([0,0,PCBDims.y-PCBZOffset+minWallThck]){
    rotate([90,0,0]) jogSwitch(0);
    //add a dummyPCB
    rotate([90,0,0]) color("darkgreen") translate([0,-PCBDims.y/2+PCBZOffset,-PCBDims.z]) linear_extrude(PCBDims.z)
      difference(){
        square([PCBDims.x,PCBDims.y],true);
        for (ix=[-1,1]){
          translate([ix*(PCBDims.x/2-1.5),-PCBDims.y/2+1.5]) circle(d=2);
          translate([ix*5/2,PCBDims.y/2-PCBZOffset]) circle(d=1);
        }
      }
    //clamp
      translate([0,-clmpDims.y/2+PCBDims.z+minWallThck,-clmpDims.z/2+PCBZOffset]){
        color("darkSlateGrey") difference(){
          cube(clmpDims,true);
          translate([0,0,(minWallThck+fudge)/2]) 
            cube([clmpDims.x+fudge,2.5+1.6,clmpDims.z-minWallThck+fudge],true);
          for (ix=[-1,1])
              translate([ix*(PCBDims.x/2-1.5),0,-clmpDims.z/2+1.6+minWallThck]) 
                rotate([90,0,0]) cylinder(d=2,h=clmpDims.z+fudge,center=true);
        }
        //hinge
        translate([(clmpDims.x+hngLen)/2,0,-(clmpDims.z-minWallThck*3)/2]){
          difference(){
            union(){
              color("darkSlateGrey") cube([hngLen,clmpDims.y,minWallThck*3],true);
              color("darkSlateGrey") translate([hngLen/2,0,0])
                cylinder(d=clmpDims.y,h=minWallThck*3,center=true);
            }
            translate([hngLen/2,0,0]) cylinder(d=M3RivetDrill,h=minWallThck*3+fudge,center=true);
          }
          translate([hngLen/2,0,(minWallThck*3)/2-5.7+0.01]) M3Rivet();
          }
          
        }
      }    
}

module M3Rivet(){
  color("gold") linear_extrude(5.7) 
    difference(){
      circle(d=4.6);
      circle(d=3);
    }
}

module M3SRivet(){
  color("gold") linear_extrude(4) 
    difference(){
      circle(d=4.6);
      circle(d=3);
    }
}

module M25Rivet(){
  color("gold") linear_extrude(5.7) 
    difference(){
      circle(d=4.6);
      circle(d=2.5);
    }
}