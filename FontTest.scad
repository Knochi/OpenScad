$fn=20;
use <ttf/DINCondensed-Bold.ttf>

projection(true) translate([0,0,-3])
difference(){
  *color("darkslategrey")cube([50,20,3]);
  color("gold") translate([25,10,3]) linear_extrude(0.5, center=true) 
    text("L1NKS", font = "DIN Condensed:style=Bold", halign="center",valign="center");
  *translate([6,10,-0.1]) cylinder(d=5,h=3.2);
}