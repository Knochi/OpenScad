/* Shark Powerdetect Adapter */
include <BOSL2/std.scad>
include <BOSL2/threading.scad>

shrkODia=33.2;
shrkIDia=28.1;
  
fudge=0.1;

$fn=50;

translate([0,0,20]) sharkAdapter(50);
vaccumBagAdapter();
tube(shrkODia,shrkIDia,20);

module sharkAdapter(h=60){
  
  ripWdth=2.9;
  ripDepth=2.9;
  
  linear_extrude(h) shape();
  translate([0,0,h]) inlet();

  module inlet(){
    rad=1;
    rotate([90,0,0]) linear_extrude(ripWdth,center=true) difference(){
      hull() for (ix=[-1,1]){
        translate([ix*(shrkODia/2+ripDepth-rad),0]) circle(rad);
        translate([ix*(shrkODia/2-rad),ripWdth]) circle(rad);
      }
      translate([0,-(rad+fudge)/2]) square([shrkODia+ripDepth*2+fudge,rad+fudge],true);
      square([shrkIDia,(ripWdth+rad)*2+fudge],true);
    }
    linear_extrude(ripWdth+rad) shape(false);
    translate([0,0,ripWdth+rad]) difference(){
      cylinder(d1=shrkODia,d2=shrkODia-1,h=3.3);
      translate([0,0,-fudge/2]) cylinder(d=shrkIDia,h=3.3+fudge);
    }
  }

  module shape(rips=true){
    difference(){
      union(){
        circle(d=shrkODia);
        if (rips) square([shrkODia+ripDepth*2,ripWdth],true);
        }
        circle(d=shrkIDia);
    }
  }
}


*vaccumBagAdapter();
module vaccumBagAdapter(anchor=[0,0,-1]){
  //adapter for packdude vacuum storage bags
  threadDia=22.5;
  threadLen=7.8;
  iDia=18.65;
  ovLen=20;
  
  cntrOffset= [threadDia/2*-anchor.x,threadDia/2*-anchor.y,ovLen/2*-anchor.z];
  
  translate(cntrOffset){
    //thread
    translate([0,0,-ovLen/2+threadLen/2]) difference(){
      threaded_rod(threadDia, threadLen, 2);
      cylinder(d=iDia,h=threadLen+fudge,center=true);
    }
    //adapter
    translate([0,0,-ovLen/2+threadLen]) 
      difference(){
        cylinder(d1=threadDia,d2=shrkODia,h=ovLen-threadLen);
        translate([0,0,0]) cylinder(d1=iDia,d2=shrkIDia,h=ovLen-threadLen);
      }
  }  
}

module tube(oDia=10,iDia=8,h=20,center=false){
  cntrOffset = center ? [0,0,-h/2] : [0,0,0];
  
  linear_extrude(h) difference(){
    circle(d=oDia);
    circle(d=iDia);
  }
}