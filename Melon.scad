include <BOSL2/std.scad>
include <BOSL2/threading.scad>

/* [Dimensions]*/

oDia=120;
iDia=50;
iHght=85;
minWallThck=6;
fleshDia=100;

/* [show] */
showTop=true;
showThread=true;
showBottom=true;
showCut=false;

export="none"; //["flesh", "seeds", "body", "thread"]
/* [Hidden] */
threadPitch=2;
threadLen=10;
threadH=0.866 * threadPitch * 0.62;
fudge=0.1;
seedAng=30;

difference(){
  union(){
    if (showTop)
      melon(true);
    if (showBottom)
      melon();

    if (showThread && (export=="thread" || export=="none"))
      rotate(270) difference(){
        threaded_rod(d=iDia+threadH+2*minWallThck-0.4, l=threadLen*2, pitch=threadPitch, internal=false);
        cylinder(d=iDia,h=threadLen*2+fudge,center=true);
      }
  }
  if (showCut) color("darkRed") translate([oDia/2,0,0]) cube(oDia,true);
}
  
minFloorThck=0.6;
  
  
$fn=100;

module melon(isTop=false){
  cutOffset= isTop ? -oDia/2 : oDia/2;
  threadDia=iDia+threadH+2*minWallThck;
  
  difference(){
    if (export=="body" || export=="none")
    color("green") difference(){ body();
      translate([0,0,cutOffset]) cube(oDia,true);
    }
    
    if (export=="flesh" || export=="none")
      color("red") difference(){
        flesh();
        translate([0,0,cutOffset]) cube(oDia,true);
      }
    
    if (export=="seeds" || export=="none")
      color("black") difference(){
        seeds();
        translate([0,0,cutOffset]) cube(oDia,true);
      }
      
    if (export!="thread") threaded_rod(d=threadDia, l=threadLen*2+1, pitch=threadPitch, internal=true);  
    translate([0,0,-2]) cylinder(d1=threadDia-2,d2=threadDia + 2,h=2+fudge);
  }
  
  module body(){
    difference(){
      sphere(d=oDia);
      cylinder(d=iDia,h=iHght,center=true);
      cylinder(d=fleshDia,h=minFloorThck*2,center=true);
    }
  }
  module seeds(){
    linear_extrude(minFloorThck*2,center=true) for (ir=[0:seedAng:360-seedAng])
        rotate(ir) translate([(fleshDia)/2- 10,0]) rotate(90) seed();
  }
  module flesh(){
    translate([0,0,-minFloorThck]) linear_extrude(minFloorThck*2) difference(){
        circle(d=fleshDia);
        circle(d=iDia);
        for (ir=[0:seedAng:360-seedAng])
        rotate(ir) translate([(fleshDia)/2- 10,0]) rotate(90) seed();
      }
  }
}
  
module bottom(){
  union(){
    difference(){
      sphere(d=oDia);
      translate([0,0,oDia/2]) cube(oDia,true);
      cylinder(d=iDia,h=iHght,center=true);
      cylinder(d=fleshDia,h=minFloorThck*2,center=true);
      
    }
    color("red") translate([0,0,-minFloorThck]) linear_extrude(minFloorThck) difference(){
      circle(d=fleshDia);
      circle(d=iDia);
      for (ir=[0:seedAng:360-seedAng])
        rotate(ir) translate([(fleshDia)/2- 10,0]) rotate(90) seed();
    }
  }
  difference(){
    threaded_rod(d=iDia+threadH+2*minWallThck, l=threadLen, pitch=threadPitch, anchor=BOTTOM);
    translate([0,0,-fudge/2]) cylinder(d=iDia,h=threadLen+fudge);    
  }
  color("black") translate([0,0,-minFloorThck]) linear_extrude(minFloorThck) for (ir=[0:seedAng:360-seedAng])
        rotate(ir) translate([(fleshDia)/2- 10,0]) rotate(90) seed();
}

module thread(){
  
}

module seed(){
  offset(1) intersection_for(ix=[-1,1])
    translate([ix*7,0]) circle(d=16);
}