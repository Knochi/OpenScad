


// --- CORES ---
EFD_30_15_9();
module EFD_30_15_9(gap=0.71){
 //https://www.tdk-electronics.tdk.com/en/529370/products/product-catalog/ferrites-and-accessories/efd-ev-cores-and-accessories
  module Former(){
    baseDims=[30,31,1.7];
    rad=2;
    
  }
  
  module Core(){
    ovDims=[30,9.1,15];
    coreDims=[14.6,4.9,11.2];
    coreYPos=(coreDims.y-ovDims.y)/2+0.75;
    chamfer=0.75;
    opnWdth=22.4;
    
    basePoly=[[-ovDims.x/2,ovDims.y/2],
              [ovDims.x/2,ovDims.y/2],
              [ovDims.x/2,-ovDims.y/2],
              [coreDims.x/2,-ovDims.y/2],
              [coreDims.x/2-chamfer,-ovDims.y/2+chamfer],
              [-coreDims.x/2+chamfer,-ovDims.y/2+chamfer],
              [-coreDims.x/2,-ovDims.y/2],
              [-ovDims.x/2,-ovDims.y/2]];
    
    corePoly=[[-coreDims.x/2,coreDims.y/2-chamfer], [-coreDims.x/2+chamfer,coreDims.y/2],
              [coreDims.x/2-chamfer,coreDims.y/2],  [coreDims.x/2,coreDims.y/2-chamfer],            
              [coreDims.x/2,-coreDims.y/2+chamfer], [coreDims.x/2-chamfer,-coreDims.y/2],  
              [-coreDims.x/2+chamfer,-coreDims.y/2],[-coreDims.x/2,-coreDims.y/2+chamfer]];

    //base
    linear_extrude(ovDims.z-coreDims.z) polygon(basePoly);
    //core
    translate([0,coreYPos,ovDims.z-coreDims.z]) linear_extrude(coreDims.z-gap) polygon(corePoly);
    //legs
    legWdth=(ovDims.x-opnWdth)/2;
    for (ix=[-1,1])
      translate([ix*(ovDims.x-legWdth)/2,0,ovDims.z/2]) cube([legWdth,ovDims.y,ovDims.z],true);
  }
}

