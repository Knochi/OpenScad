
$fn=40;
/* [Dimensions] */
mtlStrpDim=[50,6.4,1.3];
pnchDim=[6.25,6.25,64];
baseDim=[150,150,43];
matThck=5;
ltrHght=3;
frameRad=5;
outBrm=10;
inBrm=5;
rackDia=3;
fudge=0.1;

/* [show] */
showBase=true;
showPunch=true;
showTopFrame=true;
showMidFrame=true;
showBotFrame=true;

//specimen
color("silver") translate([0,0,mtlStrpDim.z/2]) cube(mtlStrpDim,true);
//base
if (showBase) color("grey") translate([0,0,-baseDim.z/2-0.01]) cube(baseDim,true);
//puncher
if (showPunch) color("darkslategrey") translate([0,0,3]) nmbrPunch();

//frame
 translate([0,0,matThck*1.5]) frame();

 translate([0,0,matThck*1.5]) carriage();

//carriage
module carriage(){
  carWdth=rackDia*6*2-rackDia;
  
  color("powderBlue"){
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
  //rail
  color("Turquoise")  
  translate([0,0,-matThck/2-3/2]) difference(){
    cube([baseDim.x-inBrm*2-rackDia,carWdth,3],true);
    rndRect([baseDim.x-inBrm*4-rackDia,carWdth-inBrm*2-rackDia*2,3+fudge],rackDia);
    for (i=[-1,1],j=[-1,1])
      translate([i*(baseDim.x/2-inBrm*1.5-rackDia),j*(carWdth/2-inBrm),0]) 
        cylinder(d=2.6,h=3+fudge,center=true);
  }
  
  //carriage
  color("DodgerBlue")
  difference(){
    rndRect([pnchDim.x*5,carWdth-inBrm*2,matThck],rackDia);
    cube([pnchDim.x,pnchDim.y,matThck+fudge],true);
    translate([-pnchDim.x*1.5,rackDia/2,0]) cube([pnchDim.x,pnchDim.y,matThck+fudge],true);
    translate([pnchDim.x*1.5,-rackDia/3,0]) cube([pnchDim.x,pnchDim.y,matThck+fudge],true);
  }
  
  color("silver") for (i=[-1,1],j=[-1,1])
      translate([i*(baseDim.x/2-inBrm*1.5-rackDia),j*(carWdth/2-inBrm),-matThck/2-3-fudge]) 
        M25Screw();
}


module frame(){

  inWdth=baseDim.x-inBrm*2;
  
 //rackFrame

  if (showTopFrame) color("Bisque"){
  difference(){
    rndRect([baseDim.x+outBrm*2,baseDim.y+outBrm*2,matThck],frameRad);
    rndRect([inWdth,inWdth,matThck+fudge],frameRad);
    for (i=[0:rackDia*2:inWdth/2-frameRad],j=[-1,1]){
      translate([j*inWdth/2,i,0]) cylinder(d=rackDia,h=matThck+fudge,center=true);
      translate([j*inWdth/2,-i,0]) cylinder(d=rackDia,h=matThck+fudge,center=true);
    }
    for (i=[-1,1],j=[-1,1])
      translate([i*(baseDim.x+outBrm)/2,j*(baseDim.y+outBrm)/2,0]) 
        cylinder(d=3.1,h=matThck+fudge,center=true);
  }
  for (i=[0:rackDia*2:inWdth/2-frameRad-rackDia*2],j=[-1,1]){
      translate([j*inWdth/2,i+rackDia,0]) cylinder(d=rackDia,h=matThck,center=true);
      translate([j*inWdth/2,-i-rackDia,0]) cylinder(d=rackDia,h=matThck,center=true);
    }
  }  

//baseframe mid
if (showMidFrame) color("RosyBrown") 
  difference(){
  for (i=[-1,1])
  translate([i*(baseDim.x/2+inBrm/2-rackDia/4),0,-matThck]) rndRect([outBrm+inBrm+rackDia/2,baseDim.y+outBrm*2,matThck],frameRad);
  for (i=[-1,1],j=[-1,1])
    translate([i*(baseDim.x+outBrm)/2,j*(baseDim.y+outBrm)/2,-matThck]) 
      cylinder(d=3.1,h=matThck+fudge,center=true);
}


color("chocolate")
//baseframe lower
translate([0,0,-matThck*2]) difference(){
  rndRect([baseDim.x+20,baseDim.y+20,matThck],5);
  cube([baseDim.x,baseDim.y,matThck+fudge],true);
  for (i=[-1,1],j=[-1,1])
    translate([i*(baseDim.x/2+outBrm/2),j*(baseDim.y/2+outBrm/2),0]) 
      cylinder(d=2.5,h=matThck+fudge,center=true);
}
}

module nmbrPunch(){
  ru=pnchDim.x*(1/sqrt(2));
  tipHght=6.8;
  translate([0,0,pnchDim.z/2+tipHght]) cube(pnchDim,true);
  intersection(){
    cylinder(r2=ru,r1=5/2,h=tipHght);
    translate([0,0,tipHght/2]) cube([pnchDim.x,pnchDim.x,tipHght],true);
  }
  translate([0,0,-0.5]) linear_extrude(0.5,scale=1.2) 
    text("X",size=ltrHght*0.8,valign="center",halign="center");
}


module rndRect(size=[1,1,1],rad=1){
  hull() for (i=[-1,1],j=[-1,1])
    translate([i*(size.x/2-rad),j*(size.y/2-rad),0]) cylinder(r=rad,h=size.z,center=true);
}

*rack(5);
module rack(N){
  dia=3;
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