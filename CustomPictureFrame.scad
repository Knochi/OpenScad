/* [Dimensions] */
//width of picture in mm
pictureWidth=152;
//height of picture in mm
pictureHeight=102;
//thickness of picture in mm
pictureThick=0.2;
//minimum wall Thickness for printing
minWallThck=2;
//minimum thickness in Z
minFloorThck=1.2;
//this will cover the picture
brimWidth=2;
cornerRadius=3;

/* [Clip] */

clipCount=[3,2];
clipWdth=10;

/* [Spacings] */
pictureXYSpcng=0.5;
pictureZSpcng=0.1;
clipSpcng=0.3;

/* [show] */
showFront=true;
showClip=true;

/* [Hidden] */
fudge=0.1;
clipDia=minFloorThck;

$fn=62;
ovDims=[pictureWidth+pictureXYSpcng*2+max(minWallThck*2,cornerRadius*2),
        pictureHeight+pictureXYSpcng*2+max(minWallThck*2,cornerRadius*2),
        pictureThick+pictureZSpcng+minFloorThck*2];
        
clipDist=[(pictureWidth-clipWdth*2)/(clipCount.x-1),(pictureHeight-clipWdth*2)/(clipCount.y-1)];

if (showFront)
  frontFrame();
if (showClip)
  clipFrame();

module frontFrame(){
  difference(){
    linear_extrude(ovDims.z,convexity=3)
      difference(){
        offset(cornerRadius) 
          square(ovDims + [-cornerRadius*2,-cornerRadius*2],true);
        //cutout picture - brim
        square([pictureWidth-brimWidth*2,pictureHeight-brimWidth*2],true);
      }
    //opening for clipFrame
    translate([0,0,-fudge]) linear_extrude(fudge+ovDims.z-minFloorThck,convexity=3) 
      square([pictureWidth+pictureXYSpcng*2,pictureHeight+pictureXYSpcng*2],true);
      
    //clips
    for (ix=[-(clipCount.x-1)/2:(clipCount.x-1)/2],iy=[-1,1])
      translate([ix*clipDist.x,iy*(pictureHeight/2+pictureXYSpcng),(minFloorThck)/2]) 
        rotate([0,90,0]) pill(clipWdth,clipDia);
    for (iy=[-(clipCount.y-1)/2:(clipCount.y-1)/2],ix=[-1,1])
      translate([ix*(pictureWidth/2+pictureXYSpcng),iy*clipDist.y,(minFloorThck)/2]) 
        rotate([90,0,0]) pill(clipWdth,clipDia);
  }
}

*clipFrame();
module clipFrame(){
  clpFrmDims=[pictureWidth+pictureXYSpcng*2-clipSpcng*2,pictureHeight+pictureXYSpcng*2-clipSpcng*2];
  clpFrmHght=minFloorThck;//ovDims.z-minFloorThck-pictureThick-pictureZSpcng;
  
  linear_extrude(clpFrmHght) 
    square(clpFrmDims,true);
  
  for (ix=[-(clipCount.x-1)/2:(clipCount.x-1)/2],iy=[-1,1])
    translate([ix*clipDist.x,iy*(clpFrmDims.y/2),(minFloorThck)/2]) 
      rotate([0,90,0]) pill(clipWdth,clipDia);
  for (iy=[-(clipCount.y-1)/2:(clipCount.y-1)/2],ix=[-1,1])
    translate([ix*(clpFrmDims.x/2),iy*clipDist.y,(minFloorThck)/2]) 
      rotate([90,0,0]) pill(clipWdth,clipDia);
}

*pill();
module pill(height=5, dia=3){
  cylinder(d=dia,h=height-dia,center=true);
  for (iz=[-1,1])
    translate([0,0,iz*(height-dia)/2]) sphere(d=dia);
}