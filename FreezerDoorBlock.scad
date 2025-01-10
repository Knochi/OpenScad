// Parts for freezer door
$fn=50;
smallRad=1.5;
bigRad=4;
ovDims=[11.3,8.5,20];
drillOffset=[0,1.4-2.1+12.8/2-0.05,ovDims.z-8.5-12.8/2-1];
drillDia=3;
fudge=0.1;

difference(){
  hull(){
    translate([smallRad,smallRad]) chamfPin(d=smallRad*2,h=ovDims.z);
    translate([smallRad,ovDims.y-smallRad]) chamfPin(d=smallRad*2,h=ovDims.z);
    translate([ovDims.x-smallRad,ovDims.y-smallRad]) chamfPin(d=smallRad*2,h=ovDims.z);
    translate([ovDims.x-bigRad,bigRad]) chamfPin(d=bigRad*2,h=ovDims.z);
  }
  translate(drillOffset+[-fudge/2,0,0]) rotate([0,90,0]) cylinder(d=drillDia,h=ovDims.x+fudge);
  translate([ovDims.x/2,-fudge/2,ovDims.z/2]) rotate([-90,0,0]) cylinder(d=drillDia,h=ovDims.x+fudge);
}


//pin

pinOvLen=14.8+7.2-ovDims.x;
pinDia=9;
chamfer=0.8;


!pin();
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