/* openSCAD basic bottle example for vorgmindset */

//these are parameters you can set via customizer

/* [Dimensions] */
wallThck=1.2;
height=150;
baseDia=80;
baseHght=90;
neckDia=50;
neckHght=18;
gripRad=9;
gripZPos=75;
gripXOffset=5;
capSpcng=0.5;
capHght=12;

/* [show] */
showBottle=true;
showCap=true;
showSectionCut=false;


/* [Hidden] */
fudge=0.1;
//polygon describing the outline of the bottle
btlPoly=[[-wallThck-fudge,0],[baseDia/2,0],[baseDia/2,baseHght],[neckDia/2,height-neckHght],[neckDia/2,height+wallThck+fudge],
         [-wallThck-fudge,height+wallThck+fudge]];

$fn=50;

// -- Assembly --
difference(){
  union(){
    if (showBottle)
      bottle();
    if (showCap)
      translate([0,0,height-capHght+wallThck+capSpcng]) cap();
  }
  if (showSectionCut)
  color("darkRed") translate([(baseDia+fudge)/4,0,(height+capSpcng+wallThck)/2]) 
    cube([baseDia/2+fudge,baseDia+fudge,height+capSpcng+wallThck+fudge],true);
  
}

module bottle(){
  //bottle crossection to rotate extrude
  

  rotate_extrude()         
    intersection(){
      //substract offset to get wall
      difference(){
        bottleShape();
        offset(-wallThck) bottleShape();
      }
      square([baseDia,height]);
    }
  //inner
}

*bottleShape();
module bottleShape(){
  difference(){
    polygon(btlPoly);
    translate([baseDia/2+gripXOffset,gripZPos]) circle(gripRad);
    }   
}

*cap();
module cap(){
  difference(){
    cylinder(d=neckDia+capSpcng*2+wallThck*2,h=capHght);
    translate([0,0,-fudge]) cylinder(d=neckDia+capSpcng*2,h=capHght-wallThck+fudge);
    }
}
