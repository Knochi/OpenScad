$fn=20;
fudge=0.1;

Skadis();

//set fillet to "0" for faster rendering
module Skadis(size=[360,560],fillet=1){
  //standard sizes: 760x560,560x560, 360x560
  slotDims=[5,15];
  slotDist=[20,40];
  slotyOffset=20; //offset for every 2nd row
  rad=8; //corner Radius
  thick=3; //thickness of the board
  coreThck=thick-fillet*2;
  sltCnt=[(size.x-slotDist.x)/slotDist.x,size.y/slotDist.y];
  
  difference(){
    hull() for (ix=[-1,1],iy=[-1,1]){
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]){
        translate([0,0,(thick/2-fillet)]) rotate_extrude() 
          translate([rad-fillet/2,0]) circle(fillet);
        cylinder(r=rad,h=coreThck,center=true);
        translate([0,0,-(thick/2-fillet)]) rotate_extrude() 
          translate([rad-fillet/2,0]) circle(fillet);
      }
    }
    for (ix=[-(sltCnt.x-1)/2:(sltCnt.x-1)/2],iy=[-(sltCnt.y-1)/2:(sltCnt.y-1)/2]){
      yOffset=(ix%2) ? slotyOffset : 0; //each second column is y-shifted
      if (!(yOffset && (iy==(sltCnt.y-1)/2))) //every second row one less
        translate([ix*slotDist.x,iy*slotDist.y+yOffset,0]) slot();
    }
  }
  
  *slot();
  module slot(){
    if (fillet) render(){//prerender the slot 
      for (iy=[-1,1]) translate([0,iy*(slotDims.y-slotDims.x)/2,0]) difference(){
        cylinder(d=slotDims.x+fillet*2,h=thick+fudge,center=true);
        for(iy=[-1,1])
          rotate_extrude() translate([slotDims.x-fillet*1.5,iy*(thick/2-fillet)]) 
            circle(fillet);
          rotate_extrude() translate([slotDims.x-fillet*2,0]) 
            square([fillet,coreThck],true);
        }
      difference(){
        cube([slotDims.x+fillet*2,slotDims.y-slotDims.x,thick+fudge],true);
        for (ix=[-1,1],iz=[-1,1])
          translate([ix*(slotDims.x-fillet*1.5),0,iz*coreThck/2]) rotate([90,0,0]) 
            cylinder(r=fillet,h=slotDims.y-slotDims.x*fudge,center=true);
        for (ix=[-1,1])
          translate([ix*(slotDims.x-fillet*2),0,0]) 
            cube([fillet,slotDims.y-slotDims.x+fudge,coreThck],true);
        }
      }
    else
    hull() for (iy=[-1,1])
      translate([0,iy*(slotDims.y-slotDims.x)/2,0]) 
        cylinder(d=slotDims.x,h=coreThck+fudge,center=true);
  }
}