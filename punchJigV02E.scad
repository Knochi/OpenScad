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
outBrm=10;
inBrm=5;
rackDia=1.5;
carWdth=rackDia*8*2-rackDia;
inWdth=baseDim.x-inBrm*2;
kerf=0.1;
fudge=0.1;

/* [show] */
showBase=true;
showPunch=true;
showTopFrame=true;
showMidFrame=true;
showBotFrame=true;
showCarriage=true;
showRail=true;
showSlider=true;
export="none"; //["none","botFrame","midFrame","topFrame","rail","slider","carriage"]

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
 if (showBotFrame) translate([0,0,matThck*1.5]) botFrame();
 if (showMidFrame) translate([0,0,matThck*1.5]) midFrame();
 if (showTopFrame) translate([0,0,matThck*1.5]) topFrame();

 if (export=="carriage") !projection() carriage();
 if (export=="rail") !projection() rail();
 if (export=="slider") !projection() slider();
       
 if (showCarriage) translate([0,0,matThck*1.5]) carriage();
 if (showRail) translate([0,0,matThck*1.5]) rail();
 if (showSlider) translate([0,0,matThck*1.5]) slider();
 
 
 if (export=="botFrame") !projection() botFrame();
 if (export=="midFrame") !projection() midFrame();
 if (export=="topFrame") !projection() topFrame();
 
//carriage
module carriage(){
  
  color("powderBlue"){ //carriage
  difference(){
    cube([baseDim.x-inBrm*2,carWdth,matThck+0.01],true);
    for (i=[-1,1],j=[rackDia:rackDia*2:rackDia*4]){
      translate([i*(baseDim.x/2-inBrm),j,0]) cylinder(d=rackDia,h=matThck+fudge,center=true);
      translate([i*(baseDim.x/2-inBrm),-j,0]) cylinder(d=rackDia,h=matThck+fudge,center=true);
    }
    cube([pnchDim.x,pnchDim.y,pnchDim.z+fudge],true);
    rndRect([baseDim.x-inBrm*4-rackDia,carWdth-inBrm*2,matThck+fudge],rackDia);
    //screw holes
    for (i=[-1,1],j=[-1,1])
      translate([i*(baseDim.x/2-inBrm*1.5-rackDia),j*(carWdth/2-inBrm),0]) 
        cylinder(d=2.0,h=matThck+fudge,center=true);
  }
  
  for (i=[-1,1],j=[0:rackDia*2:rackDia*4]){
      translate([i*(baseDim.x/2-inBrm),j,0]) cylinder(d=rackDia,h=matThck,center=true);
      translate([i*(baseDim.x/2-inBrm),-j,0]) cylinder(d=rackDia,h=matThck,center=true);
    }
  }
  }
  
module rail(){
  //rail
  translate([0,0,-matThck/2-railMatThck/2]) difference(){
    cube([carWdth,baseDim.y-inBrm*2-rackDia,railMatThck],true);
    
    rndRect([carWdth-inBrm*2-rackDia*2,baseDim.x-inBrm*4-rackDia,railMatThck+fudge],rackDia);
    
    for (i=[-1,1],j=[-1,1])
      translate([i*(baseDim.x/2-inBrm*1.5-rackDia),j*(carWdth/2-inBrm),0]) 
        cylinder(d=2.6,h=3+fudge,center=true);
  }
}
  
module slider(){
  difference(){
    rndRect([pnchDim.x*5,carWdth-inBrm*2+kerf*2,matThck],rackDia);
    cube([pnchDim.x,pnchDim.y,matThck+fudge],true);
    translate([-pnchDim.x*1.5,rackDia/2,0]) cube([pnchDim.x,pnchDim.y,matThck+fudge],true);
    translate([pnchDim.x*1.5,-rackDia/3,0]) cube([pnchDim.x,pnchDim.y,matThck+fudge],true);
  }
  
  if (export=="none") color("silver") for (i=[-1,1],j=[-1,1])
      translate([i*(baseDim.x/2-inBrm*1.5-rackDia),j*(carWdth/2-inBrm),-matThck/2-3-fudge]) 
        M25Screw();
}


module topFrame(){  
 //rackFrame
color("Bisque"){
  difference(){
    rndRect([baseDim.x+outBrm*2,baseDim.y+outBrm*2,matThck],frameRad);
    rndRect([inWdth,inWdth,matThck+fudge],frameRad);
    
    //rack cutouts
    for (ix=[-inWdth/2+frameRad:rackDia*2:inWdth/2-frameRad],iy=[-1,1])
      translate([ix,iy*inWdth/2,0]) cylinder(d=rackDia,h=matThck+fudge,center=true);
    
    //drill holes
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*(baseDim.x+outBrm)/2,iy*(baseDim.y+outBrm)/2,0]) 
        cylinder(d=3.1,h=matThck+fudge,center=true);
  }
  //rack teeth
  for (ix=[-inWdth/2+frameRad:rackDia*2:inWdth/2-frameRad-rackDia*2],iy=[-1,1]){
      translate([ix+rackDia,iy*inWdth/2,,0]) cylinder(d=rackDia,h=matThck,center=true);
      //6translate([j*inWdth/2,-i-rackDia,0]) cylinder(d=rackDia,h=matThck,center=true);
    }
  }  
}
*midFrame();
module midFrame(){
yOffset= (export=="midFrame") ? inBrm+outBrm : (baseDim.x+outBrm)/2;
if (showMidFrame) color("RosyBrown") 
  difference(){
    for (i=[-1,1])
      translate([0,i*(yOffset-rackDia/4-inBrm/2),-matThck]) 
        rndRect([baseDim.x+outBrm*2,outBrm+inBrm+rackDia/2,matThck],frameRad);
    for (i=[-1,1],j=[-1,1])
      translate([j*(baseDim.x+outBrm)/2,i*yOffset,-matThck]) 
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