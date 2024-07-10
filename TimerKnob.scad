/* [show] */
quality=20; //[20:100]
knurlKnob=true;
showScale=true;
showKnob=true;

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
txtSize=2;

/* [D-Shaft] */
shaftZOffset=2.5;
shaftDia=6;
shaftWdth=4.4;
shaftSlotWdth=2;


/* [Hidden] */
fudge=0.1;
scaleFlankAng=atan((scaleHght-scaleBaseHght)/((scaleDia-knobOuterDia)/2));
innerDia=knobOuterDia-knurlThck*2-minWallThck*2;

$fn=quality;

if (showScale)
  scale();
if (showKnob)
  knob();

module knob(){
  if (knurlKnob)
    translate([0,0,scaleHght]) linear_extrude(totalHght-knobCapHght-scaleHght)
      difference(){
        star(N=knurlCount,ri=knobOuterDia/2-knurlThck,re=knobOuterDia/2);
        circle(d=innerDia);
      }
        
  else
    cylinder(d=knobOuterDia,h=totalHght-knobCapHght);
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
  
  difference(){
    union(){
      cylinder(d=scaleDia,h=scaleBaseHght);
      translate([0,0,scaleBaseHght]) cylinder(d1=scaleDia,d2=knobOuterDia,h=scaleHght-scaleBaseHght);
    }
    translate([0,0,-fudge/2]) cylinder(d=innerDia,h=scaleHght+fudge);
  }
  color("white") translate([0,0,scaleBaseHght]) intersection(){
    cylinder(d=scaleDia,h=totalHght);
    ticks();
  }
  
  module ticks(){
    //minor Ticks
    for (i=[1:minorTickCnt-1])
      if(i%majorTick) rotate(i*minorTickAng+startAng) 
        translate([scaleDia/2,0,-fudge]) rotate([0,scaleFlankAng,0]) 
          linear_extrude(labelThck+fudge) translate([-minorTickLen/2,0]) 
            square([minorTickLen,minorTickWdth],true);
    //major Ticks and labels
    for (i=[0:majorTickCnt])
      rotate(i*majorTickAng+startAng) 
        translate([scaleDia/2,0,-fudge]) rotate([0,scaleFlankAng,0]) 
          linear_extrude(labelThck+fudge,convexity=3){
            translate([-majorTickLen/2,0]) 
              square([majorTickLen,majorTickWdth],true);
            translate([-majorTickLen-txtSize,0]) rotate(-90)
              text(str(i*majorTick),txtSize,halign="center",valign="center");
          }
  }    
}
DShaft();
module DShaft(){
  linear_extrude(totalHght-knobCapHght-minWallThck-shaftZOffset) difference(){
    circle(d=shaftDia+minWallThck*2);
    intersection(){
      circle(d=shaftDia);
      translate([-shaftDia/2,-shaftDia/2]) square([shaftDia,shaftWdth]);
    }
    translate([0,-(shaftDia/2+minWallThck)/2]) square([shaftSlotWdth,shaftDia/2+minWallThck],true);
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
