$fn=20;

/* -- [Dimensions] -- */
extrusionWidth=0.4;
wallCount=8;
screwDia=3.5;
counterSinkDia=8; //how deep a virtual
bookDims=[117*2,326,17.8];
feetDims=[9,21.5,2.2];
feetDist=[190,236,212.5]; //x, y1, y2
feetxOffset=(25.5-17.5)/2;
spcng=1;
fudge=0.1;

/* --[hidden] -- */
minWallThck=extrusionWidth*wallCount;

HPEliteBook840G5();
//left back
translate([-(bookDims.x+minWallThck)/2-spcng/2,(feetDist[1])/2,(bookDims.z+spcng)/2-feetDims.z/2-spcng/2]) clamp(stopper=true,isLeft=true);
mirror([1,0,0]) translate([-(bookDims.x+minWallThck)/2-spcng/2,(feetDist[2])/2,(bookDims.z+spcng)/2-feetDims.z/2-spcng/2])  clamp(stopper=true,isLeft=false);
translate([-(bookDims.x+minWallThck)/2-spcng/2,-(feetDist[1])/2,(bookDims.z+spcng)/2-feetDims.z/2-spcng/2]) clamp(stopper=false,isLeft=true);
mirror([1,0,0]) translate([-(bookDims.x+minWallThck)/2-spcng/2,-(feetDist[2])/2,(bookDims.z+spcng)/2-feetDims.z/2-spcng/2])  clamp(stopper=false,isLeft=false);


!mirror([1,0,0]) clamp(true,false);
module clamp(stopper=false,isLeft=true){
  topWdth=20;
  footxOffset= isLeft ? feetxOffset : -feetxOffset;
  bottomWdth=(bookDims.x-feetDist.x+minWallThck+spcng+feetDims.x)/2+feetDims.x+footxOffset;
  clampWdth=50;
  rad=4; //edge radii (median line)
  radOffset=rad-minWallThck/2;
  stprPos=[bottomWdth-feetDims.x*1.5,0,-(bookDims.z+feetDims.z+spcng)/2];
  plateZOffset=(bookDims.z+minWallThck+feetDims.z+spcng)/2;
  
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
    translate([0,0,plateZOffset]) plate(top=true);
  
    //bottom restplate
    translate([0,0,-plateZOffset]) plate(top=false);
  
    //stopper
    if (stopper)
      //color("red") translate(stprPos) sphere(2);
      translate(stprPos){
        difference(){
          translate([0,clampWdth/4,feetDims.z/2]) cube([feetDims.x*2,clampWdth/2,feetDims.z],true);
          hull() for (iy=[-1,1])
            translate([0,iy*(feetDims.y-feetDims.x)/2,feetDims.z/2]) 
              cylinder(d=feetDims.x,h=feetDims.z+fudge,center=true);
              for(iy=[-1,1]) 
                translate([topWdth/2,iy*clampWdth/4,-plateZOffset+(minWallThck-fudge)/2]-stprPos) 
                  cylinder(d=screwDia*2+spcng,h=feetDims.z+fudge);
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
  
  color("silver") translate([-234/2,0,0]) rotate([90,0,0]) linear_extrude(326,center=true) import("EliteBook840G5_contour.svg");
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