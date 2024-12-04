use <./Multiboard/Multiboard.scad>
$fn=50;
crnrRad=3;
ovWidth=140;
innerHght=30;

minWallThck=1.6;

translate([0,-6,0]) color("grey") cube([220,5,150]);

color("orange"){
  translate([20,0,0]) rotate(180) MBpushFit();
  translate([120,0,0]) rotate(180) MBpushFit();
  translate([crnrRad,0,0]) rotate([90,0,0]) linear_extrude(minWallThck) 
    difference(){
      offset(crnrRad) square([ovWidth-crnrRad*2,innerHght]);
      translate([-crnrRad,-crnrRad]) square([ovWidth,crnrRad]);
    }
}

