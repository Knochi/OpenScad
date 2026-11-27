/* [Wall Hook] */
//Dimensions of the front plate (holder)
wllHkPltDims=[88,6.2,44.5];
//Dimension of the back plate (wall)
wllHkBckDims=[77,2,44.5];
wllHkNudgeZPos=33.5;
wllHkNudgeDia=3;

/* [Dimensions] */
minWallThck=1.2;

/* [Bottles] */

/* [show] */
showWallHk=true;
showInterface=true;

/* [Hidden]*/
wllHkOvDims=[wllHkPltDims.x,wllHkBckDims.y+wllHkPltDims.y,wllHkBckDims.z];

fudge=0.1;
$fn=48;

if (showWallHk)
  wallHook();
if (showInterface)
  interface();

module wallHook(cut=false){
  spcng= cut ? 0.3 : 0;
  
  difference(){
    translate([0,0,-spcng]) linear_extrude(wllHkBckDims.z+spcng*2,convexity=3){
      translate([0,-wllHkBckDims.y/2+spcng/2]) square([wllHkBckDims.x+spcng*2,wllHkBckDims.y+spcng],true);
      translate([0,-wllHkBckDims.y-wllHkPltDims.y/2]) square([wllHkPltDims.x+spcng*2,wllHkPltDims.y+spcng*2],true);
    }
    for (ix=[-1,1])
      translate([ix*wllHkPltDims.x/2,0,wllHkNudgeZPos]) 
        rotate([90,0,0]) cylinder(d=wllHkNudgeDia-spcng,h=wllHkOvDims.y+fudge);
  }  
}

module interface(){
  ifWallThck=wllHkBckDims.y;
  difference(){
    linear_extrude(wllHkBckDims.z+ifWallThck) 
      translate([0,-wllHkPltDims.y/2-ifWallThck]) square([wllHkPltDims.x+ifWallThck*2,wllHkPltDims.y+ifWallThck*2],true);
    wallHook(cut=true);
  }
}