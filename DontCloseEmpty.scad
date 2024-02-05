
$fn=30;


/* [Dimensions] */
//Dimensions of the compartment
compDims=[150,150,150];
//spacing between mechanism and compartment
cmpSpcng=0.5;


/* [show] */
showRoll=true;
showBase=true;

/* [Hidden] */
fudge=0.1;

if (showRoll) paperRoll();
if (showBase) base();

module base(){
  crnrRad=1;
  rampWdth=10;
  baseDims=[compDims.x-cmpSpcng,compDims.y-cmpSpcng*2,4];
  flapDims=[baseDims.x*0.6,(baseDims.y-rampWdth)*0.6,baseDims.z];
  difference(){
    baseBdy();
      translate([-baseDims.x/2,rampWdth+flapDims.y/2,baseDims.z/2]) 
        cube(flapDims+[0,0,fudge],true);
  }
  
  module baseBdy(){
    
    
    rotate([0,-90,0]) linear_extrude(baseDims.x) hull(){
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