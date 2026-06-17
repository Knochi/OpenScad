include <BOSL2/std.scad>
include <BOSL2/threading.scad>



innerDia=4.5;
outerDia=8.7;
screwPitch=1.06;
screwSpcng=0.1;
lockSpcng=0;
height=7;
fudge=0.1;

/* [hidden] */
ri=sqrt(3)/2*outerDia/2;

$fn=64;

//screwPart
translate([0,0,height*2/3/2]) difference(){
  linear_extrude(height*2/3,center=true) circle(d=outerDia,$fn=6);
  threaded_rod(d=innerDia+screwSpcng*2,l=height*2/3+fudge, pitch=screwPitch, internal=true, bevel=true);
}

//lockPart
translate([0,0,height*2/3]) difference(){
  linear_extrude(height/3,convexity=4) difference(){
    circle(ri);
    circle(d=innerDia+lockSpcng);
  }
  translate([0,0,-fudge]) cylinder(d1=(innerDia+lockSpcng)*1.2,d2=innerDia+lockSpcng,h=(innerDia+lockSpcng)/2*0.2);
}

