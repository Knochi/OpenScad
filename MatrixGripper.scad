/* Matrix Gripper Test 
  https://matrix-innovations.de/matrix-3d-spanntechnik/
  https://patents.google.com/patent/DE202012101508U1/de?assignee=Matrix+Gmbh+Spannsysteme+Und+Produktionsautomatisierung

*/

$fn=50;
/* [Pin Dimensions] */ 
pinTipSpcng=0.2;
pinClmpSpcng=0.1;
pinTipDia=5;
pinDia=3;
pinTipLen=8;
pinCount=[5,5];
fitSpcng=0.05;

/* [Dimensions] */
minWallThck=1.2;
boxWallThck=2;

/* [show] */
showPins=true;
showPlate=true;
showBox=true;

/* [Hidden] */
pinTravel=pinTipLen-pinTipDia/2;
test=[0,-2];
boxHght=pinTravel*3+minWallThck*2;
boxDims=[pinTipDia*pinCount.x+boxWallThck*2,pinTipDia*pinCount.y+boxWallThck*2,boxHght];
fudge=0.05;


if (showPins)
  quadGrid();
if (showPlate){
  translate([0,0,-minWallThck]) plate();
  translate([0,0,-(pinTravel*3+minWallThck*2)]) plate();
}
if (showBox)
  box();

module quadGrid(cut=false){
  pitch=[pinTipDia,pinTipDia];
  for (ix=[-(pinCount.x-1)/2:(pinCount.x-1)/2],iy=[-(pinCount.y-1)/2:(pinCount.y-1)/2]){
    zTravel= test==[ix,iy] ? pinTravel : 0;
    if (cut)
      translate([ix*pitch.x,iy*pitch.y,zTravel]) circle(d=pinDia+pinClmpSpcng);
    else
      translate([ix*pitch.x,iy*pitch.y,zTravel]) pin();
  }
}


module pin(){
  glueLen=(pinTipLen-pinTipDia/2)/2;
  flattening=0.2;
  
  tip();
  translate([0,0,-pinTravel-minWallThck]) 
    axis();
  translate([0,0,-(pinTravel*3+minWallThck)])
    clampBox();
  translate([0,0,-(pinTravel*4+minWallThck*2)])
    axis();
  
  

  module tip(){
    difference(){
      union(){
        linear_extrude(pinTipLen-pinTipDia/2) circle(d=pinTipDia-pinTipSpcng);
        translate([0,0,pinTipLen-pinTipDia/2]) sphere(d=pinTipDia-pinTipSpcng);
      }
      translate([0,0,-fudge]) linear_extrude(glueLen) offset(fitSpcng+fudge) circle(d=pinDia,$fn=4);
    }
  }
  module axis(){  
    difference(){
      union(){
        translate([0,0,pinTravel+minWallThck]) linear_extrude(glueLen-fitSpcng) 
            circle(d=pinDia,$fn=4);
        linear_extrude(pinTravel+minWallThck) circle(d=pinDia);
        translate([0,0,-glueLen+fitSpcng]) cylinder(d=pinDia,h=glueLen-fitSpcng,$fn=4);
      }
      translate([pinDia/2,0,(pinTravel+minWallThck)/2])
        cube([pinDia*flattening/2,pinDia,pinTravel+minWallThck+glueLen*2+fudge],true);
    }
  }
  
  module clampBox(){
    difference(){
      linear_extrude(pinTravel*2) square(pinTipDia-pinClmpSpcng,true);
      translate([0,0,pinTravel*2-glueLen]) linear_extrude(glueLen+fudge) offset(fitSpcng) circle(d=pinDia,$fn=4);
      translate([0,0,-fudge]) linear_extrude(glueLen+fudge) offset(fitSpcng) circle(d=pinDia,$fn=4);
    }
  }

}

*plate();
module plate(){
  linear_extrude(minWallThck) difference(){
    square([pinTipDia*pinCount.x+boxWallThck,pinTipDia*pinCount.y+boxWallThck],true);
    quadGrid(true);
  }
}

*box();
module box(){
 
  translate([0,0,-boxHght])
    difference(){
      //walls
      linear_extrude(boxHght, convexity=3) difference(){
        square([pinTipDia*pinCount.x+boxWallThck*2,pinTipDia*pinCount.y+boxWallThck*2],true);
        square([pinTipDia*pinCount.x,pinTipDia*pinCount.y],true);
      }
      //top and bottom recesses
      translate([0,0,-fudge]) linear_extrude(minWallThck+fudge, convexity=3)
        square([pinTipDia*pinCount.x+boxWallThck,pinTipDia*pinCount.y+boxWallThck],true);
      translate([0,0,boxHght-minWallThck]) linear_extrude(minWallThck+fudge, convexity=3)
        square([pinTipDia*pinCount.x+boxWallThck,pinTipDia*pinCount.y+boxWallThck],true);
      //slots to push on pins
      for (iy=[-1,1])
        translate([0,iy*(boxDims.y-boxWallThck)/2,boxHght/2]) cube([pinTipDia*pinCount.x,boxWallThck+fudge,pinTravel],true);
    }
}