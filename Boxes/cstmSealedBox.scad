/* [Dimensions] */
outerDims=[110,44,35];
minWallThck=1.2;
minFloorThck=2;
cornerRad=4;
spcng=0.2;

/* [Sealing] */
sealWdth=+2;
sealThck=2;
sealStyle="square";

/* [Locking] */
lockStyle="screws";
heatInserts=true;
screwDia=3;
screwLen=12;
screwHdDia=6;
screwHdLen=3;

/* [Cutouts] */


/* [Show] */
quality=48; //[12:4:100]
showLid=false;
showBox=true;

/* [Hidden] */
$fn=quality;
fudge=0.1;
boxWallThck=sealWdth+2*minWallThck;
insertDia=4.5;

//calculations for routing the seal inside the holes
//sealCrnrRad=min(insertDia/2,screwHdDia/2)+boxWallThck-minWallThck;
sealCrnrRad=insertDia/2+boxWallThck-minWallThck;
smallSealOffset=sealCrnrRad-sealWdth+screwHdDia/2+spcng;

screwDist=[outerDims.x-minWallThck*2-screwHdDia-spcng*2,
           outerDims.y-minWallThck*2-screwHdDia-spcng*2];

if (showLid)
  box(true);
if (showBox)
  box(false);
  
echo(screwDist);

module box(lid=false){
  lidHght=minFloorThck+screwHdLen+spcng;
  boxHght=lid ? lidHght : outerDims.z-lidHght;  
  domeDia= lid ? screwHdDia+minWallThck*2 : insertDia+boxWallThck*2;
  
  difference(){
    union(){
      //walls
      linear_extrude(boxHght,convexity=3) difference(){
        offset(cornerRad) square([outerDims.x-cornerRad*2,outerDims.y-cornerRad*2],true);
        offset(cornerRad-boxWallThck) square([outerDims.x-cornerRad*2,outerDims.y-cornerRad*2],true);
      }
      //floor
      linear_extrude(minFloorThck,convexity=3) offset(cornerRad) square([outerDims.x-cornerRad*2,outerDims.y-cornerRad*2],true);
      
      //screw&seal Domes
      linear_extrude(boxHght){
        intersection(){
          for (ix=[-1,1],iy=[-1,1])
              translate([ix*screwDist.x/2,iy*screwDist.y/2,0]){
                circle(d=domeDia);
                rotate(atan2(iy,ix)+135) 
                  for (pos=[[smallSealOffset,0],[0,smallSealOffset]])
                    translate(pos)
                      rotate(180) intersection(){
                        difference(){
                          circle(r=screwHdDia/2+spcng-sealWdth);
                          circle(r=screwHdDia/2+spcng-sealWdth-minWallThck);
                        }
                        square(screwHdDia/2+spcng-sealWdth);
                      }
              }
          offset(cornerRad) square([outerDims.x-cornerRad*2,outerDims.y-cornerRad*2],true);
        }
      }
    }  
    //screw/insert holes
    if (lid)
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*screwDist.x/2,iy*screwDist.y/2,-fudge]){
          cylinder(d=screwHdDia+spcng*2,h=screwHdLen+spcng+fudge);
          cylinder(d=screwDia+spcng*2,h=lidHght+spcng+fudge*2);
        }
    else{
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*screwDist.x/2,iy*screwDist.y/2,boxHght-screwLen]) cylinder(d=insertDia,h=screwLen+fudge);
      //seal cutout
      translate([0,0,boxHght-sealThck]) linear_extrude(sealThck+fudge,convexity=3) seal(true);
    }
  }
}

*seal();
module seal(cut=false, lid=false){

  if (cut)
    shape();
  else{
    linear_extrude(sealThck) shape();
  } 
  
  module shape(){
    
    
    difference(){
      offset(cornerRad-minWallThck) square([outerDims.x-cornerRad*2,outerDims.y-cornerRad*2],true);
      offset(cornerRad-minWallThck-sealWdth) square([outerDims.x-cornerRad*2,outerDims.y-cornerRad*2],true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*screwDist.x/2,iy*screwDist.y/2])
          square(smallSealOffset*2,true);
    }
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*screwDist.x/2,iy*screwDist.y/2]) rotate(atan2(iy,ix)+135) corner();
        
    module corner(){
      //big corner
      intersection(){
        difference(){
          circle(r=sealCrnrRad);
          circle(r=sealCrnrRad-sealWdth);
        }
        square(sealCrnrRad);
      }
      //small corners
      for (pos=[[smallSealOffset,0],[0,smallSealOffset]])
        translate(pos)
          rotate(180) intersection(){
            difference(){
              circle(r=screwHdDia/2+spcng);
              circle(r=screwHdDia/2+spcng-sealWdth);
            }
          square(screwHdDia/2+spcng);
        }
    }
  }
  
  module lidPress(){
    rotate_extrude() translate([screwHdDia/2+spcng-sealWdth/2,0]) circle(d=sealWdth,$fn=4);
  }
}
