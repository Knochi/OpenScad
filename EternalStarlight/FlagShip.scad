use </eCAD/LEDModules.scad>

scale(15) import("human-flagship.stl");

translate([0,0,20]) rotate([-90,0,0]) LEDButton();