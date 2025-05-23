/* Simple Module Power board */
$fn=50;
fudge=0.1;

*PDModule();

breadBoard();

module breadBoard(size=[5,10], h=12,brim=1.27,spacing=0.2){
  pitch=2.54;
  difference(){
    cube([size.x*pitch+brim*2,size.y*pitch+brim*2,h]);
    translate([brim,brim,h]) breadBoardPins(spacing=spacing);
  }
}
  
  
module breadBoardPins(count=[19,10], h=10, spacing=0.2){
  pinDims=[0.75,0.75];
  pinSpcng=spacing;
  pinLen=h;
  chamfer=0.4;
  pitch=2.54;
  
  for (ix=[0:count.x],iy=[0:count.y])
    translate([ix*pitch,iy*pitch,0]) pinHole();
    
  module pinHole(){
    topWdth=pinDims.x+chamfer*2+pinSpcng*2;
    botWdth=pinDims.x+pinSpcng*2;
    sFact=topWdth/botWdth;
    
    translate([0,0,fudge/2]) cube([ topWdth,topWdth,fudge],true);
    translate([0,0,-pinLen/2-pinSpcng]) cube([botWdth,botWdth,pinLen+pinSpcng],true);
    translate([0,0,-chamfer]) linear_extrude(chamfer, scale=sFact) square(botWdth,true);
    
  }
}

module PDModule(){
  /* "PD decoy module, 5A", "HW-398"
  i.e. https://de.aliexpress.com/item/1005008233128518.html
  see also: https://pappp.net/?p=73103
  set to 5V by not selecting any of the options (all open)
  */
  brdDims=[11.75,23.4,1];
  cntcDims=[1.75,3];
  
  color(pcbBlackCol) translate([0,brdDims.y/2,brdDims.z/2]) cube(brdDims,true);
  translate([0,4.5+0.6,brdDims.z]) usbC();
  color(metalGreyPinCol) for (ix=[-1,1])
    translate([ix*(brdDims.x-cntcDims.x)/2,brdDims.y-cntcDims.y/2,brdDims.z]) cube([cntcDims.x,cntcDims.y,0.1],true);
}


*usbC(plug=false);
module usbC(center=false, pins=24, plug=false){
  //https://usb.org/document-library/usb-type-cr-cable-and-connector-specification-revision-21
  //rev 2.1 may 2021
  //receptacle dims
  shellOpng=[8.34,2.56];
  shellLngth=4.5; //reference Length of shell to datum A
  shellThck=0.2;
  centerOffset = center ? [0,0,-(shellOpng.y+shellThck*2)/2] : [0,0,0] ;
  //tongue
  tngDims=[6.69,4.45,0.6];

  //body
  bdyLngth=3;

  //contacts
  //          pinA1          ...                        pinA12
  cntcLngths= (pins>16) ? [4,3.5,3.5,4,3.5,3.5,3.5,3.5,4,3.5,3.5,4] : //8x short, 4x long per side
                          [4,0,0,4,3.5,3.5,3.5,3.5,4,0,0,4]; //16pin
  cntcDims=[0.25,0.05]; //width, thickness
  
  pitch=0.5;
  
  //assembly
  translate([0,0,shellOpng.y/2+shellThck]+centerOffset) rotate([90,0,0]){
    //shell
    color(metalSilverCol) translate([0,0,-bdyLngth]) rcptShell(shellLngth+bdyLngth);
    tongue();
    color(blackBodyCol) translate([0,0,-bdyLngth]) linear_extrude(bdyLngth) shellShape();
  }

  //plug
  if (plug)
    translate([0,0,shellOpng.y/2+shellThck]+centerOffset) rotate([-90,0,0]) plug();
  
  module tongue(){
    tngPoly=[[0,0.6],[1.37,0.6],[1.62,tngDims.z/2],[tngDims.y-0.1,tngDims.z/2],[tngDims.y,tngDims.z/2-0.1],
    [tngDims.y,-(tngDims.z/2-0.1)],[tngDims.y-0.1,-tngDims.z/2],[1.62,-tngDims.z/2],[1.37,-0.6],[0,-0.6]];

    color(blackBodyCol) rotate([0,-90,0]) linear_extrude(tngDims.x,center=true) polygon(tngPoly);
    for (ix=[0:11],iy=[-1,1])
      color(metalGoldPinCol) translate([ix*pitch-11/2*pitch,iy*(tngDims.z+cntcDims.y)/2,cntcLngths[ix]/2]) 
        cube([cntcDims.x,cntcDims.y,cntcLngths[ix]],true);
  }

  module rcptShell(length=shellLngth){
    linear_extrude(length) difference(){
      offset(shellThck) shellShape();
      shellShape();
    }
  }
  module shellShape(size=[shellOpng.x,shellOpng.y]){
    hull() for (ix=[-1,1])
        translate([ix*(size.x-size.y)/2,0]) circle(d=size.y);
  }
  
  module plug(){
    //minimal Plug length from USB.org
    translate([0,0,-6.65]){
      color(metalGreyPinCol) linear_extrude(6.65)
        shellShape(size=[8.25,2.4]);
      //body max width,height
      color(blackBodyCol) translate([0,0,-35]) 
        linear_extrude(35) shellShape(size=[12.35,6.5]);
    }
  }
}


//KiCAD Colors
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
pcbBlueCol=            [0.07,  0.12,   0.3];
FR4darkCol=         [0.2,   0.17,   0.087]; //?
FR4Col=             [0.43,  0.46,   0.295]; //?
//non VRML cols
polymidCol=         "#cd8200";
