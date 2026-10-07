baseOutDia=89.5;
baseOvHght=14;
baseInDia=85.5;
baseInHght=11.4;
baseSpcng=0.1;


topRsnThck=3.5; //thickness of the transparent resin part
topRsnDia=41.75;
topSpcng=0.1;

cndlDia=100;
cndlHght=180;
cndlCeilThck=2;
cndlCornerRad=2;
cndlTopHoleDia=6;

export="candle"; //["candle","topTest","bottomTest","none"]

/* [Hidden] */
fudge=0.1;
basePlateHght=baseOvHght-baseInHght;
topOffset=cndlHght-topRsnThck;

$fn= export=="none" ? 48 : 400;

if (export=="bottomTest")
  !intersection(){
    candle();
    cylinder(d=cndlDia,h=baseOvHght);
  }
if (export=="topTest")
  !intersection(){
    candle();
    translate([0,0,topOffset-cndlCeilThck]) cylinder(d=cndlDia,h=baseOvHght);
  }
  
difference(){
  color("ivory") candle();
  if (export=="none") color("darkRed") translate([0,0,-fudge]) linear_extrude(cndlHght+fudge*2) square(baseOutDia+fudge);
}

%color("grey") translate([0,0,topOffset]) top();
%color("grey") base();

module base(){
  //dummy of existing base
  linear_extrude(basePlateHght) circle(d=baseOutDia);
  linear_extrude(baseOvHght) circle(d=baseInDia);
}

module top(){
  //dummy of the tip with flame and resin
  translate([0,0,-5]) cylinder(d=2.5,h=20);
  cylinder(d=topRsnDia,h=topRsnThck);
}

module candle(){
//the actual candle
  
  difference(){
    cylinder(d=cndlDia,h=cndlHght);
    translate([0,0,-fudge]){
      cylinder(d=baseOutDia+baseSpcng*2,h=basePlateHght+baseSpcng+fudge);
      cylinder(d=baseInDia+baseSpcng*2,h=topOffset-cndlCeilThck);
      cylinder(d=cndlTopHoleDia,h=cndlHght+fudge*2);
    }
    //embedd the resin
    translate([0,0,topOffset-topSpcng]) cylinder(d=topRsnDia+topSpcng*2,h=topRsnThck+topSpcng+fudge);
    translate([0,0,cndlHght-cndlCornerRad]) 
      rotate_extrude() translate([cndlDia/2-cndlCornerRad,0]) square(cndlCornerRad+fudge);
  }
  translate([0,0,cndlHght-cndlCornerRad]) 
      rotate_extrude() translate([cndlDia/2-cndlCornerRad,0]) circle(cndlCornerRad);
}