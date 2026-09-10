/* [Dimensions] */
plateDims=[59,30,5];
plateRad=5;
holeDist=[45,16];
holeDia=4.2;
hldrDims=[16,17.5,10.5];
hldrWallThck=4;
filletRad=3;

sprngWallThck=3.5;
sprngOvDims=[12,25,18];
sprngOffset=[10.5,0.5];
sprngCutOut=[9,14,7];
sprngCutOutDist=15;
sprngTip=[-4.8-sprngOffset.x+plateDims.x/2,-4+plateDims.y-sprngOffset.y];

sprngPoly=[[0,0],[0,sprngWallThck],[4.8,sprngWallThck],[7.5,8.5],[7.5,20.6],[sprngTip.x-sprngWallThck,sprngTip.y],
           [sprngTip.x,sprngTip.y],[7.5+sprngWallThck,20.6],[7.5+sprngWallThck,8.5],[7.3,0]];
/* [show] */
export="holder"; //["none","holder","receiver","connector"]
/* [Hidden] */
fudge=0.1;
$fn=50;

if (export=="holder")
  !holder();
if (export=="receiver")
  !receiver();
if (export=="connector")
  !connector();
  
// -- ASY --
translate([0,hldrDims.y/2,-plateDims.z]) holder();
translate([0,0,0.2]) connector();
translate([0,100.3,-plateDims.z]) receiver();

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
      //cube
      translate([0,0,hldrHght/2]) 
        cube([hldrDims.x+hldrWallThck*2,hldrDims.y,hldrHght],true);
      //fillets
      for (ix=[-1,1])
        translate([ix*(hldrDims.x/2+filletRad/2+hldrWallThck),0,plateDims.z+filletRad/2]) cube([filletRad,hldrDims.y,filletRad],true);
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
    for (ix=[-1,1])
        translate([ix*(hldrDims.x/2+filletRad+hldrWallThck),0,plateDims.z+filletRad]) 
          rotate([90,0,0]) cylinder(r=filletRad,h=hldrDims.y+fudge,center=true);
  }
}


module connector(){
  conDims=[13.9,184,10.1];
  baseDims=[hldrDims.x+hldrWallThck*2,14.5];
  baseRad=2;
  wallThick=3.7;
  
  teethPitch=5.8;
  teethCount=round(112/teethPitch);
  teethSegLen=(teethCount+1)*teethPitch;
  toothDims=[2.5,teethPitch];
  toothPoly=[[0,0],[toothDims.x,0],[toothDims.x,2],[0,teethPitch]];
  
  shaftLen=conDims.y-baseDims.y-teethSegLen;
  
  hookDims=[5,17,1.8];
  hookMinThck=1.2;
  hookFlapLen=3;
  hookCutOutDims=[conDims.x-wallThick*2,18.5];
  hookPoly=[[0,-hookMinThck],[hookDims.y,-hookMinThck],[hookDims.y,0],[hookDims.y-hookFlapLen,0],
            [hookDims.y-hookFlapLen,hookDims.z],[0,0]];
  hookSpcng=0.2;
  hookOffset=hldrDims.y+hookDims.y-hookFlapLen+hookSpcng;
  
  translate([0,hookOffset,conDims.z]) 
    rotate([90,0,-90]) linear_extrude(hookDims.x,center=true) polygon(hookPoly);
    
  linear_extrude(conDims.z){
    //base
    translate([0,-baseDims.y/2]) offset(baseRad) square(baseDims-[baseRad*2,baseRad*2],true);
    //shaft
    translate([0,shaftLen/2]) difference(){
      square([conDims.x,shaftLen],true);
      translate([0,-shaftLen/2+hookOffset-hookCutOutDims.y/2]) square(hookCutOutDims,true);
    }
    //teeth segment
    translate([0,shaftLen]){
      for (ix=[0,1],iy=[0:teethCount])
        mirror([ix,0]) translate([conDims.x/2-toothDims.x,iy*teethPitch,0]) polygon(toothPoly);
      translate([-conDims.x/2+toothDims.x,0]) square([conDims.x-toothDims.x*2,teethSegLen]);
    }
  }
}