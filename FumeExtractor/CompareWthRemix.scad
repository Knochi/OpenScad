use <rndrect2.scad>
use <KnochisToolbox.scad>
use <eCad\packages.scad>

/* -- [Dimensions] -- */
fanDims=[80,80,25];
fanDrillDist=71.5;
fanDrillDia=3.8; //for M4screws

LEDPos=[33,-30,33];
LEDRot=[150,0,-25];

/* -- [show] -- */
showLeft=true;
showRight=true;
showFan=true;
showLid=true;
showWorkArea=true;

echo(norm([11,-39.3,-33.3]-[11,-33.4,-27.44]));
/* -- [Hidden] -- */
$fn=40;
fudge=0.1;
spcng=0.25;
fanYOffset=15; //wall to Fan
elCompYOffset=-2; //wall to electr. compartment
redWallThck=fanYOffset-elCompYOffset; //reducer wall thickness
wallThck=3.75;
StepUpDims=[30,17,5];
ovDims=[88,44+56,88];

translate(LEDPos) rotate(LEDRot) LED_5mm(lightConeAng=35,lightConeHght=120);
mirror([1,0,0]) translate(LEDPos) rotate(LEDRot) LED_5mm(lightConeAng=35,lightConeHght=120);

LEDPot();
module LEDPot(){
  difference(){
    hull(){
      for (ix=[-1,1],iz=[40,22])
        translate([ix*(40-2.5),-28,iz-2.5]) rotate([90,0,0]) cylinder(d=5,h=44-28);
    }
    for (m=[0,1])
      mirror([m,0,0]) translate(LEDPos) rotate(LEDRot) translate([0,0,6]) cylinder(d=60,h=20);

    translate([-(ovDims.x+fudge)/2,-28,-24])
      rotate([90+13.24,0,0]) cube([ovDims.x+fudge,ovDims.z,10]);
    translate([0,-28+fudge,10]) rotate([90,0,0]) cylinder(d=65,h=40);

  }
}
if (showWorkArea) translate([0,-44-ovDims.z/2,-ovDims.z/2]) cube([ovDims.x,ovDims.z,1],true);

//Lets modify the original files
//right Housing
if (showRight) {
  difference(){
    union(){
      import("minimalist-3d-printed-fume-extractor_right.stl",convexity=4);
      //close old cable duct
      translate([32,fanYOffset,-32]) rotate([90,0,0]) cylinder(d=8,h=redWallThck);
      //close old DC Jack
      translate([38,-14,-32]) rotate([0,90,0]) cylinder(d=7,h=6);
    }
    //cut away back for easier assembly and smaller fan
    translate([0,(56-15+fudge)/2+15+fanDims.z+spcng,0])
      cube([ovDims.x+fudge,56-15+fudge,ovDims.z+fudge],true);
    //cut new cable duct
    translate([40-21.5,fanYOffset,-40+2]) rotate(180) duct([4,2],redWallThck,2);
    //cut drills for fan
    for (iz=[-1,1])
      translate([fanDrillDist/2,fanYOffset+fudge/2,iz*fanDrillDist/2])
        rotate([90,0,0]) cylinder(d=fanDrillDia,h=redWallThck+fudge);
  }
}
//left housing
if (showLeft)
  difference(){
    import("minimalist-3d-printed-fume-extractor_left.stl",convexity=3);
    translate([0,(56-15+fudge)/2+fanYOffset+fanDims.z+spcng,0])
      cube([ovDims.x+fudge,56-fanYOffset+fudge,ovDims.z+fudge],true);
     for (iz=[-1,1])
      translate([-fanDrillDist/2,fanYOffset+fudge/2,iz*fanDrillDist/2])
        rotate([90,0,0]) cylinder(d=fanDrillDia,h=redWallThck+fudge);
  }

if (showLid) import("minimalist-3d-printed-fume-extractor_lid.stl");


if (showFan) translate([0,15+25/2,0]) rotate([90,180,0]) fan();
if (showMT3608) translate([-15+36,-12,-38]) rotate(180) color("green") import("MT3608.stl");

module grilleBack(){
}


*fan();
module fan(){
  //SUNON HA8025..
  //ovDims=[80,80,25];
  cntrOpening=77.2;
  rad=(fanDims.x-fanDrillDist)/2;

  difference(){
    rndRect(fanDims,rad,4.3,center=true);
    cylinder(d=cntrOpening,h=fanDims.z+fudge,center=true);
  }
  //wires
  translate([-(fanDims.x/2-22),fanDims.y/2-2,fanDims.z/2]) color("red") cylinder(d=1.5,h=20);
  translate([-(fanDims.x/2-22+1.5),fanDims.y/2-2,fanDims.z/2]) color("black") cylinder(d=1.5,h=20);
}

*duct();
module duct(size=[5,2],wallThck=20,elevation=5){
  hull(){
    shape();
    translate([0,wallThck,elevation]) shape();
  }
  module shape(){
  hull()
    for (ix=[-1,1]) translate([ix*size.x/2,0,0]) sphere(d=size.y);
  }
}
