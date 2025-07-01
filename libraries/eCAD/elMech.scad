
// KiCAD Colors
ledAlpha=0.1;
glassAlpha=0.39;

metalGreyPinCol=    [0.824, 0.820,  0.781];
metalGreyCol=       [0.298, 0.298,  0.298]; //metal Grey
metalCopperCol=     [0.7038,0.27048,0.0828]; //metal Copper
metalAluminiumCol=  [0.372322, 0.371574, 0.373173];
metalBronzeCol=     [0.714, 0.4284, 0.18144];
metalSilverCol=     [0.50754, 0.50754, 0.50754];
resblackBodyCol=    [0.082, 0.086,  0.094]; //resistor black body
darkGreyBodyCol=    [0.273, 0.273,  0.273]; //dark grey body
brownBodyCol=       [0.379, 0.270,  0.215]; //brown Body
lightBrownBodyCol=  [0.883, 0.711,  0.492]; //light brown body
pinkBodyCol=        [0.578, 0.336,  0.352]; //pink body
blueBodyCol=        [0.137, 0.402,  0.727]; //blue body
greenBodyCol=       [0.340, 0.680,  0.445]; //green body
orangeBodyCol=      [0.809, 0.426,  0.148]; //orange body
redBodyCol=         [0.700, 0.100,  0.050]; 
yellowBodyCol=      [0.832, 0.680,  0.066];
whiteBodyCol=       [0.895, 0.891,  0.813];
metalGoldPinCol=    [0.859, 0.738,  0.496];
blackBodyCol=       [0.148, 0.145,  0.145];
greyBodyCol=        [0.250, 0.262,  0.281];
lightBrownLabelCol= [0.691, 0.664,  0.598];
ledBlueCol=         [0.700, 0.100,  0.050, ledAlpha];
ledYellowCol=       [0.100, 0.250,  0.700, ledAlpha];
ledGreyCol=         [0.98,  0.840,  0.066, ledAlpha];
ledWhiteCol=        [0.895, 0.891, 0.813, ledAlpha];
ledgreyCol=         [0.27, 0.25, 0.27, ledAlpha];
ledBlackCol=        [0.1, 0.05, 0.1];
ledGreenCol=        [0.400, 0.700,  0.150, ledAlpha];
glassGreyCol=       [0.400769, 0.441922, 0.459091, glassAlpha];
glassGoldCol=       [0.566681, 0.580872, 0.580874, glassAlpha];
glassBlueCol=       [0.000000, 0.631244, 0.748016, glassAlpha];
glassGreenCol=      [0.000000, 0.75, 0.44, glassAlpha];
glassOrangeCol=     [0.75, 0.44, 0.000000, glassAlpha];
pcbGreenCol=        [0.07,  0.3,    0.12]; //pcb green
pcbBlackCol=        [0.16,  0.16,   0.16]; //pcb black
pcbBlue=            [0.07,  0.12,   0.3];
FR4darkCol=         [0.2,   0.17,   0.087]; //?
FR4Col=             [0.43,  0.46,   0.295]; //?


$fn=50;
fudge=0.1;

translate([70,0,0]) keyPad();
heatsink([9,9,5],5,3.5);
translate([12,0,0]) pushButton(col="red");
translate([12,15,0]) pushButton(col="green");
translate([12,30,0]) pushButton(col="white");
translate([-15,0,0]) rotEncoder();
translate([-15,30,0]) microStepper();
translate([30,0,0]) SMDSwitch();
translate([30,10,0]) CUI_TS02();
translate([-40,0,0]) AirValve();
translate([-80,0,0]) AirPump();
translate([-140,0,0]) SSR();
translate([120,0,0]) roundRocker20();
translate([120,0,0]) roundRocker20(true);
translate([140,0,0]) slideSwitch();
translate([180,0,0]) arcadeButton();
translate([220,0,0]) toggleSwitch();

*DIPSwitch();
module DIPSwitch(digits=6){
  //https://www.lcsc.com/product-detail/DIP-Switches_ROCPU-Switches-THS106J_C2758168.html
  //THS Series J-Hook
  width= (digits==10) ? 13.8 :
         (digits==8) ? 11.3 :
         (digits==6) ? 8.75 :
         (digits==4) ? 6.2  :
         3.7; //2
  bdyDims= [width,6.2,1.7];
  spcng=2.3-1.7;
  pitch=1.27;
  //terminals
  tWdth=0.4;
  tThck=0.2;
  tHght=2.3-0.45-tThck;
  tDist=7.1-tThck;
  tRad=0.15; //terminal bend Radius
  tZOffset=0.45; //offset from body top
  markDims=[0.9,0.9,0.2];
  //switches
  //cavity dimensions
  cvDims=[pitch*0.6,bdyDims.y*0.7,bdyDims.z*0.25];
  swLen=bdyDims.y*0.36;
  txtSize=(bdyDims.y-cvDims.y)/2*0.8;
  
  cavPoly=[[cvDims.y/2+fudge,fudge],[cvDims.y/2-cvDims.z,-cvDims.z],[swLen/2,-cvDims.z],[swLen/2,-cvDims.z*2],
          [-swLen/2,-cvDims.z*2],[-swLen/2,-cvDims.z],[-cvDims.y/2+cvDims.z,-cvDims.z],[-cvDims.y/2-fudge,fudge]];
  
  //body
  color(blackBodyCol) translate([0,0,bdyDims.z/2+spcng]) difference(){
    cube(bdyDims,true);
    //marking
    translate([bdyDims.x/2-markDims.x,bdyDims.y/2-markDims.y,bdyDims.z/2-markDims.z]) 
      linear_extrude(markDims.z+fudge) 
        polygon([[0,markDims.y+fudge],[markDims.x+fudge,markDims.y+fudge],[markDims.x+fudge,0]]);
    //cavities for switches
    for (ix=[-(digits-1)/2:(digits-1)/2])
      translate([ix*pitch,0,bdyDims.z/2]) rotate([90,0,90]) linear_extrude(cvDims.x,center=true) polygon(cavPoly);
  }
  //switches
  color(whiteBodyCol) 
    for (ix=[-(digits-1)/2:(digits-1)/2]){
      translate([ix*pitch,0,bdyDims.z/2+spcng]){
        translate([0,(swLen-cvDims.x)/2,0]) cylinder(d=cvDims.x,h=cvDims.z*2);
        cube([cvDims.x,swLen,cvDims.z/2],true);
      }
    }
      
  //terminals
  for (ix=[-(digits-1)/2:(digits-1)/2],iy=[-1,1]){
    rot = (iy<0) ? -90 : 90;
    color(metalGoldPinCol) 
      translate([ix*pitch,iy*bdyDims.y/2,bdyDims.z+spcng-tThck/2-tZOffset]) 
        rotate(rot) terminal();      
        }
  //text
  *color(lightBrownLabelCol) translate([-bdyDims.x/2*0.8,bdyDims.y/2-(bdyDims.y-cvDims.y)/4,bdyDims.z+spcng]) 
    linear_extrude(0.01) text("ON",size=txtSize,valign="center");
  *for (i=[0:digits-1])
    color(lightBrownLabelCol) 
      translate([-pitch*(digits-1)/2+i*pitch,-(bdyDims.y/2-(bdyDims.y-cvDims.y)/4),bdyDims.z+spcng]) 
        linear_extrude(0.01) text(str(1+i),size=txtSize,valign="center",halign="center");
    
  module terminal(){
    startLen=(tDist-bdyDims.y)/2-tRad-tThck/2;
    centerLen=tHght-tRad*2-tThck;
    endLen=(startLen+tRad)*2;
    
    translate([startLen/2,0,0]) cube([startLen,tWdth,tThck],true);
    translate([startLen,0,0]) bend();
    translate([startLen+tRad+tThck/2,0,-centerLen/2-tRad-tThck/2]) rotate([0,90,0]) cube([centerLen,tWdth,tThck],true);
    translate([startLen+tRad+tThck/2,0,-centerLen-tRad-tThck/2]) rotate([0,90,0]) bend();
    translate([-endLen/2+startLen,0,-centerLen-tRad*2-tThck]) cube([endLen,tWdth,tThck],true);
    
    module bend(){
      rotate([90,0,0]) 
        translate([0,-tRad-tThck/2,-tWdth/2])
          rotate_extrude(angle=90) 
            translate([tRad,0]) 
              square([tThck,tWdth]);
    }
  }
}

*Relay_WM686();
module Relay_WM686(){
  //body
  cube([45,45,45],true);
  //screw connectors
  for (ix=[-1,1]) translate([ix*29/2,0,-45/2]){
    translate([0,0,-16]) cylinder(d=6,h=16);
    translate([0,0,-3]) cylinder(d=8,h=3);
  }
}

*pushLever();
module pushLever(){
  //nav Style switch
  //LY-K3-01
  //there are variants with larger Keystoke (LY-K3-01A,B)
  //body
  translate([0,-4.1/2,2.5/2]) cube([11.8,4.1,2.5],true);

  //poles
  for (ix=[-1,1]) translate([ix*(5/2),0,-0.5]) cylinder(d=1,h=0.5);
}

*keyPad(cutPanel=false);
module keyPad(cutPCB=false, cutPanel=false, drillDia=1.6){
//https://www.adafruit.com/product/3845
//Dimensions taken from picture!
  
  rad=2.5;
  drill=2.1;
  keyDist=[14,13];
  drillDist=[46,59];
  keyDims=[8.5,7.5,2.5];
  bdyDims=[51,63,3.3]; //dimensions of the lower frame
  padDims=[46,56.8,3.5];
  padRad=4;
  keyCnt=[3,4];
  notchDims=[6.1,3];
  PCBDims=[36.7,5.6,1.6];
  pinsOffset=[17.9-PCBDims.x/2,2.54-PCBDims.y];//Offset of pinscenter to PCBcenter
  spcng=0.2;
  
  //cutOut
  if (cutPCB){
    for (ix=[-1,1], iy=[-1,1])
      translate([ix*(drillDist.x/2),iy*(drillDist.y/2)]) circle(d=drillDia);

    *hull() for (ix=[-1,1], iy=[-1,1])
      translate([ix*(drillDist.x/2-rad),iy*(drillDist.y/2-rad)]) circle(rad);
    for (ix=[0:8])
        translate([-10.7+ix*2.54,-3.4]+[0,-bdyDims.y/2,-3.1]) circle(d=0.8);
  }

  else if (cutPanel){
      hull() for (ix=[-1,1], iy=[-1,1])
        translate([ix*(padDims.x/2-padRad),iy*(padDims.y/2-padRad)]) circle(padRad+spcng);
      for (ix=[-1,1], iy=[-1,1])
        translate([ix*(drillDist.x/2),iy*(drillDist.y/2)]) circle(d=drillDia);
  }
  
  else{
    color("darkslateGrey") body();
    color("Grey") keys();
    color("darkGreen") translate([0,-bdyDims.y/2,-3.1])  PCB();
  }

  module body(){
    //lower part with screw holes
    translate([0,0,-bdyDims.z]) linear_extrude(bdyDims.z) difference(){
      hull() for (ix=[-1,1], iy=[-1,1])
        translate([ix*(bdyDims.x/2-rad),iy*(bdyDims.y/2-rad)]) circle(rad);
        for (ix=[-1,1], iy=[-1,1])
          translate([ix*(drillDist.x/2),iy*(drillDist.y/2)]) circle(d=drill);
        translate([0,(bdyDims.y-notchDims.y)/2]) square(notchDims,true);
    }
    //upper part "the pad" with keys
    linear_extrude(5.4) hull() for (ix=[-1,1], iy=[-1,1])
        translate([ix*(padDims.x/2-padRad),iy*(padDims.y/2-padRad)]) circle(padRad);
  }
  
  module keys(){
    for (ix=[-(keyCnt.x-1)/2:(keyCnt.x-1)/2],iy=[-(keyCnt.y-1)/2:(keyCnt.y-1)/2]){
      translate([ix*keyDist.x,iy*keyDist.y,8.6-3.1+keyDims.z/2]) cube(keyDims,true);
    }
  }
  
  module PCB(){
    echo(pinsOffset);
    linear_extrude(PCBDims.z) difference(){
      translate([0,-PCBDims.y/2]) square([PCBDims.x,PCBDims.y],true);
      for (ix=[-8/2:8/2]) //holes for pinheader
      //translate([-10.7+ix*2.54,-3.4]) circle(d=0.8); //0:8
        translate([ix*2.54,0]+pinsOffset) circle(d=0.8);
    }
  }
}


module keyPadPhone(bdyDims=[51,64,8.5],keyCnt=[3,4],cut=false){

  rad=2.5;
  drill=2.5;
  keyDist=[14,13];
  drillDist=[46,57];
  keyDims=[8.5,7.5,2.5];
  notchDims=[6.5,2.6];
  
  if (cut){
    for (ix=[-1,1], iy=[-1,1])
      translate([ix*(bdyDims.x/2-rad),iy*(bdyDims.y/2-rad)]) circle(d=2.5);
    hull() for (ix=[-1,1], iy=[-1,1])
      translate([ix*(drillDist.x/2-rad),iy*(drillDist.y/2-rad)]) circle(rad);
  }
  
  
  body();
  keys();
  
  
  module body(){
    translate([0,0,-3.1]) linear_extrude(3.1) difference(){
      hull() for (ix=[-1,1], iy=[-1,1])
        translate([ix*(bdyDims.x/2-rad),iy*(bdyDims.y/2-rad)]) circle(rad);
        for (ix=[-1,1], iy=[-1,1])
          translate([ix*(bdyDims.x/2-rad),iy*(bdyDims.y/2-rad)]) circle(d=drill);
        translate([0,-(bdyDims.y-notchDims.y)/2]) square(notchDims,true);
    }
    linear_extrude(5.4) hull() for (ix=[-1,1], iy=[-1,1])
        translate([ix*(46/2-rad),iy*(57/2-rad)]) circle(rad);
  }
  
  module keys(){
    for (ix=[-(keyCnt.x-1)/2:(keyCnt.x-1)/2],iy=[-(keyCnt.y-1)/2:(keyCnt.y-1)/2]){
      translate([ix*keyDist.x,iy*keyDist.y,8.6-3.1+keyDims.z/2]) cube(keyDims,true);
    }
  }
}

*CUI_TS02();
module CUI_TS02(height=11, longTerminals=false){
  /*https://www.cuidevices.com/product/resource/ts02.pdf
  available heights (SCR and LCR): 
    4.3, 5.0, 6.0, 7.0, 7.3, 8.0
    9.0, 9.5, 10.0, 11.0, 12.0, 13.0, 15.0, 15.3, 17.0
  LCR only: 
    5.5, 14.0, 16.0
  */
  
  bdyDims=[6,6,3.5];
  tThck=0.2; //terminal thickness
  tWdth=0.7;
  tHght=0.75; //height of bend (centerline)
  tLngth=(10-5)/2-0.75;
  
  //body
  translate([0,0,(bdyDims.z-tThck)/2]) color("darkSlateGrey") cube(bdyDims+[0,0,-tThck],true);
  translate([0,0,bdyDims.z-tThck/2]) color("silver") difference(){
    cube([bdyDims.x,bdyDims.y,tThck],true);
    cylinder(d=3.6,h=tThck+fudge,center=true);
  }
  
 //actuator
  translate([0,0,bdyDims.z-tThck]) color("darkSlateGrey") 
    cylinder(d=3.5,h=height-bdyDims.z+tThck);
  
  module terminal(){
    cube();
  }
  
}

module CUI_TS04(height=9.5){
  bdyDims=[6,6,3.5];
  tThck=0.2; //terminal thickness
  tWdth=0.7;
  tHght=0.75; //height of bend (centerline)
  tLngth=(10-5)/2-0.75;
  
  //body
  translate([0,0,(bdyDims.z-tThck)/2]) color("darkSlateGrey") cube(bdyDims+[0,0,-tThck],true);
  translate([0,0,bdyDims.z-tThck/2]) color("silver") difference(){
    cube([bdyDims.x,bdyDims.y,tThck],true);
    cylinder(d=3.6,h=tThck+fudge,center=true);
  }
  
 //actuator
  translate([0,0,bdyDims.z-tThck]) color("darkSlateGrey") 
    cylinder(d=3.5,h=height-bdyDims.z+tThck);
  
  //terminals
  for (ix=[-1,1],iy=[-1,1]){
    translate([ix*(10-0.75)/2,iy*4.5/2,tThck/2])
      color("silver") cube([0.75,tWdth,tThck],true);
    translate([ix*(10/2-0.75),iy*4.5/2,tThck/2]){
      rotate([90,0,0]) color("silver") cylinder(d=tThck,h=tWdth,center=true);
      translate([0,0,tHght/2]) color("silver") cube([tThck,tWdth,tHght],true);
      translate([0,0,tHght]) rotate([90,0,0]) color("silver") cylinder(d=tThck,h=tWdth,center=true);
    }
    translate([ix*((10-tLngth)/2-0.75),iy*4.5/2,tHght+tThck/2]) 
      color("silver") cube([tLngth,tWdth,tThck],true);
  }
}


*rotarySwitchAlpha();
module rotarySwitchAlpha(){
  
  //body
  color("ivory") translate([0,0,2]) cylinder(d=26,h=10.5/2);
  color("darkSlateGrey"){
    translate([0,0,2+10.5/2]) cylinder(d=26,h=10.5/2);
    translate([0,0,14.2-2]) cylinder(d=17.3,h=2);
    translate([0,0,14.2]) cylinder(d=10,h=8);
    translate([-9.5,0,12.5]) cylinder(d=3,h=4);
    translate([0,0,14.2+8]) linear_extrude(30)
      difference(){
        circle(d=6);
        translate([0,3]) square([6,3],true);
      }
    }
  //pins
  for(ir=[90-15:90:375])
    color("silver") rotate(ir) translate([11,0,5.4/2-3.4]) cube([0.2,1,5.4],true);
  color("silver") rotate(90+45) translate([4,0,5.4/2-3.4]) cube([0.2,1,5.4],true);
}

*PT15();
module PT15(rotor="R",center=true){
  cntrOffset= center ? [[0,0,0],[0,0,0]] : [[0,0,10],[90,0,0]];
  //body
  translate(cntrOffset[0]) rotate(cntrOffset[1]){
     linear_extrude(6) difference(){
      circle(d=15);
      circle(d=5);
    }
    difference(){
      color("ivory") translate([0,0,0.5]) cylinder(d=5,h=5);
      linear_extrude(6) rotorR();
    }
  }

  module rotorR(){
    difference(){
            circle(d=4);
            translate([-(4.02+fudge)/2,4.02/2-(4.02-3.52),0]) square(4.02+fudge);
          }
  }
}

module microStepper(angle=0){
  //Machifit GA12BY15
  color("gold") translate([0,0,-9/2]) cube([12,10,9],true); //gearbox
  
  color("silver"){
    //shaft
    rotate(angle){
      difference(){
        cylinder(d=3,h=10);
        translate([3-0.5,0,1+9/2]) cube([3,3,9+fudge],true);
      }
      cylinder(d=4,h=0.8);
    }
    //motor body
    translate([0,0,-19.8]) cylinder(d=12,h=10.8);
  }
}


module SSR(){
  //Solid State Relay
  //e.g. Fotek SSR-40 DA

  bdDims=[60,45.4,22.1];
  pltDims=[62.5,44.4,2.65];
  color("whiteSmoke") translate([0,0,1.1]) body();
  color("silver") plate();

  module body(){
    sltWdth=(bdDims.x-37-10)/2;
    difference(){
      translate([0,0,bdDims.z/2])  cube(bdDims,true);
      //mounting holes
      for (ix=[-1,1]){
        translate([ix*(37+10)/2,0,-fudge/2]) cylinder(d=10,h=bdDims.z+fudge);
        translate([ix*((bdDims.x-sltWdth)/2+fudge),0,bdDims.z/2]) cube([sltWdth+fudge,10,bdDims.z+fudge],true);
      }
      //screw terminals
      for (ix=[-1,1],iy=[-1,1]){
        translate([ix*((bdDims.x-11.6)/2+fudge),iy*(16.75+10.8)/2,bdDims.z-8/2]) cube([11.6+fudge,10.8,8+fudge],true);
      translate([0,0,bdDims.z-0.8/2]) cube([30.25,43.3,0.8+fudge],true);
        
      }
    }
  }

  module plate(){
    linear_extrude(pltDims.z) difference(){
      square([pltDims.x,pltDims.y],true);
      translate([(pltDims.x-4.8)/2-4.6,0]) circle(d=4.8);
      translate([-((pltDims.x-7.3)/2-3.75),0])
        hull() for (ix=[-1,1])
            translate([ix*(7.3-4.4)/2,0]) circle(d=4.4);
    }
  }


}

*MEN1281();
module MEN1281(){
  for (ix=[-1,1]){
    translate([ix*(10-2.5)/2,0,1.2])
      cube([2.5,5,2.4],true);
    translate([ix*(10-2.5)/2,0,-3.1]) cylinder(d=2.5,h=3.1);
    }
    translate([0,0,5.4]) cylinder(d=3,h=7-5.4);
    translate([0,1.5,2.4]) rotate([90,0,0]) 
      linear_extrude(3) 
        polygon([[-5,0],[-5,1],[-5+1.6,1],[-1.5,3],
                 [1.5,3],[5-1.6,1],[5,1],[5,0]]);
    
}
*AirPump();
module AirPump(){
  //CJP37-C12A2
  mtrDia=24.1;
  mtrLngth=31;
  bdyDia=27.1;
  bdyLngth=27.3;
  rad=1;
  flngDims=[36.6,10];
  
  color("grey") cylinder(d=mtrDia,h=mtrLngth);
  color("ivory") translate([0,0,mtrLngth+0.6]) cylinder(d=bdyDia,h=bdyLngth);
  color("silver"){
    hull(){
      translate([0,0,mtrLngth]) cylinder(d=bdyDia+0.6,h=0.6);
      translate([29.8-rad-(bdyDia+0.6)/2,-(bdyDia+0.6)/2+36.6/2,mtrLngth+0.3]) 
        cube([0.1,36.6,0.6],true);
    }
  //flange
    translate([29.8-rad-(bdyDia+0.6)/2,flngDims.x-(bdyDia+0.6)/2,mtrLngth]) rotate(-90)
      bend([flngDims.x,0,0.6],90,rad) 
        linear_extrude(0.6) difference(){
          union(){
            hull() for (ix=[0,1]) 
              translate([ix*(flngDims.x-rad*2)+rad,flngDims.y-rad*2]) circle(rad);
            translate([0,0]) square([flngDims.x,flngDims.y-2*rad]);
          }
        translate([4.3/2+2.5,flngDims.y-rad-4.3/2-2.5]) circle(d=4.3);
      }
    }
  //pipe
    color("ivory") translate([0,0,mtrLngth+bdyLngth]){ 
      cylinder(d=4,h=5.3);
      translate([0,0,5.3]){
        cylinder(d=4.8,h=1);
        translate([0,0,1]) cylinder(d1=4.8,d2=3,h=3);
      }}
}

*AirValve();
module AirValve(clamp=false){
  // CEME 5000EN1,5P; SH-V08298C-R(C1)4
  
  bdyDia=23.5;
  bdyLngth=30;
  pipDia=4.9;
  
  clmpDims=[38,15,30];
  clmpSpcng=1;
  clmpDrill=4.2;
  
  clmpOffset= (clamp) ? [0,-bdyLngth/2,bdyDia/2+(clmpDims.z-bdyDia)/2] : [0,0,0];
  
  translate(clmpOffset) rotate([-90,0,0]){
    //body
    color("teal") cylinder(d=bdyDia,h=bdyLngth);
    
    //contacts
    for (ix=[-1,1]){
      color("teal") translate([ix*16.8/2,0,-1.2]) cube([4,7.5,2.4],true);
      color("silver") translate([ix*16/2,0,-13.4/2]) cube([0.6,6.5,13.4],true);
    }
    //pipes
    color("ivory"){
      translate([0,0,bdyLngth]) cylinder(d=12,h=7.2);
      translate([0,0,bdyLngth+7-pipDia/2]) rotate([90,0,0]) pipe(31.7-6);
      translate([0,0,bdyLngth+7]) pipe(11.3);
    }
  }
  //clamp
  if (clamp)
    color("darkSlateGrey") clamp();
  
  module pipe(length=30){
    tipLngth=5.5;
    tipDia=4.5;
    pipDia=5.0;
    //tip
    translate([0,0,length-tipLngth]){
      cylinder(d=tipDia,h=tipLngth);
      cylinder(d1=5.5,d2=tipDia,h=1.5);
    }
    cylinder(d=pipDia,h=length-tipLngth);
  }
  
  module clamp(){
    hlfClmpDims=[clmpDims.x,clmpDims.y,(clmpDims.z-clmpSpcng)/2];
    drillDist=bdyDia+fudge+(clmpDims.x-bdyDia)/2-fudge; //is in middle of remaining space
    minWallThck=(clmpDims.z-bdyDia-fudge*2)/2;
    
    difference(){
      union(){
        difference(){
          translate([0,0,clmpDims.z/2]){
            rotate([90,0,0]) cylinder(d=bdyDia+fudge*2+minWallThck*2,h=clmpDims.y,center=true);
            translate([0,0,(clmpSpcng+minWallThck)/2]) 
              cube([clmpDims.x,clmpDims.y,minWallThck],true);
          }
          translate([0,0,(hlfClmpDims.z+clmpSpcng-fudge)/2])
            cube(hlfClmpDims+[fudge,fudge,clmpSpcng+fudge],true);
        }
        translate([0,0,hlfClmpDims.z/2]) cube(hlfClmpDims,true);
      }
        
      translate([0,0,clmpDims.z/2]) rotate([90,0,0]) 
        cylinder(d=bdyDia+fudge*2,h=clmpDims.y+fudge,center=true);
      for (ix=[-1,1])
        translate([ix*drillDist/2,0,-fudge/2]) cylinder(d=clmpDrill,h=clmpDims.z+fudge);
    }//diff
  }
}

*AlphaPot();
module AlphaPot(size=9, shaft="T18", vertical=true){
  ovDim=[9.5,6.5+4.85,10];
  yOffset=ovDim.y/2-6.5;
  
  
  translate([0,yOffset,ovDim.z/2]) cube(ovDim,true);
  translate([0,0,ovDim.z]) cylinder(d=7,h=5);
  translate([0,0,ovDim.z]) shaft();
  
  module shaft(){
    L=15;
    F=7;
    T=6;
    M=1;
    C1=0.5; //chamfer at Tip
    C2=0.25; //chamfer at middle
    dia=6;
    difference(){
      union(){
        translate([0,0,L-C1]) cylinder(d1=dia,d2=dia-C1*2,h=C1);
        translate([0,0,L-T+C2]) cylinder(d=dia,h=T-C1-C2);
        translate([0,0,L-T]) cylinder(d1=dia-C2*2,d2=dia,h=C2);
        translate([0,0,L-F]) cylinder(d=dia-C2*2,h=M);
        translate([0,0,L-F-C2]) cylinder(d1=dia,d2=dia-C2*2,h=C2);
        translate([0,0,5]) cylinder(d=dia,h=L-F-C2-5);
      }
      translate([0,0,L-F+(F+fudge)/2]) cube([dia+fudge,1,F+fudge],true);
    }
  }
}


*SMDSwitch();
module SMDSwitch(){
  translate([0,0,1.4/2]) cube([6.7,2.6,1.4],true);
  //pins
  for (ix=[-1,1],iy=[-1,1])
    color("silver") translate([ix*(6.7+0.5)/2,iy*(2.6-0.4)/2,0.15/2]) cube([0.5,0.4,0.15],true);
  for (ix=[-1,1]){
  color("silver") translate([ix*4.5/2,-(1.25+2.6)/2,0.15/2]) cube([0.4,1.25,0.15],true);
  color("white") translate([ix*1.5/2,0,1.4+1.5/2]) cube([1.3,0.65,1.5],true);
  }
  
  color("silver") translate([4.5/2-3,-(1.25+2.6)/2,0.15/2]) cube([0.4,1.25,0.15],true);
  //stem
  
  //studs
  for (ix=[-1,1])
    translate([ix*3/2,0,0]){
      translate([0,0,-0.3]) cylinder(d=0.75,h=0.3);
      translate([0,0,-0.5]) cylinder(d1=0.4,d2=0.75,h=0.2);
    }
}

*Button_1188E();
module Button_1188E(){
  shtThck=0.2;
  bdDims=[7,2.5-shtThck,3.5];
  btDims=[3,1,1.4];
  //body
  color("ivory") translate([0,shtThck/2,bdDims.z/2]) cube(bdDims,true);
  translate([0,-bdDims.y/2,0]) sheet();
  //button
  color("darkSlateGrey") translate([0,-(bdDims.y+btDims.y)/2,bdDims.z/2]) cube(btDims,true);
  //stems & pins
  for (ix=[-1,1]){
    color("ivory") translate([ix*2.3/2,-0.4,-0.75]) 
      cylinder(d=0.7,h=0.75);
    color("silver") translate([ix*4.2/2,(bdDims.y+0.6)/2,shtThck/2]) cube([0.6,0.6,shtThck],true);
  }
  
  module sheet(){
    difference(){
      union(){
        color("silver") translate([0,0,bdDims.z/2]) cube([bdDims.x,shtThck,bdDims.z],true);
        color("silver") translate([0,0,0.7/2]) cube([7.8-shtThck*2,shtThck,0.7],true);
        color("silver") translate([7.8/2-shtThck,0,0.7/2]) rotate([0,-90,-90]) 
          bend([0.7,0.4,shtThck],90,0.2,true) cube([0.7,0.4,shtThck],true);
        color("silver") translate([-(7.8/2-shtThck),0,0.7/2]) rotate([0,90,90]) 
          bend([0.7,0.4,shtThck],90,0.2,true) cube([0.7,0.4,shtThck],true);
      }
      translate([0,0,bdDims.z/2]) cube([4,shtThck+fudge,2.2],true);
    }
  }
}

module heatsink(dimensions, fins, sltDpth){
  finWdth=dimensions.x / (fins*2-1);
  bdyHght=dimensions.z - sltDpth;
  echo(bdyHght);
  
  difference(){
    translate([0,0,(dimensions.z-finWdth/2)/2]) cube(dimensions - [0,0,finWdth/2],true);
    for (i=[0:fins-2])
      translate([i*finWdth*2-(dimensions.x-finWdth)/2+finWdth,0,dimensions.z/2+bdyHght]) 
        cube([finWdth,dimensions.y+fudge,dimensions.z],true);
  }
  for (i=[0:fins-1])
      translate([i*finWdth*2-(dimensions.x-finWdth)/2,0,dimensions.z-finWdth/2]) rotate([90,0,0]) cylinder(d=finWdth,h=dimensions.y,center=true);
}
  
*pushButton(col="red");
module pushButton(panelThck=2,col="darkSlateGrey"){
  //RAFI 1.10.107, 9.1mm, 24V/0.1A
  
  translate([0,0,-20]){
    color("darkSlateGrey"){
      difference(){
        union(){
          cylinder(d=9,h=20);
          translate([0,0,20]) cylinder(d1=11,d2=10.2,h=2);
        }
        for (i=[-1,1]) translate([i*9/2,0,20-6.5-9/2]) cube([4,9,9],true);
      }
    translate([0,0,20-5.5-panelThck]) cylinder(d=11.5,h=5.5); //fixation ring
    }
    
    color(col) translate([0,0,22]) cylinder(d=7,h=2.5);
    color("silver") for (i=[-1,1]){
      difference(){
        union(){
          translate([i*2.5,0,-(5.5-2.5/2)/2]) cube([0.2,2.5,5.5-2.5/2],true);
          translate([i*2.5,0,-5.5+2.5/2]) rotate([0,90,0]) cylinder(d=2.5,h=0.2,center=true);
        }
        translate([i*2.5,0,-5.5+2.5/2]) rotate([0,90,0]) cylinder(d=0.8,h=0.3,center=true);
      }
    }
  }
}

*KMR2();
module KMR2(){
  // C and K Switches Series KMR 2
  // https://www.ckswitches.com/media/1479/kmr2.pdf
  mfudge=0.01;
  btnRad=0.6;
  btnDim=[2.1,1.6,0.5];
  //body
  color("silver") translate([0,0,0.7+mfudge]) cube([4.2,2.8,1.4-mfudge],true);
  //button (simplified)
  color("darkSlateGrey")
  hull() for (i=([-1,1]),j=[-1,1])
    translate([i*(btnDim.x/2-btnRad),j*(btnDim.y/2-btnRad),1.4]) cylinder(r=btnRad,h=btnDim.z);
    
  //pads
  color("grey") for (i=([-1,1]),j=[-1,1]){
    translate([i*(4.6-0.5)/2,j*(2.2-0.6)/2,0.1/2]) cube([0.5,0.6,0.1],true);
  }
}
*PEL12D();
module PEL12D(){
  //Bourns PEL12D https://www.bourns.com/docs/product-datasheets/PEL12D.pdf
  //vertical, 15mm shaft, with switch (PEC12R-2x15F-Sxxxx)
  
  
  LM=16; //total length
  LB=5; //threat length
  F=7; //flatten length
  C=0.5; //chamfer
  
  //total length (LM) vs. flatted lenght(L1)
  LDict=[[16,3],[18.5,5],[21,7],[26,12],[31,12]];
  
  L1= LDict[search(LM,LDict)[0]][0]; //flatted length
  
  threatDia=6.8;
  
  shftDia=6;
  fltnDia=4.5; //flattended Dia (D-Type)
  
  bodyDims=[12.5,7,13.2];
  shftZOffset=10;
  bdyZOffset=0;
  
  //pins
  //mounting pins (always 2)
  mPitch=12.9; 
  mYPos=6;
  mPinDims=[0.3,1.9,3.5];//mounting Pins
  
  //encoder pins pitch (always 3)
  ePitch=2.5; 
  ePinDims=[0.8,0.1,3.5];
  ePinYPos=mYPos-3.5;
  
  //switch/LED Pins
  sPitch=2.0;
  sPinDims=ePinDims;
  sYPos=1;
  sCount=4;
  
  
  //body
  color(blackBodyCol) translate([0,bodyDims.y/2,shftZOffset]) 
    cube([bodyDims.x,bodyDims.y,bodyDims.z],true);
  *color(metalAluminiumCol) translate([0,bodyDims.y/6,shftZOffset]) 
    cube([bodyDims.x,bodyDims.y/3,bodyDims.z],true);
  //nupsis
  color(blackBodyCol)translate([0,0,shftZOffset]) rotate([90,0,0]) for (ix=[-1,1],iy=[-1,1])
    translate([ix*8.4/2,iy*10.2/2,0]) cylinder(d=1.1,h=0.8);
    
  //threat
  color(metalAluminiumCol) translate([0,0,shftZOffset]) rotate([90,0,0]) cylinder(d=threatDia,h=LB);
  
  //shaft
  color(blackBodyCol) translate([0,0,shftZOffset]) rotate([90,0,0])  difference(){
    union(){
      translate([0,0,LB]) cylinder(d=shftDia,h=L1-LB-C);
      translate([0,0,L1-C]) cylinder(d1=shftDia,d2=shftDia-C*2,h=C);
    }
    translate([0,-shftDia/2+(shftDia-fltnDia)/2,-F/2+L1]) cube([shftDia+fudge,shftDia-fltnDia+fudge,F+fudge],true);
  }
  
  //encoder pins
  spcng=shftZOffset-bodyDims.z/2+bdyZOffset;
  color(metalGreyPinCol) for (ix=[-1:1])
    translate([ix*ePitch,ePinYPos,-(ePinDims.z-spcng)/2]) cube(ePinDims+[0,0,spcng],true);
  //mounting Pins
  color(metalGreyPinCol) for (ix=[-1,1])
    translate([ix*mPitch/2,mYPos,-(mPinDims.z-spcng)/2]) cube(mPinDims+[0,0,spcng],true);
  
  *color(metalGreyPinCol) for (iy=[-1,1])
    translate([mXPos,iy*mPitch/2,-(mPinDims.z-spcng)/2]) cube(mPinDims+[0,0,spcng],true);
  
}

*PEC09();
module PEC09(L=20,S="S",cut=false){
  //Bourns PEC12R https://www.bourns.com/pdfs/pec12R.pdf
  //vertical, 15mm shaft, with switch (PEC9-2xLLF-Sxxxx)
  
  LB= (L<=15) ? 5.0 :
      (L<=20) ? 7.0 : 10.0; //threat length
  //flat length
  L2= (L<=15) ? 7.0 :
      (L<=20) ? 10.0 : 10.0; //threat length
  
  //switch stroke
  strokeLen= (S=="N") ? 0 : 
             (S=="S") ? 0.5 :
             (S=="T") ? 1.5 : 0;
  
  C=0.5; //chamfer
  
  F= L2;
  assert(F!=undef,"Length not Found");
  threatDia=7;
  shftDia=6;
  shftZOffset=6.5;
  fltnDia=4.5; //flattended Dia (D-Type)
  
  bodyDims= (S=="N") ? [9.7,7.05,11.35] : 
            (S=="S") ? [9.7,13.3,11.35] :
            (S=="T") ? [9.7,12.05,11.35] : [9.7,7.05,11.35];
  bdyZOffset=0;
  
  //shaft length
  L1=L;
  
  lugDims=[1.8,0.8,0.6];
  
  //pins
  pitch=2.5;
  pinDims=[0.9,0.2,3.5];
  pinYDist= (S=="N") ? 0 :
            (S=="S") ? 6.25 :
            (S=="T") ? 5.0 : 0;
  pinYOffset=5;
  
  if (cut)translate([0,6.5]) {
    circle(d=7.2);
    translate([0,-6]) square([2,0.8],true);
  }
    
  else {
    //body
    color(blackBodyCol) translate([0,bodyDims.y/2,bodyDims.z/2+bdyZOffset]) 
      cube([bodyDims.x,bodyDims.y,bodyDims.z],true);
    *color(metalAluminiumCol) translate([0,bodyDims.y/6,shftZOffset]) 
      cube([bodyDims.x,bodyDims.y/3,bodyDims.z],true);
    //Lug
    color(metalAluminiumCol) translate([0,-lugDims.y/2,lugDims.z/2]) cube(lugDims,true);
      
    //threat
    color(metalAluminiumCol) translate([0,0,shftZOffset]) rotate([90,0,0]) cylinder(d=threatDia,h=LB);
    
    //shaft
    color(metalAluminiumCol) translate([0,0,shftZOffset]) rotate([90,0,0])  difference(){
      union(){
        translate([0,0,LB]) cylinder(d=shftDia,h=L1-LB-C);
        translate([0,0,L1-C]) cylinder(d1=shftDia,d2=shftDia-C*2,h=C);
      }
      translate([0,-shftDia/2+(shftDia-fltnDia)/2,-F/2+L1]) cube([shftDia+fudge,shftDia-fltnDia+fudge,F+fudge],true);
    }
    
    //pins
    spcng=shftZOffset-bodyDims.z/2+bdyZOffset;
    //ABC pins
    color(metalGreyPinCol) for (ix=[-1:1])
      translate([ix*pitch,pinYOffset,-pinDims.z/2]) cube(pinDims,true);
    //switch pins    
    if (pinYDist) color(metalGreyPinCol) for (ix=[-1,1])
      translate([ix*pitch,pinYOffset+pinYDist,-pinDims.z/2]) cube(pinDims,true);
  }  
}


*PEC12R();
module PEC12R(L=20){
  //Bourns PEC12R https://www.bourns.com/pdfs/pec12R.pdf
  //vertical, 15mm shaft, with switch (PEC12R-2x15F-Sxxxx)
  
  LB=5.0; //threat length
  
  C=0.5; //chamfer
  
  LDict=[[17.5,5],[20,7],[22.5,7],[25,12],[30,12]];
  F= LDict[search(L,LDict)[0]][1]; //flatted length
  assert(F!=undef,"Length not Found");
  threatDia=7;
  shftDia=6;
  shftZOffset=10;
  fltnDia=4.5; //flattended Dia (D-Type)
  
  bodyDims=[12.5,6,13.4];
  bdyZOffset=0;
  
  //shaft length
  L1=L-bodyDims.y;
  
  //pins
  pitch=2.5;
  pinDims=[0.8,0.1,3.5];
  mPitch=12.9;
  mYPos=6;
  mPinDims=[0.3,1.9,3.5];//mounting Pins
  
  
  //body
  color(blackBodyCol) translate([0,bodyDims.y/2,shftZOffset]) 
    cube([bodyDims.x,bodyDims.y,bodyDims.z],true);
  *color(metalAluminiumCol) translate([0,bodyDims.y/6,shftZOffset]) 
    cube([bodyDims.x,bodyDims.y/3,bodyDims.z],true);
  //nupsis
  color(blackBodyCol)translate([0,0,shftZOffset]) rotate([90,0,0]) for (ix=[-1,1],iy=[-1,1])
    translate([ix*8.4/2,iy*10.2/2,0]) cylinder(d=1.1,h=0.8);
    
  //threat
  color(metalAluminiumCol) translate([0,0,shftZOffset]) rotate([90,0,0]) cylinder(d=threatDia,h=LB);
  
  //shaft
  color(blackBodyCol) translate([0,0,shftZOffset]) rotate([90,0,0])  difference(){
    union(){
      translate([0,0,LB]) cylinder(d=shftDia,h=L1-LB-C);
      translate([0,0,L1-C]) cylinder(d1=shftDia,d2=shftDia-C*2,h=C);
    }
    translate([0,-shftDia/2+(shftDia-fltnDia)/2,-F/2+L1]) cube([shftDia+fudge,shftDia-fltnDia+fudge,F+fudge],true);
  }
  
  //pins
  spcng=shftZOffset-bodyDims.z/2+bdyZOffset;
  color(metalGreyPinCol) for (ix=[-1:1])
    translate([ix*pitch,mYPos-3.5,-(pinDims.z-spcng)/2]) cube(pinDims+[0,0,spcng],true);
  //mounting Pins
  color(metalGreyPinCol) for (ix=[-1,1])
    translate([ix*mPitch/2,mYPos,-(mPinDims.z-spcng)/2]) cube(mPinDims+[0,0,spcng],true);
  
  *color(metalGreyPinCol) for (iy=[-1,1])
    translate([mXPos,iy*mPitch/2,-(mPinDims.z-spcng)/2]) cube(mPinDims+[0,0,spcng],true);
  
}


*PEC16();
module PEC16(){
  //Bourns PEC16 https://www.bourns.com/pdfs/pec16.pdf
  //vertical, 15mm shaft (PEC16-2x15F) only for now
  L1=15; //shaft length
  LB=5; //threat length
  F=7; //flatten length
  
  threatDia=9;
  shftZOffset=12.5;
  
  bodyDims=[8,16,17.6];
  bodyZOffset=1;
  
  //body
  color(greenBodyCol) translate([-bodyDims.x*2/3,0,shftZOffset-bodyZOffset/2]) 
    cube([bodyDims.x/3*2,bodyDims.y,bodyDims.z],true);
  color(metalAluminiumCol) translate([-bodyDims.x/6,0,shftZOffset-bodyZOffset/2]) 
    cube([bodyDims.x/3,bodyDims.y,bodyDims.z],true);
  color(metalAluminiumCol) translate([-0.5,0,(12.5-9.3)/2]) cube([1,4,12.5-9.3],true);
  
  //locking
  color(metalAluminiumCol) translate([0,0,12.5-9]) rotate([0,90,0]) linear_extrude(2) difference(){
    circle(d=3);
    translate([-1.6,0]) square(3,true);
  }
  
  //threat
  color(metalAluminiumCol) translate([0,0,shftZOffset]) rotate([0,90,0]) cylinder(d=threatDia,h=LB);
  
  //shaft
  color(blackBodyCol) translate([0,0,shftZOffset]) rotate([0,90,0]) difference(){
    union(){
      translate([0,0,LB]) cylinder(d=6,h=L1-LB-1.5);
      translate([0,0,L1-1.5]) cylinder(d1=6,d2=4.5,h=1.5);
    }
    translate([-4.5/2,0,-F/2+L1]) cube([6-4.5+fudge,6+fudge,F+fudge],true);
  }
  
  //pins
  color(metalGreyPinCol) for (iy=[-1:1])
    translate([-7.5+3.1,iy*5,0]) cube([0.2,1,12.5-9.3+3.5],true);
  color(metalGreyPinCol) for (iy=[-1,1])
    translate([-7.5,iy*16.1/2,0]) cube([2,0.4,12.5-9.3+3.5],true);
  
}

*knob_K88(true);
module knob_K88(cut=false){
  //CLIFF KNOB K88
  //https://cdn-reichelt.de/documents/datenblatt/C160/K88-KNOB_ENG_TDS.pdf
  //CLL17886x, 6mm D-Shaft
  //Reichelt: https://www.reichelt.de/ws/de/knopf-12-mm-6-mm-d-shaft-schwarz-cliff-cl178862-p227921.html?&trstct=pol_0&nbc=1
   difference(){
    color(blackBodyCol) cylinder(d1=12,d2=10,h=17);
    color(blackBodyCol) translate([0,0,-fudge]) cylinder(d=6,h=11.5+fudge);
    color(redBodyCol) if (cut) translate([0,3,15/2]) cube([12+fudge,6+fudge,15+fudge],true);
  }
  color(blackBodyCol) translate([0,0,17]) cylinder(d=9,h=1);
}


*knob450AA();
module knob_450AA(){
  //Eagle Plastic Devices 450-AA series
  //https://www.mouser.de/datasheet/2/209/EPD_09202017_200733-1171041.pdf
  A=15; //base dia
  A1=3.2; //base height
  B=19; //knob height
  C=12; //bore length
  D=2;  //base bore length
  E=13; //base bore dia
  
  difference(){
    union(){
      cylinder(d=A,h=A1);
      translate([0,0,A1]) cylinder(d1=E,d2=10,h=B-A1);
    }
    translate([0,0,-fudge]){
      cylinder(d=E,h=D+fudge);
      cylinder(d=12.5,h=3+fudge);
      cylinder(d=5.8,h=C+fudge);
    }

  }
}
module rotEncoder(diff="none",thick=3,knob=false){
  //SparkFun Rotary Encoder COM-10982 - https://www.sparkfun.com/products/10982
  if (diff=="body"){
    union(){
      translate([0,0,-thick/2-fudge/2]){
        rndRect(12.4+1,13.2+1,thick+fudge,1,0);
        translate([0,0,0]) rndRect(11,15+1,thick+fudge,1,0);
      }
    }
  }
  else if (diff=="dome"){
    translate([0,0,-thick/2-fudge/2]) cylinder(h=thick+fudge,d=9+1);
  }
  else{
    union(){
      color("darkgrey") translate([0,0,0])
        hull() for (ix=[-1,1],iy=[-1,1])
          translate([ix*(12-1)/2,iy*(13.2-1)/2,0]) 
            cylinder(d=1,h=7.5);//rndRect(12,13.2,7.5,1,0); //base
      color("grey") translate([-12.4/2,-11/2,fudge]) cube([12.4,11,7.5]);//base sheet
      color("lightgrey") translate([0,0,7.5-fudge]) cylinder(h=7+fudge,d=9,$fn=100); //screw dome
      color("white",0.5) translate([0,0,7.5+7.0-fudge]) cylinder(h=10.5, d=6); //handle
      color("grey") //5pins on top
        for (i=[-4.1:8.2/4:4.1]){
          translate([i-0.8/2,7,-2.9]) cube([0.8,0.3,4.3]);
        }
      color("grey") //3 pins front
        for (i=[-2.5:2.5:2.5]){
          translate([i-0.9/2,-7.5,-2.8]) cube([0.9,0.3,7]);
        }
        if (knob) color("white",0.5) translate([0,0,7.5+7+10.5-10.3]) cylinder(d1=15,d2=14.5,h=12.5);
    }//union
  }
}

*leverSwitch();
module leverSwitch(){
  //https://cdn-reichelt.de/documents/datenblatt/C200/KS-C3900.pdf
  
  bodyDims=[29.5,14,17];
  screwDia=12;
  screwLngth=10.5;
  lvrLngth=17.5;
  lvrDia=[3.6,5.8]; //tip Dia
  
  translate([0,0,-bodyDims.z/2]) cube(bodyDims,true);
  difference(){
    cylinder(d=screwDia,h=screwLngth);
    rotate(90) translate([0,screwDia/2,(screwLngth+fudge)/2]) 
      cube([2,1.4*2,screwLngth+fudge],true);
  }
  
  translate([0,0,screwLngth]) rotate([0,15,0]) hull(){
    sphere(d=lvrDia[0]);
    translate([0,0,lvrLngth-lvrDia[1]]) sphere(d=lvrDia[1]);
  }
}

*roundRocker20();
module roundRocker20(cut=false){
  //https://cdn-reichelt.de/documents/datenblatt/C200/R13_ENG.pdf
  rockerRadius=41; //radius to substract from rocker

  if (cut){
    circle(d=20.2);
    translate([20.2/2,0]) square([1.8,2.2],true);
  }
  else{
     color("darkSlateGrey"){
        difference(){
          cylinder(d=17,h=5.5); //rocker
          translate([0,17/2,2+rockerRadius]) rotate([0,90,0]) cylinder(r=rockerRadius,h=17,center=true,$fn=100);
        }    
        translate([0,0,-14.5]) cylinder(d=20,h=14.5); //body
        cylinder(d=23,h=1); //ring
        translate([0,0,1]) cylinder(d1=23,d2=21,h=1);

     }
      //terminals
      color("silver") for (ix=[-1:1])
         translate([ix*7.1,0,-14.5-8.1/2]) cube([0.8,4.8,8.1],true);
  }
    
}

*toggleSwitch();
module toggleSwitch(){
  //e.g. TAIWAY Series 100
  //https://www.taiway.com/resource/annexes/product_items/25/6fdf503e5e83543e58a637ede7a46d6b.pdf

  /*100-DP1-T200B1M6QE --> 
      DP1: On-None-On (DPDT)
      T2: 5.4mm Actuator, actDims=[2.7,8,1.85], actAng=12.5, pivot=3.75
      0: no Cap, 
      0: no Color, 
      B1: 9mm keyway bushing,
      M6: Right angle orientation,
      Q: Silver contacts
      E: Epoxy seal
  */ 

  // T1: 10.4mm Actuator, actDims=[3,12.95,1.85], actAng=14.5, pivot=3.75

  //terminals
  termPinCS=[0.75,1.26]; //terminal pin crosssection
  termPitch=[4.7,3.81,4.83]; //contact pins pitch
  termPinLen=3.4; //terminal pin length (from PCB surface)
  //mountin pins
  mntPinPitch=5.8;
  mntPinCS=[1.3,0.5];
  mntPinLen=2.6;
  mntSheetDims=[8.9,mntPinCS.y,11];
  fPitch=5.08; //fixation pins pitch
  bodyDims=[12.7,10.2,11.4];
  mntOffset=12.7;
  termOffset=mntOffset-bodyDims.y;
  bshDims=[6.1,9]; //bushing Dia, length
  keyWay=[1,0.6]; //keyway dims
  actDims=[2.7,8,1.85]; //actuator top dia, total length, bottom dia (measured from pdf)
  actZOffset=5.8;
  actAng=12.5; //actuator angle
  actPivot=3.75; //actuator pivot point relative to bushing 
  
  //move pin1 to origin
  translate([termPitch.x,0,0]){
    //body
    color(redBodyCol) translate([0,mntOffset-bodyDims.y/2,bodyDims.z/2]) 
      cube(bodyDims,true);
    //bushing
    color(metalSilverCol) translate([0,mntOffset,actZOffset]) 
      rotate([-90,0,0]) linear_extrude(bshDims[1]) 
        difference(){
          circle(d=bshDims[0]);

        }
    //Actuator
    color(metalSilverCol) translate([0,mntOffset+bshDims[1]-actPivot,actZOffset]) rotate([-90,0,-actAng]) hull(){
      sphere(d=actDims[2]);
      translate([0,0,actDims[1]]) sphere(d=actDims[0]);
    }
    
    //terminals
    color(metalGoldPinCol) for (ix=[-1,0,1],iy=[0,1]){
      translate([ix*termPitch.x,0,0]){
        translate([0,termOffset-(termOffset-termPinCS.y/2)/2-iy*termPitch.y/2,(bodyDims.z-termPitch.z)/2+iy*termPitch.z]) 
          cube([termPinCS.x,termOffset-termPinCS.y/2+iy*termPitch.y,termPinCS.y],true);
        translate([0,termPinCS.y/2-iy*termPitch.y,(bodyDims.z-termPitch.z-termPinCS.y)/2+iy*termPitch.z]) rotate([90,0,-90]) 
          rotate_extrude(angle=90) translate([termPinCS.y/2,0]) square([termPinCS.y,termPinCS.x],true);
        translate([0,-iy*termPitch.y,-termPinLen]) 
          linear_extrude((bodyDims.z-termPitch.z-termPinCS.y)/2+termPinLen+iy*termPitch.z) 
            square(termPinCS,true);
      }
    }
    
    color(metalGreyPinCol){
      //mount sheet metal
      translate([0,mntOffset,mntSheetDims.z/2]) cube(mntSheetDims,true);
      //mount pins
      for (ix=[-1,1])
        translate([ix*mntPinPitch/2,mntOffset,0]){
          translate([0,0,-mntPinLen+mntPinCS.x/2]) rotate([90,0,0]) cylinder(d=mntPinCS.x,h=mntPinCS.y,center=true);
          translate([0,0,-(mntPinLen-mntPinCS.x/2)/2]) cube([mntPinCS.x,mntPinCS.y,mntPinLen-mntPinCS.x/2],true);
        }
    }
  }
}

*slideSwitch();
// APEM 25136 https://www.reichelt.de/index.html?ACTION=7&LA=3&OPEN=0&INDEX=0&FILENAME=C200%2F05-SERIE_25000N-D.pdf
module slideSwitch(){
  bdyDims=[14.1,7.5,8.1];
  pitch=2.54;
  pinDims=[0.5,0.6,3.8];
  actrDims=[3,3,2.8];
  actrTrvl=4;
  //body
  color("ivory") translate([0,0,5/2]) cube([bdyDims.x,bdyDims.y,5],true);
  color("darkSlateGrey") translate([0,0,5+(8.1-5)/2]) cube([bdyDims.x,bdyDims.y,8.1-5],true);
  //actuator
  color("darkSlateGrey") translate([actrTrvl/2,0,bdyDims.z+actrDims.z/2]) cube(actrDims,true);
  //pins
  color("gold") for(ix=[-1:1]) translate([ix*pitch,0,-pinDims.z/2]) cube(pinDims,true);
}

//Subminiature Slide Switch e.g. Apem NK 
module subMinSlideSwitch(){

}

*jogSwitch(-1);
module jogSwitch(pos=0){
  //https://www.qyswitch.com/h-pd-270.html

  actOutRad=8.25;
  actInRad=6.75;
  actDims=[2,7.05]; //thick, width
  actRot= (pos>0) ? -24 : (pos<0) ? 24 : 0 ;// : -24 : 0;
  cntrOffset=0.75; //rotation center to pegs

  bdyDims=[11.8,4.1,2.5];
  pegDist=5;
  pegDims=[0.9,0.5]; //dia, height
  
  padDims=[[1.5,1.15,0.5],[1,1.2,0.5]];
  padPitch=pegDist/2;
  
  //actuator
  color(blackBodyCol) translate([0,cntrOffset,0]) rotate(3+actRot) 
    rotate_extrude(angle=180-2*3,$fn=50) translate([actInRad+actDims.x/2,actDims.y/2-1.9]) square(actDims,true);
  //body
  difference(){
    union(){
      translate([0,-bdyDims.y/2,bdyDims.z/2]) cube(bdyDims,true);
      for (i=[0,1]) rotate(i*(180-30)) rotate_extrude(angle=30) square([bdyDims.x/2,bdyDims.z]);
      rotate(30) rotate_extrude(angle=180-60) square([4.9,bdyDims.z]);
      for (ix=[-1,1]) translate([ix*pegDist/2,0,-pegDims[1]]) cylinder(d=pegDims[0],h=pegDims[1]);
    }
    //recesses for pads
    for (ix=[-1:1]) translate([ix*padPitch,-4.25+padDims[0].y/2,(padDims[0].z-0.1)/2]) cube(padDims[0]+[0.4,0.4,0.1],true);  
    for (ix=[-1,1]) translate([ix*(5.8-padDims[1].x/2),1,(padDims[1].z-0.1)/2]) cube(padDims[1]++[0.4,0.4,0.1],true);

  }

  //pads bottom/front
  color(metalGreyPinCol) for (ix=[-1:1]) translate([ix*padPitch,-4.25+padDims[0].y/2,(padDims[0].z)/2]) cube(padDims[0],true);
  //pads sites
  color(metalGreyPinCol) for (ix=[-1,1]) translate([ix*(5.8-padDims[1].x/2),1,padDims[1].z/2]) cube(padDims[1],true);

}


*arcadeButton();
module arcadeButton(size=24,panelThck=3,col="red"){
  //size 24: https://www.adafruit.com/product/3433 "Mini LED Arcade Button 24mm"
  //size 30: https://www.berrybase.de/bauelemente/schalter-taster/drucktaster/arcade-button-30mm-beleuchtet-40-led-5v-dc-41-transparent

  topDia= (size==24) ? 27.6 : 33.3;
  topThck= (size==24) ? 3 : 4.7;
  btnDia= (size==24) ? 19.6 : 22.65;
  btnThck= (size==24) ? 4.2 : 4.85;
  bdyDims= (size==24) ? [24,26] : [28,28.6+4.7];
  nutDims = (size==24) ? [30.6,8] : [35.7,9];
  //top ring
  color(col) difference(){
    rotate_extrude(){ 
      translate([topDia/2-topThck,0]) circle(topThck);
      translate([0,-topThck]) square([topDia/2-topThck,topThck*2]);
    }
    translate([0,0,-topThck-fudge]) cylinder(d=topDia+fudge,h=topThck+fudge);
  }
  //button
  color(col) cylinder(d=btnDia,h=btnThck+topThck);
  //body
  color(col) translate([0,0,-bdyDims[1]]) cylinder(d=bdyDims[0],h=bdyDims[1]);
  //fixation ring
  color("ivory"){
    if (size==24) translate([0,0,-2-panelThck]) cylinder(d=33.6,h=2);
    translate([0,0,-nutDims[1]-panelThck]) cylinder(d=nutDims[0],h=nutDims[1]);
  }

}

*joystick();
module joystick(plateThck=3, cut=false){
//Joystick: https://www.berrybase.de/arcade-joystick-8-wege-78-2mm-hoehe-rot
  sheetThck=1.6;
  topPlateDims=[95,66];
  boxDims=[66,65,30];
  axisLen=44;
  ballDia=35;

  if (cut){
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*81.5/2,iy*43.5/2]) children();
  }
  else{
    //plate
    translate([0,0,-sheetThck]){
      color(blackBodyCol) linear_extrude(sheetThck) difference(){
        square(topPlateDims,true);
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*81.5/2,iy*43.5/2])
            rotate(ix*iy*-45) hull() for (ix=[-1,1]) translate([ix*2.5,0]) circle(d=5);
        for (ix=[-1,1])
          translate([ix*85/2,0]) circle(d=5);
      }
      //body
      translate([0,0,-boxDims.z/2]) cube(boxDims,true);
      //handle
      color(metalSilverCol) cylinder(d=10,h=axisLen+ballDia/2);
      color(redBodyCol) translate([0,0,axisLen+ballDia/2]) sphere(d=ballDia);
    }
    //coverplate
    color(blackBodyCol) translate([0,0,plateThck]) linear_extrude(sheetThck)
      difference(){
        circle(d=52);
        circle(d=11);
      }
  }
  
}

module snapActionSwitch(){
  //https://www.marquardt-switches.com/snap-action-switches.html?&no_cache=1&L=0&tx_produktkatalog2_pi1%5Bmode%5D=detail3&tx_produktkatalog2_pi1%5Bmodifier%5D=0&tx_produktkatalog2_pi1%5Bvalue%5D=1005&tx_produktkatalog2_pi1%5Bpointer%5D=12&cHash=d16795b95db5f77666d619cde051b6b3

  linear_extrude(10.3) difference(){
    rndRect([28,16],2.5,0,center=true);
  }
}

*rocpuSideSwitch();
module rocpuSideSwitch(){
  //https://www.lcsc.com/datasheet/lcsc_datasheet_2303211430_ROCPU-Switches-TP12422663_C5381383.pdf
  bdyDims=[6,3.6,3.5];
  sheetThck=0.1;
  
  //body
  color(blackBodyCol){
    difference(){
      translate([0,sheetThck/2,bdyDims.z/2]) cube(bdyDims+[0,-sheetThck,0],true);
      color(metalSilverCol) for (ix=[-1,1])
      translate([ix*5.2/2,(bdyDims.y-1.2)/2,(sheetThck-fudge)/2]) cube([1.2,1.3,sheetThck+fudge],true);
    }
    //pegs
    for (ix=[-1,1]){
      translate([ix,0.65,-0.6]) cylinder(d=0.8,h=0.6);
      translate([ix,0.65,-0.8]) cylinder(d1=0.6,d2=0.8,h=0.2);
    }
  }
  //metalsheet
  color(metalSilverCol) translate([0,-bdyDims.y/2+sheetThck,0]) sheet();
  
  //button
  color(whiteBodyCol) translate([0,-bdyDims.y/2,1.7]) 
    rotate([90,0,0]) linear_extrude(2.7,scale=[0.9,0.9]) square([3,1.45],true);
  //pads
  color(metalSilverCol) for (ix=[-1,1])
    translate([ix*4.8/2,(bdyDims.y-1.2)/2,sheetThck/2]) cube([0.6,1.2,sheetThck],true);
  
  module sheet(){
    sheetDims=[7.95,3.5];
    rad=0.2;
    
    //front
    rotate([90,0,0]) linear_extrude(sheetThck){
      translate([0,1.7/2+sheetThck/4]) square([sheetDims.x,1.7-sheetThck/2],true);
      translate([0,(3.5+sheetThck/2)/2,0]) square([6,sheetDims.y-sheetThck/2],true);
      
    }
    //pads
    for (ix=[-1,1]){
      translate([ix*(7.95-0.65)/2,-sheetThck/2,sheetThck/2]) 
        rotate([0,90,0]) cylinder(d=sheetThck,h=0.65,center=true);
      translate([ix*(7.95-0.65)/2,(1.1-sheetThck)/2,0]) 
        linear_extrude(sheetThck) square([0.65,1.1],true);
      
    }
  }
}


// --- Helpers ---
*bendTerminal();
module bendTerminal(size=[5,7,0.5],width=2,rad=1){
/*
 *           size.x
 *       ◄───────────►
 *                      rad
 *         ┌──────────┐◄───
 *       ▲ │ t=size.z │
 *       │ └─────┐    │
 *       │       │    │
 * size.y│       │    │
 *       │       │    │
 *       │       │    │
 *       ▼       │    │
 *               └────┘
 *               width
 */

  cube([width,size.y-width,size.z,]);

}


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


module rndRect(size, rad, drill=0, center=true){  
  if (len(size)==2) //2D shape
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(d=drill);
    }
  else
    
    linear_extrude(size.z,center=center) 
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(d=drill);
    }
}