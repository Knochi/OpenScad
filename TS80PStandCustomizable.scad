// Remix of TS80P Soldering Iron stand

/* [Tip Cleaner Dims] */
clnrBaseDia=90.8;
clnrBaseHght=6;
clnrBotDia=74.5;
clnrTopDia=73.4;
clnrEdgeDia=68.5;
clnrEdgeRad=2;
clnrEdgeHght=3.2;
clnrOvHght=30.75;
clnrHoleDia=2.5;
clnrHoleHght=9.75;

/* [Stand Dims] */
standOffset=20;
crnrRad=1;
wallThck=2;
spcng=0.2;

/* [show] */
showCleaner=true;
showBase=true;
showStand=true;

/*[General] */
layerHght=0.2;
$fn=50;

/* [Hidden] */
fudge=0.1;

module stand(){
  translate([0,0,-6]) rotate(48.2) intersection(){
    translate([-67.16-10/2,-10.7-10/2,0]) import("TS80PHolder.stl",convexity=3);
    union(){
    translate([0,0,6]) cylinder(d=20,h=20);
    translate([0,0,26]) cylinder(d=40,h=35);
    }
  }
}
if (showBase) color("red") base();
if (showCleaner) clnrDummy();

  
module base(){
  baseDia=clnrBaseDia+spcng*2+wallThck*2;
  baseHght=clnrBaseHght+wallThck+spcng;
  springDims=[(baseDia-(clnrBotDia+spcng*2))/2-wallThck,8,(clnrHoleHght-baseHght)*2-layerHght*2];
  
  //body
  difference(){
    cylinderTopFillet(d=baseDia,h=baseHght,rad=crnrRad);
    translate([0,0,-fudge])
      cylinder(d=clnrBaseDia+spcng*2,h=clnrBaseHght+spcng+fudge);
    cylinder(d=clnrBotDia+spcng*2,h=clnrBaseHght+wallThck+spcng+fudge*2);
  }
  
  //spring snaps
  for (ix=[0,1]) mirror([ix,0,0]){
    translate([clnrBotDia/2,0,clnrHoleHght]){
      sphere(d=clnrHoleDia);
      translate([clnrHoleDia/4,-clnrHoleDia/4,0]) cube([clnrHoleDia/2,clnrHoleDia/2,springDims.z],true);
      translate([-clnrHoleDia/4+springDims.x+spcng/2,0,-layerHght]) 
        cube([clnrHoleDia/2+spcng,clnrHoleDia,springDims.z+layerHght*2],true);
      //springs
      translate([0,0,-springDims.z/2])
        flatSpring(size=springDims,t=clnrHoleDia/2,n=3);
    }
  }
  //spring housings
  translate([0,0,baseHght-crnrRad]) linear_extrude(springDims.z+layerHght+crnrRad) intersection(convexity=3){
    { 
      difference(){
        square([baseDia,springDims.y+(wallThck+spcng)*2],true);
        offset(-wallThck) square([baseDia,springDims.y+(wallThck+spcng)*2],true);
      }      
      difference(){
        circle(d=baseDia);
        circle(d=clnrBotDia+spcng*2);
      }
    }
  }
  //stand
  if (showStand) translate([baseDia/2+standOffset,0,baseHght]) stand();
}

module clnrDummy(){
  difference(){
    body();
    translate([0,0,clnrHoleHght]) rotate([0,90,0]) cylinder(d=clnrHoleDia,h=clnrBotDia,center=true);
  }
  module body(){
    cylinder(d=clnrBaseDia,h=clnrBaseHght);
    translate([0,0,clnrBaseHght]) 
      cylinder(d1=clnrBotDia,d2=clnrTopDia,h=clnrOvHght-clnrBaseHght-clnrEdgeHght);
    translate([0,0,clnrOvHght-clnrEdgeHght]) 
      cylinderTopFillet(d=clnrEdgeDia,h=clnrEdgeHght,rad=clnrEdgeRad);
    } 
}

*cylinderTopFillet(d=10,h=20,rad=1);
module cylinderTopFillet(d=1,h=1,rad=0.5){
  //cylinder with a fillet on the top
  rotate_extrude(){
    translate([d/2-rad,h-rad]) circle(rad);
      square([d/2,h-rad]);
      square([d/2-rad,h]);
    }
}

*flatSpring(size=[4,5,2],n=2);
module flatSpring(size=[10,5,1],t=1,n=3){
  radius=(size.x-t)/(n*2);
  conLen=size.y-radius*2-t;
  odd= n%2 ? 0 : 1;
  //arcs
  for (ix=[0:(n-1)])
    mirror([0,ix%2,0]) translate([radius+t/2+ix*radius*2,(size.y/2-radius-t/2),0]) 
      rotate_extrude(angle=180) translate([radius-t/2,0]) square([t,size.z]);
  
  //connectors
  for (ix=[0:(n-2)])
    translate([ix*radius*2+t/2+radius*2,0]) 
      linear_extrude(size.z) square([t,conLen],true);
  //end pieces
  cube([t,conLen/2,size.z]);
  translate([size.x-t,odd *-conLen/2,0]) cube([t,conLen/2,size.z]);
}
