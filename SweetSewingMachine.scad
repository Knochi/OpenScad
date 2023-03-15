tileDims=[28,24.5,20]; //ferrero Küsschen
ovTileCnt=[10,3,9]; 
headTilesX=2;
headTilesZ=3;
bodyTilesX=5;
bodyTilesZ=7;
baseBrimTiles=[2,5];
baseRad=tileDims.y;
spcng=0;
matThck=3;

/*[show]*/
showFaces=false;
showTop=true;
showRight=true;
showLeft=true;
showbodyLeft=true;
showHeadRight=true;
showHeadBottom=true;
showBase=true;
isolate="none"; //["none","base","face"]


/* [Hidden] */
headTileCnt=[headTilesX,ovTileCnt.y,headTilesZ];
bodyTileCnt=[bodyTilesX,ovTileCnt.y,bodyTilesZ];
topTileCnt=[ovTileCnt.x,ovTileCnt.y,ovTileCnt.z-bodyTileCnt.z];
ovDims=[ovTileCnt.x*tileDims.x,ovTileCnt.y*tileDims.y,ovTileCnt.z*tileDims.y];
headDims=[headTileCnt.x*tileDims.x,ovTileCnt.y*tileDims.y,headTileCnt.z*tileDims.y];
bodyDims=[bodyTileCnt.x*tileDims.x,ovTileCnt.y*tileDims.y,bodyTileCnt.z*tileDims.y];
topDims=[ovTileCnt.x*tileDims.x,ovTileCnt.y*tileDims.y,topTileCnt.z*tileDims.y];
//base from tileDims and brims
baseDims=[(ovTileCnt.x+baseBrimTiles.x)*tileDims.x,(ovTileCnt.y+baseBrimTiles.y)*tileDims.y];
$fn=50;
fudge=0.1;

//## Assembly ##
if (showFaces) for (iy=[-1,1])
  color("wheat") translate([0,iy*(tileDims.y*ovTileCnt.y-matThck)/2+matThck/2,0]) rotate([90,0,0]) linear_extrude(matThck) face();
if (showTop)
  color("burlyWood") translate([0,-ovDims.y/2,ovDims.z-matThck]) linear_extrude(matThck) top();
if (showRight)
  color("tan") translate([ovDims.x,-ovDims.y/2,0]) rotate([0,-90,0]) linear_extrude(matThck) right();
if (showLeft)
  color("tan") translate([matThck,-ovDims.y/2,ovDims.z-headDims.z-topDims.z]) rotate([0,-90,0]) linear_extrude(matThck) left();
if (showbodyLeft)
  color("tan") translate([ovDims.x-bodyDims.x+matThck,-ovDims.y/2,0]) rotate([0,-90,0]) linear_extrude(matThck) bodyLeft();
if (showHeadRight)
  color("tan") translate([headDims.x,-ovDims.y/2,ovDims.z-topDims.z-headDims.z]) rotate([0,-90,0]) linear_extrude(matThck) headRight();
if (showHeadBottom)
  color("burlyWood") translate([0,-ovDims.y/2,ovDims.z-topDims.z-headDims.z]) linear_extrude(matThck) headBottom();
if (showBase)
  color("burlyWood")  linear_extrude(matThck) base();

//## Export ##
if (isolate=="base")
  !base();
if (isolate=="face")
  !face();

module left(){
  wall([headTileCnt.z+topTileCnt.z,ovTileCnt.y],[tileDims.y,tileDims.y],[1,0.5]);
}

module right(){
  wall([ovTileCnt.z,ovTileCnt.y],[tileDims.y,tileDims.y],[1,0.5]);
}

module top(){
  wall([ovTileCnt.x,ovTileCnt.y],tileDims,[1,1.5]);
}

module bodyLeft(){
  wall([bodyTileCnt.z,ovTileCnt.y],[tileDims.y,tileDims.y],[1,0.5]);
}

module headRight(){
  wall([headTileCnt.z,ovTileCnt.y],[tileDims.y,tileDims.y],[1,0.5]);
}

module headBottom(){
  difference(){
    wall([headTileCnt.x,ovTileCnt.y],tileDims,[-0.5,1.5]);
    translate([headDims.x/2,headDims.y/2]) circle(d=3.1);
  }
}

module base(){
  bodyOffset=tileDims.x/2+ovDims.x-bodyDims.x;
  difference(){
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(baseDims.x/2-baseRad),iy*(baseDims.y/2-baseRad)]+[baseDims.x/2-baseBrimTiles.x/2*tileDims.x,0]) circle(baseRad);
    //front and back slots
    for (ix=[0:2:(bodyTileCnt.x-1)], iy=[-1,1])
      translate([ix*tileDims.x+bodyOffset,iy*(tileDims.y*ovTileCnt.y-matThck)/2]) square([tileDims.x,matThck],true);
    //left and right slots
    for (ix=[-1,1],iy=[0:2:(bodyTileCnt.y-2)])
      translate([ix*(bodyDims.x-matThck)/2+ovDims.x-bodyDims.x/2,iy*(tileDims.y*ovTileCnt.y)/2]) square([matThck,tileDims.y],true);
    //hole for stabi
    translate([headDims.x/2,0]) circle(d=3.2);
  }
}

*wall([ovTileCnt.x,ovTileCnt.y]);
module wall(tiles=[5,5],tileDims=[10,10],start=[0,0]){
  wallDims=[tiles.x*tileDims.x,tiles.y*tileDims.y];
      difference(){
        square(wallDims);
        //front and back edge
        for (ix=[start.x:2:(tiles.x)], iy=[-1,1])
          translate([ix*tileDims.x+tileDims.x/2,iy*(wallDims.y-matThck+fudge)/2+wallDims.y/2]) square([tileDims.x,matThck+fudge],true);
        //left and right edge
        for (ix=[-1,1], iy=[start.y:2:(tiles.y)])
          translate([ix*(wallDims.x-matThck+fudge)/2+wallDims.x/2,iy*tileDims.y]) square([matThck+fudge,tileDims.y],true);
    }
}

module face(){
  //top
  topDims=[ovTileCnt.x*tileDims.x,(ovTileCnt.z-bodyTileCnt.z)*tileDims.y];

  headYOffset=(bodyTileCnt.z-headTileCnt.z)*tileDims.y;
  difference(){
    union(){
      translate([0,(bodyTileCnt.z)*tileDims.y]) square(topDims); //top
      translate([(ovTileCnt.x-bodyTileCnt.x)*tileDims.x,0]) square([bodyDims.x,bodyDims.z]); //body
      translate([0,headYOffset]) square([headDims.x,headDims.z+fudge]); //head
    }
    //top & bottom edge
    for (ix=[0:2:(ovTileCnt.x-1)], iy=[-1,1])
      translate([ix*tileDims.x+tileDims.x/2,iy*(ovTileCnt.z*tileDims.y-matThck+fudge)/2+ovDims.z/2]) square([tileDims.x,matThck+fudge],true);
    //head bottom
    for (ix=[0.5:2:(headTileCnt.x-1)])
      translate([ix*tileDims.x+tileDims.x/2,headYOffset+(matThck-fudge)/2]) square([tileDims.x,matThck+fudge],true);
    
    
    //left & right edge
    for (ix=[-1,1],iy=[0:2:(ovTileCnt.z-1)])
      translate([ix*(topDims.x-matThck+fudge)/2+topDims.x/2,iy*tileDims.y+tileDims.y/2]) square([matThck+fudge,tileDims.y],true);
    //head right
    for (iy=[0:2:(headTileCnt.z-1)])
      translate([headDims.x-(matThck-fudge)/2,iy*tileDims.y+(tileDims.y-fudge)/2+headYOffset]) square([matThck+fudge,tileDims.y+fudge],true);
    //body left
    for (iy=[0:2:(bodyTileCnt.z-1)])
      translate([ovDims.x-bodyDims.x+(matThck-fudge)/2,iy*tileDims.y+(tileDims.y-fudge)/2]) square([matThck+fudge,tileDims.y+fudge],true);
    
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