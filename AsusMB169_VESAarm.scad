$fn=20;

/* [Dimensions] */
extrusionWidth=0.4;
walls=4;
maxThickness=14;

/* [Hidden] */
minWallThck=extrusionWidth*walls;
fudge=0.1;

VESAAdapter();
translate([0,0,2]) asusVA24D();
translate([270,0,61.3]) rotate([0,-10,0]) translate([190,0,-10]) USBMon();

module VESAAdapter(){
  plateDims=[120,120,2];
  drillDia=6;
  rad=6;
  cutOutRad=50;
  cutOutDist=cutOutRad*2+80; //distance between cutout circles
  
  linear_extrude(plateDims.z) difference(){
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(plateDims.x/2-rad),iy*(plateDims.y/2-rad)]) circle(d=drillDia);
    for (ix=[-1,1],iy=[-1,1]){
      translate([ix*100/2,iy*100/2]) circle(d=6);
      translate([ix*75/2,iy*75/2]) circle(d=6);
    }
    for (ir=[0:90:270])
      rotate(ir) translate([cutOutDist/2,0]) circle(cutOutRad,$fn=50);
  }  
}

module USBMon(){
  backDim=[196+178,230];
  midDim=[192+187,235.5,8];
  frontDim=midDim-[1,1,6.5];
  backRad=2;
  midRad=(midDim.x-backDim.x)/2;
  sclMid=[midDim.x/backDim.x,midDim.y/backDim.y];
  sclFrnt=[frontDim.x/midDim.x,frontDim.y/midDim.y];
  
  linear_extrude(height=midDim.z,scale=sclMid) hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(backDim.x/2-backRad),iy*(backDim.y/2-backRad)]) circle(backRad);
  translate([0,0,midDim.z]) linear_extrude(height=frontDim.z,scale=sclFrnt) 
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(midDim.x/2-backRad),iy*(midDim.y/2-backRad)]) circle(backRad);
}

module asusVA24D(){
  //dummy of asus monitor
  ovDims=[539.7,323.55,59.30];
  bezelThck=14.39;
  AADims=[527.04,296.46]; //active area
  AAcntrPos=[0,18.83/2];

  difference(){
    color("darkSlateGrey") translate([0,-AAcntrPos.y,0]) union(){
      translate([0,0,-bezelThck/2+ovDims.z]) cube([ovDims.x,ovDims.y,bezelThck],true);
      translate([0,0,(ovDims.z-bezelThck)/2]) cube([ovDims.x*0.7,ovDims.y*0.5,ovDims.z-bezelThck],true);
    }
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*100/2,iy*100/2,-fudge/2]) cylinder(d=4,h=20);
      color("grey") translate([0,0,ovDims.z]) cube([AADims.x,AADims.y,fudge],true);
    }
  
}
