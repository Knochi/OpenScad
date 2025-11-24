outerDia=100;
innerDia=91;
spcng=0.2;
minWallThck=1.2;
minFloorThck=0.6;
rimHght=5;
ovHght=10;
ventOpnAng=5;
ventCount=9;
rimOpnAng=42;
rimOpnCnt=3;

/* [Hidden] */
$fn=100;
ventStpAng=360/ventCount;
rimStpAng=360/rimOpnCnt;
ringWdth=(outerDia-(innerDia-spcng*2-minWallThck*2))/2;
fudge=0.1;

difference(){
  ring();
  //vents
  for (i=[0:ventCount-1])
    rotate(i*ventStpAng) rotate_extrude(angle=ventOpnAng) translate([innerDia/2-minWallThck-spcng-fudge/2,-fudge]) 
      square([ringWdth+fudge,ovHght-rimHght-minFloorThck+fudge]);
  //opening in th erim
  for (i=[0:rimOpnCnt-1])
    rotate(i*rimStpAng+ventStpAng/2) rotate_extrude(angle=rimOpnAng) 
      translate([innerDia/2-spcng-fudge/2-minWallThck,ovHght-rimHght]) 
        square([ringWdth+fudge,ovHght-rimHght+fudge]);
}

module ring(){
  linear_extrude(ovHght) difference(){
    circle(d=innerDia-spcng*2);
    circle(d=innerDia-spcng*2-minWallThck*2);
  }
  linear_extrude(ovHght-rimHght) difference(){
    circle(d=outerDia);
    circle(d=innerDia-spcng*2-minWallThck*2);
  } 
}