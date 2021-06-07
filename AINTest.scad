use <eCad/Displays.scad>
use <eCad/elMech.scad>

color("darkSlateGrey") keyPad();
translate([0,60,20]) rotate([30,0,0]) Adafruit128x160TFT(centerAA=true);