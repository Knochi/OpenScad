use <SAMLA.scad>


/* [show] */
showBoxes=true;
showLits=true;
showDrawers=true;

/* [Closet Dimensions] */
ovInDims=[970,610,435];
vertBeamSect=[39,70];
horBeamSect=[39,60];
// a wall corner is protruding in the compartment
wallCrnrDim=[60,500];
flrThck=20;


/* [Drawers] */
//Dimensions of the construction Beams
constBeamsDim=[10,40]; //available widths: 10, 20, 
drawer1Pos=0; //[0:0.1:1]
drawer2Pos=0; //[0:0.1:1]
drawer3Pos=0; //[0:0.1:1]
boxDist=[304,200,134];
boxOffset=[215,110,12.7+9];
boxCount=[3,3,3];
boxRotation=0;
//Thickness of the plywood sheets
sheetThck=9;
slideLength=600;
slidesYOffset=-100;
slidesZOffset=0;
slideType="TSS-5413";
/* [Hidden] */

/*
// Materials
- Spannplatte roh 11EUR /mm² 12mm hornbach
- multiplex 29EUR /m² (thicknesses [9:3:30]

*/
drawerPos=[drawer1Pos,drawer2Pos,drawer3Pos];

for (i=[0:boxCount.x-1]) translate([i*boxDist.x+boxOffset.x,boxOffset.y+slidesYOffset,slidesZOffset])
  horizontalDrawer(pos=drawerPos[i]) 
    for (iy=[0:boxCount.y-1],iz=[0:boxCount.z-1])
      translate([0,
                iy*boxDist.y-boxDist.y,
                iz*boxDist.z]) 
        rotate(boxRotation){
          if (showBoxes)
            color("ghostWhite") SAMLAbox();
          if (showLits)
            color("ghostWhite") SAMLAlit();
        }  

//vertical Beams
color("BurlyWood"){
  translate([0,0,-horBeamSect.x]) 
    linear_extrude(ovInDims.z+horBeamSect.x*2){
      translate([-vertBeamSect.x,0]) square(vertBeamSect);
      translate([ovInDims.x,0]) square(vertBeamSect);
    }
}

//horizontal Beams
color("Wheat"){
  translate([0,vertBeamSect.y-horBeamSect.y,0]){
    rotate([0,90,0]) linear_extrude(ovInDims.x) square(horBeamSect);
    translate([0,0,ovInDims.z+horBeamSect.x]) 
      rotate([0,90,0]) linear_extrude(ovInDims.x) square(horBeamSect);
  }
}

//wall corner
color("ivory") translate([-vertBeamSect.x,ovInDims.y-wallCrnrDim.y,-horBeamSect.x]) 
  cube([wallCrnrDim.x+vertBeamSect.x,wallCrnrDim.y,ovInDims.z+horBeamSect.x*2]);

// floor
color("tan") translate([-vertBeamSect.x,vertBeamSect.y,-flrThck])
  linear_extrude(flrThck) difference(){
    square([ovInDims.x+vertBeamSect.x*2,ovInDims.y-vertBeamSect.y]);
    translate([0,ovInDims.y-wallCrnrDim.y-vertBeamSect.y]) offset(2) square(wallCrnrDim+[vertBeamSect.x,0]);
}



module horizontalDrawer(mountFlat=true, pos=0){
  sheetWidth=280; // samla lit width, was: boxDist.x-constBeamsDim.x-12.7*2;
  
  //a set of horizontal drawers from Box Positions
  
    //slides
    if (mountFlat){
      //left side with sheet
      translate([-(boxDist.x*0.66)/2,0,0])  
        slide(length=slideLength,position=pos,type=slideType)
          translate([boxDist.x*0.66/2,slideLength/2,sheetThck/2+12.7]){
            cube([sheetWidth,slideLength,sheetThck],true);
            children();
          }
      //right slide without sheet
      translate([(boxDist.x*0.66)/2,0,0])  
        slide(length=slideLength,position=pos,type=slideType);
    }
    else{
    //left slide with sheet
      translate([-(boxDist.x-constBeamsDim.x)/2,0,0]) rotate([0,90,0]) 
        slide(length=slideLength,position=pos,type=slideType)
          rotate([0,-90,0]) translate([12.7,0,-sheetThck/2]){
            cube([sheetWidth,slideLength,sheetThck]);
            children();
          }
    //right slide without sheet
      translate([(boxDist.x-constBeamsDim.x)/2,0,0]) rotate([0,-90,0]) 
        slide(length=slideLength,position=pos, type=slideType);
    }
  
    
}


*slide(position=leftDrawerPos);
module slide(length=500,position=0.0,type="TSS-3513", brackets=false, center=false){
  //TSS 4630 rail https://www.teleskopschienen-shop.de/media/pdf/d6/5f/58/teleskopschiene-tss4613-datenblatt.pdf
  //Bracket Set https://www.teleskopschienen-shop.de/montagewinkel/winkelset-vormontiert/winkelset-vormontiert
  SL=length; //slide length
  TL=length*1.016; //travel length
  profile= (type=="TSS-4630") ? [45.7,12.7] :
           (type=="ON-4613SC") ? [45.5,12.7] : //45kg soft close
           (type=="TSS-4613SC") ? [45.7,12.7] :
          (type=="TSS-3513") ? [37,12.7] :
          (type=="TSS-5413") ? [54.5,12.7] : [45.7,12.7];
  sheetThck=1.5; //just for visualisation!
  spacing=[3,1]; //just for visualisation!
  shlOffset=[(sheetThck+spacing.x)*2,sheetThck+spacing.y];
  iShlDims=profile-[(sheetThck+spacing.x)*2,sheetThck+spacing.y];
  tShlDims=iShlDims-[(sheetThck+spacing.x)*2,sheetThck+spacing.y];
  
  cntrOffset = center ? [0,0,0] : [0,0,profile.y/2];
  
  translate(cntrOffset){
    //outer shell
    color("silver") rotate([-90,0,0]) linear_extrude(SL) difference(){
      square(profile,true);
        translate([0,-sheetThck/2])
          square(profile-[sheetThck*2,sheetThck],true);
    }
    //inner shell
    color("silver") translate([0,-TL*position*0.4]) rotate([-90,0,0]) linear_extrude(SL) 
      translate([0,-(sheetThck+spacing.y)/2]) difference(){
        square(iShlDims,true);
        translate([0,-sheetThck/2])
          square(iShlDims-[sheetThck*2,sheetThck],true);
    }
    //traveller
    color("silver") translate([0,-TL*position]) rotate([-90,0,0]) linear_extrude(SL) 
      translate([0,-(sheetThck+spacing.y)]) difference(){
        square(tShlDims,true);
        translate([0,sheetThck/2])
          square(tShlDims-[sheetThck*2,sheetThck],true);
    }
  }
  translate([0,-TL*position,0]) children();
}