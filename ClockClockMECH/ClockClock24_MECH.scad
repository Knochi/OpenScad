 // VID28-05 double shaft Motor
// information from https://blog.drorgluska.com/2019/03/a-million-times.html

//Speedy 360 Working area (W x D)	813 x 508 mm

/* [Dimensions] */

minWallThck=1.2;
minFloorThck=0.6;
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

ruthexM4Dia=5.6; //Ruthex M4 short is 5.6 for plastic parts
ruthexM5Dia=6.4; //Ruthex M5 std for plastic parts

mountHoleDia=4.2;

/* [Sensors] */
sensorXOffsets=[-20,-35];
//embedd metal pins to strenghten the field
sensorMagPins=true;
sensorMagPinDia=2;

/* [Sanding Jig] */
jigProtrude=0.5;
jigCount=5;
jigSpcng=0.1;
jigTopHands=true;
jigBotHands=true;
jigLvrSpcng=0.1;

/* [show] */

showTopHand=true;
showBotHand=true;
//visualize the spacing to frame
showHandSpcng=false;

showMotor=true;
showPCB=true;

showHangers=true;
//back Layer
showLayer0=true;
showLid=true;
showLayer1=true;
showLayer2=true;
showLayer3=true;
//Front Layer
showLayer4=true;
showJigLever=true;
showJigBody=true;
//show heat set threaded inserts
showInserts=true;

export="none";//["none","Layer0","Layer1","Layer2","Layer3","Layer4","topHand":"Top Hand","botHand":"Bottom hand", "sandJig":"Sanding Jig"]

/* [options] */
roundedHands=false;
roundedCorners=false;
//metal pins for hall sensors
metalPins=false;
//split the design in the middle
splitDesign=false; 
//show which halves
splitShow="all"; //["all","left","center","right"]
//compensate kerf
kerf=0.1;

/* [Hidden] */
fudge=0.1;
$fn=128;
pcbDims=[60,0,1.6];
pcbShftXCntrOffset=10;
topHandLngth=clockDia/2-clock2TopHandSpcng;
botHandLngth=clockDia/2-clock2BotHandSpcng;
echo(str("Hand Lengths: Top: ",topHandLngth, ", Bottom: ",botHandLngth));

topShaftDia=1.6;
topShaftLngth=6.2;
topShaftZOffset=17.4;

botShaftDia=4.1;
botShaftLngth=4.8;
botShaftZOffset=11.2;

cornerRad= roundedCorners ? clockDist/2+brimWidth : 0;

ovDims=[clockDist*(clockCount.x)+brimWidth*2,clockDist*(clockCount.y)+brimWidth*2];
baseShapePos=[-clockDist/2-brimWidth+cornerRad,-clockDist/2-brimWidth+cornerRad];
centerPos=baseShapePos.x+ovDims.x/2;

  usbCYOffset=40;

//bottom to top
layerThck=[3,12,3,6,8];
layerCol=["RosyBrown","Tan","BurlyWood","Wheat","NavajoWhite"];

//distance between hangers
hangerYPos=-40;
hangerZPos=-layerThck[1]+pcbDims.z-1; //we will add a 1mm shim to make the hangers flush
hangerPos=[[-clockDist+brimWidth*3/4,hangerYPos,hangerZPos],[clockDist*clockCount.x-brimWidth*3/4,hangerYPos,hangerZPos]];

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
               [[6,6],[6,6]]  //row1hangerZPos
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

               
handPosTopBot = handPosDigit8;

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
if (export=="sandJig")
  !sandingJigFaces();
  
layerFrame();
if (showPCB){
  color("darkGreen") for (ix=[0:clockCount.x-1]) translate([ix*clockDist,clockDist,1.6]) PCB();
  translate([centerPos,-clockDist+ usbCYOffset,1.6]) rotate([0,180,0]) usbCBreakOut();
}
if (showHangers) color("silver") for (pos=hangerPos) translate(pos) rotate(180) hanger();
clocks();

if (showHandSpcng){
  color("red",0.2) translate([0,0,botShaftZOffset + 2]) linear_extrude(2) circle(d=clockDia-clock2BotHandSpcng*2);
  color("green",0.2) translate([0,0,topShaftZOffset+ -1]) linear_extrude(2) circle(d=clockDia-clock2TopHandSpcng*2);
}

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

  //layered frame
  usbCCutoutDims=[25,60];

  cutOutBrimWdth=15;
  lidSpcng=0.5;
  
  if (showLayer0)
    color(layerCol[0]) translate([0,0,pcbDims.z-layerThck[0]-layerThck[1]]) linear_extrude(layerThck[0]) layer0();
    
  if (showLayer1){
    translate([0,0,pcbDims.z-layerThck[1]]){
      color(layerCol[1]) linear_extrude(layerThck[1]) layer1();
      if (showInserts){
        for (pos=hangerPos) translate([pos.x,pos.y,0]) rotate(180) hanger(cut=true) mirror([0,0,1]) threadInsert(5,false);
        connectorBox(cut=true) mirror([0,0,1]) threadInsert(3);
      }
    }
  }
  if (showLayer2)
    color(layerCol[2]) translate([0,0,pcbDims.z]) linear_extrude(layerThck[2]) layer2();
  if (showLayer3){
    translate([0,0,pcbDims.z+layerThck[2]]){
      color(layerCol[3]) linear_extrude(layerThck[3]) layer3();
      if (showInserts){
        mirror([0,0,1]) //insert from below
          screwHoles() threadInsert(4,true); 
        for (ix=[0:clockCount.x-1]) 
          translate([ix*clockDist,clockDist]) PCB(cut="inserts") mirror([0,0,1]) threadInsert(4,true); 
      }
          
    }
  }
  if (showLayer4)
    color(layerCol[4]) translate([0,0,pcbDims.z+layerThck[2]+layerThck[3]]) linear_extrude(layerThck[4]) layer4();
  
  if (export=="Layer0")
    !layer0();
  if (export=="Layer1")
    !layer1();
  if (export=="Layer2")
    !layer2();
  if (export=="Layer3")
    !layer3();
  if (export=="Layer4")
    !layer4();

  
  //layer 0 Bottom "BackFrame"
  module layer0(){
    difference(){
      baseShape();
      translate([-clockDist*0.75,-clockDist*0.75]) square(ovDims+[-brimWidth,-brimWidth]);
      connectorBox(size=usbCCutoutDims+[cutOutBrimWdth*2-6,cutOutBrimWdth],spcng=0);
      *translate([centerPos,(usbCCutoutDims.y+cutOutBrimWdth-3)/2-clockDist]) 
          square([usbCCutoutDims.x*2,usbCCutoutDims.y+cutOutBrimWdth-3],true);
    }
    //
    if (showLid || (export=="Layer0")){
      //main lid
      difference(){
        offset(-lidSpcng) translate([-clockDist*0.75,-clockDist*0.75]) square(ovDims+[-brimWidth,-brimWidth]);
        for (pos=hangerPos) 
          translate([pos.x-brimWidth/4,-clockDist/2-4]) square([brimWidth/2,80]);
        screwHoles() circle(d=mountHoleDia);
        connectorBox(size=usbCCutoutDims+[cutOutBrimWdth*2-6,cutOutBrimWdth],spcng=0);
      
      }
      //lid for usbCbreakout
      difference(){
        connectorBox(size=usbCCutoutDims+[cutOutBrimWdth*2-6,cutOutBrimWdth],spcng=lidSpcng);
        connectorBox(cut=true) circle(d=3.2);
        }
    }
  }
  
  //layer 1 "PCBs Frame"
  module layer1(){
    
      difference(){
        baseShape(splits=1);
        screwHoles() circle(d=mountHoleDia);
        //holes for a heatinsert around cutout
        connectorBox(size=usbCCutoutDims,cut=true) threadInsert(3,cut=true); //circle(d=ruthexM4Dia);
        //center cutout
        difference(){
          translate([-clockDist/2+mountHoleDia,-clockDist/2]) square(ovDims+[-brimWidth*2-mountHoleDia*2,-brimWidth*2]);
          connectorBox(size=usbCCutoutDims+[cutOutBrimWdth*2,cutOutBrimWdth],spcng=0);
          *translate([centerPos,(usbCCutoutDims.y+cutOutBrimWdth-3)/2-clockDist]) 
            offset(3) square([usbCCutoutDims.x*2,usbCCutoutDims.y+cutOutBrimWdth-3],true);
          }
        //heat insert holes for hangers
        for (pos=hangerPos) translate([pos.x,pos.y,0]) rotate(180) hanger(cut=true) circle(d=ruthexM5Dia);
        //cutout for USBC Breakout
        connectorBox(size=usbCCutoutDims,spcng=0);
        *translate([centerPos,(usbCCutoutDims.y-3)/2-clockDist]) offset(3) square(usbCCutoutDims+[-6,-3],true);
      }
  }
  
  //layer 2 PCB Interface
  module layer2(){
      difference(){
        baseShape(splits=2);
        for(ix=[0:clockCount.x-1],iy=[0:clockCount.y-1])
          translate([ix*clockDist,iy*clockDist]) offset(0.5) VID28_05(true);
        for (ix=[0:clockCount.x-1]) translate([ix*clockDist,clockDist]) PCB(cut="pcb");
        cableSlit();
        screwHoles() circle(d=mountHoleDia);
      }
  }
  
  //layer 3 clocks Background
  module layer3(){
    difference(){
      baseShape(splits=2);
      for(ix=[0:clockCount.x-1],iy=[0:clockCount.y-1])
        translate([ix*clockDist,iy*clockDist]) circle(d=7);
      for (ix=[0:clockCount.x-1]) 
        translate([ix*clockDist,clockDist]) PCB(cut="inserts") circle(d=ruthexM4Dia);
      if (metalPins) //metal pins to improve hall sensor performance
        for (ix=[0:clockCount.x-1],iy=[0:clockCount.y-1],px=sensorXOffsets)
          translate([ix*clockDist,iy*clockDist]+[px,0]) circle(d=sensorMagPinDia);
      screwHoles() circle(d=ruthexM4Dia); 
      }
  }
  
  //layer 4 clocks frames
  module layer4(){
      difference(){
        baseShape(splits=1);
        for(ix=[0:clockCount.x-1],iy=[0:clockCount.y-1])
          translate([ix*clockDist,iy*clockDist]) circle(d=clockDia);
        }
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
      translate(baseShapePos)
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
  
  module screwHoles(d=mountHoleDia){
    //top and bottom
      for (ix=[1:clockCount.x-1],iy=[0,1]){
        if ((ix!=clockCount.x/2)||(iy==1)) //don't do the hole above the slit
          translate([ix*clockDist-clockDist/2,-clockDist/2-brimWidth/4+iy*(clockDist*clockCount.y+brimWidth/2)]) children();//circle(d=d);
      }
    //left and right
      for (ix=[0:1], iy=[1:clockCount.y-1])
        translate([-clockDist/2-brimWidth/4+ix*(clockDist*clockCount.x+brimWidth/2),iy*clockDist-clockDist/2]) children();//circle(d=d);
    
      //corners
      translate([-clockDist/2-brimWidth/4,-clockDist/2-brimWidth/4]) children();//circle(d=d);
      translate([clockCount.x*clockDist-clockDist/2+brimWidth/4,-clockDist/2-brimWidth/4]) children();// circle(d=d);
      translate([-clockDist/2-brimWidth/4,clockCount.y*clockDist-clockDist/2+brimWidth/4]) children();//circle(d=d);
      translate([clockCount.x*clockDist-clockDist/2+brimWidth/4,clockCount.y*clockDist-clockDist/2+brimWidth/4]) children();//circle(d=d);
  }
  
  module cableSlit(){
    translate([centerPos,baseShapePos.y]){
      *translate([-7.5,0]) square([15,usbCYOffset-3]);
      translate([-1.5,+usbCYOffset]){
        square([3,brimWidth+20]);
        translate([1.5,brimWidth+20]) circle(d=3);
        translate([1.5,0]) circle(d=3);
      }
    }
  }
  
  module connectorBox(size=usbCCutoutDims, cut=false, spcng=0){
    rad=3;
    if (cut){
      for (ix=[-1,1])
        translate([centerPos+ix*(size.x+cutOutBrimWdth)/2,-clockDist+cutOutBrimWdth]) children();
      translate([centerPos,size.y-clockDist/2-brimWidth+cutOutBrimWdth/2]) children();
    }
    else
      translate([centerPos,size.y/2-clockDist-rad/2]) 
        difference(){
          offset(rad-spcng) square([size.x-rad*2,size.y-rad],true);
          translate([0,-(size.y+rad)/2]) square([size.x*2,rad*2],true);
        }
  }
}


*hanger(cut=true);
module hanger(dia=mountHoleDia,cut=false){
  //https://amzn.eu/d/gCaAHSx
  holesPos=[22.5,42.5,54.5,62.5];
  holesDia=5.1;
  ovDims=[14,7.6,70];
  sheetThck=2;
  hookLen=13.6;
  if (cut)
    for (pos=holesPos)
      translate([0,-pos+hookLen/2+sheetThck]) children();//circle(d=dia);
  else
  //mount plate
  rotate([-90,0,0]){
    translate([-ovDims.x/2,sheetThck,hookLen/2+sheetThck]) rotate([90,90,0]) linear_extrude(sheetThck) difference(){
      square([ovDims.z,ovDims.x]);
      for (pos=holesPos)
        translate([pos,ovDims.x/2]) circle(d=holesDia);
    } 
    //roof
    translate([0,ovDims.y/2,hookLen/2+sheetThck/2]) cube([ovDims.x,ovDims.y,sheetThck],true);
    //hook
    translate([0,ovDims.y-sheetThck/2,0]) cube([ovDims.x,sheetThck,hookLen],true);
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
  if (cut=="pcb"){
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
    for (px=holesPos.x,py=holesPos.y)
      translate([px,py]) circle(d=5);
  }
  else if (cut=="inserts") 
    for (px=holesPos.x,py=holesPos.y)
      translate([px,py]) children();//circle(d=ruthexM5Dia);
  
  else
    rotate([0,180,0]) import("ClockClock24.stl");

}

*sandingJigFaces();
module sandingJigFaces(){
  botHandZOffset=topShaftLngth+minFloorThck-handThck*2-handZDist;
  botShaftOvLen=botHandZOffset+botShaftLngth+handThck;
  lvrThck=min(botShaftOvLen,topShaftLngth)-jigProtrude-handThck-minFloorThck;
  lvrZOffset=handThck-jigProtrude+lvrThck/2+minFloorThck;
  jigHandsYOffsetRel=1.8;
  
  xDim = (jigTopHands && jigBotHands) ? botHandLngth + topHandLngth + handWidth * 3 :
         jigTopHands ? topHandLngth + handWidth * 1.5 :
         botHandLngth + handWidth * 1.5;
         
  yDim = handWidth*jigHandsYOffsetRel*jigCount;
  
  bodyDims=[xDim,yDim,max(botShaftOvLen+jigSpcng,topShaftLngth+jigSpcng)];
  
  if (showJigBody)
    difference(){
      body();
      cutOuts();
    }
  
  if (showJigLever){
    if (jigTopHands) translate([handWidth*1.5,0,lvrZOffset]) lever();
    if (jigBotHands) mirror([1,0,0]) translate([handWidth*1.5,0,lvrZOffset]) lever(botShaftDia+2*minWallThck);
  }
  
  module body(){
    xOffset=(jigTopHands && jigBotHands)? (topHandLngth-botHandLngth)/2 :
            jigTopHands ? bodyDims.x/2 : -bodyDims.x/2;
    
    difference(){
      translate([xOffset,0,bodyDims.z/2]) linear_extrude(bodyDims.z,center=true) offset(3)
        square([bodyDims.x-6,bodyDims.y-6],true);
      //lever cutout
      for (ix=[-1,1]) 
        translate([ix*handWidth*1.5,0,lvrZOffset]) 
          cube([handWidth,yDim+fudge,lvrThck],true);
      //take out some material
      cutAwayHght=bodyDims.z-lvrZOffset+minFloorThck;
      for (im=[0,1])
      mirror([im,0,0])
      translate([handWidth*3,0,bodyDims.z-cutAwayHght/2]) rotate([90,0,0]) 
        linear_extrude(bodyDims.y+fudge,center=true){
          circle(r=cutAwayHght/2);
          translate([-cutAwayHght,0]) difference(){
            square(cutAwayHght/2+fudge);
            circle(r=cutAwayHght/2);
            }
          translate([-cutAwayHght/2,0]) square([bodyDims.x-handWidth*3+cutAwayHght/2+fudge,cutAwayHght/2+fudge]);
          translate([0,-cutAwayHght/2]) square([bodyDims.x-handWidth*3+fudge,cutAwayHght/2+fudge]);
          }
    }
    
  }
  *lever();
  module lever(snapDia=topShaftDia+2*minWallThck){
    linear_extrude(lvrThck-jigLvrSpcng*2,center=true) difference(){
      translate([0,handWidth/2]) offset(-jigLvrSpcng) square([handWidth,yDim+handWidth],true);
      for (iy=[-(jigCount-1)/2:(jigCount-1)/2]) hull(){
        translate([-handWidth/2,iy*handWidth*jigHandsYOffsetRel,-fudge]) circle(d=snapDia);
        translate([-handWidth/2,iy*handWidth*jigHandsYOffsetRel+handWidth,-fudge]) circle(d=snapDia-jigLvrSpcng*3);
      }
      }
  }
  
  module cutOuts(){
    for (iy=[-(jigCount-1)/2:(jigCount-1)/2]){
      if (jigTopHands)
        translate([handWidth,iy*handWidth*jigHandsYOffsetRel,-fudge]){ 
          linear_extrude(height = handThck-jigProtrude+jigSpcng+fudge) offset(jigSpcng) handShape(topHandLngth);
          linear_extrude(height = bodyDims.z+fudge*2) circle(d = topShaftDia+2*minWallThck);;
        }
      if (jigBotHands)
        translate([-handWidth,iy*handWidth*jigHandsYOffsetRel,-fudge]) rotate(180){
          linear_extrude(height = handThck-jigProtrude+jigSpcng+fudge) offset(jigSpcng) handShape(botHandLngth); 
          linear_extrude(height = bodyDims.z+fudge*2) circle(d = botShaftDia+2*minWallThck);;
        }
    }
  }
}


*usbCBreakOut();
module usbCBreakOut(){
  dims=[21.5,12];
  pcbThck=1.6;
  holeDia=3.2;
  holeDist=17.5;
  
  color("darkRed") linear_extrude(pcbThck) difference(){
    translate([0,dims.y/2]) square(dims,true);
    for (ix=[-1,1])
      translate([ix*holeDist/2,2]) circle(d=holeDia);
  }
  translate([0,3,pcbThck]) usbC(plug=true);
}

  
*topHand();
module topHand(){
  shaftLen=topShaftLngth-handThck-handSpcng;
  ovThck=handThck+shaftLen;
  handOffset= [0,0,-handThck+minFloorThck];
  
  translate(handOffset) difference(){
    union(){
      linear_extrude(handThck) 
        handShape(topHandLngth);
      translate([0,0,-shaftLen]) linear_extrude(shaftLen)   
        circle(d=topShaftDia+2*minWallThck);
    }
    translate([0,0,-shaftLen-fudge]) cylinder(d=topShaftDia,h=shaftLen+handThck-minFloorThck+fudge);
  }
    
  
  
}

*mirror([0,0,1]) bottomHand();
module bottomHand(){
    shaftLen=botShaftLngth;
    shaftDia=botShaftDia+2*minWallThck;
    handZOffset=topShaftLngth+minFloorThck-handThck*2-handZDist;  
    
    //shaftAdapter
    translate([0,0,-shaftLen]) linear_extrude(shaftLen) difference(){
      circle(d=shaftDia);
      circle(d=botShaftDia);
    }
    //Roof
    linear_extrude(minFloorThck) difference(){
      circle(d=shaftDia);
      circle(d=2);
    }
    
    //connector
    translate([0,0,minFloorThck]) linear_extrude(handZOffset-minFloorThck) difference(){
      circle(d=shaftDia);
      circle(d=topShaftDia+(minWallThck+handSpcng)*2);
    }
    
    //hand
    translate([0,0,handZOffset]) linear_extrude(handThck) difference(){
      handShape(botHandLngth);
      circle(d=topShaftDia+(minWallThck+handSpcng)*2);
    }
}

*handShape();    
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

module threadInsert(M=4, short=false, cut=false){
  //https://www.ruthex.de/cdn/shop/files/DE_Ruthex_Galeriebilder_DE_Gewindeeinsaetze_f171f404-4d29-4d0b-80eb-eed4b9843097_600x.jpg
  diaDict=  [//d1
    [2, 3.6],
    [2.5, 4.6],
    [3, 4.6],
    [4, 6.3],
    [5, 7.1],
    [6, 8.7],
    [8, 10.1],
    ]; 
  drillDict= [//d3
    [2,3.2],
    [2.5,4],
    [3, 4],
    [4, 5.6],
    [5, 6.4],
    [6, 8.0],
    [8, 9.6]];
    
  heightStdDict= [[2, 4],
              [2.5, 5.7],
              [3, 5.7],
              [4, 8.1],
              [5, 9.5],
              [6, 12.7],
              [8, 12.7]];
  heightShortDict=[[3, 4],
               [4, 4],
               [5, 5.8],
               [6, 6.8]];
       
  dia=lookup(M,diaDict);
  drillDia=lookup(M,drillDict);
  height= (short) ? lookup(M,heightShortDict): lookup(M,heightStdDict); 
  if (cut)
    circle(d=drillDia);
  else
    color("gold") translate([0,0,-height]) 
      linear_extrude(height) difference(){
        circle(d=dia);
        circle(d=M);
      }
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

*usbC(plug=false);
module usbC(center=false, pins=24, plug=false){
  //https://usb.org/document-library/usb-type-cr-cable-and-connector-specification-revision-21
  //rev 2.1 may 2021
  //receptacle dims
  shellOpng=[8.34,2.56];
  shellLngth=6.2; //reference Length of shell to datum A
  shellThck=0.2;
  centerOffset = center ? [0,0,-(shellOpng.y+shellThck*2)/2] : [0,0,0] ;
  //tongue
  tngDims=[6.69,4.45,0.6];

  //body
  bdyLngth=3;
  
  //colors
  metalSilverCol="silver";
  blackBodyCol="#222222";
  metalGoldPinCol="gold";
  
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
      color(metalSilverCol) linear_extrude(6.65)
        shellShape(size=[8.25,2.4]);
      //body max width,height
      color(blackBodyCol) translate([0,0,-35]) 
        linear_extrude(35) shellShape(size=[12.35,6.5]);
    }
  }
}


function time2Deg(time)= time ? (time/3-1)*-90 : handIdleAng;
  