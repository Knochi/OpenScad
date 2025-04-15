

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
pcbGreenCol=        [0.07,  0.3,    0.12]; //pcb green
pcbBlackCol=        [0.16,  0.16,   0.16]; //pcb black
pcbBlue=            [0.07,  0.12,   0.3];
FR4darkCol=         [0.2,   0.17,   0.087]; //?
FR4Col=             [0.43,  0.46,   0.295]; //?


fudge=0.1;
$fn=40;


DIPSwitch();
module DIPSwitch(digits=6){
  //https://www.lcsc.com/product-detail/DIP-Switches_ROCPU-Switches-THS106J_C2758168.html
  //THS Series J-Hook
  width= (digits==10) ? 13.8 :
         (digits==8) ? 11.3 :
         (digits==6) ? 8.75 :
         (digits==4) ? 6.2  :
         3.7; //2
  bdyDims= [width,6.2,1.7];
  spcng=2.3-1.7;
  pitch=1.27;
  //terminals
  tWdth=0.4;
  tThck=0.2;
  tHght=2.3-0.45-tThck;
  tDist=7.1-tThck;
  tRad=0.15; //terminal bend Radius
  tZOffset=0.45; //offset from body top
  markDims=[0.9,0.9,0.2];
  //switches
  //cavity dimensions
  cvDims=[pitch*0.6,bdyDims.y*0.7,bdyDims.z*0.25];
  swLen=bdyDims.y*0.36;
  txtSize=(bdyDims.y-cvDims.y)/2*0.8;
  
  cavPoly=[[cvDims.y/2+fudge,fudge],[cvDims.y/2-cvDims.z,-cvDims.z],[swLen/2,-cvDims.z],[swLen/2,-cvDims.z*2],
          [-swLen/2,-cvDims.z*2],[-swLen/2,-cvDims.z],[-cvDims.y/2+cvDims.z,-cvDims.z],[-cvDims.y/2-fudge,fudge]];
  
  //body
  color(blackBodyCol) translate([0,0,bdyDims.z/2+spcng]) difference(){
    cube(bdyDims,true);
    //marking
    translate([bdyDims.x/2-markDims.x,bdyDims.y/2-markDims.y,bdyDims.z/2-markDims.z]) 
      linear_extrude(markDims.z+fudge) 
        polygon([[0,markDims.y+fudge],[markDims.x+fudge,markDims.y+fudge],[markDims.x+fudge,0]]);
    //cavities for switches
    for (ix=[-(digits-1)/2:(digits-1)/2])
      translate([ix*pitch,0,bdyDims.z/2]) rotate([90,0,90]) linear_extrude(cvDims.x,center=true) polygon(cavPoly);
  }
  
  //switches
  color(whiteBodyCol) 
    for (ix=[-(digits-1)/2:(digits-1)/2]){
      translate([ix*pitch,0,bdyDims.z/2+spcng]){
        translate([0,(swLen-cvDims.x)/2,0]) cylinder(d=cvDims.x,h=cvDims.z*2);
        cube([cvDims.x,swLen,cvDims.z/2],true);
      }
    }
  
  
  //terminals
  for (ix=[-(digits-1)/2:(digits-1)/2],iy=[-1,1]){
    rot = (iy<0) ? -90 : 90;
    color(metalGoldPinCol) 
      translate([ix*pitch,iy*bdyDims.y/2,bdyDims.z+spcng-tThck/2-tZOffset]) 
        rotate(rot) terminal();      
        }
    
  //text
  color(lightBrownLabelCol) translate([-bdyDims.x/2*0.8,bdyDims.y/2-(bdyDims.y-cvDims.y)/4,bdyDims.z+spcng]) 
    linear_extrude(0.1) text("ON",size=txtSize,valign="center");
    /*
  for (i=[0:digits-1])
    color(lightBrownLabelCol) 
      translate([-pitch*(digits-1)/2+i*pitch,-(bdyDims.y/2-(bdyDims.y-cvDims.y)/4),bdyDims.z+spcng]) 
        linear_extrude(0.01) text(str(1+i),size=txtSize,valign="center",halign="center");
    */
    
  module terminal(){
    startLen=(tDist-bdyDims.y)/2-tRad-tThck/2;
    centerLen=tHght-tRad*2-tThck;
    endLen=(startLen+tRad)*2;
    
    translate([startLen/2,0,0]) cube([startLen,tWdth,tThck],true);
    translate([startLen,0,0]) bend();
    translate([startLen+tRad+tThck/2,0,-centerLen/2-tRad-tThck/2]) rotate([0,90,0]) cube([centerLen,tWdth,tThck],true);
    translate([startLen+tRad+tThck/2,0,-centerLen-tRad-tThck/2]) rotate([0,90,0]) bend();
    translate([-endLen/2+startLen,0,-centerLen-tRad*2-tThck]) cube([endLen,tWdth,tThck],true);
    
    module bend(){
      rotate([90,0,0]) 
        translate([0,-tRad-tThck/2,-tWdth/2])
          rotate_extrude(angle=90) 
            translate([tRad,0]) 
              square([tThck,tWdth]);
    }
  } 
}
