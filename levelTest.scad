areaSize=[150,150];
patchSize=[20,20];
conWidth=2;
patchCrnrs=true;
patchCntr=true;
patchScrw=true;
patchCon=false;

screwPos=[[23,63],[114,63],[95,136]];


if (patchCrnrs) 
  for (ix=[-1,1],iy=[-1,1])
    translate([ix*(areaSize.x-patchSize.x)/2,iy*(areaSize.y-patchSize.y)/2]) square(patchSize,true);
if (patchCntr)
  square(patchSize,true);
if (patchScrw)
  for (pos=screwPos)
    translate(pos-areaSize/2) square(patchSize,true);
