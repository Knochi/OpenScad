/*
*   3dModel creation scripts for KiCAD by Knochi
*   export as .csg, import in freecad and proceed with KiCadStepUp
*/


$fn=50;

/* [Select] */
export= "PDUUAT16"; //["PDUUAT16","ACT1210","SumidaCR43","TY6028"]

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

if (export == "PDUUAT16")
    !PDUU(false);
else if (export == "ACT1210")
    !ACT1210();
else if (export == "SumidaCR43")
    !sumidaCR43();
else if (export == "TY6028")
    !TY_6028();
else
    echo("Nothing to render!")

*boxCapacitor();
module boxCapacitor(center=false){
  //e.g. https://www.alfatec.de/fileadmin/Webdata/Datenblaetter/Faratronic/C3D_Specification_alfatec.pdf
  // C3D3A406KM0AC00, 4 pin DC, lead length 5.5mm, 
  pitch=52.5;
  W=57;
  H=50;
  T=35;
  P=52.5;
  b=20.3;
  d=1.2;
  l=5.5; //lead length
  cntrOffset = (center) ? [0,0,0] : [pitch/2,-b/2,0];

  translate(cntrOffset){
    color(greyBodyCol) translate([0,0,H/2]) cube([W,T,H],true);
    for (ix=[-1,1],iy=[-1,1])
      color(metalGreyPinCol) translate([ix*P/2,iy*b/2,-l]) cylinder(d=d,h=l);
  }

}

module SMDpassive(size="0805", thick=0, label=""){
  // SMD chip resistors, capacitors and other passives by EIA standard
  // e.g. 0805 means 0.08" by 0.05"
  // Dimensions (height, metallization) from Vishay CHP resistors
  // [size,body,capsWdth]
  dimsLUT=[
       ["0201",[0.6,0.3,0.25],0.1],
       ["0402",[1.02,0.5,0.38],0.25],
       ["0603",[1.6,0.8,0.45],0.3],
       ["0805",[2,1.25,0.55],0.4],
       ["1206",[3.2,1.6,0.55],0.45],
       ["1210",[3.2,2.6,0.55],0.5],
       ["1812",[4.6,3.2,0.55],0.5],
       ["2010",[5.0,2.5,0.55],0.6],
       ["2512",[6.35,3.2,0.55],0.6]
       ];
  
  testLUT=[ ["abc",3],["def",5],["gh",6] ];
  
  mtlLngth=dimsLUT[search([size],dimsLUT)[0]][2];//length of metallization
  bdDims=dimsLUT[search([size],dimsLUT)[0]][1]-[mtlLngth,0,0];
  ovThick= thick ? thick : bdDims.z;
  
  txtSize=bdDims.x/(0.8*len(label));
  if (label)
    color("white") translate([0,0,ovThick]) linear_extrude(0.1) 
      text(text=label,size=txtSize,halign="center",valign="center", font="consolas");
  
  
  //body
  color("darkSlateGrey") translate([0,0,ovThick/2]) cube([bdDims.x,bdDims.y,ovThick],true);
  //caps
  for (i=[-1,1]) color("silver")
    translate([i*(bdDims.x+mtlLngth)/2,0,ovThick/2]) cube([mtlLngth,bdDims.y,ovThick],true);
}


// -- helper modules --

module rndRectInt(size=[5,5,2],rad=1,center=false, method=""){
  
  cntrOffset= (center) ? [0,0,0] : [size.x/2,size.y/2,size.z/2];

  if (method=="offset") //doesn't work with freecad
    translate(cntrOffset+[0,0,-size.z/2]) linear_extrude(size.z) offset(rad) square([size.x-rad*2,size.y-rad*2],true);
  else
    translate(cntrOffset) hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]) cylinder(r=rad,h=size.z,center=true);
}
