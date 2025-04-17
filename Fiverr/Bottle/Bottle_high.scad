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
capSpcng=0.4;
capHght=20;
btlRadii=10;

/* [Thread] */
threadThck=5;
threadAng=90;
threadHght=8;
threadCount=3;


/* [show] */
showBottle=true;
showCap=true;
showSectionCut=true;


/* [Hidden] */
fudge=0.1;
//polygon describing the outline of the bottle
btlPoly=[[-wallThck-btlRadii-fudge,0],[baseDia/2,0],[baseDia/2,baseHght],[neckDia/2,height-neckHght],
         [neckDia/2,height+wallThck+btlRadii+fudge],
         [-wallThck-btlRadii-fudge,height+wallThck+btlRadii+fudge]];

$fn=64;

// -- Assembly --
difference(){
  union(){
    if (showBottle)
      bottle();
    if (showCap)
      rotate(360/(threadCount*2)) translate([0,0,height-capHght+wallThck+capSpcng]) cap();
  }
  if (showSectionCut)
  color("darkRed") translate([(baseDia+fudge)/4,0,(height+capSpcng+wallThck)/2]) 
    cube([baseDia/2+fudge,baseDia+fudge,height+capSpcng+wallThck+fudge],true);
  
}

module bottle(){
  //bottle crossection to rotate extrude

  difference(){  
    union(){
      rotate_extrude(convexity=4) intersection(){
        bottleShape();
        square([baseDia/2+fudge,height]);
      }
      for (a=[0:360/threadCount:360])
        rotate(a) translate([0,0,height-threadHght-threadThck]) thread(h=threadHght,ang=threadAng,t=threadThck);
    }
 
  rotate_extrude(convexity=4)         
    intersection(){
      //substract offset to get wall
        offset(-wallThck) bottleShape();
    
      square([baseDia,height+fudge]);
    }
  }
  //thread
  
}


module bottleShape(){
  offset(btlRadii) 
    offset(-btlRadii) difference(){
      polygon(btlPoly);
      translate([baseDia/2+gripXOffset,gripZPos]) circle(gripRad);
    }   
  *square([baseDia/2+fudge,height]);
}

*cap();
module cap(){
  capDia=neckDia+threadThck+capSpcng*2+wallThck*2;
  difference(){
    rndCylinder(d=capDia,h=capHght,r=wallThck+capSpcng);
    translate([0,0,-fudge]) rndCylinder(d=capDia-wallThck*2,h=capHght-wallThck,r=capSpcng);
    }
  //grips for thread
  for (a=[0:360/threadCount:360])
    intersection(){
      rotate(a) translate([capDia/2,0]) cylinder(r=threadThck/2+wallThck,h=wallThck);
      cylinder(d=capDia,h=capHght);
    }
        
  module rndCylinder(d=10,h=5,r=2){
    rotate_extrude() 
      intersection(){
        offset(r) square([d/2-r,h-r]);
        square([d/2,h]);
      }
  }
}

*thread(h=9);
module thread(dia=neckDia,h=capHght, ang=90, t=2, iter=0){
  // we used a mechanism called "chain hull"
  slices=$fn/(360/ang);
  stepAng=ang/slices;
  stepHght=h/slices;
  
  if (iter<slices){
    hull(){
      rotate(iter*stepAng) translate([dia/2,0,iter*stepHght]) sphere(d=t);
      rotate((iter+1)*stepAng) translate([dia/2,0,(iter+1)*stepHght]) sphere(d=t);
    }
    thread(dia,h,ang,t,iter=iter+1);
  }
  
    
    
}