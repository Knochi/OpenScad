// rectraction test

pCnt=[1,1]; //pillar count
pDist=[20,20];
pDims=[10,10,15];
doBase=true;
baseThck=2;
baseOffset=2;

/* [Hidden] */
$fn=50;
baseDims=[(pCnt.x-1)*pDist.x+pDims.x,(pCnt.y-1)*pDist.y+pDims.y];

zOffset= doBase ? baseThck : 0;

for (ix=[-(pCnt.x-1)/2,(pCnt.x-1)/2],iy=[-(pCnt.y-1)/2,(pCnt.y-1)/2])
  translate([ix*pDist.x,iy*pDist.y,pDims.z/2+zOffset]) cube(pDims,true);

linear_extrude(baseThck) offset(baseOffset) square([baseDims.x,baseDims.y],true);