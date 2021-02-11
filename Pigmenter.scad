use <3DPrinterParts.scad>;
use <eCad\elMech.scad>;

$fn=20;

/* [Dimensions] */
minWallThck=1.2; //minimum Wall Thicknes for 3DP-Parts

/* [Hidden] */
fudge=0.1;

pigmenter();

module pigmenter(){
  
  //E3D-standard parts
  color("silver") V6HeatSink();
  color("gold") translate([0,0,-21.5]) V6Nozzle();
  color("grey") translate([0,0,-7]) V6HeatBreak();
  
  translate([30,0,3.5]) pusher();
  //custom heat block
  
  //pigment container
  
  module pusher(){
    stroke=10; //travel of the rod
    pinDia=1; //Diameter of the cam pin
    rodDia=1; //Diameter of the rod that pushes the pigment
    
    rotate([180,0,0]) microStepper();
    translate([0,0,-10]) cylinder(d=stroke+pinDia*2,h=3);
    translate([stroke/2,0,-13]) cylinder(d=1,h=3); 
    translate([stroke/2,0,-11.5]) %yoke();
    color("silver") translate([3,0,-11.5]) rotate([0,-90,0]) cylinder(d=rodDia,h=30);
    //scotch yoke  
    module yoke(){
      difference(){
        union(){
          hull() for(iy=[-1,1])
            translate([0,iy*(stroke/2+pinDia*1.5+minWallThck),0]) rotate([0,90,0]) 
              cylinder(h=minWallThck*2+pinDia,d=rodDia+minWallThck,center=true);
        }
        hull() for(iy=[-1,1])
          translate([0,iy*(stroke/2+pinDia),0]) cylinder(d=pinDia,h=rodDia+minWallThck+fudge,center=true);
        for (iy=[-1,1])
          translate([0,iy*(stroke/2+pinDia*1.5+minWallThck),0]) 
            rotate([0,90,0]) cylinder(h=minWallThck*2+pinDia+fudge,d=pinDia,center=true);
      }
      //rod connection
        translate([-((3+pinDia)/2+minWallThck),0,0]) rotate([0,90,0]){
          difference(){
            cylinder(d=rodDia+minWallThck,h=minWallThck*2+pinDia,center=true);
            cylinder(d=rodDia,h=minWallThck*2+pinDia+fudge,center=true);
        }
      }
        
    }
 }
  
  
}

