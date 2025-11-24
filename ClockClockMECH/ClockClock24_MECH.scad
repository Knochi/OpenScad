 // VID28-05 double shaft Motor
// information from https://blog.drorgluska.com/2019/03/a-million-times.html

//Speedy 360 Working area (W x D)	813 x 508 mm

/* [Dimensions] */

minWallThck=1.2;
minRoofThck=0.6;
brimWidth=50;

//distance between the shafts in x and y
clockDist=100; 
clockDia=94;          //from screenshot
clock2TopHandSpcng=2; //from screenshot
clock2BotHandSpcng=8; //from screenshot
clockCount=[8,3];

handWidth=10;
handThck=2;
handTopAng=-90;
handBotAng=120;
handIdleAng=-135;

//spacing between moving parts
handSpcng=0.2;
//spacing between top and bottom hand
handZDist=1;

//Diameter of the stem to hold threated insert
mountStemDia=8; 
mountInsertDia=5.6; //Ruthex M4 short is 5.6 for plastic parts

/* [Sensors] */
sensorXOffsets=[-20,-35];
//embedd metal pins to strenghten the field
sensorMagPins=true;
sensorMagPinDia=2;

/* [Sanding Jig] */
jigProtrude=0.5;
jigCount=5;
jigSpcng=0.1;

/* [show] */
showTopHand=true;
showBotHand=true;
showMotor=true;
showPCB=true;
showLayer0=true;
showLayer1=true;
showLayer2=true;
showLayer3=true;
//Front Layer
showLayer4=true;

export="none";//["none","Layer0","Layer1","Layer2","Layer3","topHand":"Top Hand","botHand":"Bottom hand"]

/* [options] */
roundedHands=false;
roundedCorners=false;
//metal pins for hall sensors
metalPins=false;
//split the design in the middle
splitDesign=true; 
//show which halves
splitShow="all"; //["all","left","center","right"]
//compensate kerf
kerf=0.1;

/* [Hidden] */
fudge=0.1;
$fn=128;
pcbDims=[0,0,1.6];

topHandLngth=clockDia/2-clock2TopHandSpcng;
botHandLngth=clockDia/2-clock2BotHandSpcng;

topShaftDia=1.6;
topShaftLngth=6.2;
topShaftZOffset=17.4;

botShaftDia=4.1;
botShaftLngth=4.8;
botShaftZOffset=11.2;

cornerRad= roundedCorners ? clockDist/2+brimWidth : 0;

//Clock Simulation test
handPosDigit0 =[
               [[12,3],[9,12]], //row3
               [[12,6],[6,12]], //row2
               [[3,6],[9,6]]  //row1
               ];
handPosDigit1 =[
               [[0,0],[12,12]], //row3
               [[0,0],[6,12]], //row2
               [[0,0],[6,6]]  //row1
               ];
handPosDigit3 =[
               [[3,3],[9,12]], //row3
               [[3,3],[9,12]], //row2
               [[3,3],[9,6]]  //row1
               ];
handPosDigit4 =[
               [[0,0],[12,12]], //row3
               [[12,3],[6,12]], //row2
               [[6,6],[6,6]]  //row1
               ];
handPosDigit8 =[
               [[3,12],[9,12]], //row3
               [[3,12],[9,6]], //row2
               [[3,6],[9,6]]  //row1
               ];
handPosDigit6 =[
               [[3,12],[9,12]], //row3
               [[6,12],[9,6]], //row2
               [[3,6],[9,9]]  //row1
               ];

               
handPosTopBot = handPosDigit4;
echo(handPosTopBot);
/*
[
  [[3, 12], [9, 12]], 
  [[3, 12], [9, 6]], 
  [[3, 6], [9, 6]], 
  
  [[3, 12], [9, 12]], 
  [[3, 12], [9, 6]], 
  [[3, 6], [9, 6]]
]
*/

if (export=="topHand")
  !topHand();
if (export=="botHand")
  !bottomHand();
    
layerFrame();
if (showPCB) color("darkGreen") for (ix=[0:clockCount.x-1]) translate([ix*clockDist,clockDist,1.6]) PCB();

clocks();

module clocks(){
  for(ix=[0:clockCount.x-1],iy=[0:clockCount.y-1]){
    translate([ix*clockDist,iy*clockDist]){
      //motors
      if (showMotor)
        VID28_05();
      topAngle= handPosTopBot[iy][ix][0] != undef ? time2Deg(handPosTopBot[iy][ix][0]) : handTopAng;
      botAngle= handPosTopBot[iy][ix][1] != undef ? time2Deg(handPosTopBot[iy][ix][1]) : handBotAng;

      //hands
      if (showTopHand)
        color("white") translate([0,0,topShaftZOffset]) rotate(topAngle) topHand();
      if (showBotHand)
        color("white") translate([0,0,botShaftZOffset]) rotate(botAngle) bottomHand();
      
    }
    }
}

module layerFrame(layer="all"){
  //bottom to top
  layerThck=[12,3,3,3,9];
  layerCol=["RosyBrown","Tan","BurlyWood","Wheat","NavajoWhite"];
  //layered frame
  
  ovDims=[clockDist*(clockCount.x)+brimWidth*2,clockDist*(clockCount.y)+brimWidth*2];
  
  //layer 0 Bottom "Frame"
  if (showLayer0)
    color(layerCol[0]) translate([0,0,pcbDims.z-layerThck[0]]) linear_extrude(layerThck[0]) 
      difference(){
        baseShape();
        translate([-clockDist/2,-clockDist/2]) square(ovDims+[-brimWidth*2,-brimWidth*2]);
      }
  
  //layer 1 PCB Interface
  if (showLayer1)
    color(layerCol[1]) translate([0,0,pcbDims.z]) linear_extrude(layerThck[1]) 
      difference(){
        baseShape(splits=2);
        for(ix=[0:clockCount.x-1],iy=[0:clockCount.y-1])
          translate([ix*clockDist,iy*clockDist]) offset(0.5) VID28_05(true);
        for (ix=[0:clockCount.x-1]) translate([ix*clockDist,clockDist]) PCB(true);
          }
          
  //layer 2 threated inserts
  if (showLayer2)
    color(layerCol[2]) translate([0,0,pcbDims.z+layerThck[1]]) linear_extrude(layerThck[2]) 
      difference(){
        baseShape(splits=1);
        for(ix=[0:clockCount.x-1],iy=[0:clockCount.y-1])
          translate([ix*clockDist,iy*clockDist]) circle(d=7);
        if (metalPins) //metal pins to improve hall sensor performance
          for (ix=[0:clockCount.x-1],iy=[0:clockCount.y-1],px=sensorXOffsets)
            translate([ix*clockDist,iy*clockDist]+[px,0]) circle(d=sensorMagPinDia);
        }
  
  //layer 3 clocks Background
  if (showLayer3)
    color(layerCol[3]) translate([0,0,pcbDims.z+layerThck[1]+layerThck[2]]) linear_extrude(layerThck[3]) 
      difference(){
        baseShape(splits=2);
        for(ix=[0:clockCount.x-1],iy=[0:clockCount.y-1])
          translate([ix*clockDist,iy*clockDist]) circle(d=7);
        if (metalPins) //metal pins to improve hall sensor performance
          for (ix=[0:clockCount.x-1],iy=[0:clockCount.y-1],px=sensorXOffsets)
            translate([ix*clockDist,iy*clockDist]+[px,0]) circle(d=sensorMagPinDia);
        }
      
  //layer 4 clocks frames
  if (showLayer4)
    color(layerCol[4]) translate([0,0,pcbDims.z+layerThck[1]+layerThck[2]+layerThck[3]]) linear_extrude(layerThck[4]) 
      difference(){
        baseShape(splits=1);
        for(ix=[0:clockCount.x-1],iy=[0:clockCount.y-1])
          translate([ix*clockDist,iy*clockDist]) circle(d=clockDia);
        }
      
  module baseShape(splits=2){
    //show either the actual design with gaps or compensate for kerf
    
    thisKerf = splitDesign ? (splitShow == "all") ? -kerf*3 : kerf/2 : 0;
    //split always between clocks
    dims= splitDesign ? [ovDims.x/(splits+1)+thisKerf,ovDims.y] : ovDims;
    sideDims= splitDesign ? (splits>1) ? [brimWidth+floor(clockCount.x/3)*clockDist+thisKerf,ovDims.y] : 
                                        [ovDims.x/2+thisKerf,ovDims.y] :
                           ovDims;
    cntrDims= [(clockCount.x/2)*clockDist+thisKerf,ovDims.y];
    rightOffset= (splits>1) ? sideDims.x+cntrDims.x-thisKerf*2 : ovDims.x/2;
    
    
    //one piece or leftmost one 
    if (!splitDesign || (splitShow=="left") || (splitShow=="all"))
      translate([-clockDist/2-brimWidth+cornerRad,-clockDist/2-brimWidth+cornerRad])
        offset(cornerRad) square(sideDims+[-cornerRad*2,-cornerRad*2]);
        
    //center one 
    if (splitDesign && ((splitShow=="center")|| (splitShow=="all")) && (splits==2) ) //always show split design
      translate([sideDims.x-brimWidth-clockDist/2-thisKerf,-clockDist/2-brimWidth+cornerRad])
        offset(cornerRad) square(cntrDims+[-cornerRad*2,-cornerRad*2]);
        
    //rightmost one 
    if (splitDesign && ((splitShow=="right")|| (splitShow=="all"))) //always show split design
      translate([rightOffset-clockDist/2-brimWidth,-clockDist/2-brimWidth+cornerRad])
        offset(cornerRad) square(sideDims+[-cornerRad*2,-cornerRad*2]);
  }
}





*PCB();
module PCB(cut=false){
  sensorDia=5;
  D1MiniPos=[1,33];
  swtchPos=[-32.0,-60.9];
  pwrPos=[-34.5,60];
  i2cPos=[[-34.54,75.35],[14.34,75.35]];
  holesPos=[[-30,15],[50,-50]];
  if (cut){
    //sensors
    for (px=sensorXOffsets,py=[-clockDist,0,clockDist])
      translate([px,py]) circle(d=sensorDia);
    //D1 Mini
    for (iy=[-1,1])
      translate([D1MiniPos.x,D1MiniPos.y+iy*22.86/2]) 
        hull() for (ix=[-1,1]) translate([ix*17.78/2,0]) circle(d=3);
    //DIP Switch
    for (ix=[-1,1])
      translate([swtchPos.x+ix*7.62/2,swtchPos.y]) 
        hull() for (iy=[-1,1]) translate([0,iy*7.62/2]) circle(d=2);
    //Power Con
    for (iy=[-1,1])
      translate([pwrPos.x,pwrPos.y+iy*5.08/2]) 
        circle(d=3);
    //I2C Con
    for (pos=i2cPos)
      translate([pos.x,pos.y]) 
        hull() for (iy=[-1,1])
          translate([0,iy*7.62/2])
            circle(d=3);
    //Mounting holes
    for (px=holesPos.x,py=holesPos.y)
      translate([px,py]) circle(d=mountStemDia);
  }
  else
    rotate([0,180,0]) import("ClockClock24.stl");

}

!sandingJigFaces();
module sandingJigFaces(){
  botHandZOffset=topShaftLngth+minRoofThck-handThck*2-handZDist;
  botShaftOvLen=botHandZOffset+botShaftLngth+handThck;
  #mirror([0,0,1]){
    translate([handWidth,0,-0.6+jigProtrude]) topHand();
    translate([-handWidth,0,-3.8+jigProtrude]) rotate(180) bottomHand();
  }

  for (iy=[-(jigCount-1)/2:(jigCount-1)/2]){
    translate([handWidth,iy*handWidth*1.5,0]){ 
      linear_extrude(height = handThck-jigProtrude+jigSpcng) offset(jigSpcng) handShape(topHandLngth);
      linear_extrude(height = topShaftLngth-jigProtrude) circle(d = topShaftDia+2*minWallThck);;
    }
    translate([-handWidth,iy*handWidth*1.5,0]) rotate(180){
      linear_extrude(height = handThck-jigProtrude+jigSpcng) offset(jigSpcng) handShape(botHandLngth); 
      linear_extrude(height = botShaftOvLen+jigSpcng) circle(d = botShaftDia+2*minWallThck);;
    }
  }
}


*topHand();
module topHand(){
  shaftLen=topShaftLngth-handThck-handSpcng;
  ovThck=handThck+shaftLen;
  handOffset= [0,0,-handThck+minRoofThck];
  translate(handOffset) difference(){
    union(){
      linear_extrude(handThck) 
        handShape(topHandLngth);
      translate([0,0,-shaftLen]) linear_extrude(shaftLen)   
        circle(d=topShaftDia+2*minWallThck);
    }
    translate([0,0,-shaftLen-fudge]) cylinder(d=topShaftDia,h=shaftLen+handThck-minRoofThck+fudge);
  }
    
  
  
}

*mirror([0,0,1]) bottomHand();
module bottomHand(){
    shaftLen=botShaftLngth;
    shaftDia=botShaftDia+2*minWallThck;
    handZOffset=topShaftLngth+minRoofThck-handThck*2-handZDist;  
    
    //shaftAdapter
    translate([0,0,-shaftLen]) linear_extrude(shaftLen) difference(){
      circle(d=shaftDia);
      circle(d=botShaftDia);
    }
    //Roof
    linear_extrude(minRoofThck) difference(){
      circle(d=shaftDia);
      circle(d=2);
    }
    
    //connector
    translate([0,0,minRoofThck]) linear_extrude(handZOffset-minRoofThck) difference(){
      circle(d=shaftDia);
      circle(d=topShaftDia+(minWallThck+handSpcng)*2);
    }
    
    //hand
    translate([0,0,handZOffset]) linear_extrude(handThck) difference(){
      handShape(botHandLngth);
      circle(d=topShaftDia+(minWallThck+handSpcng)*2);
    }
}
    
module handShape(radius=clockDia/2){
  
  if (roundedHands)
    //cut radius from hand using circle
    intersection(){
      union(){
        circle(d=handWidth);
        translate([0,-handWidth/2]) square([clockDia/2,handWidth]);
      }
    circle(radius);
    }
  else {
    //calculate square end length from radius
    length= radius - (radius-0.5*sqrt(4*pow(radius,2)-pow(handWidth,2)));
    circle(d=handWidth);
    translate([0,-handWidth/2]) square([length,handWidth]);
  }
}

module threadInsertHolder(){
  //3Dprinted holder for threated inserts
}

*VID28_05();
module VID28_05(cut=false){
  //https://blog.drorgluska.com/2019/03/a-million-times.html?m=0
  bdyDims=[64,35,9.2];
  shaftOffset=9.5;
  baseDia=5+2*(tan(4)*(11.2-4.8));
  
  
  if (cut){
    //shaft
    circle(d=baseDia);
    
    //pins
     for (ix=[-1,1],ixx=[0,1],iy=[-1,1])
      translate([ix*(23.24/2+ixx*7.76)-shaftOffset,iy*22.86/2,0])
        circle(d=0.5);
    //studs
    for(ix=[-1,1])
      translate([ix*25-shaftOffset,9.0]) circle(d=2.5);
    translate([-shaftOffset,-12.0]) circle(d=2.5);
  }
  
  else{
    //body
    translate([-shaftOffset,0,-bdyDims.z]) linear_extrude(bdyDims.z) 
      hull() for (ix=[-1,1])
        translate([ix*(bdyDims.x-bdyDims.y)/2,0]) circle(d=bdyDims.y);
        
    //--shafts
    //top
    color("silver") cylinder(d=1.5,h=17.4);
    //bottom
    difference(){
      union(){
        cylinder(d=4,h=11.2);
        cylinder(d1=baseDia,d2=5,h=11.2-4.8);
      }
      cylinder(d=2,h=11.2+fudge);
    }
    //pins
    color("silver") for (ix=[-1,1],ixx=[0,1],iy=[-1,1])
      translate([ix*(23.24/2+ixx*7.76)-shaftOffset,iy*22.86/2,0]) cylinder(d=0.5,h=2.8);
    
    //studs
    color("grey"){ 
      for(ix=[-1,1])
        translate([ix*25-shaftOffset,9.0]) cylinder(d=2.5,h=3.8);
      translate([-shaftOffset,-12.0]) cylinder(d=2.5,h=3.8);
    }
  }
}

function time2Deg(time)= time ? (time/3-1)*-90 : handIdleAng;
  