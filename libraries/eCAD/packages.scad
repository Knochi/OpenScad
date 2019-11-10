$fn=20;
fudge=0.1;



translate([-10,0,0]) TRACO();
SMDpassive("1210",label="000");
translate([4,0,0]) SOT23(22,label="SOT23");
translate([10,0,0]) QFN(label="QFN");
translate([16,0,0]) SOIC(8,"SOIC");
translate([22,0,0]) SSOP(14,"SSOP");
translate([28,0,0]) LED5050(6);
translate([33,0,0]) sk6812mini();
translate([37,0,0]) miniTOPLED();
translate([40,0,0]) APA102();
translate([45,0,0]) SMF();



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

*QFN(pos=64);
module QFN(pos=28,label=""){
  // JEDEC MO-220
  
  //QFN24 (4x4), 28 or QFN32 (5x5)
  //common
  A=0.85;   //total thickness 
  A1=0.035; //standoff        
  A3=0.2;   //lead Frame Thick
  b=0.25;   //lead width
  
  //28/32/64
  D= (pos<28) ? 4.0 : 
     (pos<48) ? 5.0 : 
     (pos<64) ? 7.0 : 9.0;    //body size X
  
  E=D;      //body size y
  J=(pos<28) ? 2.6 : //28
    (pos<48) ? 3.1 : //32
    (pos<64) ? 5.15 : 7.15;  //48/64 //pad size x 
  
  K=J;      //pad size Y
  e=0.5;    //pitch
  L= ((pos==32) || (pos==48)) ? 0.4 : 0.55;   //lead Length /0.4
  //pos=28;
  fudge=0.01; //very small fudge
  
  txtSize=D/(0.8*len(label));
  
  if (label)
    color("white") translate([0,0,A]) linear_extrude(0.1) 
      text(text=label,size=txtSize,halign="center",valign="center", font="consolas");
  
  
  color("darkSlateGrey")
    translate([0,0,A/2]) cube([D,E,A-A1],true);
  
  color("silver") //pads
    for (i=[-(pos/4-1)/2:(pos/4-1)/2],rot=[0,90,180,270]){
      //rotate(rot) translate([i*e-b/2-pos/16,-D/2-fudge,0]){
      rotate(rot) translate([i*e-b/2,-D/2-fudge,0]){
        cube([b,L-b/2,A3]);
        translate([b/2,L-b/2-fudge,0]) cylinder(d=b,h=A3);
      }
    }
  
  color("silver") //Exposed Pad
    linear_extrude(A3) polygon([[-J/2+b,K/2],[J/2,K/2],[J/2,-K/2],[-J/2,-K/2],[-J/2,K/2-b]]);
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

module SSOP(pins=8,label=""){
  //Plastic shrink small outline package (14,16,18,20,24,26,28 pins)
  //https://www.jedec.org/system/files/docs/MO-137E.pdf (max. values where possible)
  
  b= 0.254; //lead width //JEDEC b: 0.2-0.3
  pitch=0.635;
  A= (pins>8) ? 1.72 : 1.75; // total height //JEDEC A: 
  A1=0.25; //space below package //JEDEC A1: 0.1-0.25
  c= (pins>8) ? 0.25 : 0.19; //lead tAickness //JEDEC: 0.1-0.25
  D= (pins>16) ? (pins > 24) ? 9.9 : 8.66 : 4.9;
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