$fn=50;
use <threads.scad>

innerDia=30;
minWallThck=2;
maxSpoolDia=60;
maxSpoolWidth=75;
minSpoolWidth=55;
capHght=7;
minSpoolDia=innerDia+minWallThck*2;
gripCnt=5;
gripDia=10;
spcng=0.2;
fudge=0.1;

endCap(true);

module endCap(nut=true){
  difference(){
    union(){
      translate([0,0,minWallThck]) cylinder(d1=maxSpoolDia,d2=minSpoolDia,h=capHght);
      cylinder(d=maxSpoolDia,h=minWallThck);
      translate([0,0,minWallThck/2]) rotate_extrude() 
        translate([maxSpoolDia/2,0]) circle(d=minWallThck);
    }
    //if this is the nut cut a threat, else just a hole
    translate([0,0,-fudge/2]) 
      if (nut) 
        metric_thread(diameter=minSpoolDia+spcng*2,
                      pitch=2,
                      length=capHght+minWallThck+fudge,
                      internal=true,
                      leadin=0);
      else
        cylinder(d=innerDia,h=capHght+minWallThck+fudge);
    
    for (ir=[0:360/gripCnt:360-(360/gripCnt)])
      rotate(ir) translate([(maxSpoolDia+minWallThck)/2,0,-fudge/2]) 
        cylinder(d=gripDia,h=capHght+minWallThck+fudge);
  }
  if (!nut){
    difference(){
      union(){
        translate([0,0,capHght+minWallThck]) cylinder(d=minSpoolDia,h=minSpoolWidth);
        translate([0,0,capHght+minWallThck+minSpoolWidth]) 
          metric_thread(diameter=minSpoolDia,
                        pitch=2,
                        length=capHght+minWallThck+maxSpoolWidth-minSpoolWidth);
      }
    translate([0,0,capHght+minWallThck-fudge/2]) 
      cylinder(d=innerDia,h=capHght+minWallThck+maxSpoolWidth+fudge);
    }
  }
}