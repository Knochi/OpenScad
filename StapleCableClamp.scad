// cable clamp for stabler

/* [show] */
$fn=20;
showStaple=true;
showCable=true;
showClamp=true;
showClampHolder=true;
showStaplerDummy=false;

/* [Cable] */
wireDia=1;
wireCount=4;
wireSpcng=0.2;

/* [Staples] */
stplType="53"; //["53","custom"]
stplCstmShldrWdth=11.4;
stplCstmWrWdth=0.7;
stplCstmWrThck=0.6;
stplLngth=14;

/* [Clamp Holder] */
//max. width of the stapler at the front
stplrWdth=25;
//offset from front to center of staple
stplrFrntOffset=4.24;
//wall thickness
minWallThck=2;
//spacing between holder and clamp
hldrSpcng=0.1;
//spacing between holder and stapler
stplrSpcng=0.1;
//height of the holder
hldrHght=10;

/* [Clamp] */
clmpStyle="block"; //["block","rndBlck"]
//overall Clamp Dimensions
clampDims=[20,5,3];
//spacing for the staple
stplSpcng=0.5;
cblSpcng=0.1;


/* [Hidden] */
fudge=0.1;
// -- staples --
//https://en.wikipedia.org/wiki/Staple_(fastener)
//https://de.wikipedia.org/wiki/Heftklammer

//[shoulder width , wire width , length/height, wire thick
stplDims= (stplType=="53") ? [11.4,0.7,stplLngth,0.6] : [stplCstmShldrWdth,stplCstmThck,stplLngth,cstmWrThck];

cblColors=["brown","red","orange","yellow","green","blue","purple","grey","white","black"];

//assembly
if (showClampHolder)
 color("grey") clampHolder();

if (showClamp)
  color("darkRed") clamp();
if (showStaple) 
  translate([0,0,clampDims.z-stplDims[3]]) staple();
if (showCable)
  cable();

module staple(){
  color("silver") rotate([90,0,0])  linear_extrude(stplDims.y,center=true){
    translate([0,stplDims[3]/2]) square([stplDims.x-stplDims[3],stplDims[3]],true);
    for (ix=[-1,1]){
      translate([ix*(stplDims.x-stplDims[3])/2,-stplDims.z/2+stplDims[3]*0.75]) 
        square([stplDims[3],stplDims.z-stplDims[3]/2],true);
      translate([ix*(stplDims.x-stplDims[3])/2,+stplDims[3]/2]) circle(d=stplDims[3],$fn=20);
    }
  }
}

module clamp(cut=false){
  
  if (cut)
    bodyShp();
  else
    difference(){
      linear_extrude(clampDims.z) bodyShp();
      translate([0,0,clampDims.z-stplDims[3]/2-stplSpcng+fudge/2]) 
        cube([stplDims.x+stplSpcng*2,stplDims.y+stplSpcng*2,stplDims[3]+stplSpcng*2+fudge],true);
      for (ix=[-1,1])
        translate([ix*(stplDims.x-stplDims[3])/2,0,(clampDims.z-fudge)/2]) 
          cube([stplDims[3]+stplSpcng*2,stplDims[3]+stplSpcng*2,clampDims.z+fudge],true);
      rotate([90,0,0]) linear_extrude(clampDims.y+fudge,center=true,convexity=3)
        cable(true);
    }
  
  module bodyShp(){
    if (clmpStyle=="block")
      square([clampDims.x,clampDims.y],true);
    else
      hull() for (ix=[-1,1])
        translate([ix*(clampDims.x-clampDims.y)/2,0]) circle(d=clampDims.y);
  }
}

module cable(cut=false){
  if (cut){
    for(ix=[-(wireCount-1)/2:(wireCount-1)/2])
      translate([ix*(wireDia+wireSpcng),wireDia/2]) offset(cblSpcng) circle(d=wireDia,$fn=20);
    translate([0,(wireDia-cblSpcng)/4-fudge/2]) 
      square([wireDia*(wireCount+wireSpcng)+cblSpcng*2+wireSpcng*2,wireDia/2+cblSpcng+fudge],true);
  }
  else
    for(ix=[-(wireCount-1)/2:(wireCount-1)/2]){
      col=cblColors[ix+(wireCount-1)/2];
      color(col) translate([ix*(wireDia+wireSpcng),0,wireDia/2]) 
        rotate([90,0,0]) cylinder(d=wireDia,h=clampDims.y*3,$fn=20,center=true);
    }
}

if (showStaplerDummy) staplerDummy();
  
module staplerDummy(){
  //cheap NOVUS J-01A hand stapler (discontinued)
  %translate([0,-stplDims.y/2,clampDims.z]){
    translate([0,4.6/2,5]) cube([24.9,4.6,10],true);
    translate([0,-(12-4.6)/2,4.5/2]) cube([23.3,12-4.6,4.5],true);
    translate([0,-(12-4.6)/2,4.5+ 5.5/2]) cube([23.3-0.4,12-4.6,5.5],true);
  }
}

module clampHolder(){
  //a holder to attach to the stapler
  
  //staplerside
  hldrDpth= (stplrFrntOffset>clampDims.y/2) ? stplrFrntOffset+minWallThck*3+clampDims.y/2+stplrSpcng : 0;
  ovDims=[stplrWdth+(minWallThck+stplrSpcng)*2,hldrDpth,max(hldrHght,clampDims.z*2)];
  cntrYOffset=-ovDims.y/2+stplrFrntOffset+stplrSpcng+minWallThck;
  
  difference(){
    //body
    translate([0,cntrYOffset,ovDims.z/2]) cube(ovDims,true);
    //clamp
    translate([0,0,-fudge/2]) linear_extrude(clampDims.z+fudge) offset(hldrSpcng) clamp(true);
    //Stapler
    translate([0,-ovDims.y/2+stplrFrntOffset+stplrSpcng,clampDims.z+ovDims.z/2])
      cube([stplrWdth+stplrSpcng*2,ovDims.y,ovDims.z],true);
    //cable
    translate([0,cntrYOffset,0]) rotate([90,0,0]) linear_extrude(ovDims.y+fudge,center=true,convexity=3) cable(true);
  }
}
