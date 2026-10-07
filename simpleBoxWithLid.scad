ovDims=[78,58,28];
floorThck=1;
wallThck=1;
radius=2;
spcng=0.1;

$fn=50;


*walls();
walls(ovDims+[-(wallThck+spcng)*2,-(wallThck+spcng)*2,-23],radius-wallThck-spcng);
topBottom();


module topBottom(){
  linear_extrude(floorThck) offset(radius) square([ovDims.x-radius*2,ovDims.y-radius*2],true);
}


module walls(dims=ovDims,rad=radius){
  linear_extrude(dims.z-floorThck-spcng) difference(){
    offset(rad) square([dims.x-rad*2,dims.y-rad*2],true);
    offset(rad-wallThck) square([dims.x-rad*2,dims.y-rad*2],true);
  }
}

