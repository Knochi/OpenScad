$fn=50;

use <bendShape.scad>


  translate([0,0,-46]) rotate([170,0,0]) translate([0,0,-50])  cylindric_bend([150, 20, 2],50)
    translate([0, 20, 0]) rotate(0)
      linear_extrude(height=2)
       mirror([0,1,0]) text("cylindric_bend", size=15, valign="bottom");
