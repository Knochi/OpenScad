/* [FR22 Device Dimensions] */
ovDims=[203.2,78.49,17.55];
flangeWidth=11;
flangeRad=2;
mntHoleDist=[191.2,64];
mntHoleDia=3.6;
sheetThck=1.5;
sheetRad=4;

/* [Connectors] */
//distances from center
antBackCntrDist=[49,61,74];
antFrontCntrDist=[-65,-50,50,65];
ethConCntrDist=-73.5;
ethConDims=[12.3,10,6.8];
brdyPortDims=[65,7,6];
brdyPortZPos=9.7;

/* [Protector] */
protWdth=30;
sheetVariant="3dp"; // ["sheetMetal" : "Sheet Metal" ,"3dp" : "3D Printed"]

//Spacing for separate parts
partSpcng=0.1;

//space for antenna connectors
antConDia=12;
antConLen=15;
antWireDia=5;
ehtWireDia=5;

//from bottom
antConBackZPos=6.8;
antConFrontZPos=10.6;
ethConZPos=9.8;
ethConSpcng=2;

/* [show] */
showDevice=true;
showBackProt=true;
showFrontProt=true;
showProtSheet=true;
showProtUpper=true;
showProtLower=true;

$fn=48; //[16:4:100]

/* [Hidden] */
bdyDims=ovDims+[-flangeWidth*2,0,0];
fudge=0.1;


if (showFrontProt)
  protector("front");
  
if (showBackProt)
  protector("back");
  
if (showDevice) 
  FR22Dummy();


module protector(side="front"){
  innerHeight=bdyDims.z-sheetThck;
  leftAntDist=antFrontCntrDist[0]-antFrontCntrDist[1];
  rightAntDist=antFrontCntrDist[2]-antFrontCntrDist[3];
  leftAntsCntr=antFrontCntrDist[0]-leftAntDist;
  rightAntsCntr=antFrontCntrDist[3]-leftAntDist;
  
  //yOffset = (side=="front") ? (bdyDims.y+protWdth)/2 : -(bdyDims.y+protWdth)/2;
  blockHght= (sheetVariant == "3dp") ? bdyDims.z-sheetRad-sheetThck/2 : bdyDims.z-sheetRad*2-sheetThck; 
  blockDims=[sheetThck*3,protWdth/4,blockHght];
  blockZOffset = (sheetVariant == "3dp") ? blockDims.z/2 : blockDims.z/2+sheetRad+sheetThck/2;
  
  sideDir = (side=="front") ? 1 : -1;
  
  protUpperCol = (sheetVariant == "3dp") ? "darkGrey" : "ivory";
  //sheet
  if (showProtSheet) color("darkGrey") translate([0,sideDir*(bdyDims.y+protWdth)/2,0]) difference(){
      sheet(protWdth,[mntHoleDist.x,protWdth*0.6]);
      translate([0,-sideDir*(protWdth-blockDims.y)/2,0])  lockingBlocks(true);
    }
  
  //body
  difference(){
    translate([0,sideDir*(bdyDims.y+protWdth)/2,0]) union(){
    //Lower body part
    if (showProtLower)
      color("Linen"){
        rotate([90,0,0]) linear_extrude(protWdth,center=true, convexity=3)  difference(){
          bodyShape();
          if (side=="front") 
            translate([0,(innerHeight+antConFrontZPos)/2]) square([bdyDims.x,innerHeight-antConFrontZPos],true);
          else if (side=="back")
            translate([0,(innerHeight+ethConZPos)/2]) square([bdyDims.x,innerHeight-ethConZPos],true);
        } 
        //add locking blocks
        translate([0,-sideDir*(protWdth-blockDims.y)/2,0]) lockingBlocks();
        
      }
    //Upper body part
    if (showProtUpper)
      color(protUpperCol) 
        difference(){
          rotate([90,0,0]) linear_extrude(protWdth,center=true, convexity=3)  difference(){
            bodyShape();
            if (side=="front") 
              translate([0,antConFrontZPos/2]) square([ovDims.x,antConFrontZPos],true);
            else if (side=="back")
              translate([0,ethConZPos/2]) square([ovDims.x,ethConZPos],true);
          }
          //cutout locking blocks
          translate([0,-sideDir*(protWdth-blockDims.y)/2,0]) lockingBlocks(true);
        }
    }
    FR22Dummy(true);
  }
  
  module lockingBlocks(cut=false){
    spcng= cut ? partSpcng : 0;
    
    for (ix=[-1,1]) 
      translate([ix*(bdyDims.x-blockDims.x)/2,0,blockZOffset]) 
        rotate([-90,0,0]) linear_extrude(blockDims.y+spcng*2,center=true) offset(spcng) square([blockDims.x,blockDims.z],true);// cube(blockDims,true);
  }

}

*FR22Dummy(true);
module FR22Dummy(cut=false){
  
  if (cut) {
    //front
    translate([0,(bdyDims.y+protWdth)/2,0]){
      for (ix=[0:2:3])
          hull(){
            translate([antFrontCntrDist[ix],-protWdth/2-fudge,antConFrontZPos]) rotate([-90,0,0]) cylinder(d=antConDia, h=antConLen+fudge);
            translate([antFrontCntrDist[ix+1],-protWdth/2-fudge,antConFrontZPos]) rotate([-90,0,0]) cylinder(d=antConDia, h=antConLen+fudge);
            }
        //Brady extension Port
        hull() translate([0,-protWdth/2-fudge,brdyPortZPos]) rotate([-90,0,0]) linear_extrude(brdyPortDims.y)
          for (ix=[-1,1]) translate([ix*(brdyPortDims.x-brdyPortDims.z)/2,0]) circle(d=brdyPortDims.z);
        //cables    
        for (xPos=antFrontCntrDist)
          translate([xPos,0,antConFrontZPos]) rotate([90,0,0]) cylinder(d=antWireDia+fudge,h=protWdth+fudge,center=true);
      }
     //back
    translate([0,-(bdyDims.y+protWdth)/2,0]){
      hull(){
          translate([antBackCntrDist[0],protWdth/2+fudge,antConBackZPos]) rotate([90,0,0]) cylinder(d=antConDia, h=antConLen+fudge);
          translate([antBackCntrDist[2],protWdth/2+fudge,antConBackZPos]) rotate([90,0,0]) cylinder(d=antConDia, h=antConLen+fudge);
      }
      translate([ethConCntrDist,protWdth/2+fudge,ethConZPos]) rotate([90,0,0]) linear_extrude(ethConDims.z+ethConSpcng) offset(ethConSpcng) square([ethConDims.x,ethConDims.y],true);
      translate([ethConCntrDist,0,ethConZPos]) rotate([90,0,0]) cylinder(d=antWireDia+fudge,h=protWdth+fudge,center=true);
      }
    }
    
  else {
    color("darkSlateGrey")  difference(){
      rotate([90,0,0]) linear_extrude(bdyDims.y,center=true,convexity=3) bodyShape();
      translate([ethConCntrDist,-bdyDims.y/2,ethConZPos]) cube(ethConDims,true);
    }
    color("silver") sheet();
    
    //antenna connectors
    //back
    color("gold") for (pos=antBackCntrDist)
      translate([pos,-bdyDims.y/2,antConBackZPos]) rotate([90,0,0]) cylinder(d=7.5,h=6);
    //front
    color("gold") for (pos=antFrontCntrDist)
      translate([pos,bdyDims.y/2,antConFrontZPos]) rotate([-90,0,0]) cylinder(d=7.5,h=6);
   }
}


module bodyShape(){//body

  translate([0,bdyDims.z/2-sheetRad])
    difference(){
      offset(sheetRad-sheetThck) 
        square([bdyDims.x-sheetRad*2,bdyDims.z],true);
      translate([0,-bdyDims.z/2]) square([bdyDims.x,sheetRad*2],true);
    }
  for (m=[0,1])
    mirror([m,0,0]) translate([bdyDims.x/2-sheetThck,0]) difference(){ 
      square(sheetRad);
      translate([sheetRad,sheetRad]) circle(r=sheetRad);
    }
}
  
module sheet(depth=bdyDims.y, holeDist=mntHoleDist){
  //flanges
  linear_extrude(sheetThck) 
    difference(){
      offset(flangeRad) 
        square([ovDims.x-flangeRad*2,depth-flangeRad*2],true);
      square([bdyDims.x+(sheetRad-sheetThck)*2,depth],true);
      //mount holes
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*holeDist.x/2,iy*holeDist.y/2]) circle(d=mntHoleDia);
      }
  for (m=[0:1]) mirror([m,0,0]){
    translate([-bdyDims.x/2-sheetRad+sheetThck,0,sheetRad])
      rotate([90,90,0]) sheetBend(depth);   
    translate([-bdyDims.x/2+sheetRad,0,bdyDims.z-sheetRad])
      rotate([90,-90,0]) sheetBend(depth);   
    translate([-(bdyDims.x-sheetThck)/2,0,bdyDims.z/2]) 
      cube([sheetThck,depth, bdyDims.z-sheetRad*2],true);
  }
  translate([0,0,bdyDims.z-sheetThck]) linear_extrude(sheetThck) 
    square([bdyDims.x-(sheetRad)*2,depth],true);
}

module sheetBend(depth){
  rotate_extrude(angle=90) 
    translate([sheetRad-sheetThck/2,0]) 
      square([sheetThck,depth],true);
}