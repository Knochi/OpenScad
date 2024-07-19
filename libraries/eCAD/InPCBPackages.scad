
/* [Dimensions] */
pcbDims=[90,50];
pcbThck=1.0;
pcbRad=3;
mcuCutOut=[6.7,5.4];
oledCutOut=[];

/* [Positions] */
mcuPos=[5,0];
oledPos=[-10,40];

/* [Hidden] */
fudge=0.1;
$fn=50;


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
ledRedCol=          [0.700, 0.100,  0.050, ledAlpha];
ledWhiteCol=        [0.895, 0.891,  0.813, ledAlpha];
//ledgreyCol=         [0.27, 0.25, 0.27, ledAlpha];
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



color("darkGreen") linear_extrude(pcbThck) difference(){
  hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(pcbDims.x/2-pcbRad),iy*(pcbDims.y/2-pcbRad)]) circle(pcbRad);
  translate(mcuPos) square(mcuCutOut,true);
}

translate([mcuPos.x,mcuPos.y,pcbThck+0.2]) rotate([180,0,0]) TSSOP();
translate([oledPos.x,oledPos.y,0]) OLED0_91inch128x32();

module OLED0_91inch128x32(){
  AADims=[22.384,5.584];
  panelDims=[30,11.5,1.2];
  //polarizer
  polDims=[25.9,10,0.2];
  polYOffset=-0.5;
  flexDims=[10.5,9,0.1];
  capDims=[26.6,11.5];
  
  bendRadius=5;
  
  //polarizer
  color(glassGreyCol) translate([0,-polDims.y+polYOffset,panelDims.z]) cube(polDims);
  
  //flex 
  color(orangeBodyCol) translate([capDims.x,-panelDims.y,panelDims.z/2-flexDims.z]) 
    cube(flexDims+[panelDims.x-capDims.x,0,0]);
  //bend the flex up and down calculate the radius for two 45° bends
  rotate_extrude(angle=45) translate([bendRadius,0]) square([flexDims.z,flexDims.y]);
  translate([7.14,7.14,0]) rotate(180) rotate_extrude(angle=45) translate([bendRadius,0]) square([flexDims.z,flexDims.y]);
  
  //panel
  color("white",0.5){
    translate([0,-capDims.y,0]) linear_extrude(panelDims.z/2) square(capDims);
    translate([0,-capDims.y,panelDims.z/2]) linear_extrude(panelDims.z/2) square([panelDims.x,panelDims.y]);
  }
  
  
}

module TSSOP(pins=20, pitch=0.65,  label=""){
  //Plastic shrink small outline package (14,16,18,20,24,26,28 pins)
  //https://www.jedec.org/system/files/docs/MO-137E.pdf (max. values where possible)
  
  b= 0.25; //lead width //JEDEC b: 0.2-0.3
  //pitch=0.635; make overide
  A=  1.2; // total height //JEDEC A: 
  A1= 0.2; //space below package //JEDEC A1: 0.1-0.25
  c=  0.15; //lead tAickness //JEDEC: 0.1-0.25
  D= (pins==28) ? 9.9 :   //28pin //package length
     (pins > 18) ? 6.5 : //19..24pin
     (pins==18) ? 6.8 :   //e.g. Toshiba SSOP18
     4.9; // 14..16pin
  E1=4.4; //body width
  E=6.4; //total width
  h=0; //chamfer width h=0.25-0.5
  
  txtSize=D/(0.8*len(label));
  if (label)
    color(lightBrownLabelCol) translate([0,0,A]) linear_extrude(0.1) 
      text(text=label,size=txtSize,halign="center",valign="center", font="consolas");
  
  
  //body
  color(blackBodyCol)
    difference(){
      translate([-D/2,-E1/2,A1]) cube([D,E1,(A-A1)]);
      translate([0,E1/2+fudge,A+fudge]) 
        rotate([0,90,180]) 
          linear_extrude(D+fudge,center=true) 
            polygon([[0,0],[h+fudge,0],[0,h+fudge]]);
    }    
  //leads
  color(metalGreyPinCol)
    for (i=[-pins/2+1:2:pins/2],r=[-90,90])
      rotate([0,0,r]) translate([E1/2,i*pitch/2,0]) lead([(E-E1)/2,b,A*0.5]);
  echo(pitch);
}

module lead(dims=[1.04,0.51,0.7],thick=0.2){
  
  b=dims.x*0.7; //lead length tip //JEDEC: 0.835 +-0.435
  a=dims.x-b; //JEDEC SOIC total length=1.04;
  
  translate([0,-dims.y/2,dims.z]){
    translate([-fudge,0,0]) cube([a+fudge,dims.y,thick]);
    translate([a,0,thick/2]) rotate([-90,0,0]) cylinder(d=thick,h=dims.y);
    translate([a-thick/2,0,-dims.z+thick/2]) cube([thick,dims.y,dims.z]);
    translate([a,0,-dims.z+thick/2]) rotate([-90,0,0]) cylinder(d=thick,h=dims.y);
    translate([a,0,-dims.z]) cube([b,dims.y,thick]);
  }
}