

/* [Dimensions] */
//general material thickness
matThck=3;
//thickness of top Plate
topThck=6;
kerf=0.1;
tapWdth=40;
baseHght=80;
baseWdth=410; //
basePlateDims=[482.6,444.5]; //19" Rack, 10HE
feetHght=10; //width,height
baseRad=5;
iMX1Pos=[-100,90];
iMX2Pos=[100,90];
hubPos=[100,-130,0];
RSPDims=[215,115,30];
RS15Dims=[62.5,51,28];
RSPXPos=0;
PBrickDims=[175,72,35];
relBrdDims=[140,50,1.6+15.2];
drillDia=4;


/* [show] */
showVariant="box"; //["box","stand"]
showBase=true;
showStand=true;
showCase=false;
showMXBoard=true;
showStandOffs=true;
showTop=true;
showFront=true;
showBack=true;
showSides=true;
showBeams=true;
showiFloors=true;
showBottom=false;
showHDMI=true;
showRSP320=true;
showiMXPowerBricks=false;
showRS15=true;
showUSBHub=true;
showkStone=true;
showRPi4=true;
showRelaisBoard=true;
showWAGO=true;
showInlet=true;
export="none"; //["none","top","side","bottom","front","back"] 

/* [Colors] */
sideColor="saddleBrown";
faceColor="wheat";
topColor="ivory";
bottomColor="burlyWood";

/* [Hidden] */
$fn=50;
fudge=0.1;
caseZOffset= showCase ? 668 : 0;

baseDims=[410,basePlateDims.y-tapWdth,baseHght]; //placimg front and back in middle of standoffs
iMXPos=[iMX1Pos,iMX2Pos];

/*
HDMIPos=[-baseDims.x/2+matThck,baseDims.y/2-matThck-40,-5];
HDMIRot=[0,180,-90];
*/

PBrickZOffset=-baseHght+PBrickDims.z+topThck+fudge;
RS15ZOffset=-baseHght+RS15Dims.z+topThck+fudge;
RSP2BrickOffset=10;
RSPPos=[0,baseDims.y/2-RSPDims.y/2-matThck,-baseHght+RSPDims.z+topThck+fudge];
PBrick1Pos=[-20,RSPPos.y-(RSPDims.y+PBrickDims.y)/2-matThck*2-RSP2BrickOffset-fudge,PBrickZOffset];
PBrick2Pos=[PBrick1Pos.x,PBrick1Pos.y-PBrickDims.y-fudge,PBrickZOffset];
RS15Pos=[-120,-baseDims.y/2+RS15Dims.y/2+matThck,RS15ZOffset];
RS15Rot=[0,180,0];
RPi4Pos=[50,-112,-5];
RPi4Rot=[180,0,0];
kStonePos=[120,-baseDims.y/2,-baseHght/2+topThck];
relBrdPos=[-(baseDims.x-relBrdDims.x)/2+matThck+5,-112,-5];
relBrdRot=[180,0,180];
WAGOPos=[-baseDims.x/2+matThck,-55,-baseDims.z/2];
WAGORot=[90,0,90];
WAGOClamps=["double","single","double","single","double",
            "single","single","single","single"];
WAGOColors=["lightBlue","lightBlue","lightgreen","lightgreen","lightGrey",
            "lightGrey","lightGrey","lightGrey","lightGrey"];
inletPos=[-150,baseDims.y/2,-baseDims.z/2];
inletRot=[-90,0,0];

// === Assembly ===
translate([0,0,caseZOffset+fudge]){
  if (showMXBoard) for (pos=iMXPos) 
      translate([pos.x,pos.y,topThck+fudge]) iMX8_PCB(false);
  //if (showHDMI) translate(HDMIPos) rotate(HDMIRot) HDMIConv();
  if (showBase) basePlate();
  if (showiMXPowerBricks){
    translate(PBrick1Pos) color("darkSlateGrey") rotate([0,180,0]) iMXPowerBrick();
    translate(PBrick2Pos) color("darkSlateGrey") rotate([0,180,0]) iMXPowerBrick();
  }
  if (showUSBHub) color("darkSlateGrey") translate(hubPos)  rotate([180,0,0]) USBHub();
  if (showRSP320) translate(RSPPos) rotate([180,0,0]) RSP320();
  if (showRS15) translate(RS15Pos) rotate(RS15Rot) RS15();
  if (showRPi4) translate(RPi4Pos) color("green") rotate(RPi4Rot) import("RPi_4_dummy.stl");
  if (showkStone) translate(kStonePos) rotate([90,0,0]) kStone6();
  if (showRelaisBoard) translate(relBrdPos) rotate(relBrdRot) relaisBoard();
  if (showWAGO) translate(WAGOPos) rotate(WAGORot) buildWagoAssy(WAGOClamps,WAGOColors);
  if (showInlet) translate(inletPos) rotate(inletRot) powerInlet();
  
}


if (showCase) case12U();

// === Modules ===

module basePlate(){
  
  cntrDims=baseDims-[matThck,matThck,matThck];
  soOffsets=[(baseDims.x/2-matThck-10),(baseDims.y/2-matThck-10)];
  echo(cntrDims);
  tapCounts=[floor(cntrDims.x/(tapWdth*2)),
             floor(cntrDims.y/(tapWdth*2)),
             floor(cntrDims.z/(tapWdth*2))];
  
  
  tapOffsets=[cntrDims.x/(tapCounts.x),
              cntrDims.y/(tapCounts.y),
              cntrDims.z/(tapCounts.z)];
  
  // -- Cutouts relative to iMX boards center
  LVDSSlotPos=[-6,67];
  LVDSSlotDims=[93,10];
  DCPos=[56.5,-67.5-50];
  RJ45Pos=[-37,-67.5-30];
  
  // absolute Positions & Dimensions for compartments (beams)
  RSPBeamPos=[0,cntrDims.y/2-RSPDims.y-matThck,-cntrDims.z+matThck];
  PBricksPos=[PBrick1Pos.x,PBrick1Pos.y-PBrickDims.y/2-fudge/2,-cntrDims.z+matThck];
  PBricksiFloorPos=PBricksPos+[0,0,PBrickDims.z+fudge];
  PBricksiFloorDims=[PBrickDims.x+matThck*2,(PBrickDims.y+fudge)*2,matThck];
  PBrickBeamsDist=(PBrickDims.y+fudge+matThck/2);
  PBrickBeamHght=PBrickDims.z+matThck*3;
  RS15BeamPos=[0,-cntrDims.y/2+RS15Dims.y+matThck,-cntrDims.z+matThck];
  
  if (export=="top")
    !projection() top();
  
  
  color(topColor,0.8) 
    if (showTop) top();
  
  if (showVariant=="box"){
    color(bottomColor) 
      if (showBottom) difference(){
        translate([0,0,-cntrDims.z]) bottom();
        translate(RSPPos) rotate([180,0,0]) RSP320("fan");
      }
    //sides
    color(sideColor) 
      if (showSides) for (ix=[-1,1])
        difference(){
          translate([ix*cntrDims.x/2,0,0]) rotate([90,0,90]) side();
          translate(RSPBeamPos) rotate([-90,0,0]) beamX(height=RSPDims.z,cut=true);
          for (iy=[-1,1])
            translate([0,PBricksPos.y+iy*PBrickBeamsDist,PBricksPos.z])
              rotate([-90,0,0]) beamX(height=PBrickBeamHght,cut=true);
          translate(RS15BeamPos) rotate([-90,0,0]) beamX(height=RS15Dims.z,cut=true);
        }
    
    // Front face
    color(faceColor){
      if (showFront) 
        difference(){
          translate([0,-cntrDims.y/2,0]) rotate([90,0,0]) face();
          translate(RS15Pos) rotate(RS15Rot) RS15("drills");
          translate(kStonePos) rotate([90,0,0]) kStone6(true);
        }
    // Back face
      if (showBack)
        difference(){
          translate([0,cntrDims.y/2,0]) rotate([90,0,0]) face();
          translate(RSPPos) rotate([180,0,0]) RSP320("drills");
          translate(inletPos) rotate(inletRot) powerInlet(true);
        }
    }
    
    // Beams
    color(faceColor)
      if (showBeams){ 
        // beam to hold RSP
        difference(){
          translate(RSPBeamPos) rotate([-90,0,0]) beamX(height=RSPDims.z);
          translate(RSPPos) rotate([180,0,0]) RSP320("drills");
        }
        //Beams for Powerbricks
        difference(){
          for (iy=[-1,1])
            translate([0,PBricksPos.y+iy*PBrickBeamsDist,PBricksPos.z])
              rotate([-90,0,0]) beamX(height=PBrickBeamHght);
          translate(PBricksiFloorPos) iFloor(PBricksiFloorDims,true);
          for (ix=[-1,1])
            translate(PBricksPos+[ix*(PBrickDims.x+matThck)/2,0,(PBrickDims.z)/2]) 
              rotate([90,0,90]) beam([PBrickBeamsDist*2-matThck,PBrickDims.z,matThck],cut=true);
        }
        //PBrick faces
        difference(){
          for (ix=[-1,1])
            translate(PBricksPos+[ix*(PBrickDims.x+matThck)/2,0,(PBrickDims.z)/2]) 
              rotate([-90,0,90]) beam([PBrickBeamsDist*2-matThck,PBrickDims.z,matThck]);
          translate(PBrick1Pos) color("darkSlateGrey") rotate([0,180,0]) iMXPowerBrick(true);
          translate(PBrick2Pos) color("darkSlateGrey") rotate([0,180,0]) iMXPowerBrick(true);
        }
        //Beam for RS15
        difference(){
          translate(RS15BeamPos) rotate([-90,0,0]) beamX(height=RS15Dims.z);
          translate(RS15Pos) rotate([180,0,0]) RS15("drills");
        }
      }//beams
      
    //intermidiate floor for PowerBricks
    color(bottomColor)
      if (showiFloors) 
        translate(PBricksiFloorPos) 
          iFloor(PBricksiFloorDims);
    //standoffs
    color("silver")
      if (showStandOffs) for (ix=[-1,1],iy=[-1,1])
        translate([ix*soOffsets.x,iy*soOffsets.y,-baseDims.z+matThck*2]) 
          standOff(3,baseHght-matThck*2);
    } //variant box
    
    
    else if (showStand) {
      for (im=[0:1],ir=[0,180]){
        color("ivory") mirror([im,0,0]) rotate(ir) 
          translate([-cntrDims.x/2,cntrDims.y/2,0]) stand3D();
      }
    }
  
  module top(){
     difference(){
       translate([0,0,topThck/2]) 
        rndRect([basePlateDims.x,basePlateDims.y,topThck],baseRad,0);
       //cutouts for iMX Boards 
      for (pos=iMXPos)
        translate([pos.x,pos.y,-fudge/2]){
          linear_extrude(topThck+fudge,convexity=2) iMX8_PCB(true);
          //LVDS slot
          translate([LVDSSlotPos.x,LVDSSlotPos.y,(topThck+fudge)/2]) 
            rndRect([LVDSSlotDims.x,LVDSSlotDims.y*2,topThck+fudge],baseRad,0);
          //DC Power Cord holes
          translate([DCPos.x,DCPos.y,(topThck+fudge)/2]) cylinder (d=16,h=topThck+fudge,center=true);
          //Network cable
          translate([RJ45Pos.x,RJ45Pos.y,(topThck+fudge)/2]) rndRect([16,15,topThck+fudge],1,0);
        }
      //HDMI converter screw holes
      //translate([HDMIPos.x,HDMIPos.y,-fudge/2]) linear_extrude(topThck+fudge) rotate(HDMIRot) HDMIConv("drills");
      
      //tap slots sides
      for (ix=[-1,1],iy=[-(tapCounts.y-1)/2:(tapCounts.y-1)/2])
        translate([ix*cntrDims.x/2,iy*tapOffsets.y,topThck/2]) rotate(90) tap(true,[tapWdth,matThck,topThck]);
      //tap slots faces
      for (ix=[-(tapCounts.x-1)/2:(tapCounts.x-1)/2],iy=[-1,1])
        translate([ix*tapOffsets.x,iy*cntrDims.y/2,topThck/2]) tap(true,[tapWdth,matThck,topThck]);
      //drills for standoffs
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*soOffsets.x,iy*soOffsets.y,-fudge/2]) cylinder(d=drillDia,h=topThck+fudge);
    }
  }
  
  *side();  
  module side(){
    sideHght=cntrDims.z+feetHght;
    
    difference(){
      translate([0,-(cntrDims.z-matThck)/2,0]) cube([basePlateDims.y,cntrDims.z-matThck,matThck],true);
      //slots for face-taps
      for (ix=[-1,1])
        translate([ix*(cntrDims.x/2-matThck),-cntrDims.z/2,0]) rotate(90) tap(cutout=true);
    }
    
    //feet
    for (ix=[-1,1])
      translate([ix*(basePlateDims.y-tapWdth)/2,-cntrDims.z,0])
        rndRect([tapWdth,feetHght*2,matThck],baseRad,0);
    //top Taps
    for (ix=[-(tapCounts.y-1)/2:(tapCounts.y-1)/2])
      translate([ix*tapOffsets.y,0,0]) tap(size=[tapWdth,topThck,matThck]);
    //bottom Taps
    for (ix=[-(tapCounts.y-2)/2:(tapCounts.y-2)/2])
      translate([ix*tapOffsets.y,-(cntrDims.z-matThck),0]) rotate(180) tap();
    
      
  }
  
  module face(isfront=true){
    translate([0,-(cntrDims.z-matThck)/2,0]) 
      cube([cntrDims.x-matThck,cntrDims.z-matThck,matThck],true);
    //top taps
    for (ix=[-(tapCounts.x-1)/2:(tapCounts.x-1)/2])
      translate([ix*tapOffsets.x,0,0]) tap(size=[tapWdth,topThck,matThck]);
    //side taps and feet
    for (im=[0,1]) mirror([im,0,0]){ 
      translate([(cntrDims.x-matThck)/2,-cntrDims.z/2,0]) rotate(-90) tap();
      translate([(cntrDims.x-matThck)/2,-cntrDims.z,0])
        difference(){
          rndRect([tapWdth,feetHght*2,matThck],baseRad,0);
          translate([(tapWdth/2+fudge)/2,0,0]) 
            cube([tapWdth/2+fudge,feetHght*2+fudge,matThck+fudge],true);
        }
    }
    //bottom taps
    for (ix=[-(tapCounts.x-2)/2:(tapCounts.x-2)/2])
      translate([ix*tapOffsets.x,-(cntrDims.z-matThck),0]) rotate(180) tap();
  }
  
  module bottom(){
    difference(){
      union(){
        translate([0,0,matThck/2]) cube([baseDims.x-matThck*2,basePlateDims.y,matThck],true);
        for (ix=[-1,1])
          translate([ix*cntrDims.x/2,0,matThck/2])
            rndRect([matThck*5,basePlateDims.y-tapWdth*2,matThck],baseRad,0);
      }
      //tap slots faces
      for (ix=[-(tapCounts.x-2)/2:(tapCounts.x-2)/2],iy=[-1,1])
        translate([ix*tapOffsets.x,iy*cntrDims.y/2,matThck/2]) tap(true);
      //feed slots faces
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(baseDims.x/2-matThck),iy*cntrDims.y/2,matThck/2]) tap(true);
        
      //tap slots sides
      for (ix=[-1,1],iy=[-(tapCounts.y-2)/2:(tapCounts.y-2)/2])
        translate([ix*cntrDims.x/2,iy*tapOffsets.y,matThck/2]) rotate(90) tap(true);
      
      //drills for standoffs
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*soOffsets.x,iy*soOffsets.y,-fudge/2]) cylinder(d=drillDia,h=matThck+fudge);
    } 
  }//bottom
  
  module beamX(height=20, cut=false){
    //horizontal beam
    if (cut)
      for (ix=[-1,1])
        translate([ix*(cntrDims.x)/2,-height/2,0]) rotate([90,0,90]) 
          tap(size=[height-matThck*4,matThck,matThck],cutout=true);
        
    else translate([0,-height/2,0]){
      cube([cntrDims.x-matThck,height,matThck],true);
    for (ix=[-1,1])
      translate([ix*(cntrDims.x-matThck)/2,0,0]) rotate(ix*-90) 
        tap(size=[height-matThck*4,matThck,matThck]);
    }
  }
  
  //free beam
 *beam(cut=false);
  module beam(size=[100,20,matThck], cut=false){
    if (cut)
      for (ix=[-1,1])
        translate([ix*(size.x+matThck)/2,0,0]) rotate([90,0,90]) 
          tap(size=[size.y-matThck*4,matThck,size.z],cutout=true);
        
    else {
      cube([size.x,size.y,size.z],true);
      for (ix=[-1,1])
        translate([ix*size.x/2,0,0]) rotate(ix*-90) 
          tap(size=[size.y-matThck*4,matThck,size.z]);
    }
  }//beam
  
  //intermediate Floor
  *iFloor(cutout=false);
  module iFloor(size=[150,50,matThck],cutout=false){
    
    //preset tap Width is minimum tap width
    tapCountCalc=floor(size.x/tapWdth); //how many of half sized (gaps+taps)
    tapCount= (tapCountCalc<=2) ? 2 : tapCountCalc; //minimum of 2 taps
    maxTapWdth = size.x/(tapCount*2-1); //recalc tap width to fit
    
    if (cutout)
      for (ix=[-(tapCount-1)/2:(tapCount-1)/2],iy=[-1,1])
        translate([ix*maxTapWdth*2,iy*((size.y+matThck)/2),matThck/2]) rotate([90,0,0]) 
          tap(size=[maxTapWdth,matThck,matThck],cutout=true);
    
    else {
      translate([0,0,size.z/2]) cube(size,center=true);
    
      // taps
      for (ix=[-(tapCount-1)/2:(tapCount-1)/2],iy=[-1,1])
        translate([ix*maxTapWdth*2,iy*(size.y/2),matThck/2]) rotate(90-iy*90) 
          tap(size=[maxTapWdth,matThck,matThck]);
    }      
  }
  
  module tap(cutout=false, size=[tapWdth,matThck,matThck]){
    if (cutout){
      cube([size.x-kerf*2,size.y-kerf*2,size.z+fudge],true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-kerf),iy*(size.y/2-kerf),0]) 
          cylinder(d=0.5,h=size.z+fudge,center=true);
    }
    else
      difference(){
        rndRect([size.x,size.y*2,size.z],1,0);
        translate([0,-(size.y+fudge)/2,0]) 
          cube([size.x+fudge,size.y+fudge,size.z+fudge],true);
      }
  }
  
  
  
  
  module stand3D(HDMI=true){
    
    cntrOffset=[cntrDims.x/2,-cntrDims.y/2,0];
    
    difference(){
      body();
      translate([-soOffsets.x,soOffsets.y,0]+cntrOffset){
        translate([0,0,-matThck]) cylinder(d=3.2,h=matThck+fudge);
        translate([0,0,-baseHght]) cylinder(d=8,h=baseHght-matThck+fudge);
    }
    }
    
      
    module body(){
      cntrDia=20;
      tipDia=10;
      dist=tapWdth*1.5;
      
      //taps
      translate([-(tapCounts.x-1)/2*tapOffsets.x+cntrOffset.x,0,0]) 
        rotate([90,0,0]) tap(size=[tapWdth,topThck,matThck]);
      translate([0,-((tapCounts.y+1)/2*tapOffsets.y)-cntrOffset.y,0]) 
        rotate([90,0,90]) tap(size=[tapWdth,topThck,matThck]);
      
      //front
      hull(){
        translate([dist,0,0]) halfSphere(d=tipDia);
        translate([0,0,-baseHght+5/2]) sphere(d=tipDia);
      }
      //back
      hull(){
        translate([0,-dist,0]) halfSphere(d=tipDia);
        translate([0,0,-baseHght+5/2]) sphere(d=tipDia);
      }
      //edge
      hull(){
        halfSphere(d=cntrDia);
        translate([0,0,-baseHght+5/2]) sphere(d=tipDia);
      }
      hull(){
        halfSphere(d=cntrDia);
        translate([dist,0,0]) halfSphere(d=tipDia);
        translate([0,-dist,0]) halfSphere(d=tipDia);
      }
        
    }    
    
  }
  
}

// iMX8 MEK Board
module iMX8_PCB(cutOut=false){
  crnRad=1;
  drillOffset=[4,4];
  xDrillOffset=[4,24.4];
  pcbDims=[133,133,1.6];

  iPassHV=[23.8,14.68];
  iPassPos=[-41.8,45.5,pcbDims.z];
  KPJXPos=[56.5,-pcbDims.y/2,pcbDims.z];
  SDCardPos=[-11.3,-pcbDims.y/2+1.3,pcbDims.z];
  RJ45Pos=[-37.1,-pcbDims.y/2,pcbDims.z];
  mUSBPos=[-52.8,-pcbDims.y/2,pcbDims.z];
  USBCPos=[12.2,-pcbDims.y/2,pcbDims.z];
  //status LEDs
  stLEDPos=[[65,29.5],[65,29.5+1.9],[65,29.5+1.9+1.8],[65,29.5+1.9+1.8+2],[65,29.5+1.9*2+1.8+2]];
  //power LEDs [x,y,rot]
  pwrLEDPos=[[36.2,-23.4,90],[50.4,-23.9,90],[64.9,-23.8,90],[65.3,-25.5,0]];
  hsinkPos=[-3.2,-6.35,3+pcbDims.z];
  
  //panel cutout
  cutBrim=1;
  cutDims=[pcbDims.x-cutBrim,pcbDims.y-cutBrim];
  cutRad=4;
  
  
  if (cutOut)
      difference(){
        //linear_extrude(matThck+fudge) 
          rndRect(cutDims,cutRad,0);
        // mounting taps
        for (i=[[-1,-1],[-1,1],[1,1]])
          translate([i.x*cutDims.x/2,i.y*cutDims.y/2])
            difference(){
              rndRect([16,16],cutRad,0);
              translate([i.x*(cutBrim/2-4),i.y*(cutBrim/2-4)]) 
                circle(d=drillDia);
            }
        translate([pcbDims.x/2,-pcbDims.y/2+xDrillOffset.y])
          difference(){
            rndRect([16,8],cutRad,0);
            translate([-4,0,-(matThck+fudge)/2]) circle(d=drillDia);
          }
      }
    
  else{
    color("darkgreen") linear_extrude(pcbDims.z) difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(pcbDims.x/2-crnRad),iy*(pcbDims.y/2-crnRad)]) circle(crnRad);
      //drills
      for (i=[[-1,-1],[-1,1],[1,1]])
        translate([i.x*(pcbDims.x/2-drillOffset.x),i.y*(pcbDims.y/2-drillOffset.y)]) 
          circle(d=drillDia);
      translate([pcbDims.x/2-drillOffset.x,-pcbDims.y/2+xDrillOffset.y]) circle(d=drillDia);
    }
    translate(iPassPos) for (ix=[0:3],iy=[0:1])
      translate([ix*iPassHV.x,iy*iPassHV.y,0]) mlx_iPass();
    translate(KPJXPos) KPJXHT();
    translate(SDCardPos) SDCard();
    //Status LEDs
    color("ivory")  for (pos=stLEDPos)
      translate([pos.x,pos.y,pcbDims.z]) linear_extrude(1) square([1.7,0.9],true);
    //Power LEDs
    for (pos=pwrLEDPos) color("ivory")
      translate([pos.x,pos.y,pcbDims.z]) rotate(pos.z) linear_extrude(1) square([1.7,0.9],true);
    translate(RJ45Pos) RJ45();
    translate(mUSBPos) mUSB();
    translate(USBCPos) USBC();
    translate(hsinkPos) heatsink();
  }
}

*mlx_iPass();
module mlx_iPass(){
  ovDims=[17.8,8.72,20.18];
  color("brown") translate([0,0,ovDims.z/2]) cube(ovDims,center=true);
}

*KPJXHT();
module KPJXHT(){
  color("grey") translate([-7.5,0,0]) rotate([90,0,0]) import("KPJXHT.stl");
}

*SDCard();
module SDCard(){
  ovDims=[27.1,17,3.1];
  polys=[[-ovDims.x/2,0],[ovDims.x/2,0],
         [ovDims.x/2,9.3],[ovDims.x/2-2.7,11.3],
         [ovDims.x/2-2.7,ovDims.y],[-ovDims.x/2,ovDims.y]];
  color("silver") linear_extrude(ovDims.z) polygon(polys);
  //SDCard
  color("darkblue") translate([0,-19/2,3.1/2]) cube([24.5,19,2.1],true);
}

module RJ45(){
  color("silver") translate([-15.9/2,0,0]) cube([15.9,21.84,14]);
}

module mUSB(){
  color("silver") translate([-7.2/2,-1.55,0]) cube([7.2,6,4]);
}

module USBC(){
  color("silver") translate([-9/2,-0.55,0]) cube([9,8.3,4]);
}
*heatsink();
module heatsink(){
  bodyDims=[44.8,44.8,9.3];
  color("darkslategrey") difference(){
    translate([0,0,9.3/2]) cube(bodyDims,true);
    translate([0,0,2]) cylinder(d=42,h=bodyDims.z);
  }
  color("grey") translate([0,0,3]) cylinder(d=40,h=11.25-3);
}





// Flyht Pro 12U case
module case12U(){
  //FlyhtPro 27202
  //https://images.static-thomann.de/pics/atg/atgdata/file/diagram/392419_12he_l_rack_tz.pdf
  
  bdDims=[508,503,695]; //outer Dims
  cvrDims=[508,569,78];
  
  hdRoom=95; //space between toprail and cover
  matThck=10;
  topRailLngth=446;
  topRailsOffset=[bdDims.x/2-matThck,-bdDims.y/2+(bdDims.y-topRailLngth)/2,bdDims.z-hdRoom+cvrDims.z-matThck];
  
  //body
  color("darkslategrey") body();
  
  
  //rails
  for (m=[0,1])
  color("silver") 
   mirror([m,0,0])
    translate(topRailsOffset) 
       railProfile(topRailLngth);
  
  module body(){
    for (ix=[-1,1])
      translate([ix*(bdDims.x-matThck)/2,0,bdDims.z/2]) cube([matThck,bdDims.y,bdDims.z],true);
      translate([0,0,matThck/2]) cube([bdDims.x-matThck*2,bdDims.y,matThck],true);
      translate([0,(bdDims.y-matThck)/2,(bdDims.z+matThck)/2]) 
      cube([bdDims.x-matThck*2,matThck,bdDims.z-matThck],true);
  }
  
  module railProfile(length){
    translate([0,length,-31.5]) rotate([90,-90,0]) linear_extrude(length) union(){
      square([20,2.5]);
      translate([20-2.5,0]) square([2.5,25]);
      translate([20-2.5,25-2.5]) square([14,2.5]);
      translate([20-2.5,10]) square([14,2.5]);
      translate([31.5-1.5,0]) square([1.5,10]);
    }
  }
}

module standOff(threat=3, lngth=20,H=6, P1=6,){
  //https://www.el2-tostedt.de/wordpress/wp-content/uploads/2019/03/el2_distanzbolzen.pdf
  //H= (threat>3) ? (threat>4) ? 8 : 7 : 5;
  
  difference(){
    cylinder(d=H,h=lngth,$fn=6);
    translate([0,0,-fudge]) cylinder(d=3,h=6);
  }
  translate([0,0,lngth]) cylinder(d=threat,h=P1);
}

*HDMIConv();
module HDMIConv(cut="none"){
  poly=[[-18,0],[18,0],[18,50],[10,63.2],[-10,63.2],[-18,50]];
  screwDims=[28.3,42.5];
  screwYOffset=3.4;
  
  if (cut=="drills")
    for (ix=[-1,1],iy=[0,1])
      translate([ix*screwDims.x/2,screwYOffset+iy*screwDims.y]) circle(d=drillDia);

  else{
    color("darkslategrey") linear_extrude(1.6) difference(){
      polygon(poly);
      if (cut!="body") for (ix=[-1,1],iy=[0,1])
        translate([ix*screwDims.x/2,screwYOffset+iy*screwDims.y]) circle(d=3.2);
    }
    color("silver"){
      translate([-15.2/2,0,1.6]) cube([15.2,9.1,6.4]);
      translate([-18.4/2,63.2-25.5,1.6]) cube([18.4,25.5,8]);
    }
    
  }
}




*iMXPowerBrick(true);
module iMXPowerBrick(cutout=false){
  ovDims=PBrickDims;
  //cutouts
  if (cutout){
    translate([(ovDims.x)/2+matThck,0,ovDims.z/2]) 
      rotate([0,90,0]) rndRect([20,28,matThck*2+fudge],3,0,true);
    translate([-(ovDims.x-fudge)/2,0,ovDims.z/2]) rotate([0,-90,0])
      cylinder(d=15,h=matThck*2+fudge);
  }
  else{
  //brick
  difference(){
    translate([0,0,ovDims.z/2]) cube(ovDims,true);
    translate([(ovDims.x-17)/2,0,ovDims.z/2]) cube([17+fudge,24,16],true);
  }
  //DC cord
  translate([-ovDims.x/2,0,ovDims.z/2]) rotate([0,-90,0]){
    cylinder(d1=13,d2=10,h=25);
    cylinder(d=6,h=110);
    translate([0,0,56]) cylinder(d=22,h=35);
  }
}
}

*RSP320();
module RSP320(cut="none"){
  //Mean Well AC/DC converter
  //https://www.reichelt.de/schaltnetzteil-geschlossen-320-w-12-v-26-7-a-mw-rsp-320-12-p147898.html?&nbc=1
 
  ovDims=RSPDims;
  fanDia=60;
  
  if (cut=="drills")
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*150/2,iy*ovDims.y/2,12.5]) rotate([90,0,0]) cylinder(d=4.1,h=10,center=true);
  else if (cut=="fan")
    translate([ovDims.x/2-47.45,ovDims.y/2-36.7,ovDims.z]) cylinder(d=fanDia,h=10);
  else
  difference(){
    color("silver") translate([0,0,ovDims.z/2]) cube(ovDims,true);
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*150/2,iy*ovDims.y/2,12.5]) rotate([90,0,0]) cylinder(d=4,h=10,center=true);
    color("darkslategrey") translate([ovDims.x/2-47.45,ovDims.y/2-36.7,ovDims.z-1]) cylinder(d=fanDia,h=1+fudge);
  }
}

*RS15();
module RS15(cut="none"){
  //https://www.reichelt.de/schaltnetzteil-geschlossen-15-w-5-v-3-a-snt-rs-15-5-p137080.html
  //Dimensions of Clamp Block (estimated)
  clampDims=[13,7.62*5,RS15Dims.z/3];
  
  if (cut=="drills")
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*39.1/2,iy*RS15Dims.y/2,15.1]) rotate([90,0,0]) cylinder(d=3.1,h=10,center=true);
  else {
    difference(){
      color("silver") translate([0,0,RS15Dims.z/2]) cube(RS15Dims,true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*39.1/2,iy*RS15Dims.y/2,15.1]) rotate([90,0,0]) cylinder(d=3,h=10,center=true);
    }
    color("darkSlateGrey") translate([-(RS15Dims.x+clampDims.x)/2,0,RS15Dims.z*0.4]) 
      cube(clampDims,true);
  }
}

*usbHUB();
module USBHub(){
  ovDims=[152.4,59.5,23.2];
  
  flngDims=[(178.4-ovDims.x)/2,ovDims.y,1];
  translate([0,0,ovDims.z/2]) cube(ovDims,true);
  //flanges
  for (ix=[-1,1])
    translate([ix*(ovDims.x+flngDims.x)/2,0,0]) flng();
  
  module flng(){
    linear_extrude(1) difference(){
      square([flngDims.x,flngDims.y],true);
      for (iy=[-1,1])
        translate([0,iy*25/2]) circle(2.1);
      hull() for (iy=[-1,1])
        translate([0,iy*13.5/2]) circle(1.75);
      circle(3.5);
    }
  }
}

module RPi4(cutout="none"){
  
}

*kStone6(true);
module kStone6(cutout=false){
  //https://www.reichelt.de/keystone-halterung-6-port-panel-delock-86274-p157624.html
  ovDims=[130,29.3,19.8];
  clipDist=118;
  clipDia=4;
  portDims=[14.9,19.2];
  portDist=17;
  wallThck=2;
  cutOutDims=[108,29.3,matThck*2];

  if (cutout){
    for (ix=[-1,1])
        translate([ix*clipDist/2,0,-(matThck)/2]) cylinder(d=clipDia+fudge,h=matThck+fudge,center=true);
    translate([0,0,-ovDims.z/2+wallThck/2]) cube([cutOutDims.x+fudge,cutOutDims.y+fudge,ovDims.z-wallThck+fudge],true);
  }
  else
    color("darkSlateGrey") translate([0,0,wallThck/2]) difference(){
      union(){
        rndRect([ovDims.x,ovDims.y,wallThck],3);
        translate([0,0,-ovDims.z/2]) cube([cutOutDims.x,cutOutDims.y,ovDims.z-wallThck],true);
      }
      for (ix=[-1,1])
        translate([ix*clipDist/2,0,0]) cylinder(d=clipDia,h=wallThck+fudge,center=true);
      for (ix=[-2.5:2.5])
        translate([ix*portDist,0,-(ovDims.z-wallThck)/2]) cube([portDims.x,portDims.y,ovDims.z+fudge],true);
    }
}
module halfSphere(d=10){
  difference(){
    sphere(d=d);
    translate([0,0,(d+fudge)/2]) cube(d+fudge,true);
  }
}

// wago Clamps sub-assembly

*buildWagoAssy(["single","single","single"],
               ["lightBlue","lightBlue","lightBlue"]);

module buildWagoAssy(modules=[],colors=["none"],cutOut=false,dist=0,iter=0){
  //WAGO clamps Series 261
  dblDist=10;
  snglDist=6;
  capDist=2.5;
  colCnt=len(colors);
  modCnt=len(modules);
  drillOffset=2.8;
  
  curDist= (iter) ? (modules[iter-1]=="single") ? (dist+snglDist) : (dist+dblDist) : 0;
  curCol= (colCnt==modCnt) ? colors[iter] : "grey";
  drillDist= curDist+capDist+drillOffset*2;
  
  if (iter<len(modules)){
    if (!cutOut){
      if (modules[iter]=="single")
        color(curCol) translate([curDist,0,0]) single();
      else //double
        color(curCol) translate([curDist,0,0]) double();
    }
    buildWagoAssy(modules,colors,cutOut,curDist,iter+1);
  }
  else if (!cutOut)
    color("grey") endCap();
  else 
    for (ix=[-1,1])
      translate([(ix+1)*drillDist/2-capDist-drillOffset,0,-matThck-fudge/2]) 
        cylinder(d=3.2-kerf,h=matThck+fudge);
    
  module double(){
    translate([0,0,1.2]) rotate([90,0,90]) import("261-336.stl");
  }
  module single(){
    translate([0,0,1.2]) rotate([90,0,90]) import("261-303.stl");
  }
  module endCap(){
    rotate([90,0,-90]) import("261-361.stl");
  }
}

*relaisBoard();
module relaisBoard(){
  //DEBO 8-channel relais board
//https://www.reichelt.de/entwicklerboards-relais-modul-8-channel-5-v-srd-05vdc-sl-c-debo-relais-8ch-p242814.html
  pcbDims=[relBrdDims.x,relBrdDims.y,1.6];
  relDims=[14.9,18.6,15.2];
  relDist=130.5/8;
  clmpOutDims=[15.2,7.5,9.5];
  clmpInDims=[50,7.5,9.5];
  
  //PCB
  color("crimson") translate([0,0,1.6/2]) rndRect(pcbDims,5.5,3.1);
  //Relais
  color("blue")
  for (ix=[-(130.5-relDist)/2:relDist:(130.5-relDist)/2])
    translate([ix,(pcbDims.y+relDims.y)/2-26.4-2.7,relDims.z/2+1.6]) cube(relDims,true);
  //clamps OUT
  for (ix=[-(130.5-relDist)/2:relDist:(130.5-relDist)/2])
    translate([ix,(pcbDims.y-clmpOutDims.y)/2-2.7,clmpOutDims.z/2+1.6]) cube(clmpOutDims,true);
  //clamp IN
  translate([0,-(pcbDims.y-clmpInDims.y)/2+2.7,clmpInDims.z/2+1.6]) cube(clmpInDims,true);
}

module wiringDuct6040(length=100, center=false){
  //Wiring Duct width=40, height=60
  //https://www.reichelt.de/wiring-duct-60x40-mm-1000-mm-v6k6040-p275692.html
  cube([length,40,60],center=center);
}

*powerInlet(true);

module powerInlet(cutout=false){
  // Power Inlet with Fuse
  //https://cdn-reichelt.de/documents/datenblatt/C190/42R321111.pdf
  plateDims=[44,34,3];
  bdyDims=[27,31,19-3];
  cutDims=[27.5,31.5,matThck+fudge];
  drillDist=36;
  drillDia=3.1;
  
  if (cutout){
    translate([0,0,-matThck/2]) rndRect(cutDims,2.5,0);
    for (ix=[-1,1])
        translate([ix*drillDist/2,0,-matThck/2]) 
          cylinder(d=drillDia,h=plateDims.z+fudge,center=true);
  }
  else{
    difference(){
      translate([0,0,plateDims.z/2]) cube(plateDims,true);
      for (ix=[-1,1])
        translate([ix*drillDist/2,0,-fudge/2]) cylinder(d=drillDia,h=plateDims.z+fudge);
    }
    translate([0,0,-bdyDims.z/2]) cube(bdyDims,true);
  }    
}

module rndRect(size, rad, drill=0, center=true){  
  if (len(size)==2) //2D shape
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(d=drill);
    }
  else
    
    linear_extrude(size.z,center=center) 
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(d=drill);
    }
}

