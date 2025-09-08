/* [basin] */
sphereRad=250;
wallThck=1;

/* [pot] */
potTopWdth=70;
potHght=80;
potBrimHght=5;
potUpperWdth=63;

potPos=[-165,0,-80];

/* [waterfall] */
wfDims=[40,80,7];
wfPos=[-150,0,-60];
hoseOuterDia=8;
minWallThck=2;
floorThck=3;

/* struts */
strutThck=5;
spcng=0.5;

/*[show]*/
variant="waterfall"; //["pot","waterfall"]
showBasin=true;

/* [Hidden] */

fudge=0.1;
$fn=50;


if (showBasin)
  color("grey") basin();

if (variant=="pot"){
  translate(potPos) squarePot();
  potHolder();
}
else{
  waterfall();
}




module potHolder(){
  //ring
  translate(potPos+[0,0,-strutThck]) linear_extrude(strutThck) difference(){
    square(potUpperWdth+strutThck*2,true);
    offset(strutThck) square(potUpperWdth+spcng*2-strutThck*2,true);
  }


  holderArm();
  mirror([0,1,0]) holderArm();
}

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


//arm
module holderArm(position=potPos){
    
  //connect to holder ring
  difference(){
    intersection(){
      translate([-sphereRad-strutThck,-potUpperWdth/2-strutThck,position.z-strutThck]) cube([sphereRad+position.x-potUpperWdth/2+strutThck,strutThck,abs(position.z)+strutThck*2]);
      union(){
        sphere(sphereRad-spcng);
        difference(){
          sphere(sphereRad+spcng+strutThck);
          translate([0,0,-(sphereRad+spcng+strutThck*2)]) cube((sphereRad+spcng+strutThck+fudge)*2,true);
        }
        }
    }
    intersection(){
      translate([-sphereRad,-potUpperWdth/2-strutThck-fudge/2,position.z]) cube([sphereRad+position.x+fudge,strutThck+fudge,abs(position.z)+strutThck+fudge]);
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

*waterfall();
module waterfall(){
  //a platform with a hole
  dist=sphereRad-0.5*sqrt(4*pow(sphereRad,2)-pow(wfDims.y,2));
  ovDims=wfDims+[dist+strutThck*2+wallThck+spcng*2,0,0];
  pos=[-sphereRad+ovDims.x/2-strutThck-wallThck/2-spcng,0,-ovDims.z/2];
  
  difference(){
    union(){
      difference(){
        intersection(){ //platform outer
          translate(pos) cube(ovDims,true);
          sphere(sphereRad-spcng-wallThck/2);
        }
        intersection(){ //hollow
          translate(pos+[0,0,floorThck]) cube(ovDims+[fudge,-minWallThck*2,0],true);
          sphere(sphereRad-spcng-wallThck/2-strutThck);
        }
      }
      translate(pos) cylinder(d1=hoseOuterDia*1.1+minWallThck*2,d2=hoseOuterDia*0.85+minWallThck*2,h=hoseOuterDia);
    }
    translate(pos+[0,0,-fudge/2]) cylinder(d1=hoseOuterDia*1.1,d2=hoseOuterDia*0.85,h=hoseOuterDia+fudge);
    
  }
  
}
  