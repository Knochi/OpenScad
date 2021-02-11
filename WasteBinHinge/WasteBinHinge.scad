use <myShapes.scad>


$vpt=[ 0,0,0 ];
$vpr=[ 55.00, 0.00, 25.00 ];
$vpd=213.38;


$fn=20;
fudge=0.1;

showBody=true;
showHinge=true;


bdDims=[72,35,45.2];
lidRad=290/2;
lidCenterOffset=-lidRad-bdDims.y/2+segmentHght(bdDims.x,lidRad);
rad=1;


if (showBody) body();
if (showHinge) hinge();
  
module body(){  
  difference(){
    hull() for (ix=[-1,1],iz=[-1,1]){
      translate([ix*(64/2-rad),(35/2-rad),iz*(15-rad)]) sphere(rad);
      translate([ix*(72/2-rad),-(35/2-rad),iz*(22.6-rad)]) sphere(rad);
    }
    //lid cutOut
    translate([0,lidCenterOffset,-(bdDims.z+fudge)/2]) 
      rotate(90-45/2) linear_extrude(bdDims.z+fudge) arc(r=lidRad,angle=45);  
    //half
    translate([0,0,(bdDims.z+fudge)/2]) cube(bdDims+[fudge,fudge,fudge],true);  
    //drills
    for (im=[0,1])
      translate([0,lidCenterOffset,0])
      mirror([im,0,0]){
        rotate(segmentAngle(30/2,lidRad)) 
          translate([0,lidRad-fudge,-10]) 
            rotate([-90,0,0]) cylinder(d=2.5,h=10);
      }
  }
  translate([0,(bdDims.y-2.2)/2,3.1/2]) cube([57.3,2.2,3.1],true);
  
  //hooks
  for (im=[0,1])
    translate([0,lidCenterOffset,0])
      mirror([im,0,0])
        rotate(segmentAngle(53/2,lidRad))
          translate([0,lidRad-fudge,-12]) hook();
  
  module hook(){
    difference(){
      union(){
        for (iy=[-1,1]) translate([0,iy*(3.7-3.1)/2,0]) cylinder(d=3.1,h=12,center=true);
        cube([3.1,3.7-3.1,12],true);
      }
      translate([-((1+fudge)-3.1-fudge)/2,0,0]) cube([1+fudge,2,12+fudge],true);
    }
  }
}

module hinge(){
  ovDims=[46.3,13.5,14];
  domeDims=[6,12,20.5];
  domeHght=domeDims.z-domeDims.y/2;
  wallThck=3;
  
  //main Hinge
  translate([0,(bdDims.y-ovDims.y)/2,ovDims.z/2])   
    difference(){
      translate([0,0,-fudge]) cube(ovDims+[0,0,fudge],true);
      rotate([0,90,0]) cylinder(d=7.1,h=ovDims.x+fudge,center=true);
      *translate([0,-(wallThck+fudge)/2,]) 
        cube([(ovDims.x-wallThck*2),ovDims.y-wallThck+fudge,ovDims.z+fudge],true);
      translate([0,-ovDims.y/2,ovDims.z/2]) rotate([0,90,0]) 
        cylinder(d=5,h=ovDims.x+fudge,center=true,$fn=4);
  }
  
  //dome
  difference(){
    union(){
      translate([0,0,domeHght/2]) cube([domeDims.x,domeDims.y,domeHght],true);
      translate([0,0,domeHght]) rotate([0,90,0]) cylinder(d=domeDims.y,h=domeDims.x,center=true);
    }
    translate([0,0,domeHght]) rotate([0,90,0]) cylinder(d=5,h=domeDims.x+fudge,center=true);
  }

  
}


function segmentHght(s,r)=r-0.5*sqrt(4*pow(r,2)-pow(s,2));
function segmentAngle(s,r)=2*asin(s/(2*r));