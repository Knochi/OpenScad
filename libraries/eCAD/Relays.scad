


/* [export] */
export = "none"; //["CIT","FTR","JY32FN","BS4"]

/* [Hidden] */

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

if (export=="CIT")
  CIT_L115F1();
else if (export=="FTR")
  FTR_E1();
else if (export=="JY32FN")
  JY32FN();
else if (export=="BS4")
  BS4();
else
  echo("nothing to render");
  

module BS4(){
  //https://datasheet.lcsc.com/lcsc/2309121625_JIEYING-RELAY-JY32FNH-SH-DC12V-A-20A_C17702416.pdf
  //http://www.jieyingrelay.com/upload/download/d2_20190823125882.pdf
  ovDims=[15.5,11,11.5];
  pin1Offset=[ovDims.x/2-1.4,-7.62/2,0]; //centeroffset
  pinPos=[[0,0],[0,-7.62],
          [10.16,0],[10.16,-7.62],
          [10.16+2.54,0],[10.16+2.54,-7.62]];
  pinDims=[[0.2,0.5,3.6],[0.2,0.5,3.6],
           [0.5,0.5,3.6],[0.5,0.5,3.6],
           [0.5,0.5,3.6],[0.5,0.5,3.6],
           ];
  
  translate(pin1Offset){
    color(blackBodyCol) 
      translate([0,0,ovDims.z/2]) cube(ovDims,true);
  }
  
  for (i=[0:len(pinPos)-1]){
    //round pin
    if (len(pinDims[i])==2)
      color(metalGreyPinCol) translate([pinPos[i].x,pinPos[i].y,-pinDims[i][1]]) 
        cylinder(d=pinDims[i][0],h=pinDims[i][1]);
    else
      color(metalGreyPinCol) translate([pinPos[i].x,pinPos[i].y,-pinDims[i][2]/2]) 
        cube(pinDims[i],true);
  }
}  

module JY32FN(){
  //https://datasheet.lcsc.com/lcsc/2309121625_JIEYING-RELAY-JY32FNH-SH-DC12V-A-20A_C17702416.pdf
  //http://www.jieyingrelay.com/upload/download/d2_20190823125882.pdf
  ovDims=[18.2,10.2,15.5];
  pin1Offset=[ovDims.x/2-1.7,-7.6/2,0]; //centeroffset
  pinPos=[[0,0],[0,-7.6],[12.7+2.54,0],[12.7,-7.6]];
  pinDims=[[0.5,4.1],[0.5,4.1],[0.3,1,4.1],[0.3,1,4.1]];
  
  translate(pin1Offset){
    color(blackBodyCol) 
      translate([0,0,ovDims.z/2]) cube(ovDims,true);
  }
  
  for (i=[0:len(pinPos)-1]){
    //round pin
    if (len(pinDims[i])==2)
      color(metalGreyPinCol) translate([pinPos[i].x,pinPos[i].y,-pinDims[i][1]]) 
        cylinder(d=pinDims[i][0],h=pinDims[i][1]);
    else
      color(metalGreyPinCol) translate([pinPos[i].x,pinPos[i].y,-pinDims[i][2]/2]) 
        cube(pinDims[i],true);
  }
}  

module FTR_E1(){
// Fujitsu FTR-E1 https://www.fcl.fujitsu.com/downloads/MICRO/fcai/relays/ftr-e1.pdf
  ovDims=[43.6,28.3,36.8]; //typical
  spacing=1;
  radius=0.75;
  pinDims=[1.6,0.8,4];//below zero
  pin1Offset=[28.8/2,-13.9/2,0];
  //body
  translate(pin1Offset){
    color(blackBodyCol) difference(){
      translate([0,0,ovDims.z/2]) cube(ovDims,true);
      
      /* doesn't work with freecad atm
      *rotate([90,0,0]) hull() for(ix=[-1,1]){
        translate([ix*(39/2-radius),0]){
          translate([0,spacing-radius]) cylinder(r=radius,h=ovDims.y+fudge,center=true);
          translate([0,(spacing-radius)/2]) cube([radius*2,spacing-radius+fudge,ovDims.y+fudge],true);
          }
        }
      *rotate([90,0,90]) hull() for(ix=[-1,1]){
        translate([ix*(24/2-radius),0]){
          translate([0,spacing-radius]) cylinder(r=radius,h=ovDims.x+fudge,center=true);
          translate([0,(spacing-radius)/2]) cube([radius*2,spacing-radius+fudge,ovDims.x+fudge],true);
          }
        }
        */
    }
    //contact pins
    for (iy=[-9.8,-4.4,4.4,9.8])
      color(metalGreyPinCol) translate([28.8/2,iy,-(pinDims.z+spacing)/2+spacing]) cube([pinDims.y,pinDims.x,pinDims.z+spacing],true);
    for (iy=[-13.9/2,13.9/2])
      color(metalGreyPinCol) translate([-28.8/2,iy,-(pinDims.z+spacing)/2+spacing]) cube([pinDims.x,pinDims.y,pinDims.z+spacing],true);
  }  
}


module CIT_L115F1(DT=true,center2Pin1=true){
  ovDims=[32.05,27,20];
  crnrRad=1;
  btmSpcng=0.4;
  socketHght=2.75;
  pn2Hsng=[3.4,3.4]; //offset pin1 position from housing
  
  sqPinPos=[[pn2Hsng.x,pn2Hsng.y+17.8],
            [pn2Hsng.x+7.7,3.4+17.8],
            [pn2Hsng.x+7.7+2.54,pn2Hsng.y]]; //squarePins
  sqPinZRot=[90,90,0];
  rndPinPos=[[pn2Hsng.x+7.7+15.4,pn2Hsng.y+3.8],
             [pn2Hsng.x+7.7+15.4,pn2Hsng.y+3.8+10.2]]; //round pins
  sqPinDims=[1.2,0.8,3.2];
  rndPinDims=[0.5,0.5,3];
  pin1Pos=rndPinPos[0];
  
  
  cntrOffset= center2Pin1 ? -pin1Pos : [0,0,0];
  rotation= center2Pin1 ? 180 : 0;
  
  rotate(rotation) translate(cntrOffset){
    //body
    color(blackBodyCol)
      translate([0,0,btmSpcng+socketHght]) 
        linear_extrude(ovDims.z-btmSpcng-socketHght) offset(crnrRad) offset(-crnrRad) shape();
    color(blackBodyCol)
      translate([0,0,btmSpcng])
        linear_extrude(socketHght) shape();
    //pins
    color(metalGreyPinCol)
      for (i=[0:len(sqPinPos)-1])
        translate(sqPinPos[i]) rotate(sqPinZRot[i]) sqPin();
    color(metalGreyPinCol)
      for (i=[0:len(rndPinPos)-1])
        translate(rndPinPos[i]) rndPin();
    }
  *rotate(180) translate(cntrOffset) shape();
   
  module shape(){
    poly=[[0,0],[0,27],[12.6,27],[12.6,27-5.5],[32.05,27-5.5],
         [32.05,1.9],[17.5,1.9],[17.5,0]];
    polygon(poly);
  }
  
  module sqPin(){
    tipLen=1.3;
    tipRad=0.25;
    
    rotate([90,0,0]) linear_extrude(sqPinDims.y,center=true) hull(){
      translate([0,-sqPinDims.z+tipRad]) circle(tipRad);
      translate([-sqPinDims.x/2,-sqPinDims.z+tipLen]) 
        square([sqPinDims.x,sqPinDims.z-tipLen+btmSpcng]);
    }
  }

  module rndPin(){
    translate([0,0,-rndPinDims.z+rndPinDims.x/2]){
      sphere(d=rndPinDims.x);
      cylinder(d=rndPinDims.y,h=rndPinDims.z-rndPinDims.x/2+btmSpcng);
    }
  }
}