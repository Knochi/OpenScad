$fn=20;
include <myShapes.scad>

/* -- [Dimensions] -- */
extrusionWidth=0.4;
wallCount=8;
screwDia=3.5;
counterSinkDia=8.5; 
bookDims=[117*2,326,17.8];
feetDims=[9,21.5,2.2];
feetDist=[190,236,212.5]; //x, y1, y2
feetxOffset=(25.5-17.5)/2;
tblThck=19.4;
magnetDia=5;
spcng=1;
fudge=0.1;

/* --[hidden] -- */
clampMinWallThck=extrusionWidth*wallCount;

<<<<<<< .mine


HPEliteBook840G5();
=======



>>>>>>> .theirs
//left back
translate([-(bookDims.x+clampMinWallThck)/2-spcng/2,(feetDist[1])/2,(bookDims.z+spcng)/2-feetDims.z/2-spcng/2]) 
  clamp(stopper=true,isLeft=true);
mirror([1,0,0]) translate([-(bookDims.x+clampMinWallThck)/2-spcng/2,(feetDist[2])/2,(bookDims.z+spcng)/2-feetDims.z/2-spcng/2])  
  clamp(stopper=true,isLeft=false);
//left front
translate([-(bookDims.x+clampMinWallThck)/2-spcng/2,-(feetDist[1])/2,(bookDims.z+spcng)/2-feetDims.z/2-spcng/2]) 
  clamp(stopper=false,isLeft=true,nudge=true);
mirror([1,0,0]) translate([-(bookDims.x+clampMinWallThck)/2-spcng/2,-(feetDist[2])/2,(bookDims.z+spcng)/2-feetDims.z/2-spcng/2])  
  clamp(stopper=false,isLeft=false);


//USBHub
translate([0,-bookDims.y/2,bookDims.z+clampMinWallThck+spcng-fudge]) rotate(0) USBHub();
*clamp(stopper=true,nudge=true);
module clamp(stopper=true,isLeft=true,nudge=false){
  topWdth=20;
  footxOffset= isLeft ? feetxOffset : -feetxOffset;
  bottomWdth=(bookDims.x-feetDist.x+clampMinWallThck+spcng+feetDims.x)/2+feetDims.x+footxOffset;
  clampWdth=50;
  rad=4; //edge radii (median line)
  radOffset=rad-clampMinWallThck/2;
  stprPos=[bottomWdth-feetDims.x*1.5,0,-(bookDims.z+feetDims.z+spcng)/2];
  plateZOffset=(bookDims.z+clampMinWallThck+feetDims.z+spcng)/2;
  vertPlateHght=bookDims.z+feetDims.z-radOffset*2+spcng; //hight of the vertical part
  stpRad= min(feetDims.x/4,feetDims.z); //edge radius to apply to stopper part

  hull() for (iy=[-1,1])
    translate([0,iy*(clampWdth-clampMinWallThck)/2,0]) 
      cylinder(d=clampMinWallThck,h=vertPlateHght,center=true);
  rotate([90,0,0]){
    
    *linear_extrude(clampWdth,center=true) hull()
      for (iy=[-1,1])
        translate([0,iy*(bookDims.z+feetDims.z-radOffset*2+spcng)/2])
          circle(d=clampMinWallThck);
      //square([clampMinWallThck,bookDims.z+feetDims.z-radOffset*2+spcng],true);
  
    //bottom radius
    translate([rad,-((bookDims.z+feetDims.z+spcng)/2-radOffset),0])
      rotate([0,0,180]) rotate_extrude(angle=90) 
        translate([rad,0]) hull() for(iy=[-1,1])
          translate([0,iy*(clampWdth-clampMinWallThck)/2]) circle(d=clampMinWallThck); //square([clampMinWallThck,clampWdth],true);
    //top radius
    translate([rad,((bookDims.z+feetDims.z+spcng)/2-radOffset),0])
      rotate([0,0,90]) rotate_extrude(angle=90) 
        translate([rad,0]) hull() for(iy=[-1,1])
          translate([0,iy*(clampWdth-clampMinWallThck)/2]) circle(d=clampMinWallThck);
  }
    //top screwplate
    translate([0,0,plateZOffset]) plate(top=true);
  
    //bottom restplate
    translate([0,0,-plateZOffset]) plate(top=false);
  
    //stopper
    if (stopper)
      translate(stprPos){
        difference(){
          translate([0,clampWdth/4,feetDims.z/2]){
            cube([feetDims.x*2-stpRad*2,clampWdth/2,feetDims.z],true);
              for (mx=[0,1])
                mirror([mx,0,0]) translate([(feetDims.x-stpRad),0,-stpRad/2]) 
                  translate([0,clampWdth/4,0]) rotate([90,0,0]) rotate_extrude(angle=90) square([stpRad,clampWdth/2]);
          }
          //cutout for foot
          hull() for (iy=[-1,1])
            translate([0,iy*(feetDims.y-feetDims.x)/2,feetDims.z/2]) 
              cylinder(d=feetDims.x+stpRad*2,h=feetDims.z+fudge,center=true);
          //repeat drill hole
          for(iy=[-1,1]) 
            translate([topWdth/2,iy*clampWdth/4,-plateZOffset+(clampMinWallThck-fudge)/2]-stprPos) 
              cylinder(d=screwDia*2+spcng,h=feetDims.z+fudge);
         }
         for (ix=[-1,1])
           translate([ix*feetDims.x*0.75,0,0]) 
            rotate([0,0,180]) rotate_extrude(angle=180){
               translate([feetDims.x/4-stpRad,0]) arc(stpRad,90);
               square([feetDims.x/4-stpRad,stpRad]);
            }

          //rnd corners of cutout
          for(mx=[0,1])
            mirror([mx,0,0]) translate([feetDims.x*0.75-(feetDims.x/4-stpRad),(feetDims.y-feetDims.x)/2,0]) 
              rotate([90,-90,0]) rotate_extrude(angle=90) square([stpRad,(feetDims.y-feetDims.x)/2]);
            translate([0,(feetDims.y-feetDims.x)/2,0]) rotate_extrude(angle=180) 
              translate([feetDims.x*0.75-(feetDims.x/4-stpRad),0]) mirror([1,0]) arc(stpRad,90);
          //connect to base
          translate([0,clampWdth/2-clampMinWallThck/4,-clampMinWallThck/4]) cube([feetDims.x*2,clampMinWallThck/2,clampMinWallThck/2],true);
      }
  *plate(true);
  module plate(top=false){
    ndgDims=[10,1.6];
    ndgSpcng=0.2;
    width= top ? nudge ? topWdth+ndgDims.x : topWdth : bottomWdth;
    
    difference(){
      union(){ //body
        hull() for (iy=[-1,1])
          translate([rad,iy*(clampWdth-clampMinWallThck)/2,0]) 
            rotate([0,90,0]) cylinder(d=clampMinWallThck,h=width-rad*2);
        hull() for(iy=[-1,1])
          translate([width-rad,iy*(clampWdth/2-rad),0]) 
            rotate_extrude() translate([rad-clampMinWallThck/2,0]) circle(d=clampMinWallThck);
      }
      if (top){
        for(iy=[-1,1]){
          translate([topWdth/2,iy*clampWdth/4,0]){
            cylinder(d=screwDia+fudge,h=clampMinWallThck+fudge,center=true);
          translate([0,0,-(clampMinWallThck+fudge)/2]) 
            cylinder(d1=counterSinkDia,d2=0.05,h=counterSinkDia/2);
          }
        }
        if (nudge) 
          translate([width-ndgDims.x/2-ndgSpcng-rad,0,0]){ 
            translate([0,0,(clampMinWallThck+fudge)/2-(ndgDims.y+ndgSpcng)/2]) 
              cube([ndgDims.x+ndgSpcng*2,clampWdth+fudge,ndgDims.y+ndgSpcng+fudge],true);
            translate([0,0,-fudge-clampMinWallThck/2]) cylinder(d=magnetDia+spcng,h=1+fudge); //possible magnet
          }
      }
      else
        for(iy=[-1,1]) 
        translate([topWdth/2,iy*clampWdth/4,0]) 
          cylinder(d=screwDia*2+spcng,h=clampMinWallThck+fudge,center=true);
    }    
  }  
}

module HPEliteBook840G5(){
  crnRad=3;
  //color("silver") translate([-234/2,0,0]) rotate([90,0,0]) linear_extrude(326,center=true) import("EliteBook840G5_contour.svg");
  
  color("silver") translate([0,0,bookDims.z/2]) rotate([90,0,0]) linear_extrude(bookDims.y,center=true) 
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(bookDims.x/2-crnRad),iy*(bookDims.z/2-crnRad)]) circle(crnRad);
  //feet
  color("darkgrey")for (iy=[-1,1]){
    translate([-feetDist.x/2+feetxOffset,iy*feetDist[1]/2,0]) foot();
    translate([feetDist.x/2+feetxOffset,iy*feetDist[2]/2,0]) foot();
  }
  
  module foot(){
    hull() for (iy=[-1,1]) 
      translate([0,iy*(feetDims.y-feetDims.x)/2,-feetDims.z]) 
        cylinder(d=feetDims.x,h=feetDims.z);
  }
}


*USBHub();
module USBHub(){
  //roline USB-C HUB 14025039
  //https://www.reichelt.de/usb-3-0-hub-4-port-usb-c-zu-4x-usb-3-0-typ-a-roline-14025039-p289002.html
  bdyDims=[93.5,28.5,10];
  crnRad=1.6;
  chmfer=1;
  spcng=0.2;
  hubMinWallThck=2;
  capHght=10;
  
  poly=[[-bdyDims.y/2+chmfer,-bdyDims.z/2],[-bdyDims.y/2,-bdyDims.z/2+chmfer],[-bdyDims.y/2,bdyDims.z/2-crnRad],
        [-bdyDims.y/2+crnRad,bdyDims.z/2-crnRad],[-bdyDims.y/2+crnRad,-bdyDims.z/2]];
  translate([0,0,bdyDims.z/2]) rotate([90,0,90]){
    difference(){ //body
      color("sandybrown") linear_extrude(bdyDims.x,center=true)     
        hubShape();
      translate([0,0,-bdyDims.x/2+5]) cube([12.3,4.6,10+fudge],true);
    }
    //cable strain relief
    color("darkSlateGrey") translate([0,0,bdyDims.x/2]) cylinder(d=6,h=8.6);
  }

  translate([-bdyDims.x/2,0,bdyDims.z/2]) rotate([90,0,90]) endCap();
  *endCap();
  module endCap(){
    armLngth=40;
    endCapDims=[bdyDims.y+(hubMinWallThck+spcng)*2,capHght,bdyDims.z+(hubMinWallThck+spcng)*2];
    //translate([endCapDims.x/2,0,endCapDims.z/2]) rotate([90,0,180]) 
    translate([0,0,-hubMinWallThck-spcng]) 
    difference(){
      union(){
        hull() for(ix=[-1,1],iy=[-1,1])
          translate([ix*(bdyDims.y/2-crnRad+spcng),iy*(bdyDims.z/2-crnRad+spcng),0]) 
            cylinder(r=crnRad+hubMinWallThck,h=capHght);
        translate([endCapDims.x/2-(crnRad+hubMinWallThck),-endCapDims.z/2,0]){
          cube([armLngth+(crnRad+hubMinWallThck)-hubMinWallThck/2,hubMinWallThck,capHght]);
          translate([armLngth+(crnRad+hubMinWallThck)-hubMinWallThck/2,hubMinWallThck/2,0]) 
            cylinder(d=hubMinWallThck,h=capHght);
        }
      }
      translate([0,0,hubMinWallThck]) linear_extrude(capHght-hubMinWallThck+fudge) offset(spcng) hubShape();
      translate([0,0,-fudge/2]) linear_extrude(hubMinWallThck+fudge) offset(-hubMinWallThck/2) hubShape();
      //magnet
      for (ix=[-2:2])
      translate([bdyDims.y/2+hubMinWallThck+28+ix*magnetDia*0.7,-bdyDims.z/2-hubMinWallThck-spcng-fudge,capHght/2]) 
        rotate([-90,0,0]) cylinder(d=magnetDia+spcng,h=1+fudge,$fn=50);
    }
  }
  
  module hubShape(){
    translate([(bdyDims.y-bdyDims.z)/2,0]) circle(d=bdyDims.z);
        translate([-bdyDims.z/4+crnRad/2,0]) square([bdyDims.y-bdyDims.z/2-crnRad,bdyDims.z],true);
        translate([-bdyDims.y/2+crnRad,bdyDims.z/2-crnRad]) circle(crnRad);
        polygon(poly);
  }
}