include <KiCADColors.scad>

$fn=30;
fudge=0.1;


// --- CORES ---
EFD_30_15_9();
module EFD_30_15_9(gap=0.71,center=false){
 //https://www.tdk-electronics.tdk.com/en/529370/products/product-catalog/ferrites-and-accessories/efd-ev-cores-and-accessories
  coreWdth=15;
  coreZOffset=6.6/2+1.7+1.6;
  pinCnt=12;
  pitch=[5,27.5];
  pinDims=[0.6,0.6,3.5];
  centerOffset= center ?  [0,0,0] : [((pinCnt-2)/4)*pitch.x,pitch.y/2,0];
  
  translate(centerOffset){
    color(darkGreyBodyCol){
      translate([0,coreWdth,coreZOffset]) rotate([90,0,0]) Core();
      translate([0,-coreWdth,coreZOffset]) rotate([-90,180,0]) Core();
    }
  
    Former();
  }

  module Former(){
    baseDims=[30,31,1.7];
    rad=1.5;
    spoolDims=[21.55,21.7,13];
    spoolWallThck=(21.7-20.1)/2;
    opnWdth=spoolDims.y-spoolWallThck;
    baseThck=1.7;
    baseZOffset=1.6;
    gapUprWdth=6.5;
    gapLwrWdth=5.5;
    gapHght=2.25;
    coilThck=3.5;
    tapeThck=0.1;
    
    //base
    color(blackBodyCol) translate([0,0,baseZOffset]) linear_extrude(baseThck) difference(){
      *hull() for (ix=[-1,1], iy=[-1,1])
        translate([ix*(baseDims.x/2-rad),iy*(baseDims.y/2-rad)]) circle(rad);
      offset(rad) square([baseDims.x-rad*2,baseDims.y-rad*2],true);
      square([baseDims.x+fudge,opnWdth],true);
    }
    
    //pins
    color(metalGreyPinCol) translate([0,0,-pinDims.z]) 
      linear_extrude(pinDims.z+baseZOffset) 
        for (ix=[-(pinCnt-2)/4:(pinCnt-2)/4],iy=[-1,1])
          translate([ix*pitch.x,iy*pitch.y/2]) square([pinDims.x,pinDims.y],true);
        
    //spool
    color(blackBodyCol) translate([0,0,coreZOffset]) rotate([90,0,0]){
        linear_extrude(opnWdth,center=true) difference(){
          offset((6.6-5.2)/2) chamfRect([14.9,5.2],1);
          chamfRect([14.9,5.2],1);
        }
        for (iz=[-1,1]) //spool ends
          translate([0,0,iz*opnWdth/2]) linear_extrude(spoolWallThck,center=true) difference(){
            *hull() for (ix=[-1,1],iy=[-1,1])
              translate([ix*(spoolDims.x/2-rad),iy*(spoolDims.z/2-rad)]) circle(rad);
            offset(rad) square([spoolDims.x-rad*2,spoolDims.z-rad*2],true);
            chamfRect([14.9,5.2],1);
            polygon([[-gapUprWdth/2,spoolDims.z/2],[-gapLwrWdth/2,spoolDims.z/2-gapHght],
                     [gapLwrWdth/2,spoolDims.z/2-gapHght],[gapUprWdth/2,spoolDims.z/2]]);
                     
            if (iz>0) polygon([[-spoolDims.x/2,spoolDims.z/2],[-spoolDims.x/2+rad,spoolDims.z/2],[-spoolDims.x/2,spoolDims.z/2-rad]]);
          }
      }
    //coil
    color(metalCopperCol) translate([0,0,coreZOffset]) rotate([90,0,0])
        linear_extrude(opnWdth-spoolWallThck,center=true) difference(){
          offset(coilThck) chamfRect([14.9,5.2],1);
          offset((6.6-5.2)/2) chamfRect([14.9,5.2],1);
          }
    //tape
    color(yellowBodyCol) translate([0,0,coreZOffset]) rotate([90,0,0])
        linear_extrude(opnWdth-spoolWallThck,center=true) difference(){
          offset(coilThck+tapeThck) chamfRect([14.9,5.2],1);
          offset(coilThck) chamfRect([14.9,5.2],1);
          }
  } //Former
  
  
  *Core();
  module Core(){
    ovDims=[30,9.1,coreWdth];
    coreDims=[14.6,4.9,11.2];
    lwrGapHght=0.75;
    coreYPos=(coreDims.y-ovDims.y)/2+lwrGapHght;
    chamfer=0.95;
    opnWdth=22.4;
    gapUprWdth=8.15;
    gapLwrWdth=6.5;
    gapHght=2.15;
    
    
    basePoly=[[-ovDims.x/2,ovDims.y/2],
              [-gapUprWdth/2,ovDims.y/2],[-gapLwrWdth/2,ovDims.y/2-gapHght],
              [gapLwrWdth/2,ovDims.y/2-gapHght],[gapUprWdth/2,ovDims.y/2],
              [ovDims.x/2,ovDims.y/2],
              [ovDims.x/2,-ovDims.y/2],
              [coreDims.x/2,-ovDims.y/2],
              [coreDims.x/2-chamfer,-ovDims.y/2+lwrGapHght],
              [-coreDims.x/2+chamfer,-ovDims.y/2+lwrGapHght],
              [-coreDims.x/2,-ovDims.y/2],
              [-ovDims.x/2,-ovDims.y/2]];
    
    translate([0,-coreYPos,0]){
      //base
      linear_extrude(ovDims.z-coreDims.z) polygon(basePoly);
      //core
      translate([0,coreYPos,ovDims.z-coreDims.z]) linear_extrude(coreDims.z-gap) chamfRect([coreDims.x,coreDims.y],chamfer);
      //legs
      legWdth=(ovDims.x-opnWdth)/2;
    
      for (ix=[-1,1])
        translate([ix*(ovDims.x-legWdth)/2,0,ovDims.z/2]) cube([legWdth,ovDims.y,ovDims.z],true);
    }
  }
}


*chamfRect();
module chamfRect(size=[10,10],chamfer=2){
  poly=[[-size.x/2,size.y/2-chamfer], [-size.x/2+chamfer,size.y/2],
              [size.x/2-chamfer,size.y/2],  [size.x/2,size.y/2-chamfer],            
              [size.x/2,-size.y/2+chamfer], [size.x/2-chamfer,-size.y/2],  
              [-size.x/2+chamfer,-size.y/2],[-size.x/2,-size.y/2+chamfer]];
  polygon(poly);
}


module rndRect(size=[10,10],rad=1){
  offset(rad) square(size-[rad*2,rad*2],true);
}
