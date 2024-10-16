/* [Dimensions] */
plateDims=[59,30,5];
plateRad=5;
holeDist=[45,16];
holeDia=4.2;
hldrDims=[16,18,10.1];
hldrWallThck=4;
sprngWallThck=3.5;
sprngOvDims=[12,25,18];
sprngOffset=[10.5,0.5];
sprngCutOut=[9,14,7];
sprngCutOutDist=15;
sprngTip=[-5-sprngOffset.x+plateDims.x/2,-4+plateDims.y-sprngOffset.y];

sprngPoly=[[0,0],[0,sprngWallThck],[4.8,sprngWallThck],[7.5,8.5],[7.5,20],[sprngTip.x-sprngWallThck,sprngTip.y],
           [sprngTip.x,sprngTip.y],[7.5+sprngWallThck,20],[7.5+sprngWallThck,8.5],[7.3,0]];
/* [show] */
export="none"; //["none","holder","receiver"]
/* [Hidden] */
fudge=0.1;
$fn=20;

if (export=="holder")
  holder();
if (export=="receiver")
  receiver();


module receiver(){
  difference(){
    union(){
      for (im=[0,1])
      mirror([im,0,0]) translate([-plateDims.x/2+sprngOffset.x,-plateDims.y/2+sprngOffset.y,plateDims.z]) 
        linear_extrude(sprngOvDims.z,convexity=3) polygon(sprngPoly);
      
      //base plate
      linear_extrude(plateDims.z,convexity=3) difference(){
        hull() for (ix=[-1,1],iy=[-1,1])
          translate([ix*(plateDims.x/2-plateRad),iy*(plateDims.y/2-plateRad)]) circle(plateRad);
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*holeDist.x/2,iy*holeDist.y/2]) circle(d=holeDia);
      }
    }
    for (ix=[-1,1]) 
      translate([ix*sprngCutOutDist/2,-sprngCutOut.y/2+13,sprngCutOut.z/2]) cube(sprngCutOut+[0,0,fudge],true);
    //countersunk
    for (ix=[-1,1],iy=[-1,1])
          translate([ix*holeDist.x/2,iy*holeDist.y/2,plateDims.z/2]) 
            cylinder(d1=holeDia,d2=holeDia+plateDims.z,h=plateDims.z/2+fudge);
  }
}


module holder(){
  hldrHght=hldrDims.z+plateDims.z+hldrWallThck;
  difference(){
    union(){
      translate([0,0,hldrHght/2]) 
        cube([hldrDims.x+hldrWallThck*2,hldrDims.y,hldrHght],true);
      //base plate
      linear_extrude(plateDims.z,convexity=3) difference(){
        hull() for (ix=[-1,1],iy=[-1,1])
          translate([ix*(plateDims.x/2-plateRad),iy*(plateDims.y/2-plateRad)]) circle(plateRad);
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*holeDist.x/2,iy*holeDist.y/2]) circle(d=holeDia);
      }
    }
    translate([0,0,(hldrDims.z+plateDims.z-fudge)/2]) cube(hldrDims+[0,fudge,plateDims.z+fudge],true);
    //countersunk
    for (ix=[-1,1],iy=[-1,1])
          translate([ix*holeDist.x/2,iy*holeDist.y/2,plateDims.z/2]) 
            cylinder(d1=holeDia,d2=holeDia+plateDims.z,h=plateDims.z/2+fudge);
  }
}