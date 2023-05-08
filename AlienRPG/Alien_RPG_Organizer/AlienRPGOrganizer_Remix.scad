fudge=0.1;
/* [show] */
showBox=true;
export="none"; //["none","cardTray","doveTailTestPos","doveTailTestNeg"]

/* [Dimensions] */
boxDims=[228,288,52];
boxWallThck=1.8;
minWallThck=1.8;
boxSpacing=0.5;
pressFit=0.1;

/* [DoveTails] */
dTSize=[5,10];
dTAngle=60;
dTRadius=0.5;
dTSpacing=0.1;
dTTestStart=0.2;
dTTestInc=0.2;

/* [Cards] */
sleeveDims = [68,94,0.46];
cardDims= [63.5,88,0.355];
isSleeved=true;
cardGripDia=25;
cardSpacing=0.5;

/* [Hidden] */

if (export=="none"){
  translate([-8,0,0]) import ("Alien_RPG_card_tray_x2.stl");
  translate([-9,-39,0]) import ("Alien_RPG_card_and_token_tray.stl");
  translate([-8,0,0]) import ("Alien_RPG_dice_insert_optional.stl");
}

else if (export=="cardTray")
  !tripleCards();
  
else if (export=="doveTailTestPos")
  !doveTailTest(isPositive=true);
else if (export=="doveTailTestNeg")
  !doveTailTest(isPositive=false);

if (showBox)
  color("darkslategrey") AlienRPGBox();
  
module AlienRPGBox(){
  ovDims=boxDims; //outer Dimensions
  wallThck=boxWallThck;
  translate([0,0,ovDims.z/2-wallThck]) difference(){
    cube(ovDims,true);
    translate([0,0,wallThck/2]) cube([ovDims.x-wallThck*2,ovDims.y-wallThck*2,ovDims.z-wallThck+fudge],true);
  }
}

module cards(stack=10){
  ovDims= isSleeved ? [sleeveDims.x,sleeveDims.y,sleeveDims.z*stack] : [cardDims.x,cardDims.y,cardDims.z*stack];
  translate([0,0,stack*cardDims.z/2]) cube(ovDims,true);
}

*union(){
  tripleCards();
  rotate(180) tripleCards();
}
  
module tripleCards(height=20, slice=true){
  cDims= isSleeved ? [sleeveDims.x,sleeveDims.y] : [cardDims.x,cardDims.y];
  ovDims=[boxDims.x-boxSpacing*2,cDims.y+minWallThck*2+cardSpacing*2,height];
  
  translate([0,0,height/2]) difference(){
    cube(ovDims,true);
    for (ix=[-1:1]){
      translate([ix*(cDims.x+minWallThck+cardSpacing*2),0,(minWallThck+fudge)/2]) 
        cube([cDims.x+cardSpacing*2,cDims.y+cardSpacing*2,height-minWallThck+fudge],true);
      for (iy=[-1,1])
      translate([ix*(cDims.x+minWallThck+cardSpacing*2),iy*ovDims.y/2,0]) 
        cylinder(d=cardGripDia,h=height+fudge,center=true);
    }
    //cut the half away and apply dovetails
    if (slice){
      translate([-pressFit/2,-(ovDims.y+fudge)/2,-(height+fudge)/2])
        cube([ovDims.x/2+pressFit+fudge,ovDims.y+fudge,ovDims.z+fudge]);
      translate([0,(ovDims.y-cardGripDia)/4,-(height+fudge)/2]) 
        rotate(180) linear_extrude(minWallThck+fudge) offset(dTSpacing) doveTail(dTSize,dTAngle,dTRadius,1);
    }
  }
  if (slice)
    translate([0,-(ovDims.y-cardGripDia)/4,0]) 
        linear_extrude(minWallThck)
          doveTail(dTSize,dTAngle,dTRadius,1);
}

*doveTailTest();
module doveTailTest(startSpacing=0.2, increment=0.2, isPositive=true, label=true){
  sSpcng=startSpacing;
  inc=increment;
  cntrSize=[dTSize.y*3-(sSpcng*2+inc*2)/2,
            dTSize.y*3-(sSpcng*2+inc*4)/2];
  cntrOffset=[inc/2,inc/2];        
  
  difference(){
    linear_extrude(minWallThck){
      difference(){
        union(){
          translate(cntrOffset) square(cntrSize,true);
          if (isPositive)
            for (i=[0:3]){
              spcng=sSpcng+i*inc;
              rotate(i*90) translate([dTSize.y*3/2,0])
                doveTail(dTSize,dTAngle,dTRadius,spcng);
          }
        }
        if (!isPositive)
          for (i=[0:3]){
            spcng=sSpcng+i*inc;
            rotate(i*90)
              translate([dTSize.y*3/2,0]) 
                rotate(180) offset(spcng) doveTail(dTSize,dTAngle,dTRadius,0);    
          }
      }
    }
    if (label){
      dx= isPositive ? 0 : dTSize.x;
      for (i=[0:3]){
              spcng=sSpcng+i*inc;
              rotate(i*90) translate([dTSize.y*3/2-spcng-0.5-dx,0,minWallThck/2]) linear_extrude(minWallThck/2+fudge)
                rotate(90) text(str(spcng),size=dTSize.y*0.4,halign="center");
          }
    }
  }

}

//-- a dovetail shape to link objects
*doveTail();
module doveTail(size=[5,10],angle=60,radius=0.5,flap=1){
  dy= (size.x-radius)/tan(angle); //y offset of narrow part //tan(alpha)=GK/AK
  cy= (radius/cos(90-angle))-radius; //correction of width because of radii //cos(alpha)=GK/HYP
  difference(){
    mirror([1,0]) hull()for (ix=[0,1],iy=[-1,1])
      translate([ix*(size.x-radius)-size.x+radius,iy*(size.y/2-radius-ix*dy)]) circle(radius,$fn=50);
    //cut away left part
    translate([-(radius+fudge)/2,0]) square([radius+fudge,size.y+fudge],true);
  }
  if (flap)
    square([flap*2,size.y-dy*2+cy*2],true);
}
