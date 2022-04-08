/*
*   3dModel creation scripts for KiCAD by Knochi
*   export as .csg, import in freecad and proceed with KiCadStepUp
*/


$fn=50;
fudge=0.1;


/* [Select] */
export= "none"; //["PDUUAT","ACT1210","SumidaCR43","TY6028","none"]

/* [configure] */
PDUUATseries= "UU16"; //["UU9.8","UU10.5","UU16"]


/* [Hidden] */
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

if (export == "PDUUAT")
    !PDUU(PDUUATseries, false);
else if (export == "ACT1210")
    !ACT1210();
else if (export == "SumidaCR43")
    !sumidaCR43();
else if (export == "TY6028")
    !TY_6028();
else
    echo("Nothing to render!")

// --- Inductors ---
*PDUU("UU9.8",center=false);
module PDUU(series="UU16", center=true){
  //https://datasheet.lcsc.com/lcsc/2201121530_PROD-Tech-PDUUAT16-503MLN_C2932169.pdf

  //Series
  //         0    1    2    3   4    5    6
  //         A,   B,   C,   D,  D1,  D2,  L 
  UU98 =    [17.0,12.0,17.0,0.6, 7.0, 8.0,4.0];
  UU105 =   [19.5,18.0,23.0,0.7,10.5,13.5,4.0];
  UU16 =    [22.0,20.0,28.5,0.7,10.5,13.5,4.0];
  /*
  * A: total width (incl. metal clamp)
  * B: total body deep
  * C: total Height
  * D: pin Diameter
  * D1: pin distance y
  * D2: pin distance x
  * L: pin Length
  */

  dims= (series=="UU16")    ? UU16 :
        (series=="UU10.5")  ? UU105 :
        (series=="UU9.8")   ? UU98 :
        UU16; //default


  sprtWdth=1.5; //thickness of separators
  coilFillFact=0.8; //

  //pin1 or center
  cntrOffset = (center) ? [0,0,0] : [dims[5]/2,-dims[4]/2,0];

  //core/coil
  coreThck=((dims[0]-1)-dims[5])/2; //thickness from overall width and pin distance
  coreDims=[dims[0]-1,coreThck,(dims[2]+coreThck)/2]; //iron core 
  coreInnerDims=[coreDims.x-coreThck*2,coreDims.y,coreDims.z-coreThck*2]; //innerDims from coreDims and thick
  coreChmf=0.3; //chamfering of the core
  corezOffset=(dims[2]-coreThck)/2;
  sprtrDims=[sprtWdth,dims[1],coreInnerDims.z*2+coreThck*2]; //separator Dimensions
  sprtrRad=3; //radius of separator plates
  coilDims=[(coreInnerDims.x-3*sprtrDims.x)/2,9];
  
  
  // pins
  translate(cntrOffset){
    for (ix=[-1,1],iy=[-1,1])
        color(metalGreyPinCol) translate([ix*dims[5]/2,iy*dims[4]/2,-dims[6]]) cylinder(d=dims[3],h=dims[6]);
  
    // core
      translate([0,coreDims.y/2,corezOffset+coreDims.z/2]) rotate([90,0,0]){
        color(greyBodyCol) linear_extrude(coreDims.y)
            difference(){
                square([coreDims.x,coreDims.z],true);
                square([coreInnerDims.x,coreInnerDims.z],true);
            }
    }
  
  
  //separators
    for (ix=[-1,0,1]){
        translate([ix*(coreInnerDims.x-sprtrDims.x)/2,0,corezOffset+coreThck/2]) 
          rotate([0,90,0]) difference(){
            union(){
              color(blackBodyCol) translate([coreThck/2,0,0]) rndRectInt([sprtrDims.z,sprtrDims.y,sprtrDims.x],sprtrRad,true);
              if (ix)
                color(blackBodyCol) translate([corezOffset-coreThck/2,0,ix*sprtrDims.x/2])
                  rndRectInt([coreThck*2,sprtrDims.y,sprtrDims.x*2],1,true);
            }
            color(blackBodyCol) cube([coreThck+fudge,coreDims.y+fudge,sprtrDims.x+fudge],true);
          } 
    }
  
  
    //coils
    for (ix=[-1,1])
      color(metalCopperCol) translate([ix*(sprtrDims.x+coilDims.x)/2,0,corezOffset+coreThck/2])
        rotate([0,90,0]) coilShape([coreThck,coreDims.y],coreInnerDims.z*coilFillFact,coilDims.x);
  }
  

  module coilShape(innerDims, thick, width){
    translate([0,0,-width/2]) linear_extrude(width) difference(){
      offset(thick) square(innerDims,true);
      square(innerDims,true);
    }
  }

}

*ACT1210();
module ACT1210(rad=0.06){
  
  spcng=0.25;
  ovDim=[3.2,2.5,2.35]; //overall dimensions without solder bubbles
  topDim=[3.2,2.5,0.7];
  radDim=[-rad*2,-rad*2,-rad*2]; //reduce dim by radius
  
  
  difference(){
    translate([0,0,1.65+0.7/2]) 
      color(blackBodyCol) if (rad)  minkowski($fn=20){
         cube(topDim+[-rad*2,-rad*2,-rad*2],true);
         sphere(rad);
      }
      else
        color(blackBodyCol) cube(topDim,true);
      translate([0,0,ovDim.z-0.05]) 
      color("white") linear_extrude(0.1)  text("ACT1210",valign="center",halign="center",size=0.5);
    }    
    
    body();

  
  coil();
  translate([-1*(ovDim.x/2-0.1),1.2,0.75]) rotate([90,0,-90]) contact();                    // -1,+1,0,-1
  translate([-1*(ovDim.x/2-0.1),-1*1.2,0.75]) mirror([0,1,0]) rotate([90,0,-90]) contact(); // -1,-1,1,-1
  translate([1*(ovDim.x/2-0.1),-1*1.2,0.75]) mirror([0,0,0]) rotate([90,0,90]) contact();   // +1,-1,0,+1
  translate([1*(ovDim.x/2-0.1),1*1.2,0.75]) mirror([0,1,0]) rotate([90,0,90]) contact();    // +1,+1,1,+1
    
  
    
  module contact(){
    thck=0.1;
    rad=0.05;
    color(metalGreyPinCol) rndRectInt([0.9,0.35,thck],rad);
    translate([0.9-0.35,-0.6,0]) 
      color(metalGreyPinCol) cube([0.35,0.6+rad,thck]);
    translate([0.9-0.35,-0.6,0]) 
      mirror([0,1,0]) 
        color(metalGreyPinCol) bend(size=[0.35,0.46,thck],angle=-90,radius=0.15,center=false, flatten=false)
          cube([0.35,0.46,thck]);
    translate([0.9-0.35,-0.6-0.1/2,-0.46-0.1/2]) rotate([0,-90,90]) 
      color(metalGreyPinCol) bend([0.46,0.3,thck],-90,0.2) cube([0.46,0.3,thck]);
  }  
    
  module coil(){
    translate([0,0,0.7*1.5]) rotate([90,0,90]) color(metalCopperCol)rndRectInt([2.3,1.6-0.5,1.7],0.3,true);
  }
    
  module body(){
    bdDim=[0.7,2.5,1.4];
    for (m=[0,1])
    color(blackBodyCol) mirror([m,0,0]) translate([(ovDim.x-bdDim.x)/2,0,bdDim.z/2+spcng]) 
      difference(){
        cube(bdDim,true);
        for (iy=[-1,1]){
          color(blackBodyCol) 
            translate([0,iy*(bdDim.y-0.5+fudge)/2,-(bdDim.z-0.4+fudge)/2]) 
              cube([bdDim.x+fudge,0.5+fudge,0.4+fudge],true);
          color(blackBodyCol)
            translate([(bdDim.x+fudge)/2,iy*(bdDim.y-1.1+fudge)/2,-(bdDim.z-1+fudge)/2])
              cube([0.2+fudge,1.1+fudge,1+fudge],true);
        }
      }
    //bar
      color(blackBodyCol) translate([0,0,0.7*1.5]) cube([ovDim.x-2*bdDim.x,bdDim.y-0.5,0.7],true);
  }
}


*sumidaCR43();
module sumidaCR43(){
  ovDia=4.3;
  ovHght=3.2;
  coilDia=3.1;
  
  difference(){
    coil();
    color("white") translate([0,0,3.15]) linear_extrude(0.1) text("CR43",valign="center",halign="center",size=0.8);
  }
  
  base();
  for (m=[0,1]) mirror([m,0,0])
  translate([1.7-0.3,0,0]) 
    contact();
  
  
  module contact(){
    thck=0.15;
    sgmnts=[[0.6,0.7,thck],[1.2-thck,0.5,thck],[thck,0.5,0.6-thck]]; //segment dims from center outward
    
    for (m=[0,1]) mirror([0,m,0]){
      color(metalGreyPinCol) translate([0,sgmnts[0].y/2,0.34-thck/2]) cube(sgmnts[0],true);
      color(metalGreyPinCol) translate([(sgmnts[1].x-sgmnts[0].x)/2,1.2+sgmnts[1].y/2,thck/2]) cube(sgmnts[1],true);
      color(metalGreyPinCol) translate([-sgmnts[0].x/2+sgmnts[1].x,1.2+sgmnts[1].y/2,thck/2]) 
        rotate([90,0,0]) cylinder(d=thck,h=sgmnts[1].y,center=true);
      color(metalGreyPinCol) translate([-sgmnts[0].x/2+sgmnts[1].x,1.2+sgmnts[1].y/2,sgmnts[2].z/2+thck/2]) cube(sgmnts[2],true);
      color(metalGreyPinCol) translate([0,1.2,thck/2]) 
        rotate([0,90,0]) cylinder(d=thck,h=sgmnts[0].x,center=true);
      
    }
  }
  
  module coil(){
    difference(){
      intersection(){
        union(){
          color(blackBodyCol) translate([0,0,0.5]) cylinder(d=ovDia,h=0.6);
          color(metalCopperCol) translate([0,0,0.5+0.6]) cylinder(d=coilDia,h=1.5);
          color(blackBodyCol) translate([0,0,0.5+0.6+1.5]) cylinder(d=ovDia,h=0.6);
        }
         color(blackBodyCol) translate([0,0,(ovHght+fudge)/2]) cube([ovDia+fudge,3.8,ovHght+fudge],true);
      }
      for (ix=[-1,1]){
      color(blackBodyCol) translate([ix*3.8/2,0,-fudge/2]) cylinder(d=0.6,h=ovHght+fudge);
      color(blackBodyCol) translate([ix*(3.8+0.6)/2,0,(ovHght)/2]) cube([0.6,0.6,ovHght+fudge],true);
      }
    }
  }
  
  module base(){
    ovDims=[4.5,3.9,0.45];
    crnrRad=0.2;
    
    
    translate([0,0,0.05]){
    difference(){
      union(){
        difference(){
          color(blackBodyCol) translate([0,0,ovDims.z/2]) rndRectInt(ovDims+[-0.4,0,0],crnrRad,true);
          for (ix=[-1,1])
            color(blackBodyCol) translate([ix*(ovDims.x-1)/2,0,ovDims.z/2]) cube([1+fudge,2,ovDims.z+fudge],true);
        }
      
        for (iy=[0,1]) mirror([0,iy,0])
          translate([0,-1,0]) difference(){
            color(blackBodyCol) translate([0,0,ovDims.z/2]) 
              rndRectInt([ovDims.x,0.7*2,ovDims.z],crnrRad,true);
            color(blackBodyCol) translate([0,-0.7/2-fudge/2,ovDims.z/2]) 
              cube([ovDims.x+fudge,0.7+fudge,ovDims.z+fudge],true);
          }       
      }
    
    for (i=[-1,1])
      color(blackBodyCol) translate([i*(ovDims.x+fudge)/2,0,-0.01]) 
        rotate([90,0,-i*90]) linear_extrude(1.5) 
          polygon([[-0.7,0],[-0.45,0.3],[0.45,0.3],[0.7,0]]);
    }
  }
  }
}

*TY_6028();
module TY_6028(){
  //body
  W=6;
  L=6;
  H=2.8;
  dI=2.3;
  e=1.35;
  f=4;
  
  //base
  rad=0.35;
  baseDims=[4.35,W,0.5];
  capDims=[[L, 5.65,0.5],[3.5,3.1,0.5]]; //outer, corners
  solder=0.15;
  
  translate([0,0,solder])
  color(blackBodyCol){
    //linear_extrude(baseDims.z)
      hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(baseDims.x/2-rad),iy*(W/2-rad)]) 
          cylinder(r=rad,h=baseDims.z);
  //cap octagon
  cap();
  translate([0,0,H-capDims[0].z-solder]) cap();  
    }
    
  module cap(){
    //linear_extrude(capDims[0].z)
      hull(){ 
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*(capDims[1].x/2-rad),iy*(capDims[0].y/2-rad)])
            cylinder(r=rad,h=capDims[0].z);
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*(capDims[0].x/2-rad),iy*(capDims[1].y/2-rad)])
            cylinder(r=rad,h=capDims[0].z);
      }
    }
    //coil
    color(metalCopperCol) translate([0,0,0.5+solder]) cylinder(d=capDims[0].y-0.5,h=H-1-solder);
    //pads
    color(metalGreyPinCol) for(iy=[-1,1])
      translate([0,iy*f/2,solder/2]) cube([baseDims.x,e,solder],true);
    color(metalGreyPinCol) for(iy=[-1,1])
      translate([0,iy*(baseDims.y-e)/2,solder/2]) cube([dI,e,solder],true);
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
