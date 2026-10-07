// Parts for freezer door
$fn=50;
smallRad=1.5;
bigRad=6;
ovDims=[15.8,12.8,20];
drillOffset=[0,1.4-2.1+12.8/2-0.05,ovDims.z-8.5-12.8/2-1];
drillDia=3;
fudge=0.1;


//pin

pinOvLen=7.2;
pinDia=9;
chamfer=0.8;
pinBaseDia=13;
pinBaseOffset=1.5;
pinPos=[ovDims.x,pinBaseDia/2+1.6,ovDims.z-pinBaseDia/2];


difference(){
  hull(){
    translate([smallRad,smallRad]) chamfPin(d=smallRad*2,h=ovDims.z);
    translate([smallRad,ovDims.y-smallRad]) chamfPin(d=smallRad*2,h=ovDims.z);
    translate([ovDims.x-smallRad,ovDims.y-smallRad]) chamfPin(d=smallRad*2,h=ovDims.z);
    translate([ovDims.x-bigRad,bigRad]) chamfPin(d=bigRad*2,h=ovDims.z);
  }
  translate([-ovDims.x+fudge,0,0]+pinPos) rotate([0,90,0]) cylinder(d=drillDia,h=ovDims.x+fudge);
}



translate(pinPos){ 
  //pinbase
  
  translate([-pinOvLen+pinBaseOffset,0,]) rotate([0,90,0]) linear_extrude(pinOvLen) difference(){
    circle(d=pinBaseDia);
    translate([0,pinBaseDia-2]) square([pinBaseDia,pinBaseDia],true);
    circle(d=3.7);
  }
  rotate([0,90,0]) pin();
}

wallThck=1.8;
floorThck=2;
doorAttachLen=75;
doorAttachDims=[doorAttachLen,ovDims.y-wallThck,ovDims.z];
drillPos=[[-5,-fudge,ovDims.z/2],[-doorAttachLen+10,-fudge,ovDims.z/2],[-doorAttachLen/2+2.5,-fudge,ovDims.z/2]];
difference(){
  translate([-doorAttachLen,0,0]) hull() for(ix=[0,1],iy=[0,1])
    translate([ix*doorAttachDims.x+smallRad,iy*(doorAttachDims.y-smallRad*2)+smallRad,0]) chamfPin(d=smallRad*2,h=ovDims.z);
  for (pos=drillPos)
    translate(pos) rotate([-90,0,0]){
      cylinder(d=drillDia,h=ovDims.x+fudge);
      cylinder(d1=drillDia*2.2,d2=drillDia,h=drillDia);
    }
}

module pin(){
      difference(){
        union(){
          cylinder(d=pinDia,h=pinOvLen-chamfer);
          translate([0,0,pinOvLen-chamfer]) cylinder(d1=pinDia,d2=pinDia-chamfer*2,h=chamfer);
        }
        translate([0,0,pinOvLen-2.6]) cylinder(d1=3.7,d2=7.2,h=2.6+fudge);
        translate([0,0,-fudge/2]) cylinder(d=3.7,h=pinOvLen+fudge);
      }
      
}


module chamfPin(d=3, h=10, c=1){
  cylinder(d1=d-c*2,h=c);
  translate([0,0,c]) cylinder(d=d,h=h-2*c);
  translate([0,0,h-c]) cylinder(d1=d,d2=d-c*2,h=c);
}