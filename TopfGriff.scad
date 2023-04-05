
fudge=0.1;
$fn=70;

 module nut(){
   color("gold") difference(){
     union(){
       cylinder(d=10,h=4.1);
       cylinder(d=9.3,h=12);
       cylinder(d=2.1,h=17.5);
     } 
     translate([0,0,-fudge]) cylinder(d=4.3,h=10.4);
   }
 }
 
 knob();
 module knob(){
   floorHght=6.25;
   loopThck=2.45;
   rivetHole=9.3-0.7;
   rad=5;
   //knob
   difference(){
     union(){
       translate([0,0,floorHght]) linear_extrude(14) circle(d=43.1);
       translate([0,0,floorHght-loopThck]) linear_extrude(loopThck) difference(){
         circle(d=37);
         circle(d=33.9);
       }
       linear_extrude(floorHght) circle(d=22.4);
     }
     translate([0,0,-fudge]) cylinder(d=rivetHole,h=18);
   }
   //head
   translate([0,0,floorHght+14+5/2]){
    rotate_extrude() translate([(58-rad)/2,0]) circle(d=rad);
    translate([0,0,-rad*1.5]) rotate_extrude() 
      translate([43.1/2-fudge,0]) difference(){
        square(rad+fudge);
        translate([rad+fudge,0,0]) circle(rad);
     }
     cylinder(r=(58-5)/2,h=5,center=true);
   }
 }