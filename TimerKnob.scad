/* [show] */
quality=100; //[20:100]
knurlKnob=true;
showKnob=true;
showTickMarks=true;
showSectioncut=false;
export="none"; //["None","Complete","Color1","Color2","template","DShaftTest"]


/* [Dimensions] */
scaleDia=50.6;
scaleBaseHght=1.3;
scaleHght=6.3;
knobOuterDia=30;
knobCapDia=26.3;
knobCapHght=2.5;
knobCapRad=1.5;
totalHght=19;
knurlThck=1;
knurlCount=80;
minWallThck=2;
screwHoleDia=2.5;
screwHeadDia=6;
screwHeadHght=6;
overHangAngle=60;

/* [scale] */
startAng=35.5;
sweepAng=293.5;
startValue=0;
endValue=30;
majorTick=5;
minorTick=1;
majorTickWdth=0.9;
majorTickLen=5;
minorTickWdth=0.6;
minorTickLen=3.5;
labelThck=0.3;
labelFlush=false;
txtOffset=0.5;
txtSize=5;

/* [Template] */
majorTickWdthTmp=0.4;
minorTickWdthTmp=0.2;
majorTickTmp=10;
minorTickTmp=2;
txtSizeTmp=2;
txtOffsetTmp=0.5;

/* [D-Shaft] */
shaftZOffset=2.5;
//nominal Diameter
shaftDia=6.0;
//width of the flattened Part
shaftWdth=4.5;
//spacing required for 3DPrint
shaftSpacing=0.05;
//can be reduced to improve stability
shaftLength=14.0;
shaftSlotWdth=2;
shaftWallThck=3;
//chamfer for the DShape
shaftChamfer=1;

/* [Options] */
screwOpt=false;
slotOpt=true;
matSaveOpt=true;

/* [Hidden] */
fudge=0.1;
scaleFlankAng=atan((scaleHght-scaleBaseHght)/((scaleDia-knobOuterDia)/2));
innerDia=knobOuterDia-knurlThck*2-minWallThck*2;


$fn=quality;

//export presets

if (export=="Complete"){
  tickMarks();
  knob();
}

else if (export=="Color1"){
  knob();
}

else if (export=="Color2")
  tickMarks();

else if (export=="template"){
  template();
}

else if (export=="DShaftTest")
  !DShaftTest();

else {
  difference(){
    union(){
      if (showKnob)
        knob();
      if (showTickMarks)
        tickMarks();
    }
    if (showSectioncut) color("darkRed") translate([scaleDia/2-fudge,0,(totalHght)/2]) 
      cube([scaleDia+fudge,scaleDia+fudge,totalHght+fudge],true);
  }
}

  

module DShaftTest(){
  outerDia=shaftDia+shaftWallThck*2;
  knobHght=(totalHght-shaftZOffset)/2;
  lblTxt=str(shaftSpacing);
  
  linear_extrude(totalHght-shaftZOffset) difference(){
    circle(d=outerDia);
    DShape();
    translate([0,-outerDia/4]) square([shaftSlotWdth,outerDia/2],true);
  }
  translate([0,0,totalHght-shaftZOffset]) difference(){
    knob();
    translate([0,0,knobHght-labelThck]) linear_extrude(labelThck+fudge) 
      text(lblTxt,size=outerDia*0.4,valign="center",halign="center");
  }
  
  module knob(){
    translate([0,0,+knurlThck]) 
      linear_extrude(knobHght-knurlThck*2) star(50,ri=outerDia/2,re=outerDia/2+knurlThck);
    intersection(){
      cylinder(d1=outerDia,d2=outerDia+knurlThck*2,h=knurlThck);
      linear_extrude(knurlThck,convexity=3) star(50,ri=outerDia/2,re=outerDia/2+knurlThck);
    }
    translate([0,0,knobHght-knurlThck]) intersection(){
      cylinder(d2=outerDia,d1=outerDia+knurlThck*2,h=knurlThck);
      linear_extrude(knurlThck,convexity=3) star(50,ri=outerDia/2,re=outerDia/2+knurlThck);
    }
  }
  
    
}

module knob(){
  grooveWdth=(innerDia-shaftDia)/2-shaftWallThck;
  knobBdyHght=totalHght-knobCapHght-scaleHght;
    
  //body
  difference(){
    union(){
      if (knurlKnob)
        translate([0,0,scaleHght]) linear_extrude(knobBdyHght,convexity=3)
          star(N=knurlCount,ri=knobOuterDia/2-knurlThck,re=knobOuterDia/2);
      else
        translate([0,0,scaleHght]) linear_extrude(knobBdyHght,convexity=3)
          circle(d=knobOuterDia);
      //cap
      translate([0,0,totalHght-knobCapRad]){ 
        rotate_extrude(){
          translate([knobCapDia/2-knobCapRad,0]) circle(knobCapRad);
          translate([0,-knobCapRad]) square([knobCapDia/2-knobCapRad,knobCapRad*2]);
          translate([0,-knobCapHght+knobCapRad]) square([knobCapDia/2,knobCapHght-knobCapRad]);
        }
      }
      //scale
      scale();
    }
    //make inner rounding to make printable wtho supports
    difference(){
      rotate_extrude(){
        translate([(innerDia-grooveWdth)/2,scaleHght+knobBdyHght-grooveWdth/2]) circle(d=grooveWdth);
        translate([shaftDia/2+shaftWallThck,0]) square([grooveWdth,scaleHght+knobBdyHght-grooveWdth/2]);
      }
      //leave something for the screw
      if (screwOpt){
        translate([0,0,scaleHght+screwHeadDia/2]) rotate([-90,0,0]) cylinder(d=screwHeadDia+minWallThck*2,h=knobOuterDia/2);  
        translate([0,knobOuterDia/4,scaleHght+screwHeadDia/2+totalHght/2]) cube([screwHeadDia+minWallThck*2,knobOuterDia/2,totalHght],true);
      }
    }
    //shorten the shaft
    translate([0,0,-fudge]) cylinder(d=innerDia,h=shaftZOffset+fudge);
    
    //make the DShape Hole
    linear_extrude(shaftZOffset+shaftLength) DShape();
    
    //chamfer the DShape hole
    hull(){
      translate([0,0,shaftZOffset+shaftChamfer]) linear_extrude(0.1,scale=0.1) DShape();
      translate([0,0,shaftZOffset]) linear_extrude(0.1,scale=0.1) offset(shaftChamfer) DShape();
    }
    
    //extrude the slot
    if (slotOpt) 
      translate([0,-shaftDia/4-shaftWallThck/2-grooveWdth/4,(shaftZOffset+shaftLength)/2]) 
        cube([shaftSlotWdth,(innerDia-grooveWdth)/2,shaftZOffset+shaftLength],true);
    
    //apply the screw Hole
    if(screwOpt) translate([0,0,scaleHght+screwHeadDia/2+knurlThck]){
      rotate([-90,0,0]) cylinder(d=screwHoleDia,h=knobOuterDia/2+fudge);
      translate([0,knobOuterDia/2-screwHeadHght]) rotate([-90,0,0]) cylinder(d=screwHeadDia,h=screwHeadHght+fudge);
      translate([0,knobOuterDia/2-knurlThck]) rotate([-90,0,0]) 
        cylinder(d1=screwHeadDia,d2=screwHeadDia+(knurlThck)*2,h=knurlThck);
    }
    
    //save some Material 
    if (matSaveOpt){
      matSvHght=scaleHght-minWallThck;
      difference(){
        cylinder(d1=innerDia+(matSvHght/tan(overHangAngle))*2,d2=innerDia,h=matSvHght);
        cylinder(d=innerDia-grooveWdth*2+fudge,h=matSvHght);
      }
    }
  } //difference
}

module scale(){  
  difference(){
    scaleBdy();
    //carve tickmarks if thck is negative
    if (labelFlush)
      translate([0,0,scaleBaseHght]) ticks();
  }
}



module scaleBdy(reduce=false){
  red= reduce ? 0.01 : 0; //for better color representation in CSG
  translate([0,0,red/2]) cylinder(d=scaleDia-red,h=scaleBaseHght-red);
  translate([0,0,scaleBaseHght-red/2]) cylinder(d1=scaleDia-red,d2=knobOuterDia-red,h=scaleHght-scaleBaseHght);
}    


module tickMarks(){
    
  if (labelFlush)
    color("white") intersection(){
      translate([0,0,scaleBaseHght]) ticks();
      translate([0,0,0.01]) scaleBdy(true);
    }
  else //apply tickmarks if raised
    color("white") difference(){
      intersection(){
        translate([0,0,scaleBaseHght]) ticks();
        cylinder(d=scaleDia-0.01,h=totalHght-minWallThck-fudge);
      }
      scaleBdy(true);
    }
      
    
}

module template(){
  majorTickCnt=360/majorTickTmp;
  minorTickCnt=360/minorTickTmp;
  majorTickAng=360/majorTickCnt;
  minorTickAng=360/minorTickCnt;
   
  //minor ticks
  for (i=[0:minorTickCnt-1])
    if(i%majorTick) rotate(i*minorTickAng)  
        translate([scaleDia/2+minorTickLen/2,0]) 
          square([minorTickLen,minorTickWdthTmp],true);
    
  //major Ticks and labels
  for (i=[0:majorTickCnt-1])
    rotate(i*majorTickAng) 
      translate([scaleDia/2+majorTickLen/2,0]){
        square([majorTickLen,majorTickWdthTmp],true);
        translate([majorTickLen+txtSizeTmp/2+txtOffsetTmp,0]) rotate(-90)
          text(str(i*majorTick*2),txtSizeTmp,halign="center",valign="center");
      }
      
  DShape();
}

*ticks();
module ticks(){
  majorTickCnt=(endValue-startValue)/majorTick;
  minorTickCnt=(endValue-startValue)/minorTick;
  majorTickAng=sweepAng/majorTickCnt;
  minorTickAng=sweepAng/minorTickCnt;
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



/* don't use but keeping for reference
module DShaft(){
    translate([0,0,shaftZOffset]) linear_extrude(shaftLength,convexity=3) difference(){
      circle(d=shaftDia+shaftWallThck*2);
      intersection(){
        circle(d=shaftDia);
        translate([-shaftDia/2,-shaftDia/2]) square([shaftDia,shaftWdth]);
      }
    translate([0,-(shaftDia/2+shaftWallThck)/2]) square([shaftSlotWdth,shaftDia/2+shaftWallThck],true);
    }
}
*/
  
*DShape();
module DShape(){
   intersection(){
      circle(d=shaftDia+shaftSpacing*2);
      translate([-shaftDia/2-shaftSpacing,-shaftDia/2-shaftSpacing]) square([shaftDia+shaftSpacing*2,shaftWdth+shaftSpacing*2]);
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
