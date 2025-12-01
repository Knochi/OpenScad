$fn=20;
fudge=0.1;

include <eCAD/KiCADColors.scad>

showTops=true;
showBottoms=true;

LK_DR01();



colors=["red","blue","green","yellow","orange","purple"];
module LK_DR01(){
  //https://de.aliexpress.com/item/1005003780874145.html
  ovDims=[87.5,36.5,45.5];
  crnrRad=1;
  cutOutDims=[0,26,11.2];
  labelRecess=[43,32.5,1.5];
  lvrDims=[32.5,14,3.6];
  lvrXOffset=-4.2;
  
  botCutout=[36,ovDims.y,4.5];
  botCutoutOffset=[-0.5,0,0];
  botInHght=7.8;
  
  mntSpacing=[51,22];
  mntHght=6.2;
  wallThck=2;
  
  //define topCorners of staircase type housing
  topCorners=[[87.5,36.5,0],[86.75,36.35,17.1],[61.35,36.35,17.1],[60.9,36.1,36.25],[47.5,36.1,36.25],[47.15,35.8,45.5]];
  bottomCorners=[[87.5,36.5,0],[87.1,36.1,-13]];
  
  partOffset=[0,0,botInHght-mntHght];
  
  translate(partOffset){
    if (showTops)
      color(blackBodyCol) difference(){
        body();
        body(true); //hollow
        translate([0,0,(cutOutDims.z-fudge)/2]) cube([ovDims.x+fudge,cutOutDims.y,cutOutDims.z+fudge],true);
        translate([0,0,ovDims.z-(labelRecess.z-fudge)/2]) cube(labelRecess + [0,0,fudge],true);
      }
    
    if (showBottoms) 
      {
        color(blackBodyCol) difference(){
          bottom();
          translate([0,0,fudge]) bottom(true);
          translate([0,0,bottomCorners[1].z+(botCutout.z-fudge)/2]+botCutoutOffset) cube(botCutout+[0,fudge,fudge],true);
          translate([-(ovDims.x-lvrDims.x)/2,0,bottomCorners[1].z-fudge/2]) 
            linear_extrude(lvrDims.z+fudge) square([lvrDims.x,lvrDims.y+fudge],true);
        }
        
        //mounting posts
        color(blackBodyCol) for (i=[0,1])
          mirror([0,i,0]) mirror([i,0,0]) translate([mntSpacing.x/2,mntSpacing.y/2,-botInHght]) 
            difference(){
              cylinder(d1=5.2,d2=5,h=mntHght);
              translate([0,0,-fudge/2]) cylinder(d=2.5,h=mntHght+fudge);
            }
        //lever
        color(redBodyCol) 
          translate([-(ovDims.x-lvrDims.x)/2+lvrXOffset,0,bottomCorners[1].z]) linear_extrude(lvrDims.z) square([lvrDims.x,lvrDims.y],true);
      }
    }
  
  module body(cut=false){
    crnrOffset= cut ? wallThck : crnrRad;
    rad = cut ? 0.01 : crnrRad;
    difference(){
      union(){
        for (i=[0:2:4])
          hull()
            for (ix=[-1,1],iy=[-1,1]){
              zOffset = i==0 ? 0 : -crnrOffset;
              color(colors[i]) translate([ix*(topCorners[i].x/2-crnrOffset),iy*(topCorners[i].y/2-crnrOffset),topCorners[i].z+zOffset]) sphere(rad);
              color(colors[i]) translate([ix*(topCorners[i+1].x/2-crnrOffset),iy*(topCorners[i+1].y/2-crnrOffset),topCorners[i+1].z-crnrOffset]) sphere(rad);
            }
          }
          
      if (!cut) translate([0,0,-rad]) cube([topCorners[0].x,topCorners[0].y,rad*2],true);
    }
  }
  
  module bottom(cut=false){
    sFact=[bottomCorners[0].x/bottomCorners[1].x,bottomCorners[0].y/bottomCorners[1].y];
    crnrOffset= cut ? wallThck : crnrRad;
    rad = cut ? 0 : crnrRad;
    height= cut ? -botInHght: bottomCorners[1].z;
    
    translate([0,0,height]) linear_extrude(-height, scale=sFact,convexity=3)
      difference(){
        offset(rad) square([bottomCorners[1].x-crnrOffset*2,bottomCorners[1].y-crnrOffset*2],true);
        if (cut) 
          for (iy=[-1,1]) translate([0,iy*(bottomCorners[1].y/2-wallThck*1.5)]) square([12,wallThck],true);
        else 
          for (iy=[-1,1]) translate([0,iy*(bottomCorners[1].y/2-wallThck/2)]) square([8.1,wallThck],true);
      }

  }
  
  
}

module rndCube(size=[10,10,10],crnrRad=1,center=false){
  cntrOffset = center ? [0,0,0] : [size.x/2,size.y/2,size.z/2];
  translate(cntrOffset)
    hull() for (ix=[-1,1],iy=[-1,1],iz=[-1,1])
      translate([ix*(size.x/2-crnrRad),iy*(size.y/2-crnrRad),iz*(size.z/2-crnrRad)]) 
        sphere(crnrRad);
}