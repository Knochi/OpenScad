$fn=50;

/* [PCBs Setup] */
//including frame
pcbDims=[51.4,39.8,1.6];
pcbCount=[2,3];
pcbSpcng=[5,5];
matThck=3;

/* [Rapid Registration] */
//https://community.aisler.net/t/rapid-registration/42
//use rapid reg.
rapidReg=true;
rapidHoleDia=3.8;

ovDims=[pcbDims.x*pcbCount.x+pcbSpcng.x*(pcbCount.x+1),
        pcbDims.y*pcbCount.y+pcbSpcng.y*(pcbCount.y+1)];
rad= min(pcbSpcng)/2;

linear_extrude(3) 
!difference(){
  hull() for (ix=[-1,1], iy=[-1,1])
    translate([ix*(ovDims.x/2-rad),iy*(ovDims.y/2-rad)]) circle(rad);
  for (ix=[-(pcbCount.x-1)/2:(pcbCount.x-1)/2],iy=[-(pcbCount.y-1)/2:(pcbCount.y-1)/2])
    translate([ix*(pcbDims.x+pcbSpcng.x),
               iy*(pcbDims.y+pcbSpcng.y),matThck]) rapidReg();
}

color("darkgreen",0.5) for (ix=[-(pcbCount.x-1)/2:(pcbCount.x-1)/2],iy=[-(pcbCount.y-1)/2:(pcbCount.y-1)/2])
    translate([ix*(pcbDims.x+pcbSpcng.x),
               iy*(pcbDims.y+pcbSpcng.y),matThck]) square([pcbDims.x,pcbDims.y],true);


*rapidReg();
module rapidReg(){
  width=pcbDims.x;
  drillDist= width<=70 ? 30 : 
            width>210 ? 190 : 30 + ceil((width-70)/20) * 20;
  drillDia=rapidHoleDia;
  yOffset=1+drillDia/2;
  cntrOffset=[0,-pcbDims.y/2+yOffset];
  
  for (ix=[-1,1])
    translate([ix*drillDist/2,cntrOffset.y]) circle(d=drillDia);
}
  