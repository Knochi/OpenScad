$fn=200;
fudge=0.1;
baseDia=42.4;
topDia=43.3;
baseHght=5;
ovHght=14.5;
minWallThck=1.2;

difference(){
  union(){
    cylinder(d=baseDia,h=baseHght);
    translate([0,0,baseHght]) cylinder(d1=baseDia,d2=topDia,h=ovHght-baseHght);
  }
  translate([baseDia/2-baseHght+3.5/2,0,-fudge/2]){
    cylinder(d=3.5,h=baseHght+fudge);
    translate([0,-3.5/2,0]) cube([baseHght-3.5/2+fudge,3.5,baseHght+fudge]);
  }
  translate([0,0,baseHght])
      cylinder(d1=baseDia-minWallThck*2,d2=topDia-minWallThck*2,h=ovHght-baseHght+fudge);
}
