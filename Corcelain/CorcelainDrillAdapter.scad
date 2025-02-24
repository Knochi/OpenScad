
*translate([0,-90.9+(90.9-49.1)/2,0]) import("corcelain_screw_long_V0100.stl");
translate([0,-141.9+(141.9-100.1)/2,0]) import("corcelain_screw_short_V0100.stl");

screwDia=41.8;
screwCtnrHoleDia=36.5;
translate([0,0,-40]) cylinder(d=10,h=20,$fn=6);
translate([0,0,-42]) cylinder(d1=8,d2=10,h=2,$fn=6);
translate([0,0,-20]) cylinder(d1=10,d2=screwCtnrHoleDia,h=20,$fn=6);


