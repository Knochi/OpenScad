use <2020profile.scad>
use <stars.scad>

/* [Dimensions] */
$fn=50;
prfPos=[10,100,0];
prfLen=150;
prfDims=[20,20];
fanDims=[39,50+47.4,51.6+42.9];
upperHolePos=[0,39.0,39.0];
lowerHolePos=[0,-32.0,-32.0];
minWallThck=5;
cntrOffset=[0,3.5,3.5]; //center between the two holes
spcng=[0.5,0.5,0.2]; //lateral and vertical spacing
mntHght=100;//Height of the Mount
mntThck=30;
hngAxsDia=5;
sprngWdth=3;
sprngThck=0.5;
starN=16;

/* [show]  */
showProfile=true;
showFan=true;
showHinge=true;
showPlate=true;
showSection=false;

/* [Hidden] */
fudge=0.1;



if (showFan)
  color("darkSlateGrey") translate([31,0,0]) rotate([0,-90,-90]) import("rbh9733b.stl");
if (showProfile)
  color("silver") translate(prfPos+[0,0,-prfLen/2]) linear_extrude(prfLen) profile2020();

//Profile Mount

//hinge
if (showHinge)
  difference(){
    hinge();
    if (showSection) 
      color("darkGreen") translate([10,prfPos.y-prfDims.y/2-mntThck/2,cntrOffset.z]) 
        translate([0,0,mntHght/4]) cube([prfDims.x+minWallThck*2+fudge,prfDims.y*2+fudge,mntHght/2+fudge],true);
  }
  
if (showPlate)
  difference(){
    plate();
    if (showSection) color("darkRed") 
      translate([10,prfPos.y-prfDims.y/2-mntThck/2,cntrOffset.z]) 
        translate([0,0,mntHght/4]) cube([prfDims.x+minWallThck*2+fudge,prfDims.y*2+fudge,mntHght/2+fudge],true);
  }

module hinge(){
  ctSprngThck=mntThck/2-prfDims.y/2-sprngThck-spcng.x;
  translate([10,prfPos.y-prfDims.y/2-mntThck/4,cntrOffset.z]) difference(){
    union(){
      cube([prfDims.x,mntThck/2,mntHght],true);
      translate([0,-mntThck/4,0]) cylinder(d=20,h=mntHght,center=true);
      translate([0,-mntThck/4,0]) cylinder(d=20,h=mntHght,center=true);
    }
    translate([0,-mntThck/4,0]) difference(){
      cube([prfDims.x+fudge,prfDims.y+spcng.x*2,mntHght/2+spcng.z],center=true);
      cylinder(d=hngAxsDia,h=mntHght,center=true);
      //nudge for spring
      translate([0,10+spcng.x,0]) cylinder(d=3,h=mntHght/4-sprngWdth,center=true);
      //ease printing
      translate([0,10+spcng.x,-mntHght/8+sprngWdth/4]) cylinder(d1=0.1,d2=3,h=sprngWdth/2,center=true);
      translate([0,10+spcng.x,+mntHght/8-sprngWdth/4]) cylinder(d2=0.1,d1=3,h=sprngWdth/2,center=true);
    }
    //cutouts for spring
    translate([0,mntThck/4-ctSprngThck/2+fudge/2,0]) 
      cube([prfDims.x/2,ctSprngThck+fudge,mntHght/4+spcng.z],true);
    for (iz=[-1,1])
      translate([0,(mntThck-prfDims.y)/2,iz*(mntHght/8+spcng.z/2)]) 
        cube([prfDims.x/2,(mntThck-prfDims.y)/2,spcng.z],true);
    //Screw holes
    for (iz=[-1,1])
      translate([0,(mntThck-prfDims.y)/2+prfDims.y/8+fudge,iz*(mntHght*0.375+spcng.z)]) rotate([90,0,0]){
        cylinder(d=5.5,h=mntThck+fudge);
        translate([0,0,minWallThck]) cylinder(d=10,h=mntThck+fudge);
      }
  }
  
  
}


module plate(){
  translate([10,prfPos.y-prfDims.y/2-mntThck/2,cntrOffset.z]){
    difference(){
      hull(){
        cylinder(d=prfDims.x,h=mntHght/2-spcng.x,center=true);
        translate([-(prfDims.y/2+minWallThck/2),-prfDims.y/2-4,0]) 
          cube([minWallThck,minWallThck*2,mntHght/2-spcng.z],center=true);
      }
      cylinder(d=hngAxsDia+spcng.x*2,h=mntHght/2+fudge,center=true);
      //make space for star
      difference(){
        cylinder(d=prfDims.x+spcng.x,h=mntHght/3,center=true);
        rotate(-45) translate([0,-(prfDims.y+spcng.y)/4-fudge/2,0]) 
          cube([prfDims.x+spcng.x,(prfDims.y+spcng.y)/2+fudge,mntHght/3+fudge],true);
      }
    }
    //star to snap with spring
    linear_extrude(mntHght/3,center=true,convexity=4) rotate(90+180/starN)
      difference(){
        offset(spcng.x) star(N=starN,od=prfDims.x-spcng.x*2,id=prfDims.x-sprngWdth*1.5);
        circle(d=hngAxsDia+spcng.x);
      }
    //easy printing
    translate([0,0,mntHght/6-sprngWdth]) cylinder(d1=prfDims.x-sprngWdth*1.5,d2=prfDims.x,h=sprngWdth);
    translate([0,0,-mntHght/6]) cylinder(d2=prfDims.x-sprngWdth*1.5,d1=prfDims.x,h=sprngWdth);
  }
  //mounting plate
  holeOffset=upperHolePos.y-cntrOffset.y;

    translate(cntrOffset+[-minWallThck,0,0]) rotate([90,0,90]) linear_extrude(minWallThck) difference(){
      hull(){ 
        translate([upperHolePos.y-cntrOffset.y,upperHolePos.z-cntrOffset.z]) circle(d=4.5+minWallThck*2);
        translate([lowerHolePos.y-cntrOffset.y,lowerHolePos.z-cntrOffset.z]) circle(d=4.5+minWallThck*2);
        translate([prfPos.y-prfDims.y/2-mntThck,0]) square([minWallThck,mntHght/2-spcng.z],center=true); 
      }
      translate([upperHolePos.y-cntrOffset.y,upperHolePos.z-cntrOffset.z]) circle(d=4.5);
      translate([lowerHolePos.y-cntrOffset.y,lowerHolePos.z-cntrOffset.z]) circle(d=4.5);
    }
  }
  



