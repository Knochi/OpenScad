use <eCAD/elMech.scad>
$fn=20;

/* [show] */
showSection=false;

/* [Dimensions] */
minWallThck=2; //minimum Wallthickness

/* [Positons] */
zOffset=-30;
latchPivotRot=12; //[0:12]
jogRotations=[[-90,0,0],[-90,0,0],[-90,0,0],[-90,0,0]];
        //     index            middle          ring             pinky
jogPositions=[[60,40,zOffset],[60,30,zOffset],[60,20,zOffset],[75,-10,zOffset]];

/* [Hidden] */
fudge=0.1;
latchWdth=19.81+35.2;
slotWdth=21.25+34.7;
clipDims=[90+fudge,62.37+61.55+fudge,23+3+fudge];
ClBlankOffset=[21.25-19.81-(slotWdth-latchWdth)/2,-70,0.35];// offset between ClipMain and Clipblank
clip2LatchOffset=[-0.65,0.5,19.5];
latchPivotOffset=[24.3,-117.5,50.75];


import("steamdeck_stl_20220202.stl");

//Raspberry PICO
picoDims=[21,51,1];
color("darkgreen") translate([0,0,-26]) rotate([-90,0,0]) 
  translate([-picoDims.x/2,picoDims.z/2,picoDims.y/2]) 
    import("RP_PICO.stl");

difference() {
    union(){    
      color("grey") import("SteamClipMain.stl");
    }
    if (showSection) translate([clipDims.x/2,(62.37-61.55)/2,-clipDims.z/2+3]) cube(clipDims,true);
}

translate(ClBlankOffset){
  color("ivory") import("SteamClipBlank.stl");
  color("lightgrey") translate(clip2LatchOffset-latchPivotOffset) 
  rotate([0,-latchPivotRot,0]) 
    translate(latchPivotOffset) import("SteamClipBlankLatch.stl");
}

for (m=[0,1],i=[0:len(jogPositions)-1])
    mirror([m,0,0]) translate(jogPositions[i]) rotate(jogRotations[i]) jogHolder();

!jogHolder();
module jogHolder(){
  jogSwitch(1);
  PCBDims=[5.9*2+0.5,6.1+3,1.6];
  clmpDims=[PCBDims.x+0.1,PCBDims.y+minWallThck+0.1,2.5+1.6+minWallThck];
  PCBYOffset=2;
  hngLen=5;
  //add a dummyPCB
  color("darkgreen") translate([0,-PCBDims.y/2+PCBYOffset,-PCBDims.z]) linear_extrude(PCBDims.z)
    difference(){
      square([PCBDims.x,PCBDims.y],true);
      for (ix=[-1,1]){
        translate([ix*(PCBDims.x/2-1.5),-PCBDims.y/2+1.5]) circle(d=2);
        translate([ix*5/2,PCBDims.y/2-PCBYOffset]) circle(d=1);
      }
    }
  //clamp
  color("darkSlateGrey")
  translate([0,clmpDims.y/2-PCBDims.y+PCBYOffset-minWallThck,clmpDims.z/2-PCBDims.z-minWallThck/2]){
    difference(){
      cube(clmpDims,true);
      translate([0,(minWallThck+fudge)/2,0]) 
        cube([clmpDims.x+fudge,clmpDims.y-minWallThck+fudge,2.5+1.6],true);
      for (ix=[-1,1])
          translate([ix*(PCBDims.x/2-1.5),-clmpDims.y/2+1.5+minWallThck,]) 
            cylinder(d=2,h=clmpDims.z+fudge,center=true);
  }
  //hinge
  translate([(clmpDims.x+hngLen)/2,-(clmpDims.y-minWallThck*3)/2,0]){
    cube([hngLen,minWallThck*3,clmpDims.z],true);
    translate([hngLen/2,0,0]) rotate([90,0,0]) cylinder(d=clmpDims.z,h=minWallThck*3,center=true);
  }
  
  
}
}

