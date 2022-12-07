use <eCAD/elMech.scad>
use <eCAD/Displays.scad>

$fn=20;

/* [show] */
showSection=false;
export="none";

/* [Dimensions] */
minWallThck=2; //minimum Wallthickness


/* [Positons] */
zOffset=0;


/* [Hidden] */
fudge=0.1;

M3RivetDrill= (export != "none") ? 4.6 : 4;

difference(convexity=5){
  scale(0.5) import("steamdeck_stl_20220202.stl");
  translate([-40,0,0]) cube([80,60,40],true);
}

translate([0,0,-3.8]) AdafruitOLED(size=2.42);

module M3Rivet(){
  color("gold") linear_extrude(5.7) 
    difference(){
      circle(d=4.6);
      circle(d=3);
    }
}

module M25Rivet(){
  color("gold") linear_extrude(5.7) 
    difference(){
      circle(d=4.6);
      circle(d=2.5);
    }
}