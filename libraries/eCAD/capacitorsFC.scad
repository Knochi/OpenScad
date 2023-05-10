/*
*   3dModel creation scripts for KiCAD by Knochi
*   export as .csg, import in freecad and proceed with KiCadStepUp
*/

showMarking=true;

$fn=50;

/* [Hidden] */
fudge=0.1;
// -- Kicad diffuse colors --
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



capacitorTHT();
module capacitorTHT(D=16,L=30,axial=true){

  rad=0.5;
  notch=1.0;
  foilThck=0.1;
  foilOpnDia=12.8;
  ringPos=0.15;
  footHght=1;
  footDia=10.8;
  //leads
  lSpcng=7.5;
  lDia=0.8;
  lLen=[20.5,16];
  //marking
  mkWdth=5.9;
  mkAng=asin((mkWdth/2)/(D/2))*2;
  
  //body
  translate([0,0,footHght]){ 
    //marking slice
    if (showMarking) color(whiteBodyCol) intersection(){
      body(0.01);
      rotate(-mkAng/2) rotate_extrude(angle=mkAng) translate([foilOpnDia/2,-fudge]) square([D/2-foilOpnDia/2+fudge,L+fudge]);
    }
    //body wth. removed slice for marking
    difference(){
      color(blackBodyCol) body();
      if (showMarking) rotate(-mkAng/2) rotate_extrude(angle=mkAng) translate([foilOpnDia/2,-fudge]) square([D/2-foilOpnDia/2+fudge,L+fudge]);    
      color(metalSilverCol) translate([0,0,-fudge]) cylinder(d=foilOpnDia,h=foilThck+fudge);
      color(metalSilverCol) translate([0,0,L-footHght-foilThck]) cylinder(d=foilOpnDia,h=foilThck+fudge);
    }
  }
  //foot
  color(darkGreyBodyCol) cylinder(d=footDia,h=footHght);
  //leads
  for (i=[0:1]){
    color(metalGreyPinCol) translate([i*lSpcng-lSpcng/2,0,-lLen[i]]) cylinder(d=lDia,h=lLen[i]);
    color(metalGreyPinCol) translate([i*lSpcng-lSpcng/2,0,-lLen[i]]) sphere(d=lDia);
  }
  

  
  module body(thckn=0){
    rotate_extrude(){     
      difference(){
        offset(rad+thckn) difference(){
          translate([0,rad]) square([D/2-rad,L-footHght-rad*2]);
          translate([(D+notch-rad)/2,L*ringPos+footHght]) circle(notch+rad);
        }
      translate([-(rad+thckn+fudge),-fudge]) square([rad+thckn+fudge,L+fudge]);
      }
    }
  }
}
