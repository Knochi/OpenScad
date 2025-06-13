// cable grommet for Fiverr user dgijanssen
// Order No #FO413E712BCC2 from Jun 10, 2025, 9:57 PM
// https://www.gteek.com/rubber-cable-grommet-with-conical-end

/* [Dimensions] */
totalHeight=8;  //H
totalDia=13;     //d1
holeDia=6;      //d2
cableWidth=2; //d3
cableHeight=5.0; //d3
gapHeight=1.5;  //h
headHeight=1.5;  //F
topIndent=0.4;
ringIndent=0.2;
cornerRad=0.5;
minWallThck=0.8;

/* [show] */
showSectionCut=true;
quality=100; //[50:10:200]

/* [Hidden] */
fudge=0.1;
$fn=quality;

cableDia=max(cableWidth,cableHeight);
cableWdth=min(cableWidth,cableHeight);
minHoleDia=max(cableDia+minWallThck*2,holeDia);

if ((cableDia+minWallThck*2)>holeDia) echo("HoleDia limited by minWallThck!");

poly=[[0,totalHeight],
      [cableDia/2+topIndent,totalHeight],
      [totalDia/2,headHeight+gapHeight+ringIndent],
      [totalDia/2,headHeight+gapHeight],
      [minHoleDia/2,headHeight+gapHeight],
      [minHoleDia/2,headHeight],
      [totalDia/2,gapHeight],
      [totalDia/2,cornerRad],
      [totalDia/2-cornerRad,0],
      [0,0],
      ];


difference(){     
  color("#222222") grommet();
  if (showSectionCut)
    color("yellow") translate([0,-totalDia/2,-fudge/2])  cube([totalDia/2,totalDia/2,totalHeight+fudge]);
}
      
module grommet(){      
  difference(){
    rotate_extrude(convexity=3){      
      polygon(poly);
      translate([totalDia/2-cornerRad,cornerRad]) intersection(){
        circle(cornerRad);
        translate([0,-cornerRad]) square(cornerRad);
     }
    }
    hull() 
      for (ix=[-1,1])
        translate([ix*(cableDia-cableWdth)/2,0,-fudge/2]) cylinder(d=cableWdth,h=totalHeight+fudge);
   }
}
      
      
      
      





