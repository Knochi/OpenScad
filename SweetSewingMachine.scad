tileDims=[28,25,20]; //ferrero Küsschen
ovTileCnt=[10,9,2];
headTileCnt=[2,3];
baseTileCnt=[5,7];
matThck=3;
spcng=0;
fudge=0.1;

face();
module face(){
  ovDims=[ovTileCnt.x*tileDims.x,ovTileCnt.y*tileDims.y];
  //top
  topDims=[ovTileCnt.x*tileDims.x,(ovTileCnt.y-baseTileCnt.y)*tileDims.y];
  //base
  baseDims=[baseTileCnt.x*tileDims.x,baseTileCnt.y*tileDims.y];
  //head
  headDims=[headTileCnt.x*tileDims.x,headTileCnt.y*tileDims.y];
  headYOffset=(baseTileCnt.y-headTileCnt.y)*tileDims.y;
  linear_extrude(matThck) difference(){
    union(){
      translate([0,(baseTileCnt.y)*tileDims.y]) square(topDims); //top
      translate([(ovTileCnt.x-baseTileCnt.x)*tileDims.x,0]) square(baseDims); //base
      translate([0,headYOffset]) square(headDims); //head
    }
    //top & bottom edge
    for (ix=[0:2:(ovTileCnt.x-1)], iy=[-1,1])
      translate([ix*tileDims.x+tileDims.x/2,iy*(ovTileCnt.y*tileDims.y-matThck+fudge)/2+ovDims.y/2]) square([tileDims.x,matThck+fudge],true);
    //head bottom
    for (ix=[0:2:(headTileCnt.x-1)])
      translate([ix*tileDims.x+tileDims.x/2,headYOffset+(matThck-fudge)/2]) square([tileDims.x,matThck+fudge],true);
    
    
    //left & right edge
    for (ix=[-1,1],iy=[0:2:(ovTileCnt.y-1)])
      translate([ix*(topDims.x-matThck+fudge)/2+topDims.x/2,iy*tileDims.y+tileDims.y/2]) square([matThck+fudge,tileDims.y],true);
    //head right
    for (iy=[0:2:(headTileCnt.y-1)])
      translate([headDims.x-(matThck-fudge)/2,iy*tileDims.y+(tileDims.y-fudge)/2+headYOffset]) square([matThck+fudge,tileDims.y+fudge],true);
    //base left
    for (iy=[0:2:(baseTileCnt.y-1)])
      translate([ovDims.x-baseDims.x+(matThck-fudge)/2,iy*tileDims.y+(tileDims.y-fudge)/2]) square([matThck+fudge,tileDims.y+fudge],true);
    
  }
}

*tile();
module tile(size=[20,10,10]){
  chamfer=0.8*size.y;
  //sweet
  cube([tileDims.x,tileDims.y,tileDims.z-chamfer]);
  translate([tileDims.x/2,tileDims.y/2,tileDims.z-chamfer]) 
    linear_extrude(chamfer,scale=[0.8,0.6]) square([tileDims.x,tileDims.y],true);
  }