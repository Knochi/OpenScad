$fn=50;


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
//non VRML cols
polymidCol=         "#cd8200";



OLED1_5inch4pin();
module OLED1_5inch4pin(center=false){
  //chinese OLED display 4pin 1.5Inch
  //https://www.lcdwiki.com/1.5inch_OLED_Module_SKU%3AMC01506
  
  //Dimensions of the elements
  PCBDims=[34,47,1.14];
  PCBchamfer=1.115; //results in 0.65mm chamfer
  glassDims=[33.9,37.3,1.5];
  aaDims=[26.855,26.855,0.02]; //active area
  cutOutDims=[0,0]; //cutOut at the bottom
  
  //offsets from top of PCB to top of element
  holeYOffset=-2.5;
  glassYOffset=-4.85;
  hdrYOffset=-1.5;
  aaYOffset=-7.25;
  
  //mounting hole pattern
  holeDist=[29,42];
  
  //inner and outer diameter of mounting holes (PTH)
  holeDiaIn=2.2; //drill
  holeDiaOut=3.1; //copper
  
  //microfudge to isolate surfaces
  mfudge=0.1;
  
  cntrOffset= center ? [0,0,0] : [2.54*1.5,-PCBDims.y/2-hdrYOffset,2.5];
  
  translate(cntrOffset){
    //PCB
    color(pcbBlueCol) linear_extrude(PCBDims.z)
      difference(){
        offset(delta=PCBchamfer,chamfer=true) square([PCBDims.x-PCBchamfer*2,PCBDims.y-PCBchamfer*2],true);
        //screwholes
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*holeDist.x/2,iy*holeDist.y/2+cntrOffset(holeYOffset,holeDist.y)]) circle(d=holeDiaOut);
        //pins
        for (ix=[-(4-1)/2:(4-1)/2])
          translate([ix*2.54,PCBDims.y/2+hdrYOffset]) circle(d=1.0);
        //cutout
  *translate([0,(-PCBDims.y+cutOutDims.y)/2]) square(cutOutDims,true);
        }
    //glass
    translate([0,0,PCBDims.z+mfudge]) 
      color(greyBodyCol)
        linear_extrude(glassDims.z)
          difference(){
            translate([0,cntrOffset(glassYOffset,glassDims.y)]) 
              square([glassDims.x,glassDims.y],true);
            translate([0,cntrOffset(aaYOffset,aaDims.y)]) 
              square([aaDims.x,aaDims.y],true);
              }
    //active area
    translate([0,0,PCBDims.z+mfudge]) 
      color(blackBodyCol)
        linear_extrude(glassDims.z)
          translate([0,cntrOffset(aaYOffset,aaDims.y)]) 
            square([aaDims.x,aaDims.y],true);
        
    //screw holes
    color(metalGoldPinCol) translate([0,0,mfudge/2]) linear_extrude(PCBDims.z-mfudge) 
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*holeDist.x/2,iy*holeDist.y/2+cntrOffset(holeYOffset,holeDist.y)]) difference(){
            circle(d=holeDiaOut);
            circle(d=holeDiaIn);
          }
          
    //pinHeader
    translate([-2.54*1.5,PCBDims.y/2+hdrYOffset,0]) rotate([180,0,0]) MPE_087(rows=1,pins=4,A=11.3,markPin1=false);
   
  }
  
  
  function cntrOffset(yOffset,yDim)=(PCBDims.y-yDim)/2+yOffset;
  
}

module MPE_087(rows=2, pins=6, A=19.8,markPin1=true, center=false){
  //       A   ,  B  ,   C , L // overall Length, above body, below body, body
  Ldict=[[10.20, 5.20, 2.50, 2.50],
        [11.30, 5.50, 3.30, 2.50],
        [10.80, 5.80, 2.50, 2.50],
        [12.60, 6.80, 3.30, 2.50],
        [13.90, 8.20, 3.30, 2.50],
        [14.70, 9.00, 3.30, 2.50],
        [16.50, 10.70, 3.30, 2.50],
        [17.70, 12.10, 3.30, 2.50],
        [19.80, 14.00, 3.30, 2.50],
        [21.60, 15.80, 3.30, 2.50],
        [22.80, 17.00, 3.30, 2.50],
        [24.90, 19.10, 3.30, 2.50],
        [10.00, 6.00, 2.50, 1.50],
        [10.60, 6.60, 2.50, 1.50],
        [11.10, 6.30, 3.30, 1.50],
        [13.80, 9.00, 3.30, 1.50],
        [14.30, 9.50, 3.30, 1.50],
        [14.60, 9.80, 3.30, 1.50],
        [16.80, 12.00, 3.30, 1.50],
        [19.60, 14.80, 3.30, 1.50],
        [21.40, 16.60, 3.30, 1.50],
        [22.60, 17.80, 3.30, 1.50],
        [24.70, 19.90, 3.30, 1.50]];
        
  pick=search(A,Ldict);
  
  L= (pick) ? Ldict[pick[0]][3] : 2.5;
  B= (pick) ? Ldict[pick[0]][1] : 5.2;
  C= (pick) ? Ldict[pick[0]][2] : 2.5;
  
  pitch=2.54;
  cntrOffset= center ? [-(pins/rows-1)/2*pitch,(rows-1)*-pitch/2,0] : [0,0,0];  
  //pins
  for (ix=[0:pins/rows-1],iy=[0:rows-1]){
    pinNo=(ix*rows+1)+iy;
    pinCol= ((pinNo==1)&&markPin1) ? redBodyCol : metalGoldPinCol;
    translate([ix*pitch,iy*pitch,-C]+cntrOffset) 
      color(pinCol) squarePin(size=0.64, length=A,center=false);
    //squarePin(size=0.64,length=10,center=false){
  }
  color(blackBodyCol) 
    linear_extrude(L){ 
      for (ix=[0:pins/rows-1],iy=[0:rows-1])
        translate([ix*pitch,iy*pitch,0]+cntrOffset) octagon();
      if (rows>1)//fill the gaps
        square([(pins/rows-1)*pitch,(rows-1)*pitch],center);
    }
}

*octagon();
module octagon(size=2.54){
  //isolator octagon 2D shape
  poly=[[-size/2,size/4],[-size/3,size/2],
        [size/3,size/2],[size/2,size/4],
        [size/2,-0.635],[size/3,-size/2],
        [-size/3,-size/2],[-size/2,-size/4]];
  polygon(poly);
}

*squarePin(center=true);
module squarePin(size=0.64,length=10,center=false){
  cntrOffset= center ? 0 : length/2;
  
  translate([0,0,cntrOffset]){
    translate([0,0,-(length-size)/2]) mirror([0,0,1]) pyramid();
    translate([0,0,0]) cube([size,size,length-size],true);
    translate([0,0,(length-size)/2]) pyramid();
  }
  
  module pyramid(){
    polyhedron([[size/2,size/2,0], //0
                      [size/2,-size/2,0], //1
                      [-size/2,-size/2,0], //2
                      [-size/2,size/2,0], //3
                      [0,0,size/2]], //4
                     [[0,1,2,3],[0,1,4],[1,2,4],[2,3,4],[3,0,4]]);
  }
}

