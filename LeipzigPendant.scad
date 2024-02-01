$fn=50;

linear_extrude(1) offset(3) text(text="LEIPZIG", size=15, font="Cantarell:style=regular");
translate([0,0,1]) linear_extrude(1) offset(1) text(text="LEIPZIG", size=15, font="Cantarell:style=regular");
translate([-1.7,17.3,0]) linear_extrude(2) difference(){
  circle(d=7);
  circle(d=3);
}
