use <eCad/Displays.scad>
use <eCad/Servos.scad>




/* [show] */
showDisplay=true;
showBody=true;
showSection=false;

/* [Dimensions] */
displayPos=[0,-10,0];
bodyDia=50;
wallThck=2;

/* [Colors] */
bodyCol=[];


/* [Hidden] */
fudge=0.1;

if (showDisplay)
  translate(displayPos) rotate([90,0,180]) roundDisplayWS();
if (showBody)
  body();


module body(){
  rotate([90,0,0]) difference(){
    sphere(d=bodyDia);
    sphere(d=bodyDia-wallThck*2);
    cylinder(d=30,h=bodyDia/2+fudge);
  }
 
}

translate([17.4,0,-14]) rotate([90,-90,90]) microServo();