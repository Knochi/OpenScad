$fn=20;


fudge=0.1;




raspberryPi(model="B");

module raspberryPi(rev=4, model="A+"){
  pcbHght=1.6;
  revNo=(model=="zero") ? 0 :
        (model=="A+")   ? 1 :
        (model=="B" )   ? 2 :
        (model=="B+")   ? 3 :
                          4 ;
  drillDims=[58,49];
  
  //            zero             A+                 B              B+      
  pcbDims=[[65,30,pcbHght],[65,56,pcbHght], [85,56,pcbHght], [85,56,pcbHght]];
  pcbOffset=[pcbDims[revNo].x/2-drillDims.x/2-3.5,0,-pcbHght];
  holeDims=1;
  headerPos=1;
  
  
  difference(){
    color("green") translate(pcbOffset) rndRect(pcbDims[revNo],3,0);
    for (ix=[-1,1],iy=[-1,1]){
      translate([ix*drillDims.x/2,iy*drillDims.y/2,-pcbHght-fudge/2])
        cylinder(d=2.5,h=pcbHght+fudge);
    }
  }
  
  translate([0,pcbDims[revNo].y/2-3.5,0]) pinHeader(40,2,center=true);
  if (model=="A+"){
    translate([pcbDims[revNo].x/2,-pcbDims[revNo].y/2+31.45,0]) rotate([0,0,90]) USBa();
    translate([pcbDims[revNo].x/2-11.5,-pcbDims[revNo].y/2,0]) audioJack();
  }

  
    if (rev<4) translate([32,0,0]) HDMI();
    translate([-drillDims.x/2+0.5,-drillDims.y/2+24.5,0]) rotate([0,0,90]) ZIF();
    translate([-drillDims.x/2+43,-pcbDims[revNo].y/2+11.5,0]) rotate([0,0,-90]) ZIF();
    translate([10.6,0,0]) mUSB();
    translate([0,19.9+14.6/2,-pcbHght])  rotate([0,0,-90]) mirror([0,0,1]) uSD();  
  
}



module pinHeader(pins, rows,center=false, diff="none", thick=3+fudge){
  
  cntrOffset= center ? [-(pins-rows)/rows*2.54/2,-(rows-1)*2.54/2,0]:0;
  pinLength=11.6;
  pinOffSet=1.53;
  
  translate(cntrOffset){
    if (diff=="pins"){
      translate([(pins-1)*2.54/2,0,0]) rndRect(pins*2.54,2.54,thick,1.27,0);
    }
    else if (diff=="housing"){
      translate([(pins-1)*2.54/2-fudge/2,-fudge/2,(thick)/2]) cube([pins*2.54+fudge,2.54+fudge,thick+fudge],true);
    }
    else {
      for (i=[0:pins/rows-1],j=[0:rows-1]){
        translate ([i*2.54,j*2.54,2.54/2]){
          color("DarkSlateGray")cube(2.54,true);
          color("gold") translate([0,0,pinOffSet]) cube([0.64,0.64,pinLength],true);
          difference(){
            
          }
        }
      }
    }
  }
}


module HDMI(){
  color("silver")
  translate([0,11.15,0])
    rotate([90,0,0])
      linear_extrude(12.15)
        polygon([[-5.4,0],[-6.625,1.2],[-7.85,1.7],[-7.85,6.2],[7.85,6.2],[7.85,1.7],[6.625,1.2],[5.4,0]]);
}

module ZIF(){
  //TE Part: 1-1734248-5
  translate([0,0,5.5/2]) cube([20.6,3,5.5],true);
}


module mUSB(){
  // amphenol-icc: 10103594-0001LF
  color("silver")
  translate([0,5/2-0.5,0]){
    translate([0,0,2.45/2]) cube([7.5,5,2.45],true);
    translate([0,-5/2-0.62/2,2.45/2]) cube([8.05,0.62,3],true);
  }
}


module audioJack(){
  // KyCON: STX-35017-4N
  difference(){
    union(){
      translate([0,14.5/2,5/2]) cube([6,14.5,5],true);
      translate([0,0,5/2]) rotate([90,0,0]) cylinder(d=5,h=2.5);
    }
    translate([0,-2.6,5/2]) rotate([-90,0,0]) cylinder(d=3.6,h=10);
  }
}


module USBa(){
  //e.g. ASSMANN A-USBS-A
  color("silver")
  translate([0,14/2-2,0]){
    translate([0,0,6.9/2]) cube([13.3,14,6.9],true);
    translate([0,-14/2-0.6/2,6.9/2]) cube([14.7,0.6,7.4],true);
  }
}

module uSD(){
  translate([0,14.6/2,1.7/2]) cube([14.6,14.6,1.7],true);
}

*rndRect([50,20,3],3,2);
module rndRect(size, rad, drill, center=false){  
  
  if (len(size)==2) //2D shape
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(drill);
    }
  else
    linear_extrude(size.z,center=center) difference(){
       hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(drill);
    }
}
