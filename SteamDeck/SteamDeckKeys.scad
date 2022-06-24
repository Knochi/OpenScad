use <eCAD/elMech.scad>
$fn=20;

/* [show] */
showSection=false;
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
latchWdth=19.81+35.2;
slotWdth=21.25+34.7;
clipDims=[90+fudge,62.37+61.55+fudge,23+3+fudge];
ClBlankOffset=[21.25-19.81-(slotWdth-latchWdth)/2,-70,0.35];// offset between ClipMain and Clipblank
clip2LatchOffset=[-0.65,0.5,19.5];
latchPivotOffset=[24.3,-117.5,50.75];
M3RivetDrill= (export != "none") ? 4.6 : 4;


translate([0,0,-19.03]) rotate([180,0,0])
  import("steamdeck_stl_20220202.stl");

  //Raspberry PICO
  picoDims=[21,51,1];
  color("darkgreen") translate([0,0,7]) rotate([90,0,0]) 
    translate([-picoDims.x/2,picoDims.z/2,picoDims.y/2]) 
      import("RP_PICO.stl");

translate([0,0,-19.03]) rotate([180,0,0]) difference() {
    color("grey") import("SteamClipMain.stl");
    if (showSection) translate([clipDims.x/2,(62.37-61.55)/2,-clipDims.z/2+3]) cube(clipDims,true);
}

translate([0,0,-19.03]) rotate([180,0,0]) translate(ClBlankOffset){
  color("ivory") import("SteamClipBlank.stl");
  color("lightgrey") translate(clip2LatchOffset-latchPivotOffset) 
  rotate([0,-latchPivotRot,0]) 
    translate(latchPivotOffset) import("SteamClipBlankLatch.stl");
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

module M25Rivet(){
  color("gold") linear_extrude(5.7) 
    difference(){
      circle(d=4.6);
      circle(d=2.5);
    }
}