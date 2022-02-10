*import("nerf-mega-tip.stl");

minWallThck=1.2;
innerDia=12.5;
outerDia=18.4;
innerHght=4.5;
outerHght=17;
rad=1;

translate([0,0,-innerHght])
  linear_extrude(innerHght) difference(){
    circle(d=innerDia);
    circle(d=innerDia-minWallThck*2);
  }

