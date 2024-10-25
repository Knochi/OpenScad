$fn=40;
/* [Dimensions] */
mtlPltDims=[51,63,1.8];
mtlPltDrillOffset=7;
mtlPltDrillDia=7;
mtlPltRad=3;

pnchDim=[7,7,14];
pnchTip=3;
pnchHex=true;

baseDim=[100,100,15];
matThck=6;
railMatThck=3;
ltrHght=3.18;
frameRad=5;
innerRad=1.5;
outBrm=10;
inBrm=6; //must be multiple of rackDia
rackDia=1.5;

kerf=0.1;
fudge=0.1;

minWdth=3;

/* [show] */
showBase=true;
showPunch=true;
showTopFrame=true;
showMidFrame=true;
showBotFrame=true;
showCarriage=true;
showRail=true;
showSlider=true;
showScrews=true;
export="none"; //["none","botFrame","midFrame","topFrame","rail","slider","carriage"]

/* [Hidden] */
carWdth=rackDia*floor((rackDia*2+pnchDim.x+minWdth*4)/rackDia);//rackDia*8*2;
echo(carWdth);
inWdth=baseDim.x-inBrm*2;

//specimen
color("silver") linear_extrude(mtlPltDims.z) difference(){
  rndRect([mtlPltDims.x,mtlPltDims.y],mtlPltRad);
  for (ix=[-1,1],iy=[-1,1])
    translate([ix*(mtlPltDims.x/2-mtlPltDrillOffset),iy*(mtlPltDims.y/2-mtlPltDrillOffset)]) 
      circle(d=mtlPltDrillDia);
  }
    
  
//base
if (showBase) color("grey") translate([0,0,-baseDim.z/2-0.01]) cube(baseDim,true);
//puncher
if (showPunch) color("darkslategrey") translate([0,0,3]) nmbrPunch(pnchHex);



//frame
  if (showTopFrame) translate([0,0,matThck*1]) topFrame();
  if (showMidFrame) translate([0,0,matThck*0.5]) midFrame();
  if (showBotFrame) translate([0,0,matThck*1.5]) botFrame();
 

 if (export=="carriage") !projection() carriage();
 if (export=="rail") !projection() rail();
 if (export=="slider") !projection() slider();
       
 if (showSlider) translate([0,0,matThck*1.5]) slider();
 if (showCarriage) translate([0,0,matThck*1.5]) carriage();
 if (showRail) translate([0,0,matThck*1.5]) rail();
 
 
 
 if (export=="botFrame") !projection() botFrame();
 if (export=="midFrame") !projection() midFrame();
 //if (export=="topFrame") !projection() topFrame();
 
//carriage
module carriage(){
  cutOutDims=[baseDim.x-inBrm*4,carWdth-minWdth*2-rackDia,matThck+fudge];
  cutOutRad=3;
  rackCnt=ceil((cutOutDims.x)/(rackDia*2));
  rackCnts=[ceil((cutOutDims.x)/(rackDia*2)),ceil((carWdth/(rackDia*2)))];
  
  color("powderBlue"){ //carriage
  difference(){
    cube([baseDim.x-inBrm*2,carWdth,matThck+0.01],true);
    a=[-carWdth/2:rackDia*2:carWdth/2];
    echo(a);
    //outer rack
    for (x=[-1,1],y=[-carWdth/2:rackDia*2:carWdth/2]){
      rackOffset = (x>0) ? rackDia : 0;
      translate([x*(baseDim.x/2-inBrm),y+rackOffset,0]) cylinder(d=rackDia,h=matThck+fudge,center=true);
    }
    //cutout
    rndRect(cutOutDims,rackDia);
    //inner rack
    for (x=[-(rackCnt/2-1):(rackCnt/2-1)],y=[-1,1]){
      rackOffset = (y>0) ? rackDia : 0;
      if (x*rackDia*2+rackOffset<cutOutDims.x/2-0.5)
      translate([x*rackDia*2+rackOffset,y*(cutOutDims.y/2),0]) cylinder(d=rackDia,h=matThck+fudge,center=true);
    }
    //screw holes
    for (i=[-1,1],j=[-1,1])
      translate([i*(baseDim.x/2-inBrm*1.5-rackDia),j*(carWdth/2-inBrm),0]) 
        cylinder(d=2.0,h=matThck+fudge,center=true);
  }
  
  //outer teeth
  for (x=[-1,1],y=[-(carWdth/2-rackDia):rackDia*2:(carWdth/2-rackDia)]){
    rackOffset = (x>0) ? rackDia : 0;
    if (y<(carWdth/2-rackOffset))
      translate([x*(baseDim.x/2-inBrm),y+rackOffset,0]) cylinder(d=rackDia,h=matThck,center=true);
  }
  //inner teeth
  for (x=[-(rackCnt/2-1.5):(rackCnt/2-1.5)],y=[-1,1]){
    rackOffset = (y>0) ? rackDia : 0;
    translate([x*(rackDia*2)+rackOffset,y*(cutOutDims.y/2),0]) cylinder(d=rackDia,h=matThck,center=true);
  }
    
  }
  }
  
module rail(){
  //rail
  translate([0,0,-matThck/2-railMatThck/2]) difference(){
    rndRect([baseDim.y-inBrm*2-rackDia,carWdth,railMatThck],frameRad);
    //cutout
    rndRect([baseDim.x-inBrm*4-rackDia,carWdth-minWdth*2-rackDia*2,railMatThck+fudge],rackDia);
    
    //drill Holes
    for (i=[-1,1],j=[-1,1])
      translate([i*(baseDim.x/2-inBrm*1.5-rackDia),j*(carWdth/2-inBrm),0]) 
        cylinder(d=2.6,h=3+fudge,center=true);
  }
}

*slider();
module slider(){
  sliderDims=[carWdth-minWdth*2-rackDia,carWdth-minWdth*2-rackDia,matThck];
  ru=pnchHex ? pnchDim.x/2 : pnchDim.x*(1/sqrt(2));
  
  difference(){
    rndRect(sliderDims,innerRad);
    if (pnchHex)
      cylinder(r=ru,$fn=6,h=matThck+fudge,center=true);
    else
      cube([pnchDim.x,pnchDim.y,matThck+fudge],true);
    //rack
    for (ix=[-2.5:2.5],iy=[-1,1]){
      rackOffset = (iy>0) ? rackDia : 0;
      translate([ix*rackDia*2+rackOffset,iy*sliderDims.y/2,0]) cylinder(d=rackDia,h=matThck+fudge,center=true);
    }
  }
  
  if ((export=="none") && showScrews) color("silver") for (i=[-1,1],j=[-1,1])
      translate([i*(baseDim.x/2-inBrm*1.5-rackDia),j*(carWdth/2-inBrm),-matThck/2-3-fudge]) 
        M25Screw();
  //teeth
  for (ix=[-2:2],iy=[-1,1]){
    rackOffset = (iy>0) ? rackDia : 0;
    if (abs(ix*rackDia*2+rackOffset)<(sliderDims.x/2-innerRad))
      translate([ix*rackDia*2+rackOffset,iy*sliderDims.y/2,0]) cylinder(d=rackDia,h=matThck,center=true);
  }
}

*topFrame();
module topFrame(){  
  if (export=="topFrame")
    !shape();
  else
    color("Bisque") linear_extrude(matThck) shape();
  
  module shape(){
    difference(){
      rndRect([baseDim.x+outBrm*2,baseDim.y+outBrm*2],frameRad);
      offset(kerf/2) rndRect([inWdth,inWdth],frameRad);
  
      //rack cutouts 
      for (i=[-inWdth/2+frameRad:rackDia*2:inWdth/2-frameRad],j=[-1,1]){
        rackOffset = (j>0) ? rackDia : 0;
        //front/back
        translate([i+rackOffset,j*inWdth/2]) circle(d=rackDia-kerf);
        //left/right
        translate([j*inWdth/2,i+rackOffset]) circle(d=rackDia-kerf);
      }
  
    //drill holes
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*(baseDim.x+outBrm)/2,iy*(baseDim.y+outBrm)/2]) 
        circle(d=3.1);
    }
    //rack teeth X/Y
    for (i=[-inWdth/2+frameRad:rackDia*2:inWdth/2-frameRad-rackDia*2],j=[-1,1]){
      rackOffset = (j>0) ? 2*rackDia : rackDia;
      translate([i+rackOffset,j*inWdth/2]) circle(d=rackDia+kerf);
      translate([j*inWdth/2,i+rackOffset]) circle(d=rackDia+kerf);
    }
  }
}
*midFrame();
module midFrame(){

if (showMidFrame) color("RosyBrown") 
  difference(){
    rndRect([baseDim.x+outBrm*2,baseDim.y+outBrm*2,matThck],frameRad);
    rndRect([baseDim.x-inBrm*2-rackDia,baseDim.y-inBrm*2-rackDia,matThck+fudge],innerRad);
    
    for (i=[-1,1],j=[-1,1])
      translate([j*(baseDim.x+outBrm)/2,i*(baseDim.x+outBrm)/2,0]) 
        cylinder(d=3.1,h=matThck+fudge,center=true);
  }
}

module botFrame(){
 color("chocolate")
    //baseframe lower
    translate([0,0,-matThck*2]) difference(){
      rndRect([baseDim.x+20,baseDim.y+20,matThck],5);
      cube([baseDim.x,baseDim.y,matThck+fudge],true);
      for (i=[-1,1],j=[-1,1])
        translate([i*(baseDim.x/2+outBrm/2),j*(baseDim.y/2+outBrm/2),0]) 
          cylinder(d=2.3,h=matThck+fudge,center=true);
    }
}

*nmbrPunch(true);
module nmbrPunch(hex=false){
  //color("grey") cylinder(d=7,h=14,$fn=6);
  ru=hex ? pnchDim.x/2 : pnchDim.x*(1/sqrt(2));
  tipHght=pnchTip;
  if (hex)
    translate([0,0,tipHght]) cylinder(r=ru,h=pnchDim.z,$fn=6);
  else
    translate([0,0,pnchDim.z/2+tipHght]) cube(pnchDim,true);
  
  intersection(){
    cylinder(r2=ru,r1=ltrHght*0.66,h=tipHght);
    if (hex)
      cylinder(r=ru,h=pnchDim.z,$fn=6);
    else
      translate([0,0,tipHght/2]) cube([pnchDim.x,pnchDim.x,tipHght],true);
  }
  translate([0,0,-0.5]) linear_extrude(0.5,scale=1.2) 
    text("X",size=ltrHght*0.8,valign="center",halign="center");
}


module rndRect(size=[1,1,1],rad=1){
  if (size.z==undef) //2D shape
    hull() for (i=[-1,1],j=[-1,1])
      translate([i*(size.x/2-rad),j*(size.y/2-rad)]) circle(r=rad);
  else
    hull() for (i=[-1,1],j=[-1,1])
      translate([i*(size.x/2-rad),j*(size.y/2-rad),0]) cylinder(r=rad,h=size.z,center=true);
}

*rack(5);
module rack(N){
  dia=1.75;
  for (i=[0:N-1]){
    translate([i*dia*2+dia,0,0]) cylinder(d=dia,h=matThck);
  }
  difference(){
    translate([0,-dia,0]) cube([dia*N*2,dia,matThck]);
    for (i=[0:N])
      translate([i*dia*2,0,-fudge/2]) cylinder(d=dia,h=matThck+fudge);
  }
}


module M25Screw(length=8){
  cylinder(d=2.5,h=length);
  cylinder(d1=4.7,d2=2.5,h=1.5);
}