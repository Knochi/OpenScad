/* [show] */
quality=20; //[20:100]
knurlKnob=true;
showScale=true;
showKnob=true;
showDShaft=true;

/* [Dimensions] */
scaleDia=50.6;
scaleBaseHght=1.3;
scaleHght=5.3;
knobOuterDia=30;
knobCapDia=26.3;
knobCapHght=2.5;
knobCapRad=1;
totalHght=19;
knurlThck=1;
knurlCount=80;
minWallThck=2;

/* [scale] */
startAng=0;
sweepAng=300;
startValue=0;
endValue=30;
majorTick=5;
minorTick=1;
majorTickWdth=0.5;
majorTickLen=5;
minorTickWdth=0.2;
minorTickLen=3.5;
labelThck=0.2;
labelFlush=true;
txtOffset=0.5;
txtSize=4;

/* [D-Shaft] */
shaftZOffset=2.5;
shaftDia=6;
shaftWdth=4.4;
shaftSlotWdth=2;
shaftWallThck=3;

/* [Hidden] */
fudge=0.1;
scaleFlankAng=atan((scaleHght-scaleBaseHght)/((scaleDia-knobOuterDia)/2));
innerDia=knobOuterDia-knurlThck*2-minWallThck*2;

$fn=quality;

if (showScale)
  scale();
if (showKnob)
  knob();
if (showDShaft)
  DShaft();

module knob(){
  grooveWdth=(innerDia-shaftDia)/2-shaftWallThck;
  knobBdyHght=totalHght-knobCapHght-scaleHght;
  //body
  translate([0,0,scaleHght]) difference(){
    if (knurlKnob)
      linear_extrude(knobBdyHght,convexity=3)
        star(N=knurlCount,ri=knobOuterDia/2-knurlThck,re=knobOuterDia/2);
    else
      cylinder(d=knobOuterDia,h=totalHght-knobCapHght-scaleHght);
    translate([0,0,-fudge]) cylinder(d=innerDia,h=knobBdyHght-grooveWdth/2);
    //make inner rounding to make printable wtho supports
    translate([0,0,knobBdyHght-grooveWdth/2]) rotate_extrude() translate([(innerDia-grooveWdth)/2,0]) circle(d=grooveWdth);
    }
  
    
  
  //cap
  translate([0,0,totalHght-knobCapRad]) rotate_extrude(){
    translate([knobCapDia/2-knobCapRad,0]) circle(knobCapRad);
    translate([0,-knobCapRad]) square([knobCapDia/2-knobCapRad,knobCapRad*2]);
  }
  translate([0,0,totalHght-knobCapHght]) cylinder(d=knobCapDia,h=knobCapHght-knobCapRad);
}

module scale(){
  majorTickCnt=(endValue-startValue)/majorTick;
  minorTickCnt=(endValue-startValue)/minorTick;
  majorTickAng=sweepAng/majorTickCnt;
  minorTickAng=sweepAng/minorTickCnt;
  
  //apply tickmarks if raised
  if (!labelFlush)
  color("white") intersection(){
    translate([0,0,scaleBaseHght]) ticks();
    cylinder(d=scaleDia,h=scaleHght);
  }
  
  difference(){
    union(){
      cylinder(d=scaleDia,h=scaleBaseHght);
      translate([0,0,scaleBaseHght]) cylinder(d1=scaleDia,d2=knobOuterDia,h=scaleHght-scaleBaseHght);
    }
    translate([0,0,-fudge/2]) cylinder(d=innerDia,h=scaleHght+fudge);
    //carve tickmarks if thck is negative
    if (labelFlush)
      translate([0,0,scaleBaseHght]) ticks();
  }
  
  
    
  *ticks();
  module ticks(){
    zOffset= (labelFlush) ? -labelThck : -fudge;
    //minor Ticks
    for (i=[1:minorTickCnt-1])
      if(i%majorTick) rotate(i*minorTickAng+startAng) 
        translate([scaleDia/2,0,zOffset]) rotate([0,scaleFlankAng,0]) 
          linear_extrude(abs(labelThck)+fudge) translate([-(minorTickLen+abs(labelThck))/2,0]) 
            square([minorTickLen+abs(labelThck),minorTickWdth],true);
    //major Ticks and labels
    for (i=[0:majorTickCnt])
      rotate(i*majorTickAng+startAng) 
        translate([scaleDia/2,0,zOffset]) rotate([0,scaleFlankAng,0]) 
          linear_extrude(abs(labelThck)+fudge,convexity=3){
            translate([(-majorTickLen+abs(labelThck))/2,0]) 
              square([majorTickLen+abs(labelThck),majorTickWdth],true);
            translate([-majorTickLen-txtSize/2-txtOffset,0]) rotate(-90)
              text(str(i*majorTick),txtSize,halign="center",valign="center");
          }
  }    
}

module DShaft(){
  linear_extrude(totalHght-knobCapHght-shaftZOffset) difference(){
    circle(d=shaftDia+shaftWallThck*2);
    intersection(){
      circle(d=shaftDia);
      translate([-shaftDia/2,-shaftDia/2]) square([shaftDia,shaftWdth]);
    }
    translate([0,-(shaftDia/2+shaftWallThck)/2]) square([shaftSlotWdth,shaftDia/2+shaftWallThck],true);
  }
}

//ri is inner radius and re is outer radius
*star(50,18,20);
module star(N=5, ri=15, re=30) {
    polygon([
        for (n = [0 : N-1], in = [true, false])
            in ? 
                [ri*cos(-360*n/N + 360/(N*2)), ri*sin(-360*n/N + 360/(N*2))] :
                [re*cos(-360*n/N), re*sin(-360*n/N)]
    ]);
}
