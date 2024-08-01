use <eCad/motors.scad>

/* [show] */
quality=20; //[20:100]
position=0; //[0:0.1:1]
showMotor=false;
showRail=true;
showArms=true;
showPushPlate=true;
showProjectile=true;
export="none"; //["none","rail","arms","pushPlate"]
/* [Dimensions] */
projDia=2.1;
projLen=40;
railDims=[100,7,7];
gldSpcng=0.1;
rbrWdth=3;
rbrLen=65;
strokeRel=0.6;
minWallThck=0.6;


/* [Hidden] */
fudge=0.1;
$fn=quality;
pushPlateDims=[10,railDims.y+rbrWdth*2+minWallThck*4+gldSpcng*2];


if (export=="rail")
  !rail();
else if (export=="arms")
  !arms();

if (showArms) 
  translate([railDims.x,0,0]) arms();
if (showMotor)
  translate([+93,0,-5]) rotate([90,0,-90]) N20leadScrew();
if (showRail)
  rail();

translate([position*railDims.x*strokeRel,0,0]){
  if (showPushPlate) pushPlate();
  if (showProjectile) projectile();
}

module pushPlate(){
  linear_extrude(projDia/2,center=true) difference(){
    square(pushPlateDims,true);
    translate([pushPlateDims.x/4-gldSpcng/2,0]) square([pushPlateDims.x/2+gldSpcng+fudge,projDia+gldSpcng*2],true);
  }
  
  for (im=[0,1]) mirror([0,im,0]){
    translate([-pushPlateDims.x/2,pushPlateDims.y/2-minWallThck,0]) 
      rotate([90,0,0]) linear_extrude(rbrWdth) dropShape();
    translate([-pushPlateDims.x/2,pushPlateDims.y/2,0]) 
      rotate([90,0,0]) linear_extrude(minWallThck) offset(1) dropShape();
    translate([-pushPlateDims.x/2,pushPlateDims.y/2-rbrWdth-minWallThck,0]) 
      rotate([90,0,0]) linear_extrude(minWallThck) offset(1) dropShape();
  }
  
  module dropShape(){
    hull(){
      translate([pushPlateDims.x/2,0]) square([pushPlateDims.x,projDia/2],true);
      translate([0,projDia*0.75]) circle(d=projDia*2);
    }
  }
  
}

module rail(){
  difference(){
    union(){
      translate([railDims.x/2,0,0]) cube(railDims,true);
      translate([railDims.x,0,0]) rotate([90,0,0]) cylinder(d=railDims.z,h=railDims.y,center=true);
    }
    translate([(railDims.x*strokeRel+pushPlateDims.x/2-fudge)/2,0,0]) 
      cube([railDims.x*strokeRel+pushPlateDims.x/2+fudge,railDims.y+fudge,projDia/2+gldSpcng*2],true);
    translate([-fudge/2,0,0]) rotate([0,90,0]) cylinder(d=projDia+gldSpcng*2,h=railDims.x+railDims.z/2+fudge);
    //translate([railDims.x,0,0]) cube([railDims.z,railDims.y+fudge,projDia*2],true);
    translate([railDims.x,0,0]) intersection(){
      translate([0,0,0]) cube([railDims.z,railDims.y+fudge,projDia*2],true);
      rotate([90,0,0]) cylinder(d=railDims.z+fudge,h=railDims.y+fudge,center=true);
    }
  }
}

*arms();
module arms(){
  
  difference(){
    intersection(){
      translate([0,0,0]) cube([railDims.z,railDims.y+fudge,projDia*2],true);
      rotate([90,0,0]) cylinder(d=railDims.z,h=railDims.y,center=true);
    }
    rotate([0,90,0]) cylinder(d=projDia+gldSpcng*2,h=railDims.z+fudge,center=true);
  }
  for (iy=[-1,1]){
    translate([0,iy*(pushPlateDims.y+railDims.y)/4,0]) 
      rotate([90,0,0]) cylinder(d=railDims.z-2,h=(pushPlateDims.y-railDims.y)/2,center=true);
    translate([0,iy*(pushPlateDims.y+minWallThck)/2,0]) 
      rotate([90,0,0]) cylinder(d=railDims.z,h=minWallThck,center=true);
    translate([0,iy*(railDims.y+minWallThck)/2,0]) 
      rotate([90,0,0]) cylinder(d=railDims.z,h=minWallThck,center=true);
  }
}

module projectile(){
  tipLen=9;
  tipDia=0.5;
  //halfed toothpick
  color("brown") rotate([0,90,0]){
    cylinder(d=projDia,h=projLen-tipLen);
    translate([0,0,projLen-tipLen]) cylinder(d1=projDia,d2=tipDia,h=tipLen);
  }
}