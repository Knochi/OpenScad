$fn=20;

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
spcng=1;
fudge=0.1;

/* --[hidden] -- */
minWallThck=extrusionWidth*wallCount;

HPEliteBook840G5();
//left back
translate([-(bookDims.x+minWallThck)/2-spcng/2,(feetDist[1])/2,(bookDims.z+spcng)/2-feetDims.z/2-spcng/2]) 
  clamp(stopper=true,isLeft=true);
mirror([1,0,0]) translate([-(bookDims.x+minWallThck)/2-spcng/2,(feetDist[2])/2,(bookDims.z+spcng)/2-feetDims.z/2-spcng/2])  
  clamp(stopper=true,isLeft=false);
translate([-(bookDims.x+minWallThck)/2-spcng/2,-(feetDist[1])/2,(bookDims.z+spcng)/2-feetDims.z/2-spcng/2]) 
  clamp(stopper=false,isLeft=true);
mirror([1,0,0]) translate([-(bookDims.x+minWallThck)/2-spcng/2,-(feetDist[2])/2,(bookDims.z+spcng)/2-feetDims.z/2-spcng/2])  
  clamp(stopper=false,isLeft=false);


//USBHub
translate([0,bookDims.y/2,bookDims.z+minWallThck+tblThck]) rotate(180) USBHub();
*clamp(false);
module clamp(stopper=true,isLeft=true){
  topWdth=20;
  footxOffset= isLeft ? feetxOffset : -feetxOffset;
  bottomWdth=(bookDims.x-feetDist.x+minWallThck+spcng+feetDims.x)/2+feetDims.x+footxOffset;
  clampWdth=50;
  rad=4; //edge radii (median line)
  radOffset=rad-minWallThck/2;
  stprPos=[bottomWdth-feetDims.x*1.5,0,-(bookDims.z+feetDims.z+spcng)/2];

  rotate([90,0,0]){
    linear_extrude(clampWdth,center=true)
      square([minWallThck,bookDims.z+feetDims.z-radOffset*2+spcng],true);
  
    //bottom radius
    translate([rad,-((bookDims.z+feetDims.z+spcng)/2-radOffset),0])
      rotate([0,0,180]) rotate_extrude(angle=90) 
        translate([rad,0]) square([minWallThck,clampWdth],true);
    //top radius
    translate([rad,((bookDims.z+feetDims.z+spcng)/2-radOffset),0])
      rotate([0,0,90]) rotate_extrude(angle=90) 
        translate([rad,0]) square([minWallThck,clampWdth],true);
  }
    //top screwplate
    translate([0,0,(bookDims.z+minWallThck+feetDims.z+spcng)/2]) plate(top=true);
  
    //bottom restplate
    translate([0,0,-(bookDims.z+minWallThck+feetDims.z+spcng)/2]) plate(top=false);
  
    //stopper
    if (stopper)
      //color("red") translate(stprPos) sphere(2);
      translate(stprPos){
        difference(){
          translate([0,clampWdth/4,feetDims.z/2]) cube([feetDims.x*2,clampWdth/2,feetDims.z],true);
           hull() for (iy=[-1,1])
            translate([0,iy*(feetDims.y-feetDims.x)/2,feetDims.z/2]) 
              cylinder(d=feetDims.x,h=feetDims.z+fudge,center=true);
         }
         for (ix=[-1,1])
           translate([ix*feetDims.x*0.75,0,feetDims.z/2]) 
            cylinder(d=feetDims.x/2,h=feetDims.z,center=true);
      }
  module plate(top=false){
    width= top ? topWdth : bottomWdth;
    
    difference(){
      union(){
        translate([(width)/2,0,0])
          cube([width-rad*2,clampWdth,minWallThck],true);
        hull() for(iy=[-1,1])
          translate([width-rad,iy*(clampWdth/2-rad),0]) cylinder(r=rad,h=minWallThck,center=true);
      }
      if (top) for(iy=[-1,1]){
        translate([topWdth/2,iy*clampWdth/4,0]){
          cylinder(d=screwDia+fudge,h=minWallThck+fudge,center=true);
        translate([0,0,-(minWallThck+fudge)/2]) 
          cylinder(d1=counterSinkDia,d2=0.05,h=counterSinkDia/2);
        }
      }
      else
        for(iy=[-1,1]) 
        translate([topWdth/2,iy*clampWdth/4,0]) 
          cylinder(d=screwDia*2+spcng,h=minWallThck+fudge,center=true);
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
  crnRad=2;
  chmfer=1;
  spcng=0.4;
  hubMinWallThck=2;
  capHght=5*hubMinWallThck;
  
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
  !endCap();
  module endCap(){
    endCapDims=[bdyDims.y+(hubMinWallThck+spcng)*2,capHght,bdyDims.z+(hubMinWallThck+spcng)*2];
    //translate([endCapDims.x/2,0,endCapDims.z/2]) rotate([90,0,180]) 
    difference(){
      union(){
        hull() for(ix=[-1,1],iy=[-1,1])
          translate([ix*(bdyDims.y/2-crnRad+spcng),iy*(bdyDims.z/2-crnRad+spcng),0]) 
            cylinder(r=crnRad+hubMinWallThck,h=capHght);
        translate([-30-endCapDims.x/2+minWallThck/2,-endCapDims.z/2,0]){
          cube([30+crnRad+minWallThck,minWallThck,capHght]);
          translate([0,minWallThck/2,0]) cylinder(d=minWallThck,h=capHght);
        }
      }
      translate([0,0,hubMinWallThck]) linear_extrude(capHght-hubMinWallThck+fudge) offset(spcng) hubShape();
      translate([0,0,-fudge/2]) linear_extrude(hubMinWallThck+fudge) offset(-hubMinWallThck/2) hubShape();
    }
  }
  
  module hubShape(){
    translate([(bdyDims.y-bdyDims.z)/2,0]) circle(d=bdyDims.z);
        translate([-bdyDims.z/4+crnRad/2,0]) square([bdyDims.y-bdyDims.z/2-crnRad,bdyDims.z],true);
        translate([-bdyDims.y/2+crnRad,bdyDims.z/2-crnRad]) circle(crnRad);
        polygon(poly);
  }
}