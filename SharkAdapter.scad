/* Shark Powerdetect Adapter */


include <BOSL2/std.scad>
include <BOSL2/threading.scad>

fudge=0.1;

$fn=50;


sharkAdapter();

module sharkAdapter(h=50){
  oDia=33.2;
  iDia=28.1;
  ripWdth=2.9;
  ripDepth=2.9;
  
  linear_extrude(h) shape();
  translate([0,0,h]) inlet();

  module inlet(){
    rad=1;
    rotate([90,0,0]) linear_extrude(ripWdth,center=true) difference(){
      hull() for (ix=[-1,1]){
        translate([ix*(oDia/2+ripDepth-rad),0]) circle(rad);
        translate([ix*(oDia/2-rad),ripWdth]) circle(rad);
      }
      translate([0,-(rad+fudge)/2]) square([oDia+ripDepth*2+fudge,rad+fudge],true);
      square([iDia,(ripWdth+rad)*2+fudge],true);
    }
    linear_extrude(ripWdth+rad) shape(false);
    translate([0,0,ripWdth+rad]) difference(){
      cylinder(d1=oDia,d2=oDia-1,h=3.3);
      translate([0,0,-fudge/2]) cylinder(d=iDia,h=3.3+fudge);
    }
  }

  module shape(rips=true){
    difference(){
      union(){
        circle(d=oDia);
        if (rips) square([oDia+ripDepth*2,ripWdth],true);
        }
        circle(d=iDia);
    }
  }
}


!vaccumBagAdapter();
module vaccumBagAdapter(){
  //adapter for packdude vacuum storage bags
  threadDia=22.5;
  threadLen=7.8;
  iDia=18.65;
  
  translate([0,0,threadLen/2]) difference(){
    threaded_rod(threadDia, threadLen, 2);
    cylinder(d=iDia,h=threadLen+fudge,center=true);
  }
  
  translate([0,0,threadLen]) 
    linear_extrude(10) difference(){
      circle(d=threadDia);
      circle(d=iDia);
    }
  
}