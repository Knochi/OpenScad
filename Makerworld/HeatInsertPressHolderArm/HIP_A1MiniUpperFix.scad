showCut=false;
fudge=0.1;
holeDia=3.5;
headDia=6;

$fn=48;

difference(){
  translate([-25,-15,0])
    import("insertpressA1miniUpper.stl",convexity=4);
  if (showCut)
    color("darkred") translate([0,-15-fudge/2,-fudge/2]) cube([30,30+fudge,65+fudge]);
  cylinder(d=holeDia,h=65);
  cylinder(d=headDia,h=60-3);
  //help with the overhang
  intersection(){
    cylinder(d=headDia,h=60-3+0.2);
    translate([0,0,(60-3+0.2)/2]) cube([headDia,holeDia,60-3+0.2],true);
  }
  }