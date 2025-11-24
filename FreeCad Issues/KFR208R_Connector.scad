ledAlpha=0.1;
glassAlpha=0.39;
//https://gitlab.com/kicad/libraries/kicad-packages3D/-/blob/master/Vrml_materials_doc/KiCad_3D-Viewer_component-materials-reference-list_MarioLuzeiro.pdf

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
ledRedCol=          [0.700, 0.100,  0.050, ledAlpha];
ledWhiteCol=        [0.895, 0.891,  0.813, ledAlpha];
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
pcbBlueCol=         [0.07,  0.12,   0.3];
FR4darkCol=         [0.2,   0.17,   0.087]; //?
FR4Col=             [0.43,  0.46,   0.295]; //?


fudge=0.1;

$fn=50;



!KFR208R(pitch=5.08, poles=4);
module KFR208R(pitch=5.08,poles=4){
  bdyDims=[pitch*poles+1.5,16.8,16];
  pin1Offset=[2.98,bdyDims.y-2.6-8.2,0];
  pinDims=[1,0.8,4];
  lvrDims=[4,12,3.1];
  
  //body
  color(greenBodyCol) difference(){
    translate(-pin1Offset) 
      rotate([90,0,90]) linear_extrude(bdyDims.x) bdyShape();
    for (ix=[0:(poles-1)]){
      translate([ix*pitch,-pin1Offset.y-fudge,4.3]) rotate([-90,0,0]) linear_extrude(3) holeShape();
      translate([ix*pitch,-pin1Offset.y,bdyDims.z-lvrDims.z/2]) rotate([-90,0,0]) 
        linear_extrude(lvrDims.y) offset(0.05) square([lvrDims.x,lvrDims.z],true);
      }
    }
  //levers
  color(orangeBodyCol)
    for (ix=[0:poles-1],iy=[0,1])
      translate([ix*pitch,-pin1Offset.y,bdyDims.z]) rotate([90,0,90]) 
         lvrShape();
      
  //pins    
  color(metalGreyPinCol)
    for (ix=[0:poles-1],iy=[0,1])
      translate([ix*pitch,iy*8.2,0]) pin();
      
  module bdyShape(){
    poly=[[0,0],[0,12.5],[3.7,bdyDims.z],[bdyDims.y,bdyDims.z],[bdyDims.y,0]];
    polygon(poly);
  }
  
  module pin(){
    tipLngth=pinDims.z*0.25;
    tipDia=pinDims.x*0.25;
    
    color() translate([0,0,-(pinDims.z-tipLngth)/2]) cube(pinDims-[0,0,tipLngth],true);
    hull(){
      translate([0,0,-pinDims.z+tipLngth]) rotate([-90,0,0]) cylinder(d=pinDims.x,h=pinDims.y,center=true);
      translate([0,0,-pinDims.z+tipDia/2]) rotate([-90,0,0]) cylinder(d=tipDia,h=pinDims.y,center=true);
    }
  }
  
  module holeShape(){
    holeDia=5.8;
    intersection(){
      
      circle(d=holeDia);
      square([4.2,holeDia],true);
    }
  }
  
  module lvrShape(){
    hull() linear_extrude(lvrDims.x,center=true){
      translate([0,-0.2]) circle(d=1);
      translate([3.5,-lvrDims.z/2]) circle(d=lvrDims.z);
    }
    translate([3.5,-lvrDims.z]) linear_extrude(lvrDims.x,center=true) square([lvrDims.y-3.5,lvrDims.z]);
  }
}