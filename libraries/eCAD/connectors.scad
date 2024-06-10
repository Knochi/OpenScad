//--- Style Guide ---
// 1. front/top view is the view on the connectors pins/sockets or the inserting direction
// 2. pin1 is the leftmost pin/contact
// 3. default origin for pinheaders is at pin1 (where it connects to the PCB)
// 3a. for plugs/sockets the PCB board edge is default origin
// 4. center=true will put the origin to the parts common center
// 5. "give2D" gives back different named 2D shapes for cutouts, drills etc
// 6. Colors: don't use white and black, use ivory and darkSlateGrey instead for contrast reasons

//--- CSG export to FreeCad --
// 1. don't use linear_extrude(size). Use polyhedrons instead
// 2. If you want to color sth. place the color before each primitive

use <KnochisToolbox.scad>
include <KiCADColors.scad>

$fn=50;
fudge=0.1;

translate([-30,0,0]) XH(2);
translate([-15,0,0]) mUSB(false);
translate([-15,15,0]) usbC();
usbA();
translate([10,-4,0]) pinHeader(10,2,markPin1=true);
translate([10,4,0]) pinHeader(5,1);
translate([10,8,0]) pinHeaderRA(10);
translate([10,24,0]) boxHeader(10);
translate([35,0,0]) duraClik(4);
translate([35,10,0]) duraClikRA(4);
translate([55,0,0]) ETH();
translate([70,0,0]) screwTerminal(2,false);
translate([100,0,0]) DSub();
translate([130,0,0]) BIL30(col="red",panel=2);
translate([160,0,0]) SDCard(showCard=true);
translate([160,40,0]) uSDCard(showCard=true);
translate([200,0,0]) tubeSocket9pinFlange();
translate([230,0,0]) PJ398SM();


*rotate([0,0,-90]) femHeaderSMD(20,2,center=true);

*WAGO_2601();
module WAGO_2601(poles=5,release=false){
  //vertical WAGO PCB terminal block; CAGE-CLAMP; 3.5mm pitch; 1.5mm²
  pitch=3.5;
  endPlateWdth=1.5;
  ovWdth=(poles)*pitch+endPlateWdth; //overall Width "L"
  pinDims=[1,0.5,3.6];
  pinYPos=[5.45,10.45]; //from front
  elmntDims=[pitch,12.75,14.5];
  tFeaturesWdth=0.7; //tiny features on the left
  pivot=[pitch/2,9.71,2.23]; //pivot point of the lever
  leverRot=(release) ? -60 : 0;

  for (ix=[0:(poles-1)]){
    //body Elements
    color(greyBodyCol) translate([ix*pitch,0,0]) bdyElmnt();
    //levers
    color(orangeBodyCol) 
    translate(pivot)
    rotate([leverRot])
      translate([ix*pitch+pitch/2,elmntDims.y,0]-pivot) 
          lever();
    //pins
    for (yPos=pinYPos)
      color(metalGreyPinCol) translate([ix*pitch+pitch/2,yPos,-pinDims.z/2]) cube(pinDims,true); 
  }

  //end Plate
    color(greyBodyCol) translate([poles*pitch,0,0]) bdyElmnt(true);

  *lever();

  module bdyElmnt(isPlate=false){
    
    rad=0.3;
    cutAng=50;
    portOffset=[1.85,5.2-3.6/2];
    poly=[[rad,rad],[elmntDims.y-rad,rad],[elmntDims.y-rad,rad+10.4],[rad+9.21,elmntDims.z-rad],[rad,elmntDims.z-rad]];
    cutOutDims=[2.7,1.85+fudge,elmntDims.z-3.45+fudge];

    if (isPlate)
      rotate([90,0,90]) linear_extrude(endPlateWdth) offset(rad) polygon(poly);
    else
      difference(){
        rotate([90,0,90]) linear_extrude(elmntDims.x) offset(rad) polygon(poly);
        translate([portOffset.x,portOffset.y,elmntDims.z-2]) linear_extrude(2+fudge) portShape();
        translate([elmntDims.x/2,elmntDims.y-(cutOutDims.y-fudge)/2,(cutOutDims.z+fudge)/2+3.45]) cube(cutOutDims,true);
      }
  }

  module portShape(){
    //shape of the port Holes
    lRad=0.6;
    sRad=0.3;
    lDims=[2.9,3.6];
    sDims=[1.2,5.1];

    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(lDims.x/2-lRad),iy*(lDims.y/2-lRad)]) circle(lRad);
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(sDims.x/2-sRad),iy*(sDims.y/2-sRad)+(sDims.y-lDims.y)/2]) circle(sRad);
  }
  
  module lever(){
    rad=0.3;
    poly=[[rad,3.8+3.45],[rad,12.8+3.45],[rad+0.8,12.8+3.45],[2.3-rad,10.35+3.45],[1.75-rad,13.12],[1.75-rad,3.8+3.45],[1.85+1.75-rad,3.6],[1.85+rad,3.6]]; //starting with outer knee point

    rotate([90,0,-90]) linear_extrude(2.6,center=true) offset(rad) polygon(poly);
  }

}

*microMatch();
module microMatch(pos=10){
  // TE Micro-Match connector line (also available from other manufacturers)
  // https://www.te.com/usa-en/products/connectors/pcb-connectors/wire-to-board-connectors/ffc-fpc-ribbon-connectors/intersection/micro-match.html
  pitch=1.27;
  ovHght=5.25;
  
  //pins
  pinThck=0.25;

  //the flanked part for female
  tpFace=[pos*pitch+0.53,3.85]; //
  tpFlankAngle=2.5; 
  tpHght=3.5;
  btFace=[tpFace.x,tan(tpFlankAngle)*tpHght*2+tpFace.y];

  translate([0,0,-tpHght/2+ovHght]) difference(){
    frustum(size=[btFace.x,btFace.y,tpHght], flankAng=[0,tpFlankAngle], center=true, method="poly", col=redBodyCol);
    stagger(pitch=[2.54,0.85]) color(redBodyCol) translate([0,0,tpHght/2-0.5]) linear_extrude(0.5+fudge) cross2D();
  }

  
  //collar
  collarDims=[pos*pitch+1.93,5,1.6];
  keying=[0.7,2.5];
  cutOutDims=[1.7,collarDims.y/2,0.9];
  translate([0,0,collarDims.z/2+ovHght-tpHght]) color(redBodyCol) difference(){
     cube(collarDims,true);
     translate([(collarDims.x-keying.x+fudge)/2,0,0]) cube([keying.x+fudge,keying.y,collarDims.z+fudge],true);
     //staggered cutouts
     //TODO: add fillets (r~0.25mm)
    translate([0,0,(collarDims.z-cutOutDims.z+fudge)/2]) 
      stagger(pitch=[pitch*2,collarDims.y-cutOutDims.y],stagger=(pitch+0.1)) cube(cutOutDims+[0,fudge,fudge],true);
  }

  //base
  //baseDims=[pos*pitch+1.23,3,1.5];
  baseDims=[tpFace.x+(collarDims.x-tpFace.x)/2,3,1.5];
  basePoly=[[baseDims.y/2,baseDims.z],[baseDims.y/2,0],[baseDims.y/2-0.43,0],[baseDims.y/2-0.43,0.1],[baseDims.y/2-0.95,1],
            [-(baseDims.y/2-0.95),1],[-(baseDims.y/2-0.43),0.1],[-(baseDims.y/2-0.43),0],[-baseDims.y/2,0],[-baseDims.y/2,baseDims.z]];
  color(redBodyCol) translate([-collarDims.x/2,0,ovHght-tpHght-baseDims.z]) rotate([90,0,90]) linear_extrude(baseDims.x) polygon(basePoly);

  //pins
  for (ix=[0:(pos-1)]){
    pinRot= (ix%2) ? -1 : 1 ;
    color(metalSilverCol) translate([ix*pitch-(pos-1)/2*pitch,0,0]) rotate([90,0,pinRot*90]) translate([0,0,-pinThck/2]) pin();
  }

  module cross2D(){
    ovDims=[0.85,1.5,0.5];
    barWdth=[0.4,0.6];
    square([ovDims.x,barWdth.y],true);
    square([barWdth.x,ovDims.y],true);
  }

  module pin(){
    poly=concat(push_arc([3.26,0],[3.53,0.28],0.3,0),
                push_arc([3.51,0.62],[3.36,0.76],0.15,0),
                push_arc([2.88,0.76],[2.73,0.91],0.15,1),
                push_arc([-0.63,0.95],[-0.64,1.25],0.15,1),
                push_arc([-1.82,1.92],[-1.96,1.56],0.5,1),
                push_arc([-2.63,0.9],[-2.69,0.76],0.15,0),
                [[-2.69,0.34],[-2.08,0.34]],
                push_arc([-2.08,0.39],[-1.79,0.39],0.15,1),
                push_arc([-1.77,0.31],[-1.62,0.2],0.15,0),
                push_arc([-1.17,0.2],[-1.03,0.31],0.15,0),
                push_arc([-1.0,0.39],[-0.72,0.4],0.15,1),
                push_arc([-0.68,0.31],[-0.53,0.21],0.15,0),
                push_arc([0.93,0.32],[1.04,0.29],0.15,1),
                push_arc([1.3,0.06],[1.4,0.02],0.15,0)
                );
    linear_extrude(pinThck) polygon(poly);
  }
}

*SLconnector();
module SLconnector(pos=2,height=5){
  //preci-dip Spring-Loaded Connectors SLC 
  //Series 811 https://www.precidip.com/en/Products/Spring-Loaded-Connectors/pview/811-S1-NNN-30-XXX101.html
  //single row 2..10 contacts, SMD
  //811-SS-NNN-30-XXX101 NNN is number of poles, XXX is code for height A
  //heights=[4.5:0.5:7.5] XXX=001-007

  bodyHght= (height<6) ? 2.95 : 4;
  pitch=2.54;
  stroke=1.4;
  btmDia=1.83;
  btmThck=0.4;
  pinDia=1.07;
  //pin
  color(metalGoldPinCol) translate([0,0,btmThck+bodyHght]){
     cylinder(d=pinDia,h=height-bodyHght-btmThck-pinDia/2);
     translate([0,0,height-bodyHght-btmThck-pinDia/2]) sphere(d=pinDia);
  }

  color(blackBodyCol) translate([0,0,btmThck]) linear_extrude(bodyHght)  octagon();
  color(metalGoldPinCol) cylinder(d=btmDia,h=btmThck);
}

*M411P(false);
module M411P(isMale=true){
 //https://www.hyte.pro/product/m411p-en.html
 ovDims=isMale ? [14.5,8.8,4.7] : [14.5,6.66,4.7] ;
 magDims= isMale ? [14.2,8.8-5.75,4.7] : [14.2,5.81-4.31,4.7];
 magSecWdth=1.3; //section width of magnet
 bdyDims= isMale ? [ovDims.x,5.75,ovDims.z] : [ovDims.x,4.31,ovDims.z];
 pinOffset= isMale ? 0.9 : 1.0;
 bdyRad=[2,0.5];
 pitch=2.2;
  
 color("silver") translate([0,-magDims.y/2-0.05,magDims.z/2]) magnet();
 
 color("gold") for (ix=[-1.5:1.5]){
  translate([ix*pitch,bdyDims.y-pinOffset,0]) color("gold") pin();
 }
 
 color("darkSlateGrey") translate([0,bdyDims.y/2,0]) body();
 
  module pin(){
    pinDia=0.65;
    pinRad=0.25; //inner Radius
    pinLngth=isMale ? ovDims.y-0.15-pinDia-pinRad-0.9 : ovDims.y-3.1+2.1-pinDia/2-pinRad;

    translate([0,-pinLngth-pinDia/2-pinRad,ovDims.z/2]){
      if (isMale) sphere(d=0.65);
      else rotate([-90,0,0]) cylinder(d=1.45,h=1);
      rotate([-90,0,0]) cylinder(d=0.65,h=pinLngth);
    }

    translate([0,-pinDia/2-pinRad,-pinDia/2-pinRad+ovDims.z/2]) rotate([0,-90,0])
      rotate_extrude(angle=90) 
        translate([pinRad+pinDia/2,0]) circle(d=pinDia);
    translate([0,0,-0.05]) cylinder(d=pinDia,h=ovDims.z/2-pinRad-pinDia/2+0.05);
    translate([0,0,-0.15]) cylinder(d1=pinDia-0.2,d2=pinDia,h=0.1);
 }

  module body(){
    bdyMid=(bdyDims.z-bdyRad[1]-bdyRad[0]);
    cutOutWdth= isMale ? 3 : 3.1; //cutouts for PCB
    difference(){
      union(){
        translate([0,0,bdyDims.z-bdyRad[0]]) slap([bdyDims.x,bdyDims.y,bdyRad[0]]);
        translate([0,0,bdyRad[1]]) rotate([0,180,0]) slap([bdyDims.x,bdyDims.y,bdyRad[1]]);
        translate([0,0,bdyRad[1]+bdyMid/2]) cube([bdyDims.x,bdyDims.y,bdyMid],true);
      }
      //cutaway
      translate([0,(bdyDims.y-cutOutWdth+fudge)/2,0]){
        translate([0,0,(1.5-fudge)/2]) cube([bdyDims.x+fudge,3+fudge,1.5+fudge],true);
        translate([0,0,bdyDims.z/2]) cube([9,cutOutWdth+fudge,bdyDims.z+fudge],true);
      }
   }
   //mag inlay
   magInnerDia=magDims.z-magSecWdth*2;
   magInnerLngth= isMale ? magDims.y-0.15-0.9 : ovDims.y-bdyDims.y-0.01 ;
    hull()for (ix=[-1,1]) 
      translate([ix*(magDims.x/2-magInnerDia/2-magSecWdth),-bdyDims.y/2,magDims.z/2]) 
        rotate([90,0,0]) cylinder(d=magInnerDia-fudge,h=magInnerLngth); //<-- check
   
   //pegs
   for (ix=[-1,1])
    translate([ix*10/2,bdyDims.y/2-pinOffset+0.2,1.5-0.8+0.15]){
      cylinder(d=1,h=0.8-0.15);
      translate([0,0,-0.15]) cylinder(d1=1-0.3,d2=1,h=0.15);
    }
 }
 module slap(size=[15,5,5]){
  for (im=[0,1])
    mirror([im,0,0]) 
      translate([(size.x/2-size.z),size.y/2,0]) 
        rotate([90,0,0]) 
          rotate_extrude(angle=90) square([size.z,size.y]);
  translate([0,0,size.z/2]) 
    cube([size.x-2*size.z,size.y,size.z],true);
 }

 module magnet(){
  rotate([90,90,0]) for (i=[-1,1]){
    translate([0,i*(magDims.x-magDims.z)/2]) 
      rotate_extrude(angle=i*180) translate([(magDims.z-magSecWdth)/2,0]) 
        square([magSecWdth,magDims.y],true);
        //rndRect([magSecWdth,magDims.y],0.15,center=true);
     translate([i*(magDims.z-magSecWdth)/2,0,0]) rotate([90,0,0]) 
      linear_extrude(magDims.x-magDims.z,center=true) 
        square([magSecWdth,magDims.y],true);
        //rndRect([magSecWdth,magDims.y],0.15,center=true);
   }
 }
}

*uSDCardOpen();
module uSDCardOpen(){
//molex 151129-0001 (obsolete)
  gap=0.08; // gap unde
  bdyDims=[11.5,5.7,1.4];
  termDims=[0.3,2.86,0.65+bdyDims.z-gap]; //terminal
  pin1Offset=[-2.45,3.55,gap]; //pin1 offset from bottom right
  padDims=[0.24,0.6,0.15];
  pitch=1.1;
  slotDims=[0.42,3.55,bdyDims.z];
  //right pads
  rPadDims=[0.25,0.6,0.15];
  rPadDist=0.6;
  rPadPos=[6.1-rPadDims.x/2,bdyDims.y/2-2.15,0]; //from center
  //fitting nail
  ftPadDims=[0.15,0.5,1];
  ftPadPos=[-5.33,bdyDims.y/2-1.32,0]; //from center
  //switch
  swPadDims=[0.6,0.5,0.15];
  swPadPos=[3.25+swPadDims.x/2,bdyDims.y/2-0.45,0];

  poly=[[-bdyDims.y/2,0],[bdyDims.y/2,0],[bdyDims.y/2,bdyDims.z],
        [-bdyDims.y/2+0.5,bdyDims.z],[-bdyDims.y/2,bdyDims.z-0.3]];

  //translate([0,0,bdyDims.z/2]) cube(bdyDims,true);
  difference(){
  color(blackBodyCol) translate([0,0,gap]) rotate([90,0,90]) linear_extrude(bdyDims.x, center=true) polygon(poly);
  for (ix=[0:7]){
    color(blackBodyCol) 
      translate([bdyDims.x/2+pin1Offset.x+(termDims.x-slotDims.x)/2,-bdyDims.y/2,0]+[-ix*pitch,0,0]+[0,-fudge,-fudge]) cube(slotDims+[0,fudge,fudge*2]);
  }
  }
  //terminals and pads
  for (ix=[0:7])
    color(metalGoldPinCol) translate([-ix*pitch,0,0]+[bdyDims.x/2,-bdyDims.y/2,0]){
      translate(pin1Offset+[0,-termDims.y,0]) cube(termDims);
      translate([(termDims.x-padDims.x)/2+pin1Offset.x,0.5,0]) cube(padDims);
  }
  //right pads
  for (iy=[-1,1])
    color(metalGoldPinCol) 
      translate(rPadPos+[0,iy*(rPadDims.y+rPadDist)/2,rPadDims.z/2]) cube(rPadDims,true);

  //fitting nail
  color(metalGoldPinCol) translate(ftPadPos+[0,0,ftPadDims.z/2]) cube(ftPadDims,true);

  //switch
  color(metalGoldPinCol) translate(swPadPos+[0,0,swPadDims.z/2]) cube(swPadDims,true);
}

*uSDCard();
module uSDCard(showCard=true){
  //push-push by Wuerth 
  //https://www.we-online.de/katalog/datasheet/693071010811.pdf
    translate([0,0,1.98/2]){
      color("silver") difference(){
        cube([14,15.2,1.98],true);
        translate([-(14-11.2+fudge)/2,-(15.2-1.3+fudge)/2,0]) cube([11.2+fudge,1.3+fudge,1.98+fudge],true);
      }
      if(showCard){
        color("darkslateGrey") translate([-(14-11)/2+0.1,-0.6,0.35]) cube([11,15,0.7],true);
        color("darkslateGrey",0.5) translate([-(14-11)/2+0.1,-5,0.35]) cube([11,15,0.7],true);
      }
    }
}

*PJ398SM();
module PJ398SM(){
  //vertical 3.5mm Jack Socket
  //https://www.thonk.co.uk/shop/3-5mm-jacks/
  bodyDims=[9,4.5+6,9];
  difference(){
    union(){
      color("darkSlateGray") translate([0,(4.5+6)/2-4.5,9/2]) cube(bodyDims,true);
      for (ix=[-1,1])
        color("darkSlateGray") translate([ix*(5/2+1),0,bodyDims.z+1/2]) cube([1,6,1],true);
      color("silver") translate([0,0,bodyDims.z+1/2]) cube([6,6,1],true);
      color("silver") translate([0,0,bodyDims.z+1]) cylinder(d=6,h=4.5);
    }
    color("silver") translate([0,0,-fudge/2]) cylinder(d=3.6,h=14.5+fudge);
  }
  //pins
  translate([0,-3.38,-3.5/2]) color("silver") cube([1,0.1,3.5],true);
  translate([0,4.92,-3.5/2]) color("silver") cube([1,0.1,3.5],true);
  
  *color("silver")
  translate([0,-4.5,7]) rotate([0,-90,180]) rotate_extrude(angle=90) 
    translate([6-4.5,0,0]) color("silver") square([0.1,0.8],true);

    translate([0,-6,7]) color("silver")
      rotate([0,90,0]) cylinder(d=0.1,h=0.8,center=true);
    translate([0,-6.48,-3.5]) color("silver")
      rotate([0,90,0]) cylinder(d=0.1,h=0.8,center=true);
  
    
  alpha=atan(0.48/10.5);
  lgLngth=sqrt(pow(0.48,2)+pow(10.5,2));
  color("silver")
  translate([-0.4,-6.48-0.1/2,-3.5]) rotate([-alpha,0,0]) cube([0.8,0.1,lgLngth]);
}

*femHeaderSMD(10,2,3.7,1.27,center=false);
module femHeaderSMD(pins=10,rows=1,height=3.7, pitch=2.54, pPeg=true,center=false){
  //1.27: https://www.mpe-connector.de/de/produkte/buchsenleisten/buchsenleiste-smd-127-mm
  //2.54: https://www.mpe-connector.de/de/produkte/buchsenleisten/buchsenleiste-smd-254-mm
  
  rowWdth= (pitch==2.54) ? 2.5 : 1.5;
  holeWdth = (pitch==2.54) ? 0.7 : 0.35;
  pinDims= (pitch==2.54) ? [0.64,(7.2-pitch-holeWdth)/2,0.2] : [0.32,(4.3-pitch-holeWdth)/2,0.15];
  bdDims= [pins*pitch/rows,rowWdth*rows,height-pinDims.z];
  frstmDims= (pitch==2.54) ? [2,2,1+fudge] : [1,1,0.5+fudge] ;
  pegDia= (pitch==2.54) ? 1.6 : 0.55;
  pegHght= (pitch==2.54) ? 1.1 : 0.9 ;

  cntrOffset= (center) ? [0,0,height/2+pinDims.z/2] : [(pins/rows-1)*pitch/2,pitch/2*(rows-1),height/2+pinDims.z/2] ;

  translate(cntrOffset){

        difference(){
          color(blackBodyCol) cube(bdDims,true);
          translate([0,0,-(bdDims.z-pinDims.z)/2])
            color(blackBodyCol)
              cube([bdDims.x+fudge,pitch+frstmDims.x,pinDims.z+fudge],true);

            if (rows==1) for (ix=[-(pins-1)/2:(pins-1)/2]){
              translate([ix*pitch,0,0]) color(blackBodyCol)
                cube([holeWdth,holeWdth,bdDims.z+fudge],true);
              translate([ix*pitch,0,(bdDims.z-frstmDims.z+fudge)/2]) mirror([0,0,1])
                frustum(size=frstmDims,flankAng=40, col=blackBodyCol);
            }
            else for (ix=[-(pins/2-1)/2:(pins/2-1)/2],iy=[-1,1]){
              translate([ix*pitch,iy*pitch/2,0]) color(blackBodyCol)
                cube([holeWdth,holeWdth,bdDims.z+fudge],true);
              translate([ix*pitch,iy*pitch/2,(bdDims.z-frstmDims.z+fudge)/2]) mirror([0,0,1])
                frustum(size=frstmDims,flankAng=40, col=blackBodyCol);
            }
          }

    //pins
    if (rows==1){
        for (ix=[-(pins-1)/2:2:(pins-1)/2])
          translate([ix*pitch,pinDims.y/2+1-pinDims.z*2,-(bdDims.z+pinDims.z)/2])
            color(metalGoldPinCol) cube(pinDims,true);
        for (ix=[-(pins-3)/2:2:(pins-1)/2])
          translate([ix*pitch,-(pinDims.y/2+1-pinDims.z*2),-(bdDims.z+pinDims.z)/2]) color(metalGoldPinCol)
            cube(pinDims,true);
      }
    else {
        for (ix=[-(pins/2-1)/2:(pins/2-1)/2],iy=[-1,1])
          translate([ix*pitch,iy*(pinDims.y/2+pitch/2+holeWdth/2),-(bdDims.z+pinDims.z)/2])
            color(metalGoldPinCol) cube(pinDims,true);
        if (pPeg)
          for (ix=[-1,1])
            translate([-ix*((pins/2-2)*pitch)/2,0,-(bdDims.z/2+pegHght)]){
              color(blackBodyCol) cylinder(d1=pegDia-0.4,d2=pegDia,h=0.2);
              translate([0,0,0.2]) color(blackBodyCol) cylinder(d=pegDia,h=pegHght+pinDims.z+fudge);
            }

    }

  }//cntrOffset
}

*BIL30(panel=6, notch=false, cutOut=false);
module BIL30(col="red",panel=2, notch=false, cutOut=false){
  //4mm Jack
  //Hirschmann BIL30 (SKS-kontakt.de)

  if (cutOut)
    translate([0,0,-panel-fudge/2]) linear_extrude(panel+fudge) intersection(){
      circle(d=8.2);
      if (notch) square([8.2+fudge,7.2],true);
    }
  else translate([0,0,5])
    mirror([0,0,1]){
    color(col) difference(){
      union(){
        cylinder(d=10,h=5);
        linear_extrude(7.5) intersection(){
          circle(d=8);
          if (notch) square([8+fudge,7],true);
        }
        if (panel<5) translate([0,0,5+panel]) cylinder(d=10,h=4.2);
      }
      translate([0,0,-fudge/2]) cylinder(d=4.5,h=18);
    }

    color("silver") difference(){
      union(){
        translate([0,0,1]) cylinder(d=6,h=17.5);
        translate([0,0,18.5]) cylinder(d1=6,d2=3.5,h=1);
        translate([0,0,19.5]) cylinder(d=3.5,h=4);
      }
      cylinder(d=4,h=18);
      translate([0,0,23.5-2.4/2]) cube([1.5,3.5+fudge,2.4+fudge],true);
    }
  }
}

module screwTerminal(pins=2,col="darkSlateGrey",center=false){
  *translate([-(RM)/2,4.2,0]) rotate([90,0,0]) import("screwTerm.stl");

  RM=5.08;
  ovDims=[RM*(pins-1)+RM+1,8,10];
  baseHght=6.3;
  cntrOffset= center ? [-(RM/2) * (pins-1),0,0]:[0,0,0];
  poly=[[-3.8,0],[-3.8,baseHght],[-3.1,baseHght],[-2.5,10],[2.5,10],[4.2,baseHght],[4.2,0]];
  //body
  translate(cntrOffset) {
    color(col)  difference(){
      translate([-(RM+1)/2,0,0]) rotate([90,0,90]) linear_extrude(ovDims.x,convexity=2) polygon(poly);
      for (i=[0:pins-1]){
        translate([i*RM,0,ovDims.z-2]) cylinder(r=2,h=2+fudge);
        translate([i*RM,-3.8-fudge,1.2+1.5]) rotate([-90,0,0]) cylinder(d=3,h=5.8+fudge);
        translate([i*RM-2,-3.8-fudge,0.7]) cube([4,1.8+fudge,5]);
      }
    }
    for (i=[0:pins-1])
      color("silver") translate([i*RM,0,-3.5]) cylinder(d=1,h=3.5+fudge);
  }
}


*DSub(pins=9,isFemale=false,mountBehind=false,THT=true,cutOut=true,drillDia=5);

module DSub(pins=9, isFemale=true, mountBehind=true, THT=false, cutOut=false, drillDia=3.1){
  // DIN 41652-1
  // http://www.interfacebus.com/Connector_D-Sub_Mechanical_Dimensions.html

  // Array of Dimensions to use depending on pin count
  //          0:pins, 1:A   2:B   3:C   4:D   5:E   6:F   7:G   8:H   9:J  10:K  11:L
  DSubDimsTbl= [[  9,31.19,17.04,25.12, 8.48,12.93,10.97, 6.05,19.53,10.97, 1.52, 1.02], //size 1 (9pin)
                [ 15,39.52,25.37,33.45, 8.48,12.93,10.97, 6.05,27.76,10.97, 1.52, 1.02], //size 2 (15pin)
                [ 25,53.42,39.09,47.17, 8.48,12.93,11.07, 6.05,41.53,10.97, 1.78, 1.25], //size 3 (25pin)
                [ 37,],//size 4 (37pin)
                [ 50,0,0,11.33,15.75,11.07,6.05,0,13.82],//size 5 (50pin)
                [104,0,0,12.90,17.35]];//size 6 (104pin)
  //Tolerances
  DSubTol=[];
  //pick the right row
  DSubDims=   (pins<= 9) ? DSubDimsTbl[0] :  //Shell size 1
              (pins<=15) ? DSubDimsTbl[1] :  //Shell size 2
              (pins<=25) ? DSubDimsTbl[2] :  //Shell size 3 
              (pins<=37) ? DSubDimsTbl[3] :  //Shell size 4
              (pins<=50) ? DSubDimsTbl[4] :  //Shell size 5
              DSubDimsTbl[5];                //Shell size 6

  // -- Break Down the Dims --
  A=DSubDims[1]; //Sheet width
  B=DSubDims[2]; //plug width (inner for male, outer for female)
  C=DSubDims[3]; //drillDist
  D=DSubDims[4]; //plug height
  E=DSubDims[5]; //Sheet Height
  
  Bm=16.79; //male inner
  Bf=16.46; //female outer
    
  G=6.12; // thick
  

  H=DSubDims[8]; //terminal body width
  J=DSubDims[9]; //terminal body hght
  bodyDims=[H,J,4.1]; //bodywidth

  //fixed Dims
  rFem=2.59;
  rMale=2.62;
  rPlug=0.102*25.4; //minimum radius
  rTerm=0.062*25.4; //minimum radius
  rSheet=1;
  sheetThck=0.8;
  spcng=0.3;

  //pins
  pitch= (pins<=15) ? [2.74,2.84] : [2.77,2.84];
  pinDia=1;

  //THT //ref: https://www.we-online.com/katalog/datasheet/618009233721.pdf
  THTOffset= THT ? [0,0,E/2] : (mountBehind) ? [0,0,0] : [0,0,sheetThck]; //y= -11.64 if centerd on mount
  THTrot= THT ? [90,0,0] : [0,0,0];
  baseDims=[A,14.2,2.85]; //basePlate
  
  if (cutOut){
    if (mountBehind) { //CutOut for Back Mounted
    cutOutDims=[B+sheetThck*2+spcng,D+sheetThck*2+spcng];
      for (ix=[-1,1])
        translate([ix*C/2,0]) circle(d=drillDia);
      rndTrapez(cutOutDims,rPlug);
      }
  

    else{ //CutOut for Front Mounted
      for (ix=[-1,1])
        translate([ix*C/2,0]) circle(d=drillDia);
      rndTrapez([H,J],rTerm);
      }
  }//cutout

  else {
    translate(THTOffset) rotate(THTrot){
      //sheet
      color("silver") difference(){
        hull(){
          for (i=[-1,1],j=[-1,1])
            translate([i*(A/2-rSheet),j*(E/2-rSheet),-sheetThck]) 
              cylinder(r=rSheet,h=sheetThck);
        }
        for (i=[-1,1])
          translate([i*C/2,0,-sheetThck-fudge/2]) 
            cylinder(d=3.05,h=sheetThck+fudge);
      }
      //body behind sheet
    if (THT) color("darkSlateGrey"){
      translate([0,0,-1-sheetThck]) difference(){
        rndRect([A,E,2],rSheet,true);
        for (i=[-1,1])
          translate([i*C/2,0,0]) cylinder(d=3.05,h=2+fudge,center=true);
      }
      translate([0,0,-baseDims.y/2-sheetThck]) rndRect([B,E-baseDims.z*2+3,baseDims.y],1.5,true);
    }

      //plug
      
      if (isFemale)
        difference(){
          rndTrapez([B,D,6],rFem);
        for (ix=[-(pins-1)/4:(pins-1)/4])
          translate([ix*pitch.x,pitch.y/2,0])
            cylinder(d=pinDia,h=6+fudge);
        for (ix=[-(floor(pins/2-1)/2):(floor(pins/2-1)/2)])
          translate([ix*pitch.x,-pitch.y/2,0])
            cylinder(d=pinDia,h=6+fudge);

        }
      else{ //male
        color("silver") difference(){
          rndTrapez([B+sheetThck*2,D+sheetThck*2,6],rMale+sheetThck);
          translate([0,0,fudge]) rndTrapez([B,D,6+fudge],rMale);
        } 
        //pins
        for (ix=[-(pins-1)/4:(pins-1)/4])
          color(metalGoldPinCol) translate([ix*pitch.x,pitch.y/2,0]){
            cylinder(d=pinDia,h=5.1-pinDia/2);
            translate([0,0,5.1-pinDia/2]) sphere(d=pinDia);
        }
        for (ix=[-(floor(pins/2-1)/2):(floor(pins/2-1)/2)])
          color(metalGoldPinCol) translate([ix*pitch.x,-pitch.y/2,0]){
            cylinder(d=pinDia,h=5.1-pinDia/2);
            translate([0,0,5.1-pinDia/2]) sphere(d=pinDia);
        }

      }

      //body
      if (!THT) color("silver") translate([0,0,-bodyDims.z-sheetThck]) rndTrapez(bodyDims,rFem);
      }//translate THTOffset/rotation
    if (THT) color("darkSlateGrey") translate([0,baseDims.y/2+THTOffset.y+sheetThck,baseDims.z/2]) cube(baseDims,true);
    } //else give2D

  //submodule
  module rndTrapez(size=[],rad){
  xOffsetRad=tan(10)*(size.y-2*rad); //tan(alpha)=(GK/AK)
  if (len(size)==2) //2D shape
    hull(){
      for (ix=[-1,1]){
        translate([ix*(size.x/2-rad),size.y/2-rad]) circle(r=rad);
        translate([ix*(size.x/2-rad-xOffsetRad),-size.y/2+rad]) circle(r=rad);
      }
    }
  else //3dShape
    hull(){
      for (i=[-1,1]){
        translate([i*(size.x/2-rad),size.y/2-rad,0]) cylinder(r=rad,h=size.z);
        translate([i*(size.x/2-rad-xOffsetRad),-size.y/2+rad,0]) cylinder(r=rad,h=size.z);
      }
    }
  } //module

}

*SH();
module SH(pins=4,sideEntry=true,center=false){
  pitch=1;
  A=(pins-1)*pitch;
  B=A+3;
  bdyDims= sideEntry ? [B,4.25,2.9] : [B,2.9,4.25];
  centerOffset= center ? [A/2,0,0] : [0,0,0];
  plugDims=[pins,3+fudge,2.1]; //

  color("darkSlateGray") translate([0,0,bdyDims.z/2]) 
  difference(){
    cube(bdyDims,true);
    translate([0,-(bdyDims.y-plugDims.y+fudge)/2,0]) cube(plugDims,true);
  }

}

module XH(pins,center=false){
  pitch=2.5;
  A=(pins-1)*2.5;
  B=A+4.9;
  outWdth=5.75;
  inWdth=4.1;
  inLngth=A+3.2;
  xOffset= center ? A/2 : 0;
  // pins
  color("silver")
    for (i=[0:pins-1])
      translate([i*2.5-xOffset,0,-3.4]) quadPin(0.64,3.4+7);
  // body
  color("ivory")
    translate([B/2-2.45-xOffset,0,7/2])
    difference(){
      cube([B,outWdth,7],true);
      translate([0,0,1.5]) cube([inLngth,inWdth,7],true);
      translate([(B-1.5)/2-1.9,-(inWdth+1)/2+fudge,(-7-3.8)/2+7]) slotFrnt();
      translate([-((B-1.5)/2-1.9),-(inWdth+1)/2+fudge,(-7-3.8)/2+7]) mirror([1,0,0]) slotFrnt();
      if (pins==2) translate([0,-(inWdth+1)/2+fudge,(-7-3.8+fudge)/2+7]) cube([0.7,1,3.8+fudge],true);
      translate([(B-1)/2+fudge,-1,(-7-3.25)/2+7]) rotate([0,0,-90]) slotSide();
      translate([-(B-1)/2+-fudge,-1,(-7-3.25)/2+7]) rotate([0,0,-90]) slotSide();
    }

  module slotFrnt(){
    translate([0,0,-(3.8-1.5)/2]) rotate([90,0,0]) cylinder(d=1.5,h=1,center=true);
    translate([-0.75/2,0,fudge/2]) cube([0.75,1,3.8+fudge],true);
    translate([0,0,1.5/4+fudge/2]) cube([1.5,1,3.8-1.5/2+fudge],true);
   }
   module slotSide(){
    difference(){
      union(){
        translate([0,0,-(3.25-2)/2]) rotate([90,0,0]) cylinder(d=2,h=1,center=true);
        translate([0,0,1.5/4+fudge/2]) cube([2,1,3.25-1.5/2+fudge],true);
      }
      translate([(-1-fudge)/2,0,fudge/2]) cube([1+fudge,1+fudge,3.25+fudge*2],true);
    }
   }
}

*ETH();
module ETH(){
  //e.g. HALO HFJ11-2450E-L12RL
  ovDims=[15.88,21.59,13.64];
  cutOutDims=[16.66,14.72,-0.25]; //Z is offset from PCB top side
  pinsYOffset=-ovDims.y/2+10.9;
  difference(){
    color("silver") translate([0,0,ovDims.z/2]) cube(ovDims,true);
    color("darkSlateGrey") translate([-6,-ovDims.y/2-fudge,(ovDims.z-7)/2]) cube([12,12+fudge,7]);
  }
  //pins
  for (i=[-1,1]) {
    translate([i*11.43/2,pinsYOffset,-2]) cylinder(d=3,h=2+fudge);
    translate([i*11.43/2,pinsYOffset,-3]) cylinder(d1=2,d2=3,h=1);
    color("silver") translate([i*15.49/2,pinsYOffset+3.05,-3/2]) cube([0.4,1,3],true);
  }

}

*usbCUpright();
module usbCUpright(){
  //upright USB-C connector
  //https://www.xunpu.com.cn/uploadfile/202307/b4bb7aeb28cf0b3.pdf
  bdyDims=[];
  translate([0,-0.1-7.15/2,4.58+0.2]) rotate([0,90,0]) usbC(true,pins=16);
  //mounting pins
  for (ix=[-1,1],iy=[-1,1])
    color(metalSilverCol) translate([ix*4.06/2,iy*6.1/2,0]) rotate([0,90,0]) linear_extrude(0.2,center=true){
      translate([1.35-0.5,0]) circle(d=1);
      translate([(1.35-0.5)/2,0]) square([1.35-0.5,1],true);
    }
  for (iy=[-1,1])
    color(blackBodyCol) translate([0,iy*7.15/2,-1]) cylinder(d=0.6,h=1);
  //body
    color(metalSilverCol) translate([0,0,9.9/2]) cube([4.35,8,9.9],true);
}


!usbC(plug=false);
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

module usbA(){
  outerDims=[13.3,14,5.8]; //from Assmann/Wuerth
  innerDims=[12.5,8.88,5.12]; //from USB.org
  tongDims=[11.1,8.38,1.84]; //from usb.org

  o2iOffset=[0,(outerDims.y-innerDims.y)/2,0];
  in2tngOffset=[0,(innerDims.y-tongDims.y)/2,tongDims.z/2];

  bodyHght=6.9;
  shellZOffset=-outerDims.z/2+bodyHght;
  shellThick=0.3;

  //sheet metal shell
  translate([0,0,shellZOffset]){
    rotate([90,0,0]) sheetBox([outerDims.x,outerDims.z,outerDims.y],shellThick,shellThick*2,inlay=outerDims.y-innerDims.y);
    color("ivory") translate(-o2iOffset+in2tngOffset + [0,fudge,0]) cube(tongDims,true);
  }
  //plastic spacer
  color("ivory")
  translate([0,-(7.95-outerDims.y)/2,(bodyHght-outerDims.z)/2]) cube([outerDims.x-shellThick*4,7.95,bodyHght-outerDims.z],true);
  //pins
  color("silver")
  for (i=[-3.5,-1,1,3.5]){
    translate([i,-outerDims.y/2+10.3+2.71,-3.4/2]) cube([0.8,0.25,3.4+fudge],true);
  }
  //flanges
  color("silver"){
  translate([0,-outerDims.y/2,bodyHght-outerDims.z-0.2])
    rotate([90,0,-90]) flange(1,innerDims.x,shellThick);
  translate([0,-outerDims.y/2,bodyHght+0.2])
    rotate([-90,0,-90]) flange(1,innerDims.x,shellThick);
  translate([-outerDims.x/2-0.2,-outerDims.y/2,bodyHght-outerDims.z/2])
    rotate([0,0,-90]) flange(1,innerDims.z,shellThick);
  translate([outerDims.x/2+0.2,-outerDims.y/2,bodyHght-outerDims.z/2])
    rotate([0,0,180]) flange(1,innerDims.z,shellThick);
  }

}

*pinHeader();
module pinHeader(pins=10, rows=2,center=false, markPin1=false, diff="none", thick=3+fudge,
       plugJmprCol=[]){

  cntrOffset= center ? [-(pins-rows)/rows*2.54/2,-(rows-1)*2.54/2,0]:[0,0,0];
  pinLength=11.6;
  pinOffSet=1.53;

  translate(cntrOffset){
    if (diff=="pins"){
      translate([(pins-1)*2.54/2,0,0]) rndRect(pins*2.54,2.54,thick,1.27,0);
    }
    else if (diff=="housing"){
      translate([(pins-1)*2.54/2-fudge/2,-fudge/2,(thick)/2]) cube([pins*2.54+fudge,2.54+fudge,thick+fudge],true);
    }
    else if (diff=="pcb"){ //holes in PCB
      for (i=[0:pins/rows-1],j=[0:rows-1])
        translate ([i*2.54,j*2.54,2.54/2]) circle(d=1.1);
    }
    else {
      for (i=[0:pins/rows-1],j=[0:rows-1]){
        pinNo=(i*rows+1)+j;
        translate ([i*2.54,j*2.54,2.54/2]){
          color("DarkSlateGray")cube(2.54,true);
          if ((pinNo==1)&&markPin1)
            color("red") translate([0,0,pinOffSet]) cube([0.64,0.64,pinLength],true);
          else
            color("gold") translate([0,0,pinOffSet]) cube([0.64,0.64,pinLength],true);
          if (plugJmprCol[pinNo-1]) translate([0,0,2.54/2])
            jumperWire(plugJmprCol[pinNo-1]);
          
        }
      }
    }
  }
}

*pinHeaderRA(pins=10,rows=3,center=false);
module pinHeaderRA(pins=10, rows=2,center=false, diff="none", thick=3+fudge,
       plugJmprCol=[]){
  //Dimensions from MPE-Garry 088-2

  B=6; //hor. pin Length
  C=3.3;//vert. pin Length
  W=3.9; //bodyPosition
  A=B+W; //first row to tip dist.
  RM=2.54;

  pinSQ=0.64;
  bodyDims=[(pins/2)*RM,2.5,5];
  pinZOffset=(bodyDims.z-RM)/2;

  cntrOffset= center ? [-(pins-rows)/rows*2.54/2,-(rows-1)*2.54/2,0]:[0,0,0];
  pinLength=11.6;
  pinOffSet=1.53;

  translate(cntrOffset){
    if (diff=="pins"){
      translate([(pins-1)*2.54/2,0,0]) rndRect(pins*2.54,2.54,thick,1.27,0);
    }
    else if (diff=="housing"){
      translate([(pins-1)*2.54/2-fudge/2,-fudge/2,(thick)/2]) cube([pins*2.54+fudge,2.54+fudge,thick+fudge],true);
    }
    else {
      for (i=[0:pins/rows-1],j=[0:rows-1]){
        elev=(rows-j-1)*RM;
        pinNo=(i*rows+1)+j;
        //angled pin
        color("gold") translate ([i*2.54,j*2.54,0]){
          translate([-pinSQ/2,-pinSQ/2,-C]) cube([pinSQ,pinSQ,C+pinZOffset+elev]);//vertical Pins
          translate([-pinSQ/2,0,elev-pinSQ/2+pinZOffset]) cube([pinSQ,A+elev,pinSQ]); //horiz pins
          translate([0,0,2.54/4+elev-pinSQ+pinZOffset]) rotate([0,90,0]) cylinder(d=pinSQ,h=pinSQ,center=true);
        }
        if (plugJmprCol[pinNo-1]) translate([i*2.54,W+2.5,elev+pinZOffset])
          rotate([-90,0,0]) jumperWire(plugJmprCol[pinNo-1]);
      }
      //body
      color("darkslategrey") translate([-RM/2,RM+W-2.5,0]) cube([(pins/rows)*RM,2.5,2.5*rows]);
    } //else
  }
}

module boxHeader(pins=10,center=false){
  fudge=0.1;
  RM=2.54;


  //Dimensions from WE PartNo: 612 0xx 216 21
  height=8.85;
  pinHght=11.5;
  ovDpth=8.85;
  inDepth=6.35;
  yWallThck=(ovDpth-inDepth)/2;
  A=RM*(pins/2-1);//pin to pin distance
  B=RM*(pins/2)+7.66; //overall Width
  C=RM*(pins/2-1)+7.88; //inner Width


  cntrOffset= center ? [0,0,0] : [RM*(pins/2-1)/2,RM/2,0];

  translate(cntrOffset){
    color("darkslateGrey")
       difference(){
        translate([0,0,height/2]) cube([B,ovDpth,height],true);
        translate([0,0,(2.35+height)/2]) cube([C,6.35,height-2.35+fudge],true);
        translate([-(B-1.05-fudge)/2,0,6.4/2]) cube([(B-C)/2+fudge,3.3,6.4+fudge],true);//side nudges
        translate([(B-1.05-fudge)/2,0,6.4/2]) cube([(B-C)/2+fudge,3.3,6.4+fudge],true);
        translate([0,-(ovDpth-yWallThck)/2,(height-2.35)/2+2.35]) cube([4.5,yWallThck+fudge,height-2.35+fudge],true);
        color("ivory") translate([-B/2*0.7,-ovDpth/2-fudge,height*0.7]) rotate([-90,-30,0]) cylinder(d=2,h=fudge*2,$fn=3);
      }
      for (i=[0:pins/2-1],j=[-1,1]){
        color("gold") translate([-A/2+i*RM,RM/2*j,pinHght/2-3]) cube([0.64,0.64,pinHght],true);
      }
    }
}

module duraClikRA(pos=2,diff="none"){
  //Molex DuraClik Right Angle
  A=4+2*pos; //ovWith

  ovHght=6.4;
  baseHght=5.7;
  ovDpth=9.4;
  resess=[4,2.4+fudge,2.3+fudge];
  plug=[1+2*pos,5+fudge,4.7];
  plugZ=0.7;


  translate([0,ovDpth/2,0])
  if (diff=="housing"){
    translate([0,0,ovHght/2]) cube([A+fudge,ovDpth+fudge,ovHght+fudge],true);
  }

  else {
   color(whiteBodyCol)
    difference(){
      translate([0,0,ovHght/2]) cube([A,ovDpth,ovHght],true);//body
      translate([0,(-ovDpth+plug[1])/2-fudge,plug[2]/2+plugZ])
        difference(){//plug
          cube(plug,true);
          translate([0,-plug[1]/2+0.5,plug[2]/2-0.25+fudge]) cube([1.8,1,0.5],true);
        }
       translate([0,ovDpth/2-resess[1]/2+fudge,resess[2]/2-fudge]) cube(resess,true);
       translate([0,(ovDpth-resess[1])/2+fudge,(ovHght+resess[2]-fudge)/2]) cube([A+fudge,resess[1],ovHght-resess[2]+2*fudge],true);
    }
  }
}

*duraClik(2);
module duraClik(pos=2,givePoly=false){
  A= (pos>2) ? 6.6+2*pos : 10.9; 
  B= (pos>2) ? 3.7+pos*2 : 8; 
  C= (pos>6) ? pos*2-0.9 : 
     (pos>2) ? pos*2 : 0;
  D= (pos>5) ? 11.8 : 
     (pos>2) ? -0.2+2*pos : 6.3;

  ovDpth=7.8;

  baseThck=3;
  scktThck=5.05;
  ovHght=baseThck+scktThck;
  resess=[4.3,1.6+fudge,7.2+fudge]; //resess

  iLckDpth=3;

  plug=[1+2*pos,4.7,5+fudge];
  plgY=2.3;
  
  pinDims=[0.5,1.35,1];
  hdrDims=[0.5,0.5,3.4];
  yOffset=-0.96;

  if (givePoly) !square([A,ovDpth],true);
    
  color(whiteBodyCol)
  translate([0,yOffset,0]) difference(){
    union(){
      translate([0,0,baseThck/2]) cube([A,ovDpth,baseThck],true); //base
      translate([0,0,baseThck+(scktThck/2)-fudge/2]) cube([B-2,ovDpth,scktThck+fudge],true); //socket
      translate([0,0,baseThck+(scktThck/2)-fudge/2]) cube([B,iLckDpth,scktThck+fudge],true); //flange
    }
    translate([0,-(ovDpth-plug[1])/2+plgY,ovHght-plug[2]/2+fudge])
      difference(){
        cube(plug,true); //plug
        translate([0,-plug[1]/2+0.24,plug[2]/2-0.5+fudge]) cube([1.8,0.5,1],true);
      }
    if (C) {
      translate([-C/2,-(ovDpth)/2-fudge,-fudge/2]) cube([(C-D)/2,2.3,scktThck+fudge]);
      translate([D/2,-(ovDpth)/2-fudge,-fudge/2]) cube([(C-D)/2,2.3,scktThck+fudge]);
    }
    else translate([0,-(ovDpth-resess[1])/2-fudge,resess[2]/2-fudge]) cube(resess,true); //resess
  }
  //pins
  color(metalGreyPinCol)
  for (ix=[-(pos-1)/2:(pos-1)/2]){
    translate([ix*2,(ovDpth+pinDims.y)/2+yOffset,pinDims.z/2]) cube(pinDims,true);
    translate([ix*2,0,baseThck]) header();
  }
  module header(){
    tipDims=[hdrDims.x,0.25,0.5];
    linear_extrude(hdrDims.z-tipDims.z) square([hdrDims.x,hdrDims.y],true);
    translate([0,0,hdrDims.z-tipDims.z]) linear_extrude(tipDims.z, scale=[1,0.5]) square([hdrDims.x,hdrDims.y],true);
  }
}

*SDCard();
module SDCard(showCard=true){
  ovDims=[28.25,28,2.7];
  //e.g. Kyocera Series 5738
  translate([0,0,ovDims.z/2]) difference(){
    color("silver") cube(ovDims,true);
    translate([0,-(ovDims.y/2+10),0]) cylinder(d=28,h=ovDims.z+fudge,center=true);
 }
 if (showCard){
   color("darkblue") translate([0,-(ovDims.y-32)/2-7,ovDims.z-2.08/2-0.2]) cube([24.13,32,2.08],true);
   color("lightblue",0.5) translate([0,-(ovDims.y-5)/2-12,ovDims.z-2.08/2-0.2]) cube([24.13,5,2.08],true);
 }
}

*jumperWire();
module jumperWire(col="red",wireLen=5){

  color("darkSlateGrey") difference(){
    translate([0,0,7]) cube([2.6,2.6,14],true);
    translate([0,0,14-3/2]) cube([2.4,2.4,3+fudge],true);
  }
  color(col) translate([0,0,14-2]) cylinder(d=1.6,h=wireLen+2);
}

/* --- helper modules --- */
*sheetBox([20,10,15],0.5,2);
// metall sheet housing (e.g. for USB connector)
module sheetBox(outer=[20,10,15], thick=0.5, radius=1, inlay=0, inlayCol="ivory"){
  inRad= ((radius-thick)<=0) ? 0.1 : radius-thick;

  color("silver")
  translate([0,0,-outer.z/2])
    linear_extrude(outer.z)
      difference(){
        hull()
          for (i=[-1,1],j=[-1,1])
            translate([i*(outer.x/2-radius),j*(outer.y/2-radius)]) circle(radius);
        hull()
          for (i=[-1,1],j=[-1,1])
            translate([i*(outer.x/2-thick-inRad),j*(outer.y/2-thick-inRad)]) circle(inRad);

        }
   color(inlayCol)
    translate([0,0,-outer.z/2])
      linear_extrude(inlay)
        hull()
          for (i=[-1,1],j=[-1,1])
            translate([i*(outer.x/2-thick-inRad),j*(outer.y/2-thick-inRad)]) circle(inRad);
}

//quadPin(0.64,5);
module quadPin(width=0.64,length,center=false){

  zOffset= center ? 0 : length/2;

  translate([0,0,zOffset]){
    cube([width,width,length-width],true);
    translate([0,0,(length-width)/2]) rotate(45) cylinder(d1=width*sqrt(2),d2=0.1,h=width/2,$fn=4);
    translate([0,0,-(length-width)/2]) rotate(45) mirror([0,0,1]) cylinder(d1=width*sqrt(2),d2=0.1,h=width/2,$fn=4);
  }
}


module flange(dia, length, thick){
  intersection(){
    translate([0,0,-length/2]) cube([dia,dia,length]);
    difference(){
       cylinder(d=1,h=length-thick*2,center=true);
       cylinder(d=1-thick*2,length,center=true);
    }
  }
}

*testJack4mm();
module testJack4mm(hdCol="red"){
  color("silver") difference(){
    union(){
      translate([0,0,5]) cylinder(d=6,h=16);
      cylinder(d=3.4,h=5);
      translate([0,0,4]) cylinder(d1=3.4,d2=6,h=1);
    }
    translate([0,0,5]) cylinder(d=4,h=17+fudge);
  }
  color(hdCol)
    difference(){
      translate([0,0,22-9.2]) cylinder(d=9.7,h=9.2);
      translate([0,0,22-9.2-fudge/2]) cylinder(d=4.1,h=9.2+fudge);
    }
}




*tubeSocket9Pin();

module tubeSocket9Pin(){
  //body
  translate([0,0,3.5]) difference(){
         union(){
           color("tan") cylinder(d=18.3,h=8.5);
           translate([0,0,12-2.8-1-3.5]) ring();
         }
        for (ir=[36*1.5:36:36*10])
          rotate([0,0,ir]) translate([12/2,0,0]){
            translate([0,-2.2/2,-fudge/2]) color("tan") cube([1.1,2.2,17.5-9+fudge]);
            translate([0,0,+1]) color("tan") cylinder(d=2.2,h=17.5-10+fudge);
          }
      }

  for (ir=[36*1.5:36:36*10])
      color("silver") rotate([0,0,ir]) translate([10.5,0,0]) pin();

  module ring(){
    color("tan") rotate_extrude(){
      translate([0,-1,0]) square([(22.8-2)/2,2]);
      translate([(22.8-2)/2,0,0]) circle(d=2);
    }
  }

  module pin(){
    pinThck=0.2;
    pinWdth=1.5;
    translate([0,0,-3+pinWdth/2]) rotate([0,-90,0]){
      cylinder(d=pinWdth,h=pinThck,center=true);
      translate([(3-pinWdth/2)/2,0,0]) cube([3-pinWdth/2,pinWdth,pinThck],true);
      translate([3.5/2+(3-pinWdth/2),0,0]) cube([3.5,2.6,pinThck],true);
      hull(){
        translate([6.5-pinWdth/2,0,0]) rotate([90,0,0]) cylinder(d=pinThck,h=2.7,center=true);
        translate([6.5-pinWdth/2,0,(20-12-2.2)/2]) rotate([90,0,0]) cylinder(d=pinThck,h=2.7,center=true);
      }
    }
  }

}

module tubeSocket9pinFlange(flange=true){

  //https://www.tubesandmore.com/products/socket-9-pin-pc-mount
  // without flange VT9-PT
  //https://www.tubesandmore.com/sites/default/files/associated_files/p-st9-620.pdf

  sheetThck=(19.5-18.3)/2;

  translate([0,0,-3.2]){
    //sheet metal
      if (flange) translate([0,0,17.5-6.5]){
          difference(){
            color("grey") hull(){
              for (ix=[-1,1])
                translate([ix*28/2,0,0]) cylinder(d=34.8-28,h=sheetThck);
                cylinder(d=23.2,h=sheetThck);
            }
            for (ix=[-1,1])
                translate([ix*28/2,0,-fudge/2]) color("grey") cylinder(d=3.5,h=sheetThck+fudge);
            color("grey") cylinder(d=18.3,h=sheetThck+fudge);
        }


        difference(){
          intersection(){
            translate([0,0,sheetThck])color("grey") cylinder(d=23.2,h=6.5-2);
            color("grey") translate([0,0,(6.5-2+fudge)/2]) cube([19.6,23.2+fudge,6.5-2+fudge+sheetThck],center=true);
          }
          color("grey") translate([0,0,-fudge/2]) cylinder(d=18.3+fudge,h=6.5+fudge);
        }
      }
    //plastic body

      translate([0,0,9]) difference(){
         color("tan") cylinder(d=18.3,h=17.5-9);
        for (ir=[36*1.5:36:36*10])
          rotate([0,0,ir]) translate([12/2,0,0]){
            translate([0,-2.2/2,-fudge/2]) color("tan") cube([1.1,2.2,17.5-9+fudge]);
            translate([0,0,+1]) color("tan") cylinder(d=2.2,h=17.5-10+fudge);
          }
      }

    //pins
    for (ir=[36*1.5:36:36*10])
      color("silver") rotate([0,0,ir]) translate([10,0,0]) rotate([0,-90,0]) pin();
  }

  module pin(){
    pinThck=0.2;

    cylinder(d=1.6,h=pinThck,center=true);
    translate([3.2/2,0,0]) cube([3.2,1.6,pinThck],true);
    translate([3.2+(8-3.2)/2,0,0]) cube([8-3.2,2.7,pinThck],true);
    hull(){
      translate([3.2+(8-3.2),0,0]) rotate([90,0,0]) cylinder(d=pinThck,h=2.7,center=true);
      translate([3.2+(8-3.2)+1-pinThck/2,0,(20-12-2.2)/2]) rotate([90,0,0]) cylinder(d=pinThck,h=2.7,center=true);
    }
  }

}





*mUSB();
module mUSB(showPlug=false){
  //usb.org CabConn20.pdf

  M= 6.9;   //Rece inside width
  N= 1.85;  //Rece inside Height -left/right

  C= 3.5;   //Plastic width
  X= 0.6;   //plastic height
  U= 0.22;  //plastic from shell
  P= 0.48;  //Conntacst from plastic

  Q= 5.4;   //shell inside bevel width
  R= 1.1;   //shell inside bevel height -left/right

  S= 4.75;  //Latch separation
  T= 0.6;   //Latch width -left/right
  V= 1.05;  //Latch recess
  W= 2.55;  //Latch recess
  Y= 0.56;  //Latch Height
  Z= 60;    //Latch Angle

  H= 2.6;   //Pin1-5 separation
  I= 1.3;   //Pin2-4 separation
  conWdth= 0.37; //# contact width


  conThck= 0.1; //contact thickness

  //JAE DX4R005J91
  r=0.25; //corner radius
  t=0.25; //sheet thickness

  //flaps
  flpLngth=0.6;
  flpDimTop=[6.2,flpLngth,t];
  flpDimBot=[5.2,flpLngth,t];
  flpDimSide=[0.75,flpLngth,t];

  flpAng=40;


  THT_OZ=-(5-1.8);
  legDim=[0.9,0.65-r/2,t];

  translate([0,-THT_OZ,0]){
    //THT pins
    color(metalSilverCol){
      for (ix=[-1,1]){
        translate([ix*(6.45/2-r),THT_OZ,t/2])
          rotate(ix*-90)
            bend(size=legDim,radius=r,angle=-90,center=true)
              flap(legDim);
      }
      translate([0,THT_OZ,t/2]) cube([6.45-r*2,0.9,t],true);
    }

    //SMD pads
    padDim=[1,1,t];
    color(metalSilverCol)
      for (ix=[-1,1]){
        translate([ix*(M+t)/2,-(padDim.x/2),r+t]) rotate([-90,0,ix*-90])
          bend(padDim,angle=-90,radius=r+t/2,center=true)
            flap(padDim);
        translate([ix*(M+t)/2,-(padDim.x/2),1.1/2+t/2+r])
          cube([t,padDim.x,1.1-r],true);
      }

    //SMD pins
      for (ix=[-H/2,-I/2,0,I/2,H/2]){
        color(metalGoldPinCol)
        translate([ix,-0.7,r+conThck/2])
          rotate([-90,0,0])
            bend([conWdth,1-r,conThck],center=true,angle=90,radius=r)
              cube([conWdth,1-r,conThck],center=true);
        color(metalGoldPinCol)
        translate([ix,-W/2-1-t,-X+t+N-(conThck)/2])
          cube([conWdth,W-fudge,conThck],true);
     }


    //plastics
    color(blackBodyCol)
      translate([0,-t,N/2+t])
        rotate([90,0,0])
         hull()
            for (ix=[-1,1],iy=[-1,1])
              translate([ix*(M/2-r),iy*(N/2-r)]) cylinder(r=r-0.01, h=1);
    color(blackBodyCol)
       translate([0,-W/2-1-t,-X/2+t+N-U]) plastic();


    //metal-body with cutouts
    color(metalSilverCol){
      difference(){
        shell();
        translate([0,THT_OZ,t+(t+1)/2]) cube([7.4+fudge,1,1+t],true);
        translate([0,-(1+t)/2+fudge/2,(t+1.1-fudge)/2]) cube([7.4+fudge,1+t+fudge,1.1+t+fudge],true);
        //Latch
        for (ix=[-1,1])
          translate([ix*S/2,THT_OZ,N+t*1.5]) cube([T,1.2,t+fudge],true);
      }
      //flaps
      translate([0,-5,N+t/2+t])
        rotate(180)
          bend(flpDimTop,angle=flpAng,radius=r,center=true)
            flap(flpDimTop);
      translate([0,-5,t/2])
        rotate(180)
        bend(flpDimBot,angle=-flpAng,radius=r,center=true)
          flap(flpDimBot);
      for (ix=[-1,1])
        translate([ix*(M+t)/2,-5,t+N-R/2])
          rotate([0,ix*-90,180])
            bend(flpDimSide,angle=flpAng,radius=r,center=true)
              flap(flpDimSide);
    }//metalBody
  }//assy
  
  if (showPlug) translate([0,-2.5-1.3,-2.7]) plug();
    
  module plastic(){
    difference(){
      cube([C,W,X],true);
      for (ix=[-H/2,-I/2,0,I/2,H/2])
        translate([ix,0,-X/2+(X-P+conThck-fudge)/2])
          cube([conWdth,W+fudge,X-P+conThck+fudge],true);
    }
  }

  module shell(){
    translate([0,0,N-R/2+t])
      rotate([90,0,0]){
          difference(){ //2D
            shape(radius=r+t,length=5);
            translate([0,0,-fudge/2]) shape(radius=r,length=5+fudge);
          }
    }
  }

  //the usb shape
  module shape(radius=r,length=5){
    if (length)
      hull(){
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*(M/2-r),iy*(R/2-r)]) cylinder(r=radius,h=length);
        for (ix=[-1,1])
          translate([ix*(Q/2-r/2),-N+(R/2+r)]) cylinder(r=radius,h=length);
      }
    else
     hull(){
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*(M/2-r),iy*(R/2-r)]) circle(r=radius);
        for (ix=[-1,1])
          translate([ix*(Q/2-r/2),-N+(R/2+r)]) circle(r=radius);
      } 
  }

  module flap(size){
    hull() for (ix=[-1,1])
      translate([ix*(size.x/2-r),size.y/2-r,0]) cylinder(r=r,h=size.z,center=true);
    translate([0,-r/2,0]) cube([size.x,size.y-r,size.z],true);
  }
  
  module plug(){
    rad=0.9;
    cham=2;
    sze=[10.6,18.5,8.5];
    poly=[[-sze.x/2,rad],[-sze.x/2,sze.z-cham],[-sze.x/2+cham,sze.z],
          [sze.x/2-cham,sze.z],[sze.x/2,sze.z-cham],[sze.x/2,rad]];
    rotate([90,0,0]) color("darkSlateGrey") linear_extrude(sze.y){
      polygon(poly);
      hull() for (ix=[-1,1]) translate([ix*(sze.x/2-rad),rad]) circle(rad);
      }
    translate([0,0,sze.z/2]) rotate([-90,180,0]) 
      color("silver") linear_extrude(5.4) offset(-0.2) shape(0.4,0);
  }
}

*BatteryHolder(true);
module BatteryHolder(showCoin=true){
  //linx BAT-HLD-001 https://linxtechnologies.com/wp/wp-content/uploads/bat-hld-001.pdf
  sheetThck=0.3;
  poly=[[-7.25,7.25],
        [7.25,7.25],
        [10.3,4.6],
        [10.3,-4.5],
        [7,-7.5],
        [-7,-7.5],
        [-10.3,-4.5],
        [-10.3,4.6]];
  flapAng=atan((10.3-7.25)/(7.25-4.6))-90;
  flapLen=norm([7.25,7.25]-[10.3,4.6]);
  
  if (showCoin) color("silver") cylinder(d=20,h=3.2);
  
  color("grey") translate([0,0,4.1-sheetThck]) linear_extrude(sheetThck) topShape();
  
  for (m=[0,1]) mirror([m,0,0]){
    color("grey") translate([10.3,0,4.1-sheetThck]) side();
    //pads
    for(iy=[-1,1]) translate([10.3,iy*1.5+1.05,sheetThck]) rotate([-90,0,-90]) 
      color("grey") bend([2,0.9,sheetThck],90,sheetThck) cube([2,0.9,sheetThck]);
    //flaps
    color("grey") translate([7.25,7.25,4.1-sheetThck]) 
      rotate(flapAng) bend([flapLen,2.7,sheetThck],-90,sheetThck) cube([flapLen,2.7,sheetThck]);
  }
  
  
  
  
  module side(){
  translate([0,9/2+0.1]) rotate(-90)
    bend([9.1,2.7+0.8,sheetThck],-90,sheetThck) linear_extrude(sheetThck) 
      translate([9.1/2,0]) rotate(90){  
        translate([2.7/2,0]) square([2.7,9.1],true);
        for (iy=[-1,1]) translate([0.8/2+2.7,iy*1.5]) square([0.8,2],true);
      }
    
}
  
  module topShape(){
    difference(){
      union(){
        polygon(poly);
        for (ix=[-1,1]) translate([ix*5.8,-5.9]) circle(d=4);
        }
      translate([0,-16.35]) circle(d=20);
      for (ix=[-1,1]){
        translate([ix*5.5,2.5]) circle(d=6.25);
        translate([ix*5.5,-1.7]) square([3.2,5.6],true);
      }
    }//diff
  }
  
}

*PCBFuseATO();
module PCBFuseATO(center=false){
  ovDims=[20,6,17.5];
  pinOffset=[4.6,1.2];
  cntrOffset= center ? [0,0,0] : [pinOffset.x,-pinOffset.y,0];
  translate(cntrOffset){
    difference(){
      color("darkSlateGrey") translate([0,0,ovDims.z/2]) cube(ovDims,true);
      color("darkSlateGrey") translate([0,0,0.5-fudge]) 
        cube([ovDims.x-3,ovDims.y+fudge,1+fudge],true);
      color("darkSlateGrey") translate([0,0,ovDims.z-3.5/2]) 
        cube([ovDims.x-2,ovDims.y-2,3.5+fudge],true);
    }
   for (ix=[-1,1])
     color("silver") translate([ix*4.6,1.2,-3.1]) cylinder(d=2,h=3.1+1);
   color("darkSlateGrey") translate([0,0,-4.1]) cylinder(d=2.4,h=4.1+1);
 }
}

*PCBFuseMini();
module PCBFuseMini(center=false){
  //Littlefuse 153008
  ovDims=[17.3,6.1,10.4];
  pinOffset=[7.62/2,3.46/2];
  latchDims=[0.76,5.4,2.54];
  cntrOffset= center ? [0,0,0] : [pinOffset.x,-pinOffset.y,0];
  pinDims=[1,0.4,3.9];
  
  translate(cntrOffset){
    difference(){
      color("darkSlateGrey") translate([0,0,ovDims.z/2]) cube(ovDims,true);
      color("darkSlateGrey") translate([0,0,0.5-fudge]) 
        cube([ovDims.x-3,ovDims.y+fudge,1+fudge],true);
      color("darkSlateGrey") translate([0,0,ovDims.z-3.5/2]) 
        cube([12,5.4,3.5+fudge],true);
    }
  //latches
  for (ix=[-1,1])
    translate([ix*12.1/2,0,ovDims.z+latchDims.z/2])
    color("darkSlateGrey") cube(latchDims,true);
  //pins
  for (ixy=[-1,1])
    color("silver") translate([ixy*pinOffset.x,-ixy*pinOffset.y,-(pinDims.z-1)/2]) 
      cube(pinDims+[0,0,1],true);
   color("darkSlateGrey") translate([0,0,-4.1]) cylinder(d=2.4,h=pinDims.z+1);
 }
}

// ---- keyStone  PlayGround ---
*translate([70,20,0]){
   keyStoneModule();
   translate([0,30,0]) rotate(90) H_MTD();
   mateNet();
}

module keyStoneModule(){
    springDims=[11.3,10,2];
    latchHght=19.8;
    latchDeep=8.5;
    keyStoneOpening=[14.5,16.1];
    translate([0,8.5/2,16.1/2]) cube([14.5,8.5,16.1],true);
    translate([0,latchDeep+springDims.y/2,latchHght-1]) 
        cube(springDims,true);
}

module H_MTD(){
  color("silver")translate([0,0,8.2/2]) cube([10,9,8.2],true);
  color("teal") translate([-(14.1+10)/2,0,9.6/2-0.15]) cube([14.1,11,9.6],true);
}

module mateNet(){
  import("/sources/MateNetInliner.stl");
}

*BKLPwrCable();
module BKLPwrCable(angled=true,length=20){
  //https://cdn-reichelt.de/documents/datenblatt/C160/075104_DB-DE.pdf

  //body
  color("darkSlateGrey"){
    translate([0,0,4.8]){ 
     cylinder(r=6.1,h=11.6);
      translate([14.9/2,0,11.6/2]) cube([14.9,6.1*2,11.6],true);
    }
    cylinder(d=10.5,h=4.8);
    translate([14.9,0,4.8+11.6/2]) rotate([0,90,0]) cylinder(d=8,h=26.9-14.9);
  }
  //contact
  color("silver"){
    translate([0,0,-9.5]) cylinder(d=5.5,h=9.5);
  }

  //wires
  color("red") translate([14.9+26.9-14.9,-2.35/2,4.8+11.6/2]) rotate([0,90,0]) cylinder(d=2.35,h=length);
  color("black") translate([14.9+26.9-14.9,2.35/2,4.8+11.6/2]) rotate([0,90,0]) cylinder(d=2.35,h=length);
}

// ---- helpers ---

// bend modifier
// bends an child object along the x-axis
// size: size of the child object to be bend
// angle: angle to bend the object, negative angles bend down
// radius: bend radius, if center= false is measured on the outer if center=true is measured on the mid
// center=true: bend relative to the childrens center
// center=false: bend relative to the childrens lower left edge
// flatten: calculates only the stretched length of the bend and adds a cube accordingly


module bend(size=[50,20,2],angle=45,radius=10,center=false, flatten=false){
  alpha=angle*PI/180; //convert in RAD
  strLngth=abs(radius*alpha);
  i = (angle<0) ? -1 : 1;


  bendOffset1= (center) ? [-size.z/2,0,0] : [-size.z,0,0];
  bendOffset2= (center) ? [0,0,-size.x/2] : [size.z/2,0,-size.x/2];
  bendOffset3= (center) ? [0,0,0] : [size.x/2,0,size.z/2];

  childOffset1= (center) ? [0,size.y/2,0] : [0,0,size.z/2*i-size.z/2];
  childOffset2= (angle<0 && !center) ? [0,0,size.z] : [0,0,0]; //check

  flatOffsetChld= (center) ? [0,size.y/2+strLngth,0] : [0,strLngth,0];
  flatOffsetCb= (center) ? [0,strLngth/2,0] : [0,0,0];

  angle=abs(angle);

  if (flatten){
    translate(flatOffsetChld) children();
    translate(flatOffsetCb) cube([size.x,strLngth,size.z],center);
  }
  else{
    //move child objects
    translate([0,0,i*radius]+childOffset2) //checked for cntr+/-, cntrN+
      rotate([i*angle,0,0])
      translate([0,0,i*-radius]+childOffset1) //check
        children(0);
    //create bend object

    translate(bendOffset3) //checked for cntr+/-, cntrN+/-
      rotate([0,i*90,0]) //re-orientate bend
       translate([-radius,0,0]+bendOffset2)
        rotate_extrude(angle=angle)
          translate([radius,0,0]+bendOffset1) square([size.z,size.x]);
  }
}

module octagon(size=2.54){
  //isolator octagon 2D shape
  poly=[[-size/2,size/4],[-size/3,size/2],
        [size/3,size/2],[size/2,size/4],
        [size/2,-0.635],[size/3,-size/2],
        [-size/3,-size/2],[-size/2,-size/4]];
  polygon(poly);
}

*frustum([3,2,0.9],method="linExt");
module frustum(size=[1,1,1], flankAng=[5,5], center=false, method="poly", col="darkSlateGrey"){
  //a square frustum --> cube with a trapezoid crosssection
  //https://en.wikipedia.org/wiki/Frustum
  
  flnkAng = is_list(flankAng) ? flankAng : [flankAng,flankAng];
  //size = base dimensions x height
  //https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
  cntrOffset= (center) ? [0,0,-size.z/2] : [size.x/2,size.y/2,0];
  
  flankRed=[tan(flnkAng.x)*size.z,tan(flnkAng.x)*size.z]; //reduction in width by angle
  faceScale=[(size.x-flankRed.x*2)/size.x,(size.y-flankRed.y*2)/size.y]; //scale factor for linExt

  if (method=="linExt")
    translate(cntrOffset)
      linear_extrude(size.z,scale=faceScale)
        square([size.x,size.y],true);
  else{ //for export to FreeCAD/StepUp
    polys= [[-size.x/2,-size.y/2,-size.z/2], //0
            [ size.x/2,-size.y/2,-size.z/2], //1
            [ size.x/2, size.y/2,-size.z/2], //2
            [-size.x/2, size.y/2,-size.z/2],//3
            [-(size.x/2-flankRed.x),-(size.y/2-flankRed.y),size.z/2],  //4
            [  size.x/2-flankRed.x ,-(size.y/2-flankRed.y),size.z/2],  //5
            [  size.x/2-flankRed.x , (size.y/2-flankRed.y),size.z/2],  //5
            [-(size.x/2-flankRed.x), (size.y/2-flankRed.y),size.z/2]]; //5
    faces= [[0,1,2,3],  // bottom
            [4,5,1,0],  // front
            [7,6,5,4],  // top
            [5,6,2,1],  // right
            [6,7,3,2],  // back
            [7,4,0,3]]; // left
   color(col) polyhedron(polys,faces,convexity=2);
  }
}

module rndRect(size=[10,10], rad=1, center=false){
  /* square or cube with rounded corners
 accepts 2 or 3 Dimensions 
  */
  if (len(size)==3){
    cntrOffset= center ? [0,0,0] : size/2;    
    hull() for(ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]+cntrOffset) 
        cylinder(r=rad,h=size.z,center=true);
  }
  else{
    cntrOffset= center ? [0,0] : size/2;    
    hull() for(ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]+cntrOffset) circle(r=rad);
  }
}



module stagger(pos=10, pitch=[1.27,1.27], stagger){
  stagger = (stagger==undef) ? pitch.x/2 : stagger;
 
  for (ix=[-(pos-1)/4:(pos-1)/4],iy=[-1,1])
      translate([ix*pitch.x+iy*stagger/2+pitch.x/4,iy*pitch.y/2,0]) children();
}

function squarePoly(size=[1,1],height)= (height==undef) ? 
[
    [-size.x/2,size.y/2],[size.x/2,size.y/2],
    [size.x/2,-size.y/2],[-size.x/2,-size.y/2]
    ] :
  [
    [-size.x/2,size.y/2,height],[size.x/2,size.y/2,height],
    [size.x/2,-size.y/2,height],[-size.x/2,-size.y/2,height]
    ];



