/* [Wall Hook] */
//Dimensions of the front plate (holder)
wllHkPltDims=[88,6.2,44.5];
//Dimension of the back plate (wall)
wllHkBckDims=[77,2,44.5];
wllHkNudgeZPos=33.5;
wllHkNudgeDia=3;

/* [Bottles] */
btlBdyDia=69;
btlBdyHght=147;
btlNckDia=25.1;
btlCapDia=30.2;
btlCapHght=21;
btlCount=3;
btlDist=5;

/* [Limits] */
minWallThck=1.2;
structThck=2;
btlSpcng=0.5;
hPrflSpcng=0.1;

/* [Interlock] */
hPrflWallThck=1.5;
hPrflDims=[20,8.9];

/* [show] */
showWallHk=true;
showWallIF=true;
showBottles=true;
showProfile=true;

/* [Hidden]*/
wllHkOvDims=[wllHkPltDims.x,wllHkBckDims.y+wllHkPltDims.y,wllHkBckDims.z];
btlYZPos=[0,-btlBdyDia/2-wllHkOvDims.y-structThck*2-hPrflDims.y,-btlBdyHght+wllHkBckDims.z-structThck];
hPrflPos=[0,-hPrflDims.y/2-wllHkOvDims.y-structThck,wllHkOvDims.z/2];

fudge=0.1;
$fn=48;

if (showWallHk)
  wallHook();
if (showWallIF)
  wallInterface();
if (showBottles)
  for (ix=[-(btlCount-1)/2:(btlCount-1)/2])
    translate([ix*(btlBdyDia+btlDist),0,0]+btlYZPos) bottleDummy();
if (showProfile)
  color("grey") translate(hPrflPos) rotate([0,90,0]) 
    linear_extrude(btlBdyDia*btlCount+btlDist*(btlCount-1),center=true) hProfile();
    
#translate(btlYZPos) bottleAdaptor();
  
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

module wallInterface(){
  ifWallThck=wllHkBckDims.y;
  ovXYDims=[wllHkPltDims.x+ifWallThck*2,wllHkPltDims.y+ifWallThck*2+hPrflDims.y/2];
  difference(){
    linear_extrude(wllHkBckDims.z+ifWallThck,convexity=3) 
      translate([0,-ovXYDims.y/2]) square(ovXYDims,true);
    wallHook(cut=true);
    translate(hPrflPos) rotate([0,90,0]) linear_extrude(ovXYDims.x+fudge,center=true,convexity=3) 
      offset(hPrflSpcng) hProfile();
  }
}

module bottleDummy(){
  lwrRad=btlBdyDia*0.2;
  uprRad=(btlBdyDia-btlCapDia)/2;
  
  //body
  rotate_extrude() translate([btlBdyDia/2-lwrRad,lwrRad]) circle(lwrRad);
  cylinder(d=btlBdyDia-lwrRad*2,h=lwrRad);
  translate([0,0,lwrRad]) cylinder(d=btlBdyDia,h=btlBdyHght-lwrRad-uprRad);
  rotate_extrude() translate([btlBdyDia/2-uprRad,btlBdyHght-uprRad]) 
    intersection(){
      circle(uprRad);
      square(uprRad);
    }
  translate([0,0,btlBdyHght-uprRad]) cylinder(d=btlCapDia,h=uprRad);
  //neck
  translate([0,0,btlBdyHght]) cylinder(d=btlNckDia,h=structThck);
  //cap
  translate([0,0,btlBdyHght+structThck]) cylinder(d=btlCapDia,h=btlCapHght);
}

*hProfile();
module hProfile(size=hPrflDims,wallThck=hPrflWallThck){
  //e.g. https://www.hornbach.de/p/h-profil-alu-silber-eloxiert-12-9x22x1-5-mm-2-m/5025823/
  difference(){
    square(size,true);
    for (ix=[-1,1])
      translate([ix*(size.x/2+wallThck)/2,0]) square([size.x/2,size.y-wallThck*2],true);
      }
}
*bottleAdaptor();
module bottleAdaptor(){
  flapWdth=-btlYZPos.y-wllHkOvDims.y-structThck-hPrflDims.y/2;
  *bottleDummy();
  
  //round style
  translate([0,0,btlBdyHght]){
    linear_extrude(structThck) difference(){
      circle(d=btlCapDia+btlSpcng*2);
      circle(d=btlNckDia+btlSpcng*2);
    }
    linear_extrude(structThck*2) difference(){
      union(){
        circle(d=btlCapDia*2);
        translate([0,flapWdth/2]) square([btlCapDia*2,flapWdth],true);
      }
      circle(d=btlCapDia+btlSpcng*2);
      }
     translate([0,flapWdth-(structThck+hPrflDims.y/2)/2,-(wllHkOvDims.z)/2+structThck*1.5]) 
      cube([btlCapDia*2,structThck+hPrflDims.y/2,wllHkOvDims.z+structThck],true);
    }
}
