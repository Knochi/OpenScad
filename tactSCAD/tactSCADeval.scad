/* Evaluation tactSCAD */

/* Sensor solutions 
  Digikey pre-filtered search - https://www.digikey.de/short/4mrjv5qt
  IQS7221E001QFR - https://www.digikey.de/de/products/detail/azoteq-pty-ltd/IQS7221E001QFR/22155141
  */
$fn=20;

/*  [Dimensions]  */
armWdth=20;
armThck=15;
upperArmLen=130;
lowerArmLen=100;
tableDia=150;
tableThck=10;
shoulderLen=100;

/* [Control] */
upperArmRotation=90; //[0:180]
lowerArmRotation=90; //[0:180]
penRotation=0; //[-90:0:90]


/* [Hidden] */
penAutoRot=-upperArmRotation-lowerArmRotation;

r1=cos(upperArmRotation)*upperArmLen;

echo(r1);
color("red") translate([shoulderLen-r1,0,tableThck]) sphere(2);

//table
cylinder(d=tableDia,h=tableThck);

//shoulder
arm(shoulderLen);

//upperArm
translate([shoulderLen,0,0]) rotate([0,upperArmRotation+180,0]){
  arm(upperArmLen);
  //lowerArm
  translate([upperArmLen,0,0]) rotate([0,lowerArmRotation+180,0]){
    arm(lowerArmLen);
    //pen
    translate([lowerArmLen,0,0]) rotate([0,penAutoRot+penRotation,0]) color("darkRed") cylinder(d=2,h=40,center=true);
  }
}




*arm();
module arm(length=100,hasEnd=true,hasStart=true){
  bearingDims=[15,10,4];
  
  *rotate([90,0,0]) bearing(center=true);
  *magSens();
  
  //simple arm
  rotate([90,0,0]) linear_extrude(armWdth,center=true) difference(){
    hull(){
      circle(d=armThck);
      translate([length,0]) circle(d=armThck);
    }
    circle(d=armThck/2);
    translate([length,0]) circle(d=armThck/2);
  }
}

module bearing(do=15,di=10,h=4,center=false){
  zOffset= center ? -h/2 : 0;
  translate([0,0,zOffset])
    linear_extrude(h) difference(){
      circle(d=do);
      circle(d=di);
    }
}


module magSens(){
  rad=3;
  pcbDims=[18,15,1.6];
  holeDist=11.5;
  holeDia=2.7;
  chipDims=[5.1,4,1.75];
  
  //pcb
  color("darkgreen") linear_extrude(1.6) difference(){
    offset(rad) square([pcbDims.x-rad*2,pcbDims.y-rad*2],true);
    for (iy=[-1,1])
      translate([0,iy*holeDist/2]) circle(d=holeDia);
  }
  //chip
  color("darkslategrey") translate([0,0,pcbDims.z]) linear_extrude(chipDims.z) square([chipDims.x,chipDims.y],true);
  
}