
$fn=30;

/* [Dimensions] */
//Dimensions of the compartment
compDims=[150,150,150];
//spacing between mechanism and compartment
cmpSpcng=0.5;
//Diameter of the axis
axisDia=2;
//spacing for the axis
axisSpcng=0.1;
//general spacing
spcng=0.1;
crnrRad=1;
rampWdth=10;
baseDims=[compDims.x-cmpSpcng,compDims.y-cmpSpcng*2,4];
flapDims=[baseDims.x*0.5,(baseDims.y-rampWdth)*0.6,baseDims.z];

/* [show] */
showRoll=false;
showBase=true;

/* [Hidden] */
fudge=0.1;

if (showRoll) translate([baseDims.x/2,baseDims.y/2,baseDims.z]) paperRoll();
if (showBase) base();

module base(){

  axisOffset=[baseDims.x/2,baseDims.y/2-flapDims.y/2,baseDims.z/2];
  //base
  difference(){
    baseBdy();
    //coutout for flap
    translate([baseDims.x/2,rampWdth+(flapDims.y+baseDims.z)/2,baseDims.z/2]) 
      cube(flapDims+[0,-baseDims.z,fudge],true);
    //cutout for hinge
    translate([baseDims.x/2,rampWdth+(baseDims.z+fudge)/2,baseDims.z/2]) 
      cube([flapDims.x-baseDims.z*2,baseDims.z+fudge,baseDims.z+fudge],true);
    //axis
    translate(axisOffset) 
      rotate([0,90,0]) cylinder(d=axisDia+axisSpcng*2,h=baseDims.x+fudge,center=true);
  }
  
  //flap
  translate(axisOffset) rotate([0,90,0]) linear_extrude(flapDims.x-baseDims.z*2-spcng,center=true) difference(){
    circle(d=baseDims.z-spcng);
  }
  
  module baseBdy(){
    translate([baseDims.x,0,0]) rotate([0,-90,0]) linear_extrude(baseDims.x) hull(){
      translate([crnrRad,crnrRad]) circle(crnrRad);
      translate([crnrRad,baseDims.y]) circle(crnrRad);
      translate([baseDims.z-crnrRad,rampWdth]) circle(crnrRad);
      translate([baseDims.z-crnrRad,baseDims.y]) circle(crnrRad);
      }
  }
}

module paperRoll(){
  dOuter=120;
  dInner=50;
  hght=120;
  color("white") linear_extrude() difference(){
    circle(d=dOuter);
    circle(d=dInner);
  }
  color("grey") linear_extrude() difference(){
    circle(d=dInner);
    circle(d=dInner-2);
  }
}