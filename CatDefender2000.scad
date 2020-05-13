/* [show] */
showSpikes=true;
showPlanter=true;

/* [Dimensions] */
spikeLen=400;
spikeDia=4;
spikeCnt=10;
spcng=0.2;

wallThck=2;

plntrSize=[500,190,195];
plntrSizeBtm=[480,170];

/* [Hidden] */
fudge=0.1;
$fn=20;

plntrFlnkAng=atan(((plntrSize.x-plntrSizeBtm.x)/2)/plntrSize.z);


translate([(plntrSizeBtm.x+spikeDia)/2+wallThck,plntrSizeBtm.y/2+wallThck,-wallThck]) 
  rotate([0,0,-90]) spikes();
if (showPlanter) color("purple") planter();


module spikes(){
  spikeAng=90/(spikeCnt-1);
  
  dist=30; //distance spikes from center
  deep=15; //how deep embedded in holder
  ovRad=dist+deep;
  discThck=spikeDia+wallThck*2; //thickness of the disc holding the spikes
  
  // --- mounts ---
  //back
  rotate([-plntrFlnkAng,0,0]) translate([wallThck,discThck/2,wallThck]) rotate([90,-90,0]){
    rotate_extrude($fn=(spikeCnt-1)*4,angle=plntrFlnkAng) 
        translate([dist-wallThck,-discThck/2]) square([deep+wallThck,discThck]);
    rotate([0,0,plntrFlnkAng]) translate([dist-wallThck,0,-discThck/2]) 
      cube([deep+wallThck,wallThck,ovRad]); 
  }
  //bottom
  translate([dist,-ovRad+discThck*2,0]) 
    cube([deep+wallThck,ovRad-discThck,wallThck]);
  
  
  rotate([-plntrFlnkAng,0,0]) translate([wallThck,discThck/2,wallThck]){
    difference(){
      rotate([90,0,0]) rotate_extrude($fn=(spikeCnt-1)*4,angle=90) 
        translate([dist-wallThck,-discThck/2]) square([deep+wallThck,discThck]);
      for (r=[0:spikeAng:90-spikeAng])
        rotate([0,r+spikeAng/2,0]) translate([0,0,dist]) cylinder(d=spikeDia+spcng,h=deep+fudge);
    }
      color("peru") if (showSpikes) for (r=[0:spikeAng:90-spikeAng])
        rotate([0,r+spikeAng/2,0]) translate([0,0,dist]) spike();
  }
  
  module spike(){
    tipLen=spikeDia*2;
    cylinder(d=spikeDia,h=spikeLen-tipLen);
    translate([0,0,spikeLen-tipLen]) cylinder(d1=spikeDia,d2=0.1,h=tipLen);
  }
}

module planter(){

  scaleFac=[plntrSizeBtm.x/plntrSize.x,plntrSizeBtm.y/plntrSize.y];
  translate([0,0,plntrSize.z]) mirror([0,0,1]) linear_extrude(height=plntrSize.z,scale=scaleFac) square([plntrSize.x,plntrSize.y],true);
}