sphereRad=250;
wallThck=1;

potTopWdth=70;
potHght=80;
potBrimHght=5;
potUpperWdth=63;

potPos=[-165,0,-80];
spcng=0.5;

strutThck=5;
fudge=0.1;

$fn=50;

//half sphere basin
module basin(radius=sphereRad, wallThck=wallThck, angle=180){
  
  rotate_extrude(angle=angle){
    intersection(){
      difference(){
        circle(radius+wallThck/2);
        circle(radius-wallThck/2);
      }
      translate([0,-sphereRad]) square([radius+wallThck,radius]);
    }
    translate([radius,0]) circle(d=wallThck);
  }
}

color("grey") basin();

translate(potPos) squarePot();

!holder();

module holder(){
  //ring
  translate(potPos+[0,0,-strutThck]) linear_extrude(strutThck) difference(){
    square(potUpperWdth+strutThck*2,true);
    offset(strutThck) square(potUpperWdth+spcng*2-strutThck*2,true);
  }


  holderArm();
  mirror([0,1,0]) holderArm();
}

//arm
module holderArm(){
    
  //connect to holder ring
  difference(){
    intersection(){
      translate([-sphereRad-strutThck,-potUpperWdth/2-strutThck,potPos.z-strutThck]) cube([sphereRad+potPos.x+strutThck,strutThck,abs(potPos.z)+strutThck*2]);
      union(){
        sphere(sphereRad-spcng);
        difference(){
          sphere(sphereRad+spcng+strutThck);
          translate([0,0,-(sphereRad+spcng+strutThck*2)]) cube((sphereRad+spcng+strutThck+fudge)*2,true);
        }
        }
    }
    intersection(){
      translate([-sphereRad,-potUpperWdth/2-strutThck-fudge/2,potPos.z]) cube([sphereRad+potPos.x+fudge,strutThck+fudge,abs(potPos.z)+strutThck+fudge]);
      sphere(sphereRad-spcng-strutThck);
    }
    basin(sphereRad,wallThck+2*spcng,360);
  }
}

*squarePot();  
module squarePot(topWdth=70, height=80,brimHght=5,upperWdth=63,botWdth=50,rad=5){
  sFact=upperWdth/botWdth;
  topRad=rad*sFact+(topWdth-upperWdth)/2;
  translate([0,0,-height+brimHght]) linear_extrude(height-brimHght,scale=sFact) offset(rad) square(botWdth-rad*2,true);
  *hull(){
    linear_extrude(0.1,scale=0) offset(rad) square(upperWdth-rad*2,true);
    mirror([0,0,1]) translate([0,0,height-brimHght-0.1]) linear_extrude(0.1,scale=0) offset(rad) square(botWdth-rad*2,true);
  }
  linear_extrude(brimHght) offset(topRad) square(topWdth-topRad*2,true);
}

m
  