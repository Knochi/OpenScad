/* [Wall Hook] */
//Dimensions of the front plate (holder)
wllHkPltDims=[88,6.2,44.5];
//Dimension of the back plate (wall)
wllHkBckDims=[77,2,44.5];
wllHkNudgeZPos=33.5;
wllHkNudgeDia=3;
wllHkCtrHoleDia=5;

/* [Bottles] */

/* [Hidden]*/
wllHkOvDims=[wllHkPltDims.x,wllHkBckDims.y+wllHkPltDims.y,wllHkBckDims.z];
fudge=0.1;
$fn=48;

wallHook();

module wallHook(){
  difference(){
    linear_extrude(wllHkBckDims.z,convexity=3){
      translate([0,-wllHkBckDims.y/2]) square([wllHkBckDims.x,wllHkBckDims.y],true);
      translate([0,-wllHkBckDims.y-wllHkPltDims.y/2]) square([wllHkPltDims.x,wllHkPltDims.y],true);
    }
    for (ix=[-1,1])
      translate([ix*wllHkPltDims.x/2,0,wllHkNudgeZPos]) 
        rotate([90,0,0]) cylinder(d=wllHkNudgeDia,h=wllHkOvDims.y+fudge);
    
  }  
}