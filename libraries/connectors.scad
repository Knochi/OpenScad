$fn=20;
fudge=0.1;

XH(8,true);
module XH(pins,center=false){
  pitch=2.5;
  A=(pins-1)*2.5;
  B=A+4.9;
  outWdth=5.75;
  inWdth=4.1;
  inLngth=A+3.2;
  xOffset= center ? A/2 : 0;
  // pins
  color("silver")
    for (i=[0:pins-1])
      translate([i*2.5-xOffset,0,-3.4]) quadPin(0.64,3.4+7);
  // body
  color("white")
    translate([B/2-2.45-xOffset,0,7/2])
    difference(){
      translate() cube([B,outWdth,7],true);
      translate([0,0,1.5]) cube([inLngth,inWdth,7],true);
      translate([(B-1.5)/2-1.9,-(inWdth+1)/2+fudge,(-7-3.8)/2+7]) slotFrnt();
      translate([-((B-1.5)/2-1.9),-(inWdth+1)/2+fudge,(-7-3.8)/2+7]) mirror([1,0,0]) slotFrnt();
      if (pins==2) translate([0,-(inWdth+1)/2+fudge,(-7-3.8+fudge)/2+7]) cube([0.7,1,3.8+fudge],true)
      translate([(B-1)/2+fudge,-1,(-7-3.25)/2+7]) rotate([0,0,-90]) slotSide();
      translate([-(B-1)/2+-fudge,-1,(-7-3.25)/2+7]) rotate([0,0,-90]) slotSide();
    }
  
  module slotFrnt(){
    translate([0,0,-(3.8-1.5)/2]) rotate([90,0,0]) cylinder(d=1.5,h=1,center=true);
    translate([-0.75/2,0,fudge/2]) cube([0.75,1,3.8+fudge],true);
    translate([0,0,1.5/4+fudge/2]) cube([1.5,1,3.8-1.5/2+fudge],true);
   }
   module slotSide(){
    difference(){
      union(){
        translate([0,0,-(3.25-2)/2]) rotate([90,0,0]) cylinder(d=2,h=1,center=true);
        translate([0,0,1.5/4+fudge/2]) cube([2,1,3.25-1.5/2+fudge],true);
      }
      translate([(-1-fudge)/2,0,fudge/2]) cube([1+fudge,1+fudge,3.25+fudge*2],true);
    }
   }
}

//quadPin(0.64,5);
module quadPin(width,length,center=false){
  
  zOffset= center ? 0 : length/2;
  
  translate([0,0,zOffset]){
    cube([width,width,length-width],true);
    translate([0,0,(length-width)/2]) rotate(45) cylinder(d1=width*sqrt(2),d2=0.1,h=width/2,$fn=4);
    translate([0,0,-(length-width)/2]) rotate(45) mirror([0,0,1]) cylinder(d1=width*sqrt(2),d2=0.1,h=width/2,$fn=4);
  }
}
