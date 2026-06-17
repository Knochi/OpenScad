
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
 *nutBig();
 module nutBig(cut=true){
 spcng=0.3;
  if (cut)
    translate([0,0,-fudge]){
      cylinder(d=11+spcng*2,h=3.2+spcng+fudge);
      cylinder(d=7.15+spcng*2,h=24+fudge);
      }
  else
  color("gold") translate([0,0,-3]) difference(){
     union(){
       cylinder(d=11,h=6.2);
       cylinder(d=7.15,h=14.7);
       translate([0,0,14.7]) cylinder(d=8.6,h=5.3);
       cylinder(d=3.6,h=23.4);
     } 
     translate([0,0,-fudge]){
      cylinder(d=4.3,h=16.7+fudge);
      cylinder(d=8.6,h=2.25+fudge);
     }
   }
 }
 
 knob();
 module knob(){
   floorHght=2;
   loopHght=2;
   loopDia=43.1;
   loopWallThck=2;
   cntrStemHght=2;
   cntrStemDia=15;
   baseDia=43.1;
   rivetHole=9.3-0.7;
   rad=5;
   
   //knob base
   difference(){
     union(){
       translate([0,0,floorHght]) linear_extrude(14,convexity=3) circle(d=baseDia);
       //loop
       translate([0,0,floorHght-loopHght]) linear_extrude(loopHght,convexity=3) difference(){
         circle(d=loopDia);
         circle(d=loopDia-loopWallThck*2);
       }
       //center stem
       linear_extrude(floorHght) circle(d=cntrStemDia);
     }
     translate([0,0,-fudge]) nutBig(true);
   }
   //head
   translate([0,0,floorHght+14+5/2]){
    rotate_extrude() translate([(58-rad)/2,0]) circle(d=rad);
    translate([0,0,-rad*1.5]) rotate_extrude() 
      translate([baseDia/2-fudge,0]) difference(){
        square(rad+fudge);
        translate([rad+fudge,0,0]) circle(rad);
     }
     //fill top
     cylinder(r=(58-5)/2,h=5,center=true);
   }
 }
 