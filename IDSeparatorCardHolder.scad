$fn=52;

showCards=true;

ovDims=[112.25,18,83];
lowerWidth=100;
lowerHeight=76; //from Top
flankAngle=atan((ovDims.x-lowerWidth)/lowerHeight);
topRad=5;
botWidth=88; //excl. radii
botRad=3;
slotDims=[3.5,8.3];
slotHght=ovDims.z-(ovDims.y-slotDims.y)/2;
cardDist=[30,8];
cardSlotDims=[55,1.3,60];
fudge=0.1;

echo(flankAngle);
if (showCards)
  for (ix=[-1,1],iy=[-1,1]){
    stagger = (ix>0) ? cardDist.y/4 : -cardDist.y/4;
    translate([ix*cardDist.x/2,iy*cardDist.y/2+stagger,60]) rotate([90,90,0]) card(true);
  }
  
%difference(){
  body();
  for (xm=[0,1])
   mirror([xm,0,0]) slot();
}

module slot(){
  
  translate([ovDims.x/2-slotDims.x,0,slotHght])
  rotate([0,flankAngle/2,0])
    translate([slotDims.x/2,0,-slotHght]) linear_extrude(slotHght) square(slotDims,true);
}

module body(){

  difference(){
   mainBody();
   translate([0,0,ovDims.z-topRad]) linear_extrude(topRad+fudge) square([ovDims.x,ovDims.y+fudge],true);
  }

  //top rounding
  intersection(){
    hull(){
      translate([0,ovDims.y/2-topRad,ovDims.z-topRad]) rotate([0,90,0]) cylinder(r=topRad,h=ovDims.x,center=true);
      translate([0,-ovDims.y/2+topRad,ovDims.z-topRad]) rotate([0,90,0]) cylinder(r=topRad,h=ovDims.x,center=true);
    }
    mainBody();
  }
  
  //bottom part
  hull(){
    translate([0,0,ovDims.z-lowerHeight]) linear_extrude(0.1) mirror([0,0,1]) square([lowerWidth,ovDims.y],true);
    for (ix=[-1,1])
      translate([ix*botWidth/2,0,botRad]) rotate([90,0,0]) cylinder(r=botRad,h=ovDims.y,center=true);
  }
    
  module mainBody(){
    sFac=ovDims.x/lowerWidth;
    translate([0,0,ovDims.z-lowerHeight]) linear_extrude(lowerHeight,scale=[sFac,1]) square([lowerWidth,ovDims.y],true);
  }
}

*card();
module card(center=false){
  ovDims=[85.6,53.98,0.76];
  crnrRad=3.175;
  cntrOffset= center ? [0,0,0] : ovDims/2;
  translate(cntrOffset) 
    linear_extrude(ovDims.z,center=true)  
      hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(ovDims.x/2-crnrRad),iy*(ovDims.y/2-crnrRad)]) circle(crnrRad);
}