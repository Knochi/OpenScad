//--- Style Guide ---
// 1. front/top view is the view on the connectors pins/sockets or the inserting direction
// 2. pin1 is the leftmost pin/contact
// 3. default origin for pinheaders is at pin1 (where it connects to the PCB)
// 3a. for plugs/sockets the PCB board edge is default origin
// 4. center=true will put the origin to the parts common center
// 5. "give2D" gives back different named 2D shapes for cutouts, drills etc
// 6. Colors: don't use white and black, use ivory and darkSlateGrey instead for contrast reasons

$fn=50;
fudge=0.1;


translate([-30,0,0]) XH(2);
translate([-15,0,0]) mUSB();
usbA();
translate([10,-4,0]) pinHeader(10,2);
translate([10,4,0]) pinHeader(5,1);
translate([10,8,0]) pinHeaderRA(10);
translate([35,0,0]) duraClik(2);
translate([35,10,0]) duraClikRA(2);
translate([55,0,0]) ETH();
translate([70,0,0]) screwTerminal(2,false);
translate([100,0,0]) DSub();
translate([130,0,0]) BIL30(col="red",panel=2);
translate([160,0,0]) SDCard(showCard=true);

!miniFitJr();
module miniFitJr(pins=8,rows=2,give2D="none"){
  pitch=4.2;
  A=(pins/rows-1)*pitch;
  B=A+5.4;
  C=A+10.8;
  D=A+5.8;
  
  ovBdDims=[B,23.9,9.6];
  cvtyDims=[4,10+fudge,4];
  hookPoly=[[0,0],[3,0],[3,1.4],[2,1.4]];
  
  if (give2D=="cutOut")
    union(){
      square([C,5.6],true);
      square([D,10],true);
      translate([0,(11.6-10)/2]) square([4,11.6],true);
    }
  else
    difference(){
      union(){
        cube(ovBdDims,true);
        translate([0,(ovBdDims.y-1)/2,0]) cube([ovBdDims.x+2,1,ovBdDims.z+2],true);
        for (ix=[-1,1],iz=[-1,1])
          translate([ix*ovBdDims.x/2,(ovBdDims.y-11.9)/2,iz*ovBdDims.z/2]) cube([2,11.9,2],true);
        translate([0,-ovBdDims.y/2,ovBdDims.z/2]) rotate([90,0,90]) 
          linear_extrude(height=3.4,center=true) polygon(hookPoly);
      }
      for(ix=[-(pins/rows-1)/2:(pins/rows-1)/2],iz=[-(rows-1)/2:(rows-1)/2])
        translate([ix*pitch,-(ovBdDims.y-cvtyDims.y)/2-fudge,iz*pitch]) cube(cvtyDims,true);
      translate([0,(ovBdDims.y-1)/2,(ovBdDims.z+1+fudge)/2]) 
        cube([4.6,1+fudge,1+fudge],true);
    }
  
}

*BIL30(give2D="");
module BIL30(col="red",panel=2,give2D="none"){
  //4mm Jack
  //Hirschmann BIL30 (SKS-kontakt.de)
  
  if (give2D=="cutOut")
    intersection(){
      circle(d=8.2);
      square([8.2+fudge,7.2],true);
    }
  else translate([0,0,5]) 
    mirror([0,0,1]){
    color(col) difference(){
      union(){
        cylinder(d=10,h=5);
        linear_extrude(7.5) intersection(){
          circle(d=8);
          square([8+fudge,7],true);
        }
        translate([0,0,5+panel]) cylinder(d=10,h=4.2);
      }
      translate([0,0,-fudge/2]) cylinder(d=4.5,h=18);
    }
    
    color("silver") difference(){
      union(){
        translate([0,0,1]) cylinder(d=6,h=17.5);
        translate([0,0,18.5]) cylinder(d1=6,d2=3.5,h=1);
        translate([0,0,19.5]) cylinder(d=3.5,h=4);
      }
      cylinder(d=4,h=18);
      translate([0,0,23.5-2.4/2]) cube([1.5,3.5+fudge,2.4+fudge],true);
    }
  }
}

module screwTerminal(pins=2,center=false){
  *translate([-(RM)/2,4.2,0]) rotate([90,0,0]) import("screwTerm.stl");
  
  RM=5.08;
  ovDims=[RM*(pins-1)+RM+1,8,10];
  baseHght=6.3;
  cntrOffset= center ? [-(RM/2) * (pins-1),0,0]:[0,0,0];
  poly=[[-3.8,0],[-3.8,baseHght],[-3.1,baseHght],[-2.5,10],[2.5,10],[4.2,baseHght],[4.2,0]];
  //body
  translate(cntrOffset) {
    color("DarkSlateGrey")  difference(){
      translate([-(RM+1)/2,0,0]) rotate([90,0,90]) linear_extrude(ovDims.x,convexity=2) polygon(poly);
      for (i=[0:pins-1]){
        translate([i*RM,0,ovDims.z-2]) cylinder(r=2,h=2+fudge);
        translate([i*RM,-3.8-fudge,1.2+1.5]) rotate([-90,0,0]) cylinder(d=3,h=5.8+fudge);
        translate([i*RM-2,-3.8-fudge,0.7]) cube([4,1.8+fudge,5]);
      }
    }
    for (i=[0:pins-1])
      color("silver") translate([i*RM,0,-3.5]) cylinder(d=1,h=3.5+fudge);
  }
}

*DSub(gender="male",give2D="cutOutBack");
module DSub(pins=9, gender="female", give2D=false){
  // DIN 41652-1
  
  //e.g. D-Sub 9 dims
  A=31.19; //sheet width
  E=12.93; //sheet height
  
  Bm=16.79; //male inner
  Bf=16.46; //female outer
  C=25; //drill dist
  G=6.12; // thick
  bodyDims=[19.2,10.72,4.1]; //bodywidth
  
  
  //fixed Dims
  Dm=7.9;
  Df=8.02;
  rFem=2.59;
  rMale=2.62;
  rSheet=1;
  sheetThck=0.8;
  
  if (give2D=="cutOutFront") { //CutOut for Front Mounted
    for (i=[-1,1])
      translate([i*C/2,0]) circle(d=3.1);
    hull() for (i=[-1,1]) {
        translate([i*17.98/2,8.81/2]) circle(2.11);
        translate([i*14.8/2,-8.81/2]) circle(2.11);
      }
  }
  
  else if (give2D=="cutOutBack") { //CutOut for Front Mounted
    for (i=[-1,1])
      translate([i*C/2,0]) circle(d=3.1);
    hull() for (i=[-1,1]) {
        translate([i*13.77/2,3.96/2]) circle(3.35);
        translate([i*12.01/2,-3.96/2]) circle(3.35);
      }
  }
  
  else {
    //sheet
    color("silver") difference(){
      hull(){
        for (i=[-1,1],j=[-1,1])
          translate([i*(A/2-rSheet),j*(E/2-rSheet),-sheetThck]) cylinder(r=rSheet,h=sheetThck);
      }
      for (i=[-1,1])
        translate([i*C/2,0,-sheetThck-fudge/2]) cylinder(d=3.05,h=sheetThck+fudge);
    }
    
    //plug
    color("darkSlateGrey")
    if (gender=="female")
      rndTrapez([Bf,Df,6],rFem);
    else
      difference(){
        rndTrapez([Bm+1.2,Dm+1.2,6],rMale+0.6);
        translate([0,0,fudge]) rndTrapez([Bm,Dm,6+fudge],rMale);
      } //else gender
    
    
    //body
    color("silver") translate([0,0,-bodyDims.z-sheetThck]) rndTrapez(bodyDims,rFem);
    } //else give2D
    
  //submodule
  module rndTrapez(size=[],rad){
  xOffsetRad=tan(10)*(size.y-2*rad); //tan(alpha)=(GK/AK)
    hull(){
      for (i=[-1,1]){
        translate([i*(size.x/2-rad),size.y/2-rad,0]) cylinder(r=rad,h=size.z);
        translate([i*(size.x/2-rad-xOffsetRad),-size.y/2+rad,0]) cylinder(r=rad,h=size.z);
      }
    }  
  } //module
  
}

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
  color("ivory")
    translate([B/2-2.45-xOffset,0,7/2])
    difference(){
      cube([B,outWdth,7],true);
      translate([0,0,1.5]) cube([inLngth,inWdth,7],true);
      translate([(B-1.5)/2-1.9,-(inWdth+1)/2+fudge,(-7-3.8)/2+7]) slotFrnt();
      translate([-((B-1.5)/2-1.9),-(inWdth+1)/2+fudge,(-7-3.8)/2+7]) mirror([1,0,0]) slotFrnt();
      if (pins==2) translate([0,-(inWdth+1)/2+fudge,(-7-3.8+fudge)/2+7]) cube([0.7,1,3.8+fudge],true);
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

*ETH();
module ETH(){
  //e.g. HALO HFJ11-2450E-L12RL
  ovDims=[15.88,21.59,13.64];
  cutOutDims=[16.66,14.72,-0.25]; //Z is offset from PCB top side
  pinsYOffset=-ovDims.y/2+10.9;
  difference(){
    color("silver") translate([0,0,ovDims.z/2]) cube(ovDims,true);
    color("darkSlateGrey") translate([-6,-ovDims.y/2-fudge,(ovDims.z-7)/2]) cube([12,12+fudge,7]);
  }
  //pins
  for (i=[-1,1]) {
    translate([i*11.43/2,pinsYOffset,-2]) cylinder(d=3,h=2+fudge);
    translate([i*11.43/2,pinsYOffset,-3]) cylinder(d1=2,d2=3,h=1);
    color("silver") translate([i*15.49/2,pinsYOffset+3.05,-3/2]) cube([0.4,1,3],true);
  }
  
}


module usbA(){
  outerDims=[13.3,14,5.8]; //from Assmann/Wuerth
  innerDims=[12.5,8.88,5.12]; //from USB.org
  tongDims=[11.1,8.38,1.84]; //from usb.org
  
  o2iOffset=[0,(outerDims.y-innerDims.y)/2,0];
  in2tngOffset=[0,(innerDims.y-tongDims.y)/2,tongDims.z/2];
  
  bodyHght=6.9;
  shellZOffset=-outerDims.z/2+bodyHght;
  shellThick=0.3;
  
  //sheet metal shell
  translate([0,0,shellZOffset]){
    rotate([90,0,0]) sheetBox([outerDims.x,outerDims.z,outerDims.y],shellThick,shellThick*2,inlay=outerDims.y-innerDims.y);
    color("ivory") translate(-o2iOffset+in2tngOffset + [0,fudge,0]) cube(tongDims,true);
  }
  //plastic spacer
  color("ivory")
  translate([0,-(7.95-outerDims.y)/2,(bodyHght-outerDims.z)/2]) cube([outerDims.x-shellThick*4,7.95,bodyHght-outerDims.z],true);
  //pins
  color("silver")
  for (i=[-3.5,-1,1,3.5]){
    translate([i,-outerDims.y/2+10.3+2.71,-3.4/2]) cube([0.8,0.25,3.4+fudge],true);
  }
  //flanges
  color("silver"){
  translate([0,-outerDims.y/2,bodyHght-outerDims.z-0.2]) 
    rotate([90,0,-90]) flange(1,innerDims.x,shellThick);
  translate([0,-outerDims.y/2,bodyHght+0.2]) 
    rotate([-90,0,-90]) flange(1,innerDims.x,shellThick);
  translate([-outerDims.x/2-0.2,-outerDims.y/2,bodyHght-outerDims.z/2]) 
    rotate([0,0,-90]) flange(1,innerDims.z,shellThick);
  translate([outerDims.x/2+0.2,-outerDims.y/2,bodyHght-outerDims.z/2]) 
    rotate([0,0,180]) flange(1,innerDims.z,shellThick);
  }
  
}

*pinHeader();
module pinHeader(pins=10, rows=2,center=false, diff="none", thick=3+fudge, 
       plugJmprCol=[]){
  
  cntrOffset= center ? [-(pins-rows)/rows*2.54/2,-(rows-1)*2.54/2,0]:[0,0,0];
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
        pinNo=(i*rows+1)+j;
        translate ([i*2.54,j*2.54,2.54/2]){
          color("DarkSlateGray")cube(2.54,true);
          color("gold") translate([0,0,pinOffSet]) cube([0.64,0.64,pinLength],true);
          if (plugJmprCol[pinNo-1]) translate([0,0,2.54/2]) 
          jumperWire(plugJmprCol[pinNo-1]);
        }
      }
    }
  }
}

*pinHeaderRA(pins=10,rows=3,center=false);
module pinHeaderRA(pins=10, rows=2,center=false, diff="none", thick=3+fudge, 
       plugJmprCol=[]){
  //Dimensions from MPE-Garry 088-2
  
  B=6; //hor. pin Length
  C=3.3;//vert. pin Length
  W=3.9; //bodyPosition
  A=B+W; //first row to tip dist.
  RM=2.54;
  
  pinSQ=0.64;
  bodyDims=[(pins/2)*RM,2.5,5];
  pinZOffset=(bodyDims.z-RM)/2;
  
  cntrOffset= center ? [-(pins-rows)/rows*2.54/2,-(rows-1)*2.54/2,0]:[0,0,0];
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
        elev=(rows-j-1)*RM;
        pinNo=(i*rows+1)+j;
        //angled pin
        color("gold") translate ([i*2.54,j*2.54,0]){ 
          translate([-pinSQ/2,-pinSQ/2,-C]) cube([pinSQ,pinSQ,C+pinZOffset+elev]);//vertical Pins
          translate([-pinSQ/2,0,elev-pinSQ/2+pinZOffset]) cube([pinSQ,A+elev,pinSQ]); //horiz pins
          translate([0,0,2.54/4+elev-pinSQ+pinZOffset]) rotate([0,90,0]) cylinder(d=pinSQ,h=pinSQ,center=true);
        }
        if (plugJmprCol[pinNo-1]) translate([i*2.54,W+2.5,elev+pinZOffset]) 
          rotate([-90,0,0]) jumperWire(plugJmprCol[pinNo-1]);
      }
      //body
      color("darkslategrey") translate([-RM/2,RM+W-2.5,0]) cube([(pins/rows)*RM,2.5,2.5*rows]);
    } //else
  }
}

module boxHeader(pins,center=false){
  fudge=0.1;
  RM=2.54;
  
  
  //Dimensions from WE PartNo: 612 0xx 216 21
  height=8.85;
  pinHght=11.5;
  ovDpth=8.85;
  inDepth=6.35;
  yWallThck=(ovDpth-inDepth)/2;
  A=RM*(pins/2-1);//pin to pin distance
  B=RM*(pins/2)+7.66; //overall Width
  C=RM*(pins/2-1)+7.88; //inner Width
  
  
  cntrOffset= center ? 0 : [RM*(pins/2-1)/2,RM/2,0];
  
  translate(cntrOffset){
    color("grey")
       difference(){
        translate([0,0,height/2]) cube([B,ovDpth,height],true);
        translate([0,0,(2.35+height)/2]) cube([C,6.35,height-2.35+fudge],true);
        translate([-(B-1.05-fudge)/2,0,6.4/2]) cube([(B-C)/2+fudge,3.3,6.4+fudge],true);//side nudges
        translate([(B-1.05-fudge)/2,0,6.4/2]) cube([(B-C)/2+fudge,3.3,6.4+fudge],true);
        translate([0,-(ovDpth-yWallThck)/2,(height-2.35)/2+2.35]) cube([4.5,yWallThck+fudge,height-2.35+fudge],true);
        color("ivory") translate([-B/2*0.7,-ovDpth/2-fudge,height*0.7]) rotate([-90,-30,0]) cylinder(d=2,h=fudge*2,$fn=3);
      }
      for (i=[0:pins/2-1],j=[-1,1]){
        color("gold") translate([-A/2+i*RM,RM/2*j,pinHght/2-3]) cube([0.64,0.64,pinHght],true);
      }
    }
}

module duraClikRA(pos=2,diff="none"){
  //Molex DuraClik Right Angle
  A=4+2*pos; //ovWith
  
  ovHght=6.4;
  baseHght=5.7;
  ovDpth=9.4;
  resess=[4,2.4+fudge,2.3+fudge];
  plug=[1+2*pos,5+fudge,4.7];
  plugZ=0.7;
  

  translate([0,ovDpth/2,0])
  if (diff=="housing"){
    translate([0,0,ovHght/2]) cube([A+fudge,ovDpth+fudge,ovHght+fudge],true);
  }
  
  else {
   color("Ivory")
    difference(){
      translate([0,0,ovHght/2]) cube([A,ovDpth,ovHght],true);//body
      translate([0,(-ovDpth+plug[1])/2-fudge,plug[2]/2+plugZ])
        difference(){//plug
          cube(plug,true);
          translate([0,-plug[1]/2+0.5,plug[2]/2-0.25+fudge]) cube([1.8,1,0.5],true);
        }
       translate([0,ovDpth/2-resess[1]/2+fudge,resess[2]/2-fudge]) cube(resess,true);
       translate([0,(ovDpth-resess[1])/2+fudge,(ovHght+resess[2]-fudge)/2]) cube([A+fudge,resess[1],ovHght-resess[2]+2*fudge],true);
    }
  }
}

//!duraClik(2);
module duraClik(pos=2,givePoly=false){
  A= (pos>2) ? 6.6+2*pos : 10.9;
  B= (pos>2) ? 3.7+pos*2 : 8;
  C= (pos>6) ? pos*2-0.9 : (pos>2) ? pos*2 : 0;
  D= (pos>5) ? 11.8 : (pos>2) ? -0.2+2*pos : 6.3;
  
  ovDpth=7.8;
  
  
  baseThck=3;
  scktThck=5.05;
  ovHght=baseThck+scktThck;
  resess=[4.3,1.6+fudge,7.2+fudge]; //resess
  
  iLckDpth=3;
  
  plug=[1+2*pos,4.7,5+fudge];
  plgY=2.3;
  
  
  if (givePoly) square([A,ovDpth],true);
  color("Ivory")
  difference(){
    union(){
      translate([0,0,baseThck/2]) cube([A,ovDpth,baseThck],true); //base
      translate([0,0,baseThck+(scktThck/2)-fudge/2]) cube([B-2,ovDpth,scktThck+fudge],true); //socket
      translate([0,0,baseThck+(scktThck/2)-fudge/2]) cube([B,iLckDpth,scktThck+fudge],true); //flange
    }
    translate([0,-(ovDpth-plug[1])/2+plgY,ovHght-plug[2]/2+fudge]) 
      difference(){
        cube(plug,true); //plug
        translate([0,-plug[1]/2+0.24,plug[2]/2-0.5+fudge]) cube([1.8,0.5,1],true);
      }
    if (C) {
      translate([-C/2,-(ovDpth)/2-fudge,-fudge/2]) cube([(C-D)/2,2.3,scktThck+fudge]);
      translate([D/2,-(ovDpth)/2-fudge,-fudge/2]) cube([(C-D)/2,2.3,scktThck+fudge]); 
    }
    else translate([0,-(ovDpth-resess[1])/2-fudge,resess[2]/2-fudge]) cube(resess,true); //resess
  
  }
  
}

*SDCard();
module SDCard(showCard=true){
  ovDims=[28.25,28,2.7];
  //e.g. Kyocera Series 5738
  translate([0,0,ovDims.z/2]) difference(){
    color("silver") cube(ovDims,true);
    translate([0,-(ovDims.y/2+10),0]) cylinder(d=28,h=ovDims.z+fudge,center=true);
 }
 if (showCard){
   color("darkblue") translate([0,-(ovDims.y-32)/2-7,ovDims.z-2.08/2-0.2]) cube([24.13,32,2.08],true);
   color("lightblue",0.5) translate([0,-(ovDims.y-5)/2-12,ovDims.z-2.08/2-0.2]) cube([24.13,5,2.08],true);
 }
}

*jumperWire();
module jumperWire(col="red",wireLen=5){
  
  color("darkSlateGrey") difference(){
    translate([0,0,7]) cube([2.6,2.6,14],true);
    translate([0,0,14-3/2]) cube([2.4,2.4,3+fudge],true);
  }
  color(col) translate([0,0,14-2]) cylinder(d=1.6,h=wireLen+2);
}

/* --- helper modules --- */
*sheetBox([20,10,15],0.5,2);
// metall sheet housing (e.g. for USB connector)
module sheetBox(outer=[20,10,15], thick=0.5, radius=1, inlay=0, inlayCol="ivory"){
  inRad= ((radius-thick)<=0) ? 0.1 : radius-thick;
  
  color("silver")
  translate([0,0,-outer.z/2])
    linear_extrude(outer.z)
      difference(){
        hull()
          for (i=[-1,1],j=[-1,1])
            translate([i*(outer.x/2-radius),j*(outer.y/2-radius)]) circle(radius);
        hull()
          for (i=[-1,1],j=[-1,1])
            translate([i*(outer.x/2-thick-inRad),j*(outer.y/2-thick-inRad)]) circle(inRad);
        
        }
   color(inlayCol)
    translate([0,0,-outer.z/2])
      linear_extrude(inlay)
        hull()
          for (i=[-1,1],j=[-1,1])
            translate([i*(outer.x/2-thick-inRad),j*(outer.y/2-thick-inRad)]) circle(inRad);
}

//quadPin(0.64,5);
module quadPin(width=0.64,length,center=false){
  
  zOffset= center ? 0 : length/2;
  
  translate([0,0,zOffset]){
    cube([width,width,length-width],true);
    translate([0,0,(length-width)/2]) rotate(45) cylinder(d1=width*sqrt(2),d2=0.1,h=width/2,$fn=4);
    translate([0,0,-(length-width)/2]) rotate(45) mirror([0,0,1]) cylinder(d1=width*sqrt(2),d2=0.1,h=width/2,$fn=4);
  }
}


module flange(dia, length, thick){ 
  intersection(){
    translate([0,0,-length/2]) cube([dia,dia,length]);
    difference(){
       cylinder(d=1,h=length-thick*2,center=true);
       cylinder(d=1-thick*2,length,center=true);
    }
  }
}

*testJack4mm();
module testJack4mm(hdCol="red"){
  color("silver") difference(){
    union(){
      translate([0,0,5]) cylinder(d=6,h=16);
      cylinder(d=3.4,h=5);
      translate([0,0,4]) cylinder(d1=3.4,d2=6,h=1);
    }
    translate([0,0,5]) cylinder(d=4,h=17+fudge);
  }
  color(hdCol)
    difference(){
      translate([0,0,22-9.2]) cylinder(d=9.7,h=9.2);
      translate([0,0,22-9.2-fudge/2]) cylinder(d=4.1,h=9.2+fudge);
    }
}





module mUSB(){
  //usb.org CabConn20.pdf
  
  M= 6.9;   //Rece inside width
  N= 1.85;  //Rece inside Height -left/right
  
  C= 3.5;   //Plastic width
  X= 0.6;   //plastic height
  U= 0.22;  //plastic from shell
  P= 0.48;  //Conntacst from plastic
  
  Q= 5.4;   //shell inside bevel width
  R= 1.1;   //shell inside bevel height -left/right
  
  S= 4.75;  //Latch separation 
  T= 0.6;   //Latch width -left/right
  V= 1.05;  //Latch recess
  W= 2.55;  //Latch recess
  Y= 0.56;  //Latch Height
  Z= 60;    //Latch Angle
  
  H= 2.6;   //Pin1-5 separation
  I= 1.3;   //Pin2-4 separation
  conWdth= 0.37; //# contact width
  
  
  conThck= 0.1; //contact thickness
  
  //JAE DX4R005J91
  r=0.25; //corner radius
  t=0.25; //sheet thickness
  
  //flaps
  flpLngth=0.6;
  flpDimTop=[6.2,flpLngth,t];
  flpDimBot=[5.2,flpLngth,t];
  flpDimSide=[0.75,flpLngth,t];
  
  flpAng=40;
  
  
  THT_OZ=-(5-1.8);
  legDim=[0.9,0.65-r/2,t];
  
  translate([0,-THT_OZ,0]){
    //THT pins
    color("silver"){
      for (ix=[-1,1]){
        translate([ix*(6.45/2-r),THT_OZ,t/2])
          rotate(ix*-90)
            bend(size=legDim,radius=r,angle=-90,center=true)
              flap(legDim);
      }
      translate([0,THT_OZ,t/2]) cube([6.45-r*2,0.9,t],true);  
    }
    
    //SMD pads
    padDim=[1,1,t];
    color("silver")
      for (ix=[-1,1]){
        translate([ix*(M+t)/2,-(padDim.x/2),r+t]) rotate([-90,0,ix*-90])
          bend(padDim,angle=-90,radius=r+t/2,center=true)
            flap(padDim);
        translate([ix*(M+t)/2,-(padDim.x/2),1.1/2+t/2+r])
          cube([t,padDim.x,1.1-r],true);
      }
      
    //SMD pins
      for (ix=[-H/2,-I/2,0,I/2,H/2]){
        color("gold")
        translate([ix,-0.7,r+conThck/2])
          rotate([-90,0,0])
            bend([conWdth,1-r,conThck],center=true,angle=90,radius=r)
              cube([conWdth,1-r,conThck],center=true);
        color("gold")
        translate([ix,-W/2-1-t,-X+t+N-(conThck)/2]) 
          cube([conWdth,W-fudge,conThck],true); 
     }
   
     
    //plastics
    color("darkSlateGrey")
      translate([0,-t,N/2+t])
        rotate([90,0,0])
         hull()
            for (ix=[-1,1],iy=[-1,1])
              translate([ix*(M/2-r),iy*(N/2-r)]) cylinder(r=r-0.01, h=1);
    color("darkSlateGrey")
       translate([0,-W/2-1-t,-X/2+t+N-U]) plastic();     
          
          
    //metal-body with cutouts
    color("silver"){
      difference(){
        shell();
        translate([0,THT_OZ,t+(t+1)/2]) cube([7.4+fudge,1,1+t],true);
        translate([0,-(1+t)/2+fudge/2,(t+1.1-fudge)/2]) cube([7.4+fudge,1+t+fudge,1.1+t+fudge],true);
        //Latch
        for (ix=[-1,1])
          translate([ix*S/2,THT_OZ,N+t*1.5]) cube([T,1.2,t+fudge],true);
      }
      //flaps
      translate([0,-5,N+t/2+t])
        rotate(180)
          bend(flpDimTop,angle=flpAng,radius=r,center=true)
            flap(flpDimTop);
      translate([0,-5,t/2])
        rotate(180)
        bend(flpDimBot,angle=-flpAng,radius=r,center=true)
          flap(flpDimBot);
      for (ix=[-1,1])
        translate([ix*(M+t)/2,-5,t+N-R/2])
          rotate([0,ix*-90,180])
            bend(flpDimSide,angle=flpAng,radius=r,center=true)
              flap(flpDimSide);
    }
  }
  
  module plastic(){
    difference(){
      cube([C,W,X],true);
      for (ix=[-H/2,-I/2,0,I/2,H/2])
        translate([ix,0,-X/2+(X-P+conThck-fudge)/2]) 
          cube([conWdth,W+fudge,X-P+conThck+fudge],true); 
    }
  }
  
  module shell(){
    translate([0,0,N-R/2+t])
      rotate([90,0,0]){
          difference(){ //2D
            shape(radius=r+t,length=5);
            translate([0,0,-fudge/2]) shape(radius=r,length=5+fudge);
          }
    }
  }

  //the usb shape
  module shape(radius=r,length=5){
    hull(){
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(M/2-r),iy*(R/2-r),0]) cylinder(r=radius,h=length);
      for (ix=[-1,1])
        translate([ix*(Q/2-r/2),-N+(R/2+r),0]) cylinder(r=radius,h=length);
    }
  }
 
  module flap(size){
    hull() for (ix=[-1,1])
      translate([ix*(size.x/2-r),size.y/2-r,0]) cylinder(r=r,h=size.z,center=true); 
    translate([0,-r/2,0]) cube([size.x,size.y-r,size.z],true);
  }
}


// bend modifier
// bends an child object along the x-axis
// size: size of the child object to be bend
// angle: angle to bend the object, negative angles bend down
// radius: bend radius, if center= false is measured on the outer if center=true is measured on the mid
// center=true: bend relative to the childrens center
// center=false: bend relative to the childrens lower left edge
// flatten: calculates only the stretched length of the bend and adds a cube accordingly


module bend(size=[50,20,2],angle=45,radius=10,center=false, flatten=false){
  alpha=angle*PI/180; //convert in RAD
  strLngth=abs(radius*alpha);
  i = (angle<0) ? -1 : 1;
  
  
  bendOffset1= (center) ? [-size.z/2,0,0] : [-size.z,0,0];
  bendOffset2= (center) ? [0,0,-size.x/2] : [size.z/2,0,-size.x/2];
  bendOffset3= (center) ? [0,0,0] : [size.x/2,0,size.z/2];
  
  childOffset1= (center) ? [0,size.y/2,0] : [0,0,size.z/2*i-size.z/2];
  childOffset2= (angle<0 && !center) ? [0,0,size.z] : [0,0,0]; //check
  
  flatOffsetChld= (center) ? [0,size.y/2+strLngth,0] : [0,strLngth,0];  
  flatOffsetCb= (center) ? [0,strLngth/2,0] : [0,0,0];  
  
  angle=abs(angle);
  
  if (flatten){
    translate(flatOffsetChld) children();
    translate(flatOffsetCb) cube([size.x,strLngth,size.z],center);
  }
  else{
    //move child objects
    translate([0,0,i*radius]+childOffset2) //checked for cntr+/-, cntrN+
      rotate([i*angle,0,0]) 
      translate([0,0,i*-radius]+childOffset1) //check
        children(0);
    //create bend object
    
    translate(bendOffset3) //checked for cntr+/-, cntrN+/-
      rotate([0,i*90,0]) //re-orientate bend
       translate([-radius,0,0]+bendOffset2)
        rotate_extrude(angle=angle) 
          translate([radius,0,0]+bendOffset1) square([size.z,size.x]);
  }
}
