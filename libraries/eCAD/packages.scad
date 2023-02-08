include <KiCADColors.scad>


$fn=50;
fudge=0.1;

translate([-20,40,0]) boxCapacitor();
translate([-10,0,0]) TRACO();
SMDpassive("1210",label="000");
translate([4,0,0]) SOT23(22,label="SOT23");
translate([10,0,0]) QFN(label="QFN");
translate([16,0,0]) SOIC(8,"SOIC");
translate([22,0,0]) SSOP(14,label="SSOP");
translate([28,0,0]) LED5050(6);
translate([33,4,0]) LED3030();
translate([33,0,0]) sk6812mini();
translate([37,0,0]) miniTOPLED();
translate([40,0,0]) APA102();
translate([45,0,0]) SMF();
translate([50,0,0]) sumidaCR43();
translate([57,0,0]) TY_6028();
translate([50,20,0]) PDUU();


// -- Kicad diffuse colors --
metalGreyPinCol=[0.824,0.820,0.781];
metalCopperCol=[0.7038,0.27048,0.0828];
goldPinCol=[0.859,0.738,0.496];
blackBodyCol=[0.148,0.145,0.145];
greyBodyCol=[0.250,0.262,0.281];
greenBoardCol=[0.07,0.3,0.12];
blackBoardCol=[0.16,0.16,0.16];
FR4darkCol=[0.2,0.17,0.087];
FR4Col=[0.43,0.46,0.295];

// -- passives --
*resRadial(power=5);
module resRadial(type="SQM", power=5){
  pitch=5;
  dims= (power>2) ? (power>3) ? (power>5) ? (power>7) ? 
        [13,9,51] : [13,9,39] : [13,9,25] :  [12,8,25] : [11,7,20]; 
         //10W         7W           5W          3W           2W         
  gapOffset=(dims.x-pitch-0.8)/2;
  //body
  color("ivory") difference(){
    translate([0,0,dims.z/2]) cube(dims,true);
    rotate([90,0,0])
      translate([0,0,-(dims.y+fudge)/2]) linear_extrude(dims.y+fudge) 
        polygon([[-dims.x/2-fudge,-fudge],
                [-gapOffset,gapOffset],
                [gapOffset,gapOffset],
                [dims.x/2+fudge,-fudge]]);
  }
  //pins
  color("silver") for (ix=[-1,1])
    translate([ix*pitch/2,0,-3.5]) cylinder(d=0.8,h=3.5+gapOffset);
}

*boxCapacitor();
module boxCapacitor(center=false){
  //e.g. https://www.alfatec.de/fileadmin/Webdata/Datenblaetter/Faratronic/C3D_Specification_alfatec.pdf
  // C3D3A406KM0AC00, 4 pin DC, lead length 5.5mm, 
  pitch=52.5;
  W=57;
  H=50;
  T=35;
  P=52.5;
  b=20.3;
  d=1.2;
  l=5.5; //lead length
  cntrOffset = (center) ? [0,0,0] : [pitch/2,-b/2,0];

  translate(cntrOffset){
    color(greyBodyCol) translate([0,0,H/2]) cube([W,T,H],true);
    for (ix=[-1,1],iy=[-1,1])
      color(metalGreyPinCol) translate([ix*P/2,iy*b/2,-l]) cylinder(d=d,h=l);
  }

}

// -- IC packages --

*LGA8();
module LGA8(){
  //XTX LGA-8 package
  //https://www.lcsc.com/product-detail/FLASH_XTX-XTSD01GLGEAG_C558837.html
  ovDims=[8,6,0.9];
  padDims=[0.8,0.6,0.2];
  standOff=0.02;
  pitch=1.27;
  
  difference(){
    color("darkSlateGrey") translate([0,0,ovDims.z/2+standOff]) cube(ovDims,true);
    color("grey") translate([-ovDims.x/2+0.5,ovDims.y/2-0.5,ovDims.z-fudge]) cylinder(d=0.5,h=fudge*2);
  }
  for (ix=[-1,1], iy=[-1.5:1.5])
    color("silver") translate([ix*(ovDims.x-padDims.x)/2,iy*pitch,padDims.z/2]) cube(padDims,true);
  
}


*QFN(20,[3,3,0.65],0.4, 0, label="");
module QFN(pos=28,size=[5,5,1], pitch=0.5, pSize=undef, label="QFN"){
  // JEDEC MO-220
  // https://www.jedec.org/system/files/docs/MO-220K01.pdf
  /*
   -- Variation Designators --
  1st digit - max thickness (A)
  V: 1.0; W: 0.8
  
  2nd/3rd digit - body length/width (D/E)
  [A:G] - [1.0:0.5:4.0] e.g. F=3.5mm (1.0+5*0.5)
  [H:R] - [5.0:1:12.0]
  [S:U] - [4.5:1:6.5]
  
  4th digit - pitch (e)
  A: 1.0; B:0.8; C:0.65; D:0.5; E:0.4
  */
  
  //QFN24 (4x4), 28 or QFN32 (5x5)
  
  // --- LEAD WIDTH ---
  bnom= (pitch==1.0)  ? 0.4 :
        (pitch==0.8)  ? 0.3 :
        (pitch==0.65) ? 0.3 :
        (pitch==0.5)  ? 0.25 :
        (pitch==0.4)  ? 0.20 : 0.25; //default pitch=0.5
  bmin= (pitch==1.0)  ? 0.3 :
        (pitch==0.8)  ? 0.25 :
        (pitch==0.65) ? 0.25 :
        (pitch==0.5)  ? 0.18 :
        (pitch==0.4)  ? 0.15 : 0.18; //default pitch=0.5
          
  // --- COMMON DIMENSIONS ---
  A=size.z;   //max thickness V=1.0, W=0.8
  A1=0.02;    //nominal standoff        
  //A2= (size.z<1) ? 0.6 : 0.8 //nominal body Hght
  A3=0.2;   //lead Frame Thick incl. standoff
  //theta=10; //flank angle 0..14° 
  //K= 0.2    //minimum spacing lead corner
  //R= bmin/2 //radius of leads
  b=0.25;   //lead width
  
  //28/32/64
  //length/width from pins or size
  D= (len(size)>2) ? size.x ://auto size when nothing provided
     (pos<28) ? 4.0 : 
     (pos<48) ? 5.0 : 
     (pos<64) ? 7.0 : 9.0 ;    //body size X
  
  E= (len(size)>2) ? size.y :D;      //body size y
  
  //thermal pad size.x
  J=(pSize!=undef) ? pSize.x :
    (pos<28) ? 2.6 : //28
    (pos<48) ? 3.1 : //32
    (pos<64) ? 5.15 : 7.15;  //48/64 //pad size x 
  
  K=J;      //pad size Y
  e=pitch;    //pitch
  L= ((pos==32) || (pos==48)) ? 0.4 : 0.55;   //lead Length /0.4
  //pos=28;
  fudge=0.01; //very small fudge
  
  txtSize=D/(0.8*len(label));
  
  if (label)
    color(lightBrownLabelCol) translate([0,0,A]) linear_extrude(0.1) 
      text(text=label,size=txtSize,halign="center",valign="center", font="consolas");
  
  
  color(blackBodyCol)
    translate([0,0,A/2]) cube([D,E,A-A1],true);
  
  color(metalGreyPinCol) //pads
    for (i=[-(pos/4-1)/2:(pos/4-1)/2],rot=[0,90,180,270]){
      //rotate(rot) translate([i*e-b/2-pos/16,-D/2-fudge,0]){
      rotate(rot) translate([i*e-b/2,-D/2-fudge,0]){
        cube([b,L-b/2,A3]);
        translate([b/2,L-b/2-fudge,0]) cylinder(d=b,h=A3);
      }
    }
  if (pSize)
    color(metalGreyPinCol) //Exposed Pad
        linear_extrude(A3) polygon([[-J/2+b,K/2],[J/2,K/2],[J/2,-K/2],[-J/2,-K/2],[-J/2,K/2-b]]);
}

!DHVQFN();
module DHVQFN(pos=20){
  // Nexperia DHVQFN14,16,20,24
  // https://www.nexperia.com/support/packages/
  // https://www.nexperia.com/packages/SOT762-1.html
  
  // --- LEAD WIDTH ---
  bnom= 0.25;
  bmin= 0.18;
  size = (pos==14) ? [2.5,3.0,1] :
         (pos==16) ? [2.5,3.5,1] :
         (pos==20) ? [2.5,4.5,1] :
         (pos==24) ? [3.5,5.5,1] :
          [0,0,0];
  pSize = (pos==14) ? [1  ,1.5] :
            (pos==16) ? [1  ,2.0] :
            (pos==20) ? [1  ,3.0] :
            (pos==24) ? [2.1,4.1] :
              [0,0];
  pitch=0.5;
  
  // --- COMMON DIMENSIONS ---
  A=size.z;   //max thickness V=1.0, W=0.8
  A1=0.02;    //nominal standoff        
  //A2= (size.z<1) ? 0.6 : 0.8 //nominal body Hght
  A3=0.2;   //lead Frame Thick incl. standoff
  //theta=10; //flank angle 0..14° 
  //K= 0.2    //minimum spacing lead corner
  //R= bmin/2 //radius of leads
  b=0.25;   //lead width
  
  //28/32/64
  //length/width from pins or size
  D= size.x;  //auto size when nothing provided
  E= size.y;  //body size y
  
  //thermal pad size.x
  J= pSize.x;
  
  K= pSize.y;      //pad size Y
  e= pitch;    //pitch
  L= 0.4;   //lead Length /0.4
  
  fudge=0.01; //very small fudge
  
  //body
  color(blackBodyCol)
    translate([0,0,A/2]) cube([D,E,A-A1],true);
  //pins
  color(metalGreyPinCol) 
    for (i=[-(pos/2-3)/2:(pos/2-3)/2],rot=[90,270]){
      //rotate(rot) translate([i*e-b/2-pos/16,-D/2-fudge,0]){
      rotate(rot) translate([i*e-b/2,-D/2-fudge,0]){
        cube([b,L-b/2,A3]);
        translate([b/2,L-b/2-fudge,0]) cylinder(d=b,h=A3);
      }
    }
  color(metalGreyPinCol) 
    for (i=[-1/2,1/2],rot=[0,180]){
      e = (pos==24) ? 1.5 : pitch; 
      //rotate(rot) translate([i*e-b/2-pos/16,-D/2-fudge,0]){
      rotate(rot) translate([i*e-b/2,-E/2-fudge,0]){
        cube([b,L-b/2,A3]);
        translate([b/2,L-b/2-fudge,0]) cylinder(d=b,h=A3);
      }
    }
  //ePad
  if (pSize)
    color(metalGreyPinCol) //Exposed Pad
      linear_extrude(A3) square(pSize,true);
}


module SOIC(pins=8, label=""){
  //https://www.jedec.org/system/files/docs/MS-012G.pdf (max. values)
  
  b= (pins>8) ? 0.46 : 0.51; //lead width //JEDEC b: 0.31-0.51
  pitch=1.27;
  A= (pins>8) ? 1.72 : 1.75; // total height
  A1=0.25; //space below package
  c= (pins>8) ? 0.25 : 0.19; //lead thickness //JEDEC: 0.1-0.25
  D= (pins>8) ? (pins > 14) ? 9.9 : 8.65 : 4.9; //total length
 
  E1=3.9; //body width
  E=6.0; //total width
  h=0.5; //chamfer width h=0.25-0.5
  
  txtSize=D/(0.8*len(label));
  if (label)
    color("white") translate([0,0,A]) linear_extrude(0.1) 
      text(text=label,size=txtSize,halign="center",valign="center", font="consolas");
    
  //body
  color("darkSlateGrey")
    difference(){
      translate([-D/2,-E1/2,A1]) cube([D,E1,(A-A1)]);
      translate([0,E1/2+fudge,A+fudge]) 
        rotate([0,90,180]) 
          linear_extrude(D+fudge,center=true) 
            polygon([[0,0],[h+fudge,0],[0,h+fudge]]);
    }    
  //leads
  color("silver")
    for (i=[-pins/2+1:2:pins/2],r=[-90,90])
      rotate([0,0,r]) translate([E1/2,i*pitch/2,0]) lead([(E-E1)/2,b,A*0.5]);
  
}

*SSOP();
module SSOP(pins=8, pitch=0.635,  label="test"){
  //Plastic shrink small outline package (14,16,18,20,24,26,28 pins)
  //https://www.jedec.org/system/files/docs/MO-137E.pdf (max. values where possible)
  
  b= 0.254; //lead width //JEDEC b: 0.2-0.3
  //pitch=0.635; make overide
  A= (pins>8) ? 1.72 : 1.75; // total height //JEDEC A: 
  A1=0.25; //space below package //JEDEC A1: 0.1-0.25
  c= (pins>8) ? 0.25 : 0.19; //lead tAickness //JEDEC: 0.1-0.25
  D= (pins==28) ? 9.9 :   //28pin
     (pins > 18) ? 8.66 : //20..24pin
     (pins==18) ? 6.8 :   //e.g. Toshiba SSOP18
     4.9; // 14..16pin
  E1=3.9; //body width
  E=6.0; //total width
  h=0.5; //chamfer width h=0.25-0.5
  
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

module SOT23(pins=3, label=""){
  //http://www.ti.com/lit/ml/mpds026l/mpds026l.pdf
  //3..6 pins
  pins = (pins<3) ? 3 : (pins>6) ? 6 : pins; //limit to 6 pins max
   b= 0.5; //lead width 
  pitch= 0.95;
  A= 1.45; // total height 
  A1=0.15; //space below package 
  c= 0.22; //lead tAickness /
  D= 3.05; //total package length
  E1=1.75; //body width
  E=3.0; //total width
  h=0; //chamfer width h=0.25-0.5
  
  txtSize=D/(0.8*len(label));
  if (label)
    color("white") translate([0,0,A]) linear_extrude(0.1) 
      text(text=label,size=txtSize,halign="center",valign="center", font="consolas");
  
  
  //body
  color("darkSlateGrey")
    difference(){
      translate([-D/2,-E1/2,A1]) cube([D,E1,(A-A1)]);
      if (h)
       translate([0,E1/2+fudge,A+fudge]) 
        rotate([0,90,180]) 
          linear_extrude(D+fudge,center=true) 
            polygon([[0,0],[h+fudge,0],[0,h+fudge]]);
    }    
  //leads
  color("silver"){
    rotate([0,0,-90]) translate([E1/2,-pitch,0]) lead([(E-E1)/2,b,A*0.5]); //pin1
    if (pins>4) rotate([0,0,-90]) translate([E1/2,0,0]) lead([(E-E1)/2,b,A*0.5]); //pin2
    rotate([0,0,-90]) translate([E1/2,pitch,0]) lead([(E-E1)/2,b,A*0.5]); //pin3
    if (pins>3) rotate([0,0,90]) translate([E1/2,-pitch,0]) lead([(E-E1)/2,b,A*0.5]); //pin4
    if ((pins==3) || (pins==6)) rotate([0,0,90]) translate([E1/2,0,0]) lead([(E-E1)/2,b,A*0.5]); //pin5
    if (pins>3) rotate([0,0,90]) translate([E1/2,pitch,0]) lead([(E-E1)/2,b,A*0.5]); //pin6
  }
    
}


// --- Inductors ---
*PDUU(false);
module PDUU(center=true){
  //https://datasheet.lcsc.com/lcsc/2201121530_PROD-Tech-PDUUAT16-503MLN_C2932169.pdf
  //Series UU16
  

  D=0.7;
  D1=10.5; //pin distance y
  D2=13.5; //pin distance x
  L=4;
  A=22; //total width (incl. metal clamp)
  B=20; //total body deep
  C=28.5; //total Height
  sprtWdth=1.5; //thickness of separators
  coilFillFact=0.8; //

  //pin1 or center
  cntrOffset = (center) ? [0,0,0] : [D2/2,-D1/2,0];

  //core/coil
  coreThck=((A-1)-D2)/2; //thickness from overall width and pin distance
  coreDims=[A-1,coreThck,(C+coreThck)/2]; //iron core 
  coreInnerDims=[coreDims.x-coreThck*2,coreDims.y,coreDims.z-coreThck*2]; //innerDims from coreDims and thick
  coreChmf=0.3; //chamfering of the core
  corezOffset=(C-coreThck)/2;
  sprtrDims=[sprtWdth,B,coreInnerDims.z*2+coreThck*2]; //separator Dimensions
  sprtrRad=3; //radius of separator plates
  coilDims=[(coreInnerDims.x-3*sprtrDims.x)/2,9];
  
  translate(cntrOffset){
    // pins
    for (ix=[-1,1],iy=[-1,1])
      color(metalGreyPinCol) translate([ix*D2/2,iy*D1/2,-L]) cylinder(d=D,h=L);

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
      color("darkSlateGrey") if (rad)  minkowski($fn=20){
         cube(topDim+[-rad*2,-rad*2,-rad*2],true);
         sphere(rad);
      }
      else
        color("darkSlateGrey") cube(topDim,true);
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
    color("silver") rndRectInt([0.9,0.35,thck],rad);
    translate([0.9-0.35,-0.6,0]) 
      color("silver") cube([0.35,0.6+rad,thck]);
    translate([0.9-0.35,-0.6,0]) 
      mirror([0,1,0]) 
        color("silver") bend(size=[0.35,0.46,thck],angle=-90,radius=0.15,center=false, flatten=false)
          cube([0.35,0.46,thck]);
    translate([0.9-0.35,-0.6-0.1/2,-0.46-0.1/2]) rotate([0,-90,90]) 
      color("silver") bend([0.46,0.3,thck],-90,0.2) cube([0.46,0.3,thck]);
  }  
    
  module coil(){
    translate([0,0,0.7*1.5]) rotate([90,0,90]) color("salmon")rndRectInt([2.3,1.6-0.5,1.7],0.3,true);
  }
    
  module body(){
    bdDim=[0.7,2.5,1.4];
    for (m=[0,1])
    color("darkSlateGrey") mirror([m,0,0]) translate([(ovDim.x-bdDim.x)/2,0,bdDim.z/2+spcng]) 
      difference(){
        cube(bdDim,true);
        for (iy=[-1,1]){
          color("darkSlateGrey") 
            translate([0,iy*(bdDim.y-0.5+fudge)/2,-(bdDim.z-0.4+fudge)/2]) 
              cube([bdDim.x+fudge,0.5+fudge,0.4+fudge],true);
          color("darkSlateGrey")
            translate([(bdDim.x+fudge)/2,iy*(bdDim.y-1.1+fudge)/2,-(bdDim.z-1+fudge)/2])
              cube([0.2+fudge,1.1+fudge,1+fudge],true);
        }
      }
    //bar
      color("darkSlateGrey") translate([0,0,0.7*1.5]) cube([ovDim.x-2*bdDim.x,bdDim.y-0.5,0.7],true);
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
      color("silver") translate([0,sgmnts[0].y/2,0.34-thck/2]) cube(sgmnts[0],true);
      color("silver") translate([(sgmnts[1].x-sgmnts[0].x)/2,1.2+sgmnts[1].y/2,thck/2]) cube(sgmnts[1],true);
      color("silver") translate([-sgmnts[0].x/2+sgmnts[1].x,1.2+sgmnts[1].y/2,thck/2]) 
        rotate([90,0,0]) cylinder(d=thck,h=sgmnts[1].y,center=true);
      color("silver") translate([-sgmnts[0].x/2+sgmnts[1].x,1.2+sgmnts[1].y/2,sgmnts[2].z/2+thck/2]) cube(sgmnts[2],true);
      color("silver") translate([0,1.2,thck/2]) 
        rotate([0,90,0]) cylinder(d=thck,h=sgmnts[0].x,center=true);
      
    }
  }
  
  module coil(){
    difference(){
      intersection(){
        union(){
          color("darkslategrey") translate([0,0,0.5]) cylinder(d=ovDia,h=0.6);
          color("salmon") translate([0,0,0.5+0.6]) cylinder(d=coilDia,h=1.5);
          color("darkslategrey") translate([0,0,0.5+0.6+1.5]) cylinder(d=ovDia,h=0.6);
        }
         color("darkSlateGrey") translate([0,0,(ovHght+fudge)/2]) cube([ovDia+fudge,3.8,ovHght+fudge],true);
      }
      for (ix=[-1,1]){
      color("darkslategrey") translate([ix*3.8/2,0,-fudge/2]) cylinder(d=0.6,h=ovHght+fudge);
      color("darkslategrey") translate([ix*(3.8+0.6)/2,0,(ovHght)/2]) cube([0.6,0.6,ovHght+fudge],true);
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
          color("darkslategrey") translate([0,0,ovDims.z/2]) rndRectInt(ovDims+[-0.4,0,0],crnrRad,true);
          for (ix=[-1,1])
            color("darkslategrey") translate([ix*(ovDims.x-1)/2,0,ovDims.z/2]) cube([1+fudge,2,ovDims.z+fudge],true);
        }
      
        for (iy=[0,1]) mirror([0,iy,0])
          translate([0,-1,0]) difference(){
            color("darkslategrey") translate([0,0,ovDims.z/2]) 
              rndRectInt([ovDims.x,0.7*2,ovDims.z],crnrRad,true);
            color("darkslategrey") translate([0,-0.7/2-fudge/2,ovDims.z/2]) 
              cube([ovDims.x+fudge,0.7+fudge,ovDims.z+fudge],true);
          }       
      }
    
    for (i=[-1,1])
      color("darkslategrey") translate([i*(ovDims.x+fudge)/2,0,-0.01]) 
        rotate([90,0,-i*90]) linear_extrude(1.5) 
          polygon([[-0.7,0],[-0.45,0.3],[0.45,0.3],[0.7,0]]);
    }
  }
  }
}





// -- LEDs --
*LED3030();
module LED3030(){
  //e.g. Osram Duris S5
  ovDims=[3,3,0.6];
  difference(){
    color("ivory") translate([0,0,ovDims.z/2]) cube(ovDims,true);
    color("orange") difference(){
      translate([0,0,ovDims.z]) rndRectInt([2.55,2.55,0.1],0.5,true);
      translate([-2.55/2,2.55/2,ovDims.z]) cylinder(d=1,$fn=4,center=true);
    }
    translate([0,0,-0.05]) pads(0.2);
  }
  
  pads();
  module pads(thick=0.1){
    color("silver") translate([(1.55-2.68)/2,0,thick/2]) 
      rndRectInt([1.55,2.4,thick],0.1,true);
    color("silver") translate([-(0.58-2.68)/2,0,thick/2]) 
      rndRectInt([0.58,2,thick],0.1,true);
  }
}


*LED_3mm();
module LED_3mm(){
  bdDia= 2.9;
  bdHght= 4.6;
  rngDia= 3.2;
  ovHght= 5.1;
  pitch= 2.54;
  legLngth=[27,27-1.5];
  
  //body
  color("white",0.7){
    translate([0,0,ovHght-bdDia/2]) sphere(d=bdDia);
    translate([0,0,ovHght-bdHght]){
      cylinder(d=bdDia,h=bdHght-bdDia/2);
      cylinder(d=rngDia,h=1);
    }
  }
  
  //legs
  for (leg=[[-1,0],[1,1]]){
    color("silver") translate([leg.x*pitch/2,0,-legLngth[leg[1]]/2+ovHght-bdHght]) 
      cube([0.5,0.5,legLngth[leg[1]]],true); 
    echo(leg);
  }
}

*LED_5mm();
module LED_5mm(lightConeAng=15,lightConeHght=50){
  bdDia= 5;
  bdHght= 7.6;
  rngDia= 5.8;
  ovHght= 8.6;
  pitch= 2.54;
  legLngth=[25.4+1,25.4];
  
  //body
  color("white",0.7){
    translate([0,0,ovHght-bdDia/2]) sphere(d=bdDia);
    translate([0,0,ovHght-bdHght-1]){
      cylinder(d=bdDia,h=bdHght-bdDia/2+1);
      cylinder(d=rngDia,h=1);
    }
  }
  
  //legs
  for (leg=[[-1,0],[1,1]]){
    color("silver") translate([leg.x*pitch/2,0,-legLngth[leg[1]]/2+ovHght-bdHght]) 
      cube([0.5,0.5,legLngth[leg[1]]],true); 
    echo(leg);
  }
  //lightcone
  if (lightConeAng){
    hc=lightConeHght;
    alpha=(180-lightConeAng)/2;
    a=hc/sin(alpha);
    c=2*a*sin(lightConeAng/2);
    %translate([0,0,ovHght-bdDia/2]) cylinder(d1=0.1,d2=c,h=lightConeHght);
  }
}

module LED5050(pins=6){
  // e.g. WS2812(B)
  dims=[5,5,1.5];
  pitch= (pins==6) ? 0.9 : 1.8;
  grvHght=1;
  marking=[0.7,0.2]; //width,height
  
  //body
  color("ivory")
    difference(){
      translate([0,0,(dims.z+0.1)/2]) cube(dims-[0,0,0.1],true);
      translate([0,0,dims.z-grvHght]) cylinder(d1=3.2,d2=4,h=grvHght+0.01);
      //marking
      translate([dims.x/2,dims.y/2,dims.z-marking[1]]) linear_extrude(marking[1]+fudge)      
        polygon([[-marking.x-fudge,fudge],[fudge,fudge],[fudge,-marking.x-fudge]]);
    }
  color("grey",0.6)
    translate([0,0,dims.z-grvHght]) cylinder(d1=3.2,d2=4,h=grvHght);
  //leads
  color("silver")
    for (i=[-pins/2+1:2:pins/2],r=[-90,90])
      rotate([0,0,r]) translate([dims.x/2,i*pitch,0]){
        translate([-1.1/2+0.2,0,0.1]) cube([1.1,1.0,0.2],true);
        translate([0.1,0,0.45]) cube([0.2,1.0,0.9],true);
      }
}
PLCC6();
module PLCC6(){
  // e.g. CREE CLP6C-FKB https://media.digikey.com/pdf/Data%20Sheets/CREE%20Power/CLP6C-FKB.pdf
  
  dims=[5,6,2.5];
  pitch= 2.1;
  grvHght=1; 
  grvDia=4;
  marking=[0.7,0.2]; //width,height
  pins=6;
  
  //body
  color("ivory")
    difference(){
      translate([0,0,(dims.z+0.1)/2]) cube(dims-[0,0,0.1],true);
      translate([0,0,dims.z-grvHght]) cylinder(d1=3.2,d2=4,h=grvHght+0.01);
      //marking
      translate([-dims.x/2,dims.y/2,dims.z-marking[1]]) linear_extrude(marking[1]+fudge)      
        polygon([[marking.x+fudge,fudge],[-fudge,fudge],[-fudge,-marking.x-fudge]]);
    }
  color("grey",0.6)
    translate([0,0,dims.z-grvHght]) cylinder(d1=3.2,d2=grvDia,h=grvHght);
  //leads
  color("silver")
    for (i=[-pins/2+1:2:pins/2],r=[90,-90])
      rotate([0,0,r]) translate([i*pitch/2,dims.x/2,0]) rotate(90){
        translate([-1.1/2+0.2,0,0.1]) cube([1.1,1.0,0.2],true);
        translate([0.1,0,0.45]) cube([0.2,1.0,0.9],true);
      }
}

*PLCC2();
module PLCC2(){
  // e.g. WS2812(B)
  dims=[3,3.4,1.8];
  pinDims= [2.3,1.1,1];
  pinThck= 0.1;
  grvHght=0.8; //height of groove
  grvDia=2.4;
  grvDiaBtm=grvDia-2*tan(30)*grvHght;
  
  marking=[0.7,0.2]; //width,height
  
  //body
  color("ivory")
    difference(){
      union(){
        translate([0,0,dims.z-grvHght/2]) 
          frustum([dims.x,dims.y,grvHght],4,true);
        mirror([0,0,1]) translate([0,0,-0.1-(grvHght+0.1)/2]) 
          frustum([dims.x,dims.y,dims.z-grvHght-0.1],4,true);
      }
        //cube(dims-[0,0,0.1],true);
      //groove
      translate([0,0,dims.z-grvHght]) 
        cylinder(d2=grvDia,d1=grvDiaBtm,h=grvHght+0.01);
      //marking
       translate([dims.x/2,dims.y/2,dims.z-marking[1]]) linear_extrude(marking[1]+fudge)      
        polygon([[-marking.x-fudge,fudge],[fudge,fudge],[fudge,-marking.x-fudge]]);
    }
    
  //glass
  color("grey",0.6) 
    translate([0,0,dims.z-grvHght]) cylinder(d1=grvDiaBtm,d2=grvDia,h=grvHght);
    
  //leads
  *color("silver")
    for (i=[-pins/2+1:2:pins/2],r=[-90,90])
      rotate([0,0,r]) translate([dims.x/2,i*pitch,0]){
        translate([-1.1/2+0.2,0,0.1]) cube([1.1,1.0,0.2],true);
        translate([0.1,0,0.45]) cube([0.2,1.0,0.9],true);
      }
   color("silver"){
     translate([0,dims.y/2,0]) uContact();   
     mirror([0,1,0]) translate([0,dims.y/2,0]) uContact();  
   } 
   module uContact(){
     translate([0,-pinDims.y/2,pinThck/2]) cube([pinDims.x,pinDims.y,pinThck],true);
     translate([0,0,pinThck/2]) 
      bend([pinDims.x,pinDims.z-pinThck*2,pinThck],90,pinThck/2,center=true) 
        cube([pinDims.x,pinDims.z-pinThck*2,pinThck],true);
     translate([0,pinThck/2,pinDims.z-pinThck]) rotate([90,0,0]) 
      bend([pinDims.x,pinThck,pinThck],90,pinThck/2,true);
   }
}


module sk6812mini(pins=4){
  // e.g. SK6812Mini aka NeoPixel mini
  dims=[3.5,3.5,0.95];
  pitch= (pins==6) ? 0.9 : 1.75;
  
  marking=[0.7,0.2]; //width,height
  lensDim=[2.6,2.9,0.7]; //lens d1,d2,thick
  
  padDim=0.85;
  
  //body
  color("ivory")
    difference(){
      union(){
        translate([0,0,(dims.z/3+0.01)/2]) cube(dims-[0,0,dims.z*(2/3)],true);
        translate([0,0,(dims.z*(2/3))/2+dims.z/3]) frustum([dims.x,dims.y,dims.z*(2/3)],flankAng=12,center=true);
      }
      translate([0,0,dims.z-lensDim.z]) cylinder(d1=lensDim[0],d2=lensDim[1],h=lensDim.z+0.01);
      //marking
      translate([dims.x/2,dims.y/2,dims.z-marking[1]]) linear_extrude(marking[1]+fudge)      
        polygon([[-marking.x-fudge,fudge],[fudge,fudge],[fudge,-marking.x-fudge]]);
    }
  color("grey",0.6)
    translate([0,0,dims.z-lensDim.z+0.01]) cylinder(d1=lensDim[0],d2=lensDim[1],h=lensDim.z);
  //leads
  color("silver")
    for (i=[-pins/2+1:2:pins/2],r=[-90,90])
      rotate([0,0,r]) translate([dims.x/2,i*pitch/2,0]){
        translate([-0.85/2+0.01,0,0.1]) cube([0.85,0.85,0.2],true);
       
      }
}


*SMF();
module SMF(){
  //aka DO-219AB
  //http://www.vishay.com/docs/95572/smf_do-219ab.pdf
  padDim=[0.85,1.2,0.25];
  bodyDim=[2.9,1.9,1.08-padDim.z]; //bodyDim at widest
  
  bodyAng=5;
  bodyRed=tan(bodyAng)/bodyDim.z; //reduction in width by angle
  padRed=tan(bodyAng)/padDim.z;
  
  bodyScale=[(bodyDim.x-bodyRed*2)/bodyDim.x,(bodyDim.y-bodyRed*2)/bodyDim.y];
  padScale=[(padDim.x-padRed*2)/padDim.x,(padDim.y-padRed*2)/padDim.y];
  
  mfudge=0.01;
  //pads
  for (i=[-1,1])
    color("silver") translate([i*(3.9-padDim.x)/2,0,padDim.z/2]) cube(padDim,true);
  
 //body top
  difference(){
    color("darkSlateGrey") translate([0,0,padDim.z+bodyDim.z/2+mfudge]) 
      frustum(bodyDim,flankAng=bodyAng,center=true,method="Poly");
    color("grey") translate([-bodyDim.x/3,0,bodyDim.z+padDim.z]) cube([0.3,bodyDim.y-bodyRed*2-0.2,0.05],true);
  }
  //body bottom
  color("darkSlateGrey") translate([0,0,padDim.z/2+mfudge]) 
  mirror([0,0,1])
    frustum([bodyDim.x,bodyDim.y,padDim.z],flankAng=bodyAng,center=true,method="Poly");
      //linear_extrude(padDim.z,scale=bodyScale) square([bodyDim.x,bodyDim.y],true);
  
}


*APA102();
module APA102(){
  //APA102-2020
  //http://www.normandled.com/upload/201807/APA102-2020%20LED%20Datasheet.pdf
  
  //alias Dotstar
  ovDims=[2,2,0.9];
  padDims=[0.6,0.4,0.1];
  mfudge=0.02;
  
  //PCB
  color("darkgreen") translate([0,0,ovDims.z/6+mfudge/2]) cube([ovDims.x,ovDims.y,ovDims.z/3-mfudge],true);
  //Resin
  %color("gold",0.5) translate([0,0,ovDims.z*0.66/2+ovDims.z/3]) cube([ovDims.x,ovDims.y,ovDims.z*0.66],true);
  //pads
  for (i=[1,-1],j=[-1,0,1])
    color("silver") translate([i*(1-padDims.x/2),j*(1-padDims.y/2),padDims.z/2]) cube(padDims+[mfudge,mfudge,0],true);
  for (j=[1,-1])
    color("silver") translate([0,j*(1-0.5/2),padDims.z/2]) cube([0.3+mfudge,0.5+mfudge,padDims.z],true);
  //IC
  color("darkslategrey") translate([0,0.5,0.3]) cube([1,0.8,0.1],true);
}

*miniTOPLED();
module miniTOPLED(){
  
  color("ivory") difference(){
    translate([0,0,1.3/2+0.1]) cube([1.5,2.1,1.3],true);
    translate([0,0,1.4-0.8]) linear_extrude(0.8+0.01,scale=[1.2,1.2]) square([0.8,1.2],true);
    translate([-1.5/2,-2.1/2,1.4-0.8+0.01]) cylinder(r1=0.01,r2=0.35,h=0.8,$fn=4);
    translate([-1.5/2,-2.1/2,-0.01]) cylinder(r2=0.01,r1=0.3,h=0.6,$fn=4);
  }
    color("darkSlateGrey") translate([0,-0.3,0.6]) cube(0.3,true);
    color("silver") for (i=[-1,1]) translate([0,i*(2.3-0.5)/2,0.3]) cube([1,0.5,0.6],true);
}
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

*potentiometer();
module potentiometer(){
  // taiwan alpha RV24AF
  // http://www.taiwanalpha.com/downloads?target=products&id=104
  dia=24;
  //can
  translate([0,-0.5,18]) rotate([-90,0,0])
    rotate_extrude()
      union(){
        square([dia/2,5.5]);
        translate([dia/2-2,5.5]) circle(d=4);
        square([dia/2-2,7.5]);
      }
  //PCB
  translate([0,-0.5/2,0]){
    color("brown") translate([0,0,18]) rotate([90,0,0]) cylinder(r=12.4,h=1.5);
    intersection(){
      translate([0,0,14.5]) rotate([90,0,0]) color("brown") cylinder(r=13.5,h=1.5);
      translate([0,-(1.5+fudge)/2,9]) color("brown") cube([19.1,1.5+fudge,18],true);
    }
  }
  //pivot
  translate([0,-1.5,18]){
    rotate([90,0,0]) cylinder(d=10,h=2.7);
    translate([0,-2.7,0]) rotate([90,0,0]) cylinder(d=8,h=6.5);
    translate([0,-2.7-6.5,0]) rotate([90,0,0]) cylinder(d=6,h=15-6.5);
  }
  
  for (im=[0,1])
    mirror([im,0,0]) translate([-7.7,0,0]) pin();
    translate([0,-2.5,0]) pin(straight);
  
  //pins
  module pin(type="poly"){
    hght=4;
    rad=0.7;
    thck=0.5;
    
    
    translate([0,0,-4+1.4/2]) rotate([90,0,0]) cylinder(r=rad,h=thck,center=true);
    if (type=="poly"){
      translate([0,0,-(hght-rad)/2]) cube([rad*2,thck,hght-rad],true);
      hull(){
        translate([0,thck/2,0]) rotate([90,0,0]) linear_extrude(thck) 
          polygon([[-1.9,0],[rad,0],[-1.9,2]]);
        translate([0.45,0,3.17]) rotate([90,0,0]) cylinder(d=3.1,h=thck,center=true);
      }
    }
    else{
      translate([0,0,-(hght-rad-3.17)/2]) cube([rad*2,thck,hght+3.17-rad],true);
      translate([0,0,3.17]) rotate([90,0,0]) cylinder(r=rad,h=thck,center=true);
    }
  }
}

module TRACO(givePoly=false){
  if (givePoly) translate([-11.7/2,-2]) square([11.7,7.6]);
  else{
    color("darkslategrey") 
    difference(){
      translate([-11.7/2,-2,0]) cube([11.7,7.6,10.2]);
      translate([-10.7/2,-2-fudge/2,-fudge]) cube([10.7,7.6+fudge,0.5+fudge]);
    }
    color("silver") for (i=[-2.54,0,2.54]) translate([i,0,-4.6/2+0.5]) cube([0.5,0.3,4.6],true);
    color("white") translate([0,-1.9,3])  rotate([90,0,0]) linear_extrude(0.2) text("TSR 1-2450",size=1.5,halign="center");
  }
}

*WE_sideLED();
module WE_sideLED(){
  rad=0.2;
  translate([0,0,0.5])
    difference(){
      color("ivory") cube([3.2,0.5,1],true);
      for (ix=[-1,1], iz=[-1,1])
        color("gold") translate([ix*(1.6),0,iz*(0.5)]) rotate([90,0,0]) cylinder(r=rad,h=0.6,center=true);
  }
  difference(){
    color("lightgrey") translate([0,0.4-0.25,0]) rotate_extrude(angle=180) square([1.1,1]);
    color("ivory") translate([0,0,0.5]) cube([3.2,0.5,1],true);
  }
  translate([1.6,-0.25,1]) rotate([90,180,0]){
    color("green") linear_extrude(0.02) import("155124_paint.dxf");
    color("gold") linear_extrude(0.02) import("155124_plating.dxf");
  }
}


// ---- helper modules ---
*bendLeg();
module bendLeg(){
  //from JEDEC MO-137E (SSOP)
  //inch converted to mm
  L= 0.016*25.4; //0.016-0.05 foot length
  L1=0.041*25.4; //overall Length (REF)
  L2=0.010*25.4; //tip distance to gauge plane (BSC)
  R= 0.003*25.4; //bend radius (min)
  R1=0.003*25.4; ////bend radius (min)
  b= 0.012*25.4; //leg width (max)
  c= 0.010*25.4; //leg thick (max)
  Lx=L1-L-R-c; //base length
  A= 0.069*25.4; //component height (max)
  A1=0.0098*25.4; //spacing (max)
  A2=0.049*25.4; //body height (min)
  E= 0.236*25.4; // (BSC)
  E1=0.154*25.4; // (BSC)
  echo((E-E1)/2); //max length (1.041)
  theta=8; //0-8° foot angle
  theta1=15; //5-15° body flank angle
  theta2=0; //0-x° vertical leg angle
  
  translate([0,0,A1+(A2-c)/2]){ //lift to component mid
    cube([Lx,b,c]);
    translate([Lx,b,-R1]) 
      rotate([90,0,0])
        rotate_extrude(angle=90) 
          translate([R1,0]) 
            square([c,b]);
  }
  translate([R*2+c+Lx,b,R+L2+c/2])
      rotate([90,90+theta,0])
        rotate_extrude(angle=-90+theta) 
          translate([R,0]) 
            square([c,b]);
  translate([R*2+c+Lx,0,R+L2+c/2])
    rotate([0,theta,0])
      translate([0,0,-c-R])
      cube([L,b,c]);
  
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



module r_SMD(size="0603"){
  //overall dimensions and contact width
  dims= (size=="0805") ? [2.0,1.25,0.50,0.35] : 
        (size=="0603") ? [1.6,0.80,0.45,0.25] : 
        (size=="0402") ? [1  ,0.50,0.35,0.20] :
        (size=="0201") ? [0.6,0.30,0.30,0.10] : [0.4,0.2,0.13,0.10];
  color("darkSlateGrey") translate([0,0,dims.z/2]) cube([dims.x-dims[3]*2,dims.y,dims.z],true);
  color("lightGrey") for (ix=[-1,1]) 
    translate([ix*(dims.x-dims[3])/2,0,dims.z/2]) 
      cube([dims[3],dims.y,dims.z],true);
}

*frustum([3,2,0.9],method="poly");
module frustum(size=[1,1,1], flankAng=5, center=false, method="poly"){
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
    polyhedron(polys,faces);
  }
}

module rndRectInt(size=[5,5,2],rad=1,center=false, method="offset"){
  
  cntrOffset= (center) ? [0,0,0] : [size.x/2,size.y/2,size.z/2];

  if (method=="offset")
    translate(cntrOffset+[0,0,-size.z/2]) linear_extrude(size.z) offset(rad) square([size.x-rad*2,size.y-rad*2],true);
  else
    translate(cntrOffset) hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]) cylinder(r=rad,h=size.z,center=true);
}



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
  childOffset2= (angle<0 && center) ? [0,0,size.z] : [0,0,0]; //check
  
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
        children();
    //create bend object
    
    translate(bendOffset3) //checked for cntr+/-, cntrN+/-
      rotate([0,i*90,0]) //re-orientate bend
       translate([-radius,0,0]+bendOffset2)
        rotate_extrude(angle=angle) 
          translate([radius,0,0]+bendOffset1) square([size.z,size.x]);
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
  color("darkSlateGrey"){
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
    color("salmon") translate([0,0,0.5+solder]) cylinder(d=capDims[0].y-0.5,h=H-1-solder);
    //pads
    color("silver") for(iy=[-1,1])
      translate([0,iy*f/2,solder/2]) cube([baseDims.x,e,solder],true);
    color("silver") for(iy=[-1,1])
      translate([0,iy*(baseDims.y-e)/2,solder/2]) cube([dI,e,solder],true);
}
