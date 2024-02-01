
//by Knochi 2022/12/01 - mail@knochi.de
//export to .csg then open in FreeCad and save to KiCAD using KicadStepUp Workbench

/* [Dimensions] */
bodyDims=[3.2,1.0,0.48]; //including pads
capWidth=0.45;
filRad=0.25;
plating=0.02;
marking=0.005;
domeDia=2.2;


/* [Hidden] */
$fn=50;
fudge=0.1;
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



assembly();

module assembly(){
  translate([0,bodyDims.z-plating,0]) dome();
  translate([0,0,bodyDims.y/2]) rotate([-90,0,0]){
    for (im=[0,1])
        mirror([im,0,0]) translate([bodyDims.x/2,0,0]) color(metalGoldPinCol) cap();
    cntrPad();
    body();
    marking();
  }
}

module body(){
    //plating
  translate([0,0,plating]) color(whiteBodyCol) linear_extrude(bodyDims.z-plating*2) 
    difference(){
      square([bodyDims.x,bodyDims.y],true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(bodyDims.x/2),iy*(bodyDims.y/2)]) circle(filRad+plating);
    }
}

module cap(){
    translate([-capWidth/2,0,bodyDims.z/2]) difference(){
      cube([capWidth,bodyDims.y,bodyDims.z],true);
      for (iy=[-1,1])
        translate([capWidth/2,iy*bodyDims.y/2]) cylinder(r=filRad,h=bodyDims.z+fudge,center=true);
      cube([capWidth+fudge,bodyDims.y-filRad*2-plating*2,bodyDims.z-plating*2],true);

      translate([-(capWidth-(capWidth-filRad-plating)+fudge)/2,0,0]) 
        cube([capWidth-filRad-plating+fudge,bodyDims.y+fudge,bodyDims.z-plating*2],true);
    }
  }

module cntrPad(){
color(metalGoldPinCol) linear_extrude(plating){
    square(0.8,true);
    square([0.07,bodyDims.y],true);
}
}

*dome();
module dome(){
  color(ledWhiteCol) linear_extrude(height = bodyDims.y) difference(){
    circle(d=domeDia);
    //need a very small gap to prevent bottom face from dissapearing
    translate([0,-(domeDia+fudge-0.001)/2]) square(domeDia+fudge,true);
  }
}

*marking();
module marking(){
  translate([(0.8+0.2)/2,0,plating-marking]) color(greenBodyCol) linear_extrude(marking) square([0.2,bodyDims.y],true);
}