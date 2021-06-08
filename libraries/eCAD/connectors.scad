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

$fn=50;
fudge=0.1;


translate([-30,0,0]) XH(2);
translate([-15,0,0]) mUSB(false);
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

!M411P(false);
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


*uSDCard();
module uSDCard(showCard=true){
  //push-push by Wuerth 
  //https://www.we-online.de/katalog/datasheet/693071010811.pdf
    color("silver") difference(){
      cube([14,15.2,1.98],true);
      translate([-(14-11.2+fudge)/2,-(15.2-1.3+fudge)/2,0]) cube([11.2+fudge,1.3+fudge,1.98+fudge],true);
    }
    if(showCard){
      color("darkslateGrey") translate([-(14-11)/2+0.1,-0.6,0]) cube([11,15,0.7],true);
      color("darkslateGrey",0.5) translate([-(14-11)/2+0.1,-5,0]) cube([11,15,0.7],true);
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

module femHeaderSMD(pins=10,rows=1,height=3.7,pPeg=true,center=false){
  pitch=2.54;
  pinDims=[0.64,2.5/2+0.2*2,0.2];
  bdDims=[pins*2.54/rows,2.5*rows,height-pinDims.z];


  cntrOffset= (center) ? [0,0,height/2+pinDims.z] : [(pins/rows-1)*pitch/2,pitch/2*(rows-1),height/2+pinDims.z] ;

  translate(cntrOffset){

        difference(){
          color("darkslategrey") cube(bdDims,true);
          translate([0,0,-(bdDims.z-pinDims.z)/2])
            color("darkslategrey")
              cube([bdDims.x+fudge,2*rows,pinDims.z+fudge],true);

            if (rows==1) for (ix=[-(pins-1)/2:(pins-1)/2]){
              translate([ix*pitch,0,0]) color("darkslategrey")
                cube([0.7,0.7,bdDims.z+fudge],true);
              translate([ix*pitch,0,(bdDims.z-1)/2]) mirror([0,0,1])
                frustum(size=[2,2,1+fudge],flankAng=40, col="darkslategrey");
            }
            else for (ix=[-(pins/2-1)/2:(pins/2-1)/2],iy=[-1,1]){
              translate([ix*pitch,iy*pitch/2,0]) color("darkslategrey")
                cube([0.7,0.7,bdDims.z+fudge],true);
              translate([ix*pitch,iy*pitch/2,(bdDims.z-1)/2]) mirror([0,0,1])
                frustum(size=[2,2,1+fudge],flankAng=40, col="darkslategrey");
            }
          }

    //pins
    if (rows==1){
        for (ix=[-(pins-1)/2:2:(pins-1)/2])
          translate([ix*pitch,pinDims.y/2+1-pinDims.z*2,-(bdDims.z+pinDims.z)/2])
            color("gold") cube(pinDims,true);
        for (ix=[-(pins-3)/2:2:(pins-1)/2])
          translate([ix*pitch,-(pinDims.y/2+1-pinDims.z*2),-(bdDims.z+pinDims.z)/2]) color("gold")
            cube(pinDims,true);
      }
    else {
        for (ix=[-(pins/2-1)/2:(pins/2-1)/2],iy=[-1,1])
          translate([ix*pitch,iy*(pinDims.y/2+pitch/2+0.7),-(bdDims.z+pinDims.z)/2])
            color("gold") cube(pinDims,true);
        if (pPeg)
          for (ix=[-1,1])
            translate([-ix*((pins/2-2)*pitch)/2,0,-(bdDims.z/2+1.3)]){
              color("darkSlateGrey") cylinder(d1=1.2,d2=1.6,h=0.2);
              translate([0,0,0.2]) color("darkSlateGrey") cylinder(d=1.6,h=1.1+pinDims.z+fudge);
            }

    }

  }//cntrOffset
}

*BIL30(panel=3,cutOut=false);
module BIL30(col="red",panel=2,cutOut=false){
  //4mm Jack
  //Hirschmann BIL30 (SKS-kontakt.de)

  if (cutOut)
    translate([0,0,-panel-fudge/2]) linear_extrude(panel+fudge) intersection(){
      circle(d=8.2);
      square([8.2+fudge,7.2],true);
    }
  else translate([0,0,5])
    mirror([0,0,1]){
    color(col) difference(){
      union(){
        cylinder(d=10,h=5);
        linear_extrude(7.5) intersection(){
          circle(d=8);
          square([8+fudge,7],true);
        }
        translate([0,0,5+panel]) cylinder(d=10,h=4.2);
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

module screwTerminal(pins=2,center=false){
  *translate([-(RM)/2,4.2,0]) rotate([90,0,0]) import("screwTerm.stl");

  RM=5.08;
  ovDims=[RM*(pins-1)+RM+1,8,10];
  baseHght=6.3;
  cntrOffset= center ? [-(RM/2) * (pins-1),0,0]:[0,0,0];
  poly=[[-3.8,0],[-3.8,baseHght],[-3.1,baseHght],[-2.5,10],[2.5,10],[4.2,baseHght],[4.2,0]];
  //body
  translate(cntrOffset) {
    color("DarkSlateGrey")  difference(){
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


module DSubTHT(pins=9){
  
}


*DSub(pins=15,isFemale=true,mountBehind=false,cutOut=true);
module DSub(pins=9, isFemale=true, mountBehind=true, cutOut=false){
  // DIN 41652-1
  // http://www.interfacebus.com/Connector_D-Sub_Mechanical_Dimensions.html

  // Array of Dimensions to use depending on pin count
  //          0:pins, 1:A   2:B   3:C   4:D   5:E   6:F   7:G   8:H   9:J  10:K  11:L
  DSubDimsTbl= [[  9,31.19,17.04,25.12, 8.48,12.93,10.97, 6.05,19.53,10.97, 1.52, 1.02], //size 1
                [ 15,39.52,25.37,33.45, 8.48,12.93,10.97, 6.05,27.76,10.97, 1.52, 1.02], //size 2
                [ 25,53.42,39.09,47.17, 8.48,12.93,11.07, 6.05,41.53,10.97, 1.78, 1.25], //size 3
                [ 37,],//size 4
                [ 50,,,11.33,15.75,11.07,6.05,,13.82],//size 5
                [104,,,12.90,17.35]];//size 6
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
  E=DSubDims[5]; //Sheet Height
  C=DSubDims[3]; //drillDist
  
  B=DSubDims[2]; //plug width (inner for male, outer for female)
  Bm=16.79; //male inner
  Bf=16.46; //female outer
  
  D=DSubDims[4]; //plug height
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

  
  if (cutOut){
    if (mountBehind) { //CutOut for Back Mounted
    cutOutDims=[B+sheetThck*2+spcng,D+sheetThck*2+spcng];
      for (ix=[-1,1])
        translate([ix*C/2,0]) circle(d=3.1);
      rndTrapez(cutOutDims,rPlug);
      }
  

    else{ //CutOut for Front Mounted
      for (ix=[-1,1])
        translate([ix*C/2,0]) circle(d=3.1);
      rndTrapez([H,J],rTerm);
      }
  }//cutout

  else {
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
      difference(){
        rndTrapez([B+sheetThck*2,D+sheetThck*2,6],rMale+sheetThck);
        translate([0,0,fudge]) rndTrapez([B,D,6+fudge],rMale);
      } 
      //pins
      for (ix=[-(pins-1)/4:(pins-1)/4])
        color("gold") translate([ix*pitch.x,pitch.y/2,0]){
           cylinder(d=pinDia,h=5.1-pinDia/2);
           translate([0,0,5.1-pinDia/2]) sphere(d=pinDia);
      }
      for (ix=[-(floor(pins/2-1)/2):(floor(pins/2-1)/2)])
        color("gold") translate([ix*pitch.x,-pitch.y/2,0]){
           cylinder(d=pinDia,h=5.1-pinDia/2);
           translate([0,0,5.1-pinDia/2]) sphere(d=pinDia);
      }

    }

    //body
    color("silver") translate([0,0,-bodyDims.z-sheetThck]) rndTrapez(bodyDims,rFem);
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

*usbC();
module usbC(){
  //https://usb.org/document-library/usb-type-cr-cable-and-connector-specification-revision-21
  //rev 2.1 may 2021
  //receptacle dims
  shellOpng=[8.34,2.56];
  shellLngth=6.2; //reference Length of shell to datum A
  shellThck=0.2;

  //tongue
  tngDims=[6.69,4.45,0.6];

  //body
  bdyLngth=3;

  //contacts
  //          pinA1          ...                        pinA12
  cntcLngths=[4,3.5,3.5,4,3.5,3.5,3.5,3.5,4,3.5,3.5,4]; //8x short, 4x long per side
  cntcDims=[0.25,0.05];
  pitch=0.5;

  translate([0,0,shellOpng.y/2+shellThck]) rotate([90,0,0]){
    color("silver") translate([0,0,-bdyLngth]) shell(shellLngth+bdyLngth);
    tongue();
    color("darkSlateGrey") translate([0,0,-bdyLngth]) linear_extrude(bdyLngth) shellShape();
  }

  module tongue(){
    tngPoly=[[0,0.6],[1.37,0.6],[1.62,tngDims.z/2],[tngDims.y-0.1,tngDims.z/2],[tngDims.y,tngDims.z/2-0.1],
    [tngDims.y,-(tngDims.z/2-0.1)],[tngDims.y-0.1,-tngDims.z/2],[1.62,-tngDims.z/2],[1.37,-0.6],[0,-0.6]];

    color("darkSlateGrey") rotate([0,-90,0]) linear_extrude(tngDims.x,center=true) polygon(tngPoly);
    for (ix=[0:11],iy=[-1,1])
      color("gold") translate([ix*pitch-11/2*pitch,iy*(tngDims.z+cntcDims.y)/2,cntcLngths[ix]/2]) 
        cube([cntcDims.x,cntcDims.y,cntcLngths[ix]],true);
  }

  module shell(length=shellLngth){
    linear_extrude(length) difference(){
      offset(shellThck) shellShape();
      shellShape();
    }
  }
  module shellShape(size=[shellOpng.x,shellOpng.y]){
    hull() for (ix=[-1,1])
        translate([ix*(size.x/2),0]) circle(d=size.y);
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
   color("Ivory")
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

//!duraClik(2);
module duraClik(pos=2,givePoly=false){
  A= (pos>2) ? 6.6+2*pos : 10.9;
  B= (pos>2) ? 3.7+pos*2 : 8;
  C= (pos>6) ? pos*2-0.9 : (pos>2) ? pos*2 : 0;
  D= (pos>5) ? 11.8 : (pos>2) ? -0.2+2*pos : 6.3;

  ovDpth=7.8;


  baseThck=3;
  scktThck=5.05;
  ovHght=baseThck+scktThck;
  resess=[4.3,1.6+fudge,7.2+fudge]; //resess

  iLckDpth=3;

  plug=[1+2*pos,4.7,5+fudge];
  plgY=2.3;


  if (givePoly) square([A,ovDpth],true);
    
  color("Ivory")
  difference(){
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
    color("silver"){
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
    color("silver")
      for (ix=[-1,1]){
        translate([ix*(M+t)/2,-(padDim.x/2),r+t]) rotate([-90,0,ix*-90])
          bend(padDim,angle=-90,radius=r+t/2,center=true)
            flap(padDim);
        translate([ix*(M+t)/2,-(padDim.x/2),1.1/2+t/2+r])
          cube([t,padDim.x,1.1-r],true);
      }

    //SMD pins
      for (ix=[-H/2,-I/2,0,I/2,H/2]){
        color("gold")
        translate([ix,-0.7,r+conThck/2])
          rotate([-90,0,0])
            bend([conWdth,1-r,conThck],center=true,angle=90,radius=r)
              cube([conWdth,1-r,conThck],center=true);
        color("gold")
        translate([ix,-W/2-1-t,-X+t+N-(conThck)/2])
          cube([conWdth,W-fudge,conThck],true);
     }


    //plastics
    color("darkSlateGrey")
      translate([0,-t,N/2+t])
        rotate([90,0,0])
         hull()
            for (ix=[-1,1],iy=[-1,1])
              translate([ix*(M/2-r),iy*(N/2-r)]) cylinder(r=r-0.01, h=1);
    color("darkSlateGrey")
       translate([0,-W/2-1-t,-X/2+t+N-U]) plastic();


    //metal-body with cutouts
    color("silver"){
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

*frustum([3,2,0.9],method="poly");
module frustum(size=[1,1,1], flankAng=5, center=false, method="poly", col="darkSlateGrey"){
  //cube with a trapezoid crosssection
  //https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
  cntrOffset= (center) ? [0,0,-size.z/2] : [size.x/2,size.y/2,0];

  flankRed=tan(flankAng)*size.z; //reduction in width by angle
  faceScale=[(size.x-flankRed*2)/size.x,(size.y-flankRed*2)/size.y]; //scale factor for linExt

  if (method=="linExt")
    translate(cntrOffset)
      linear_extrude(size.z,scale=faceScale)
        square([size.x,size.y],true);
  else{ //for export to FreeCAD/StepUp
    polys= [[-size.x/2,-size.y/2,-size.z/2], //0
            [ size.x/2,-size.y/2,-size.z/2], //1
            [ size.x/2, size.y/2,-size.z/2], //2
            [-size.x/2, size.y/2,-size.z/2],//3
            [-(size.x/2-flankRed),-(size.y/2-flankRed),size.z/2], //4
            [  size.x/2-flankRed ,-(size.y/2-flankRed),size.z/2], //5
            [  size.x/2-flankRed , (size.y/2-flankRed),size.z/2], //5
            [-(size.x/2-flankRed), (size.y/2-flankRed),size.z/2]]; //5
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
