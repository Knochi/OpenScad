// VID28-05 double shaft Motor
// information from https://blog.drorgluska.com/2019/03/a-million-times.html

/* [Dimensions] */

minWallThck=1.2;
minRoofThck=0.6;

brimWidth=50;


//distance between the shafts in x and y
clockDist=100; 
clockDia=96; 
clock2TopHandSpcng=1;
clock2BotHandSpcng=4;
clockCount=[8,3];

handWidth=10;
handThck=2;
handTopAng=-90;
handBotAng=120;
handIdleAng=-135;
handShortOffset=4;
//spacing between moving parts
handSpcng=0.2;
//spacing between top and bottom hand
handZDist=1;

/* [show] */
showTopHand=true;
showBotHand=true;
showMotor=true;
showPCB=true;

/* [options] */
roundedHands=false;
roundedCorners=false;

/* [Hidden] */
fudge=0.1;
$fn=128;
pcbDims=[0,0,1.6];

topHandLngth=clockDia/2-clock2TopHandSpcng;
botHandLngth=clockDia/2-clock2BotHandSpcng;

topShaftDia=1.5;
topShaftLngth=6.2;
topShaftZOffset=17.4;

botShaftDia=4;
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

layerFrame();

module layerFrame(){
  layerThck=[12,3,3,12];
  layerCol=["RosyBrown","Tan","BurlyWood","Wheat"];
  //layered frame
  
  ovDims=[clockDist*(clockCount.x)+brimWidth*2,clockDist*(clockCount.y)+brimWidth*2];
  
  //layer 0
  color(layerCol[0]) translate([0,0,pcbDims.z-layerThck[0]]) linear_extrude(layerThck[0]) difference(){
    baseShape();
    translate([-clockDist/2,-clockDist/2]) square(ovDims+[-brimWidth*2,-brimWidth*2]);
  }
  
  color(layerCol[1]) translate([0,0,pcbDims.z]) linear_extrude(layerThck[1]) difference(){
    baseShape();
    for(ix=[0:clockCount.x-1],iy=[0:clockCount.y-1])
      translate([ix*clockDist,iy*clockDist]) offset(0.5) VID28_05(true);
      }
      
  //layer 1
  color(layerCol[2]) translate([0,0,pcbDims.z+layerThck[1]]) linear_extrude(layerThck[2]) difference(){
    baseShape();
    for(ix=[0:clockCount.x-1],iy=[0:clockCount.y-1])
      translate([ix*clockDist,iy*clockDist]) circle(d=7);
    }
    
  //layer 2
  color(layerCol[3]) translate([0,0,pcbDims.z+layerThck[1]+layerThck[2]]) linear_extrude(layerThck[3]) difference(){
    baseShape();
    for(ix=[0:clockCount.x-1],iy=[0:clockCount.y-1])
      translate([ix*clockDist,iy*clockDist]) circle(d=clockDia);
    }
    
  module baseShape(){
    translate([-clockDist/2-brimWidth+cornerRad,-clockDist/2-brimWidth+cornerRad])
      offset(cornerRad) square(ovDims+[-cornerRad*2,-cornerRad*2]);
  }
}



if (showPCB)
  color("darkGreen")
  for (ix=[0:clockCount.x-1])
    translate([ix*clockDist,clockDist,1.6]) rotate([0,180,0]) import("ClockClock24.stl");

//clocks
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


*topHand();
module topHand(){
  shaftLen=topShaftLngth-handThck-handSpcng;
  ovThck=handThck+shaftLen;
  
  translate([0,0,-handThck+minRoofThck]) difference(){
    union(){
      linear_extrude(handThck) 
        handShape(topHandLngth);
      translate([0,0,-shaftLen]) linear_extrude(shaftLen)   
        circle(d=topShaftDia+2*minWallThck);
    }
    translate([0,0,-shaftLen-fudge]) cylinder(d=topShaftDia,h=shaftLen+handThck-minRoofThck+fudge);
  }
    
  
  
}

*bottomHand();
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
  