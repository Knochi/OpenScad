// cable grommet for Fiverr user dgijanssen
// Order No #FO413E712BCC2 from Jun 10, 2025, 9:57 PM
// https://www.gteek.com/rubber-cable-grommet-with-conical-end

/* [Dimensions] */
totalHeight=6;  //H
totalDia=8;     //d1
holeDia=5;      //d2
cableDia=2.4;   //d3
gapHeight=1.5;  //h
headHeight=1.5;  //F
topIndent=0.2;
ringIndent=0.2;
cornerRad=0.5;

/* [show] */
showSectionCut=false;
quality=100; //[50:10:200]
/* [Hidden] */
fudge=0.1;
$fn=quality;



poly=[[cableDia/2,totalHeight],
      [cableDia/2+topIndent,totalHeight],
      [totalDia/2,headHeight+gapHeight+ringIndent],
      [totalDia/2,headHeight+gapHeight],
      [holeDia/2,headHeight+gapHeight],
      [holeDia/2,headHeight],
      [totalDia/2,gapHeight],
      [totalDia/2,cornerRad],
      [totalDia/2-cornerRad,0],
      [cableDia/2,0],
      ];


difference(){     
  color("#222222") grommet();
  if (showSectionCut)
    color("yellow") translate([0,-totalDia/2,-fudge/2])  cube([totalDia/2,totalDia/2,totalHeight+fudge]);
}
      
module grommet(){      
  rotate_extrude(convexity=3){      
    polygon(poly);
    translate([totalDia/2-cornerRad,cornerRad]) intersection(){
       circle(cornerRad);
       translate([0,-cornerRad]) square(cornerRad);
       }
      
  }
}
      
      
      
      





