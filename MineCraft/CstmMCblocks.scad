/* MineCraft Blocks */


/* [Dimensions] */
wallThck=0.4;
blockSize=20;
layerThck=0.16;
decorLayers=4;
magnetDia=5;
magSpcng=0.1;
//pixels per face (squared)
pxCount=4; 

/* [show] */
showCore=true;

/* [Hidden] */
coreSize=blockSize-2*layerThck*decorLayers;
coreDims=[coreSize,coreSize,coreSize];
diffDist=(coreSize-magnetDia)/2-magSpcng;
pxSize=coreSize/pxCount;
fudge=0.1;

//displacement values
defaultMap=[
  [30,11,16,13],
  [20,21,22,23],
  [25,31,32,33],
  [40,41,32,29] 
  ];

//cube on the tip
*translate([0,0,cubeORad(blockSize)]) 
  rotate([45,35,60]) 
    core();

if (showCore)
  core();

module core(){
  difference(){
    cube(coreSize,true);
    for (dir=[[1,0,0],[0,1,0],[0,0,1],[-1,0,0],[0,-1,0],[0,0,-1]])
      translate([dir.x*diffDist,dir.y*diffDist,dir.z*diffDist]) cube(magnetDia+magSpcng*2,true);
  }
}


scale([1,1,1]) decor();

module decor(map=defaultMap){
  echo(str("LenMap: ",len(map)));
  for (iy=[0:len(map)-1])
    for (ix=[0:len(map[iy])-1]){
      echo(ix,iy);
      translate([ix*pxSize,iy*pxSize]) linear_extrude(map[iy][ix]) square(pxSize);
    }
}

function cubeORad(size=10)=size/2*sqrt(3);