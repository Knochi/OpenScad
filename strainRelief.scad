/* H-cable-strain-relief */


cableDia=2.85;
totalHght=6;
cntrWdth=4.6;
outrWdth=7.6;
ripThck=2;
ripSpcng=2.7;
tailLen=5;
sltWdth=0.83;
fudge=0.1;
$fn=50;

ovLen=ripThck*2+ripSpcng;
tailPoly=[[-outrWdth/2,0],[outrWdth/2,0],[cntrWdth/2,-tailLen],[-cntrWdth/2,-tailLen]];

difference(){
  linear_extrude(totalHght,convexity=4){
    difference(){
      union(){
        square([cntrWdth,ovLen],true);
        for (iy=[-1,1])
          translate([0,iy*(ripSpcng+ripThck)/2]) square([outrWdth,ripThck],true);
        //tail
        translate([0,-ovLen/2]) polygon(tailPoly);
      }
      for (i=[0:sltWdth*2:tailLen])
        translate([0,-ovLen/2-sltWdth/2-i]) square([outrWdth,sltWdth],true);
      }
      translate([0,-(ovLen+tailLen)/2]) square([cableDia,tailLen],true);
  }
  translate([0,-ovLen/2-tailLen-fudge/2,totalHght/2]) rotate([-90,0,0]){
    cylinder(d=cableDia,h=ovLen+tailLen+fudge);
    translate([0,-cableDia/4,(ovLen+tailLen+fudge)/2]) cube([cableDia,cableDia/2,ovLen+tailLen+fudge],true);
  }
  }