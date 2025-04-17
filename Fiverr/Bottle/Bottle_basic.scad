/* openSCAD basic bottle example for vorgmindset */

//these are parameters you can set via customizer

/* [Dimensions] */
wallThck=1.2;
height=150;
baseDia=80;
neckDia=50;

/* [Hidden] */
fudge=0.1;
baseHght=height*0.6;
neckHght=height*0.15;
$fn=50;


cylinder(d=baseDia,h=baseHght);
translate([0,0,baseHght]) cylinder(d1=baseDia,d2=neckDia,h=height-baseHght-neckHght);
translate([0,0,height-neckHght]) cylinder(d=neckDia,h=neckHght);