$fn=30;

microServo();
module microServo(center=true){
  //2gramm servo
  //e.g. DS-M005B
  //https://www.dspowerservo.com/ds-m005b-0-5kg-high-precision-copper-gear-coreless-2g-micro-servo-product/
  
  bdyDims=[16.05,8.3,17.2];
  chamfer=1; //chamfer on the body
  flngHght=10.2; //height of the flange
  flngDrill=1.8; //drill diameter
  flngDrillDist=19.5;
  flngWdth=23.3; //overall width of the flange
  oShaftDia=3.8;
  oShaftLngth=4;
  oShaftOffset= flngDrillDist/2-5.82; //offset between body center and shaft
  grBxHght=3.2; //height of the gearbox
  
  cntrOffset=center ? [0,0,-bdyDims.z] : [0,0,0];
  
  translate(cntrOffset){
    //body
    translate([oShaftOffset,0,(bdyDims.z-grBxHght)/2]) cube([bdyDims.x,bdyDims.y,bdyDims.z-grBxHght],true);
    translate([0,0,(bdyDims.z-grBxHght)]) cylinder(d=bdyDims.y,h=grBxHght);
    //shaft
    translate([0,0,bdyDims.z]) cylinder(d=oShaftDia,h=oShaftLngth);
    
    //flange
  }
  
  
}