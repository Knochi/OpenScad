// Logitech Brio 100/105 Mount
// Instructions:
// Remove the small caps on the axis
// Remove screw on the right side of the cam (cable site, PH00)
// Push out axle with small screwdriver 

/* [Axle] */
axDia=2.8;
axLen=29.1;
axHeadThck=1.2;
axHeadDia=4;
axScrewHoleDia=1.5;
axScrewHoleLen=3.5;
axSpcng=0.1;

/* [Interface] */
intOutSegmWdth=12.1;
intInSegmWdth=7.85;
intSegmDia=6.5;
intDist=0.5;

/* [Hidden] */
fudge=0.1;
$fn=50;

intOvLen=intOutSegmWdth*2+intInSegmWdth;
axOffset=(intOvLen-axLen)/2;

*brioAxle();
module brioAxle(){
  difference(){
    union(){
      cylinder(d=axDia,h=axLen);
      cylinder(d=axHeadDia,h=axHeadThck);
      linear_extrude(intOutSegmWdth-axOffset) intersection(){
         square([axHeadDia,axDia],true);
         circle(d=axHeadDia);
       }
     }
    #translate([0,0,axLen-axScrewHoleLen]) cylinder(d=axScrewHoleDia,h=axScrewHoleLen+fudge);
  }
}

brioInterface();
translate([0,-intSegmDia/2-3/2-intDist,0]) cube([intOvLen,3,intSegmDia],true);
module brioInterface(){
  rotate([0,90,0]) difference(){
    for (iz=[-1,1])
      translate([0,0,iz*(intInSegmWdth+intOutSegmWdth)/2]){
        cylinder(d=intSegmDia,h=intOutSegmWdth,center=true);
        translate([0,-(intSegmDia/2+intDist)/2,0]) cube([intSegmDia,intSegmDia/2+intDist,intOutSegmWdth],true);
      }
    
    cylinder(d=axDia+axSpcng*2,h=intOvLen+fudge,center=true);
    translate([0,0,-(intOvLen+fudge)/2]){
      linear_extrude(intOutSegmWdth+fudge) intersection(){
        square([axHeadDia+axSpcng*2,axDia+axSpcng*2],true);
        circle(d=axHeadDia+axSpcng*2);
      }
      cylinder(d=axHeadDia+axSpcng*2,h=axOffset+axHeadThck+axSpcng);
    }
  }
}