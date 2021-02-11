$fn=50;
minWallThck=2;
sideLngth=62;
outerDrill=6;
outerHght=20;
centerDrill=8;
centerHght=7;
spcng=0.1;

ru=sideLngth/sqrt(3);

//center
linear_extrude(centerHght) difference(){
  circle(d=centerDrill+minWallThck*2);
  circle(d=centerDrill+spcng*2);
}

linear_extrude(outerHght)
  for (ir=[0:120:240])
    rotate(ir) translate([ru,0]) difference() {
      circle(d=outerDrill+minWallThck*2);
      circle(d=outerDrill+spcng*2);
    }
    
//base
linear_extrude(minWallThck) difference(){
    hull() for (ir=[0:120:240])
      rotate(ir) translate([ru,0]) 
        circle(d=outerDrill+minWallThck*4);
  
  for (ir=[0:120:240])
    rotate(ir) translate([ru,0]) 
      circle(d=outerDrill+spcng*2);
  circle(d=centerDrill+spcng*2);
}
