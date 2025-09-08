/*
*   3dModel creation scripts for KiCAD by Knochi
*   export as .csg, import in freecad and proceed with KiCadStepUp
*/


$fn=50;

/* [Select] */
export= "none"; //["C32","3D2H306KLMB0420400200","none"]

/* [Variants] */
capSize=[26.5,14.5,29.5];
capPitch=[22.5,0];
capLeadDia=0.8;
capLeadLngth=4.5;

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

if (export == "C32")
  !boxCapacitor(size=capSize, leads=[capLeadDia,capLeadLngth], pitch=capPitch);
else if (export =="3D2H306KLMB0420400200")
  !boxCapacitor(size=[42.0,20.0,40.0], leads=[1.2,20], pitch=[37.5,10.2]);
else
  echo("Nothing to render!");

SMDJhook();
module SMDJhook(){
//https://www.lcsc.com/datasheet/C42393559.pdf
  
  spcng=0.15;
  bdyDims=[6,5.55,2.38-spcng];
  leadThck=0.15;
  leadRad=0.2;//bending radius
  leadAng=10;
  leadLengths=[0.73,0.13];
  
  //body
  color(blackBodyCol)
    translate([0,0,bdyDims.z/2+spcng]){
      pillow(size=[bdyDims.x,bdyDims.y,bdyDims.z/2]);
      mirror([0,0,1]) pillow(size=[bdyDims.x,bdyDims.y,bdyDims.z/2]);
    }
  //leads
  for (m=[0,1])
  mirror([m,0,0])
    translate([0,0,spcng+bdyDims.z/2-leadThck/2]) color(metalGreyPinCol){
      translate([bdyDims.x/4,0,0]) cube([bdyDims.x/2,2.5,leadThck],true);
      translate([bdyDims.x/2,0,-leadRad]) 
        rotate([90,-90,0]) 
          rotate_extrude(angle=-90+leadAng) translate([leadRad,0]) square([leadThck,2.5],true);
      translate([bdyDims.x/2,0,-leadRad]) 
        rotate([0,90-leadAng,0]) 
          translate([leadLengths[0]/2,0,leadRad]){
            cube([leadLengths[0],2.5,leadThck],true);
            translate([leadLengths[0]/2,0,-leadRad]){
              rotate([90,-90,0])
                rotate_extrude(angle=-90-leadAng) translate([leadRad,0]) square([leadThck,2.5],true);
              rotate([0,90+leadAng,0]) translate([leadLengths[1]/2,0,leadRad]) cube([leadLengths[1],2.5,leadThck],true);
            }
          }
    }
}  
  
  
*capacitorTHT();
module capacitorTHT(D=16,L=30,axial=true){
  showMarking=true;
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
*boxCapacitor();
module boxCapacitor(size=[57,35,50], leads=[1.2,5.5], pitch=[52.5,20.3], center=false){
  //e.g. https://www.alfatec.de/fileadmin/Webdata/Datenblaetter/Faratronic/C3D_Specification_alfatec.pdf
  // C3D3A406KM0AC00, 4 pin DC, lead length 5.5mm, 
  // size=[W,T,H], leads=[d,C], pitch=[P,b] (set b to zero for 2pin)

  //pitch=52.5;
  rad=1;
  cntrOffset = (center) ? [0,0,0] : [pitch.x/2,-pitch.y/2,0];
  iyPins= pitch[1] ? [-1,1] : [0]; //if pitch[1] not zero --> four pin
  translate(cntrOffset){
    /* rounded corners, problems with import into freecad
    color(greyBodyCol) linear_extrude(size.z-rad) hull()
      for (ix=[-1,1],iy=[-1,1]) translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]) circle(rad); 
    color(greyBodyCol) for (ix=[-1,1],iy=[-1,1]){
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad),size.z-rad]) sphere(rad);
      if (iy==1) translate([ix*(size.x/2-rad),0,size.z-rad]) rotate([90,0,0]) cylinder(r=rad,h=size.y-rad*2,center=true);
      if (ix==1) translate([0,iy*(size.y/2-rad),size.z-rad]) rotate([0,90,0]) cylinder(r=rad,h=size.x-rad*2,center=true);
    }
    color(greyBodyCol) translate([0,0,size.z-rad]) cube([size.x-rad*2,size.y-rad*2,rad*2],true);
    */
    color(greyBodyCol) translate([0,0,size.z/2]) cube(size,true);
    
    //pins
    for (ix=[-1,1],iy=iyPins)
      color(metalGreyPinCol) translate([ix*pitch.x/2,iy*pitch.y/2,-leads[1]]) 
        cylinder(d=leads[0],h=leads[1]);
  }

}
*SMDpassive();
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
*rndRectInt();
module rndRectInt(size=[5,5,2],rad=1,center=false, method=""){
  
  cntrOffset= (center) ? [0,0,0] : [size.x/2,size.y/2,size.z/2];

  if (method=="offset") //doesn't work with freecad
    translate(cntrOffset+[0,0,-size.z/2]) linear_extrude(size.z) offset(rad) square([size.x-rad*2,size.y-rad*2],true);
  else
    translate(cntrOffset) hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]) cylinder(r=rad,h=size.z,center=true);
}

*pillow();
module pillow(size=[6,5.55,1.2],rad=0.2,angle=5){
  //half pillow
  flankOffset=tan(angle)*(size.z-rad);
  echo(flankOffset);
  hull(){
    linear_extrude(0.1,scale=0) for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]) circle(rad);
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad-flankOffset),iy*(size.y/2-rad-flankOffset),size.z-rad]) sphere(rad);
  }
}
