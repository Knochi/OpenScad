$fn=100;

use <bezier.scad>

/* [roofDimensions] */
ovDia= 150;
ovHght = 40;
thick= 2;

crvT=25;
crvO=10;

/* [slot Dimensions] */
slotLen=20;
slotWdth=5;
slotDist=138;


difference(){
  roof();
  for (ir=[0:90:270])
    rotate(ir+45) translate([slotDist/2,0,ovHght/2]) cube([slotLen,slotWdth,ovHght],true);
}



module roof(){
  //                    p1         c1             c2            p2              c3
  bez=[        [0,ovHght],OFFSET([crvT,0]),OFFSET([-crvO,0]),[(ovDia-thick)/2,thick], LINE(),
       LINE(),  [(ovDia-thick)/2,0], OFFSET([-crvO,0]), OFFSET([crvT,0]), [0,ovHght-thick]];
  //      c4              p3               c5              c6           P4
  rotate_extrude(angle=180){
    polygon(Bezier(bez));
    translate([(ovDia-thick)/2,thick/2]) circle(d=thick);
  }
}