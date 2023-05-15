ovHght=16;
fitHght=4.7; 
fitDiaMax=30.8;
fitDiaMin=30.7;
diaMax=33.9;
diaMin=30.9;
minWallThck=1.4;
opnDia=24;
fudge=0.1;

$fn=150;

difference(){
  union(){
    cylinder(d1=diaMin,d2=diaMax,h=ovHght-fitHght);
    translate([0,0,ovHght-fitHght]) cylinder(d1=fitDiaMax,d2=fitDiaMin,h=fitHght);
    for (i=[0:7])
      rotate(360/8*i) translate([(fitDiaMax-minWallThck)/2,0,ovHght-fitHght]) cylinder(d=minWallThck,h=fitHght);
  }
  translate([0,0,-fudge/2]) cylinder(d=opnDia,h=ovHght+fudge);
  translate([0,0,minWallThck]) cylinder(d=fitDiaMin-minWallThck*2,h=ovHght);
}