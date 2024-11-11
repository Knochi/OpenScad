use  <TestProbes.scad>
//use <rndRect.scad>
use <rndRect2.scad>
use <boxHeader.scad>
use <Getriebe.scad>

//pi = 3.14159;

//use <CanWud.scad>

/*
TODO:
- add locking mechanism
- add rack'n'Pinion for securing PCB
- make it really screwless!
- use PCBThick for probeZOffset - done!

CHECK:
KerfCalc(screw/-less)|  MatThick != 3
---------------------+-----------------
Sides
PressPlate
Levers
Base
PivotAxis
pvtSidePlt  (OK/nOK)
Crossbars   (OK/OK)
*/



/* ---- [Dimensions] ---- */

PCBLength = 27.5;
PCBWidth= 15;
//PCB Thickness
PCBThick = 1.5; 

probePositions= [[7.4, 2.2], [4.9, 2.2], [2.7, 7.3], [2.7, 9.8], [2.7, 12.3], //PCB Probes
                 [17, 4.5], [17, 8.5], [17, 10.5], //Connector probes (shifted by 1.2mm)
                 [18.235, 1]]; //dummy probe to keep CenterOfMass at same place
probeSeries="RSPro19"; //["S27","RSPro19"]
//Material Thickness
matThck=2.6;  

//maximum opening Angle
maxAngle=30; 

//Kerf of the Laser Cutter
kerf=0.15; 

//Pins of boxed Header
connPins = 6;

/* ---- [Show] ---- */
expPart="none"; // ["none","Base","PressPlate","Levers","Sides","PivotAxis","CrossBars"]
showPCB = true;
showSides = true;
showPressPlate = true;
showLevers = true;
showBase = true;
showPivotAxis = true;
showCrossBar = true;
showConnector = false;
showTestProbes=true;
leverRotation = 0; // [0:0.5:30]
debugVerts = false;
showDebug = false;

//rack and Pinion Test
showGears =false; 

//locking mechanism Test
showLocking = true;


/* ---- [ShowLayers] ---- */

showLayer0 = true;
locked = true;
showLayer1 = true;
showLayer2 = true;

/* ---- [Advanced] ---- */

screwLess=false;
//take x-Distribution of test needles into account for Position of cam
balancePlate=true; 

rackPinion=false;
//add spring to basePlate and nuckle to Lever
springLock=false;


/* ---- [Hidden] ---- */
$fn=50;

// PCB
PCBYClrnc=matThck*3; //clearance between PCB and side Walls
PCBOffsetMin=40;
PCBOffsetFix=40; //Fix Offset of PCB-Zero to Pivot
PCBOffsetCntr= PCBOffsetFix + PCBLength/2; //Offset from Pivot to PCB center

// --- Probes ---
probeZOffset= (probeSeries == "S27") ? 12.15 - matThck/2 + PCBThick :  //Offset with typ travel
              (probeSeries == "RSPro19") ? 3.4 - matThck/2 + PCBThick : 0; //Offset with typ travel

probesFromTop= (probeZOffset > matThck*3) ? true : false; //insert probes from below if probeZOffset to small

probeDrillDia=(probeSeries == "S27") ? 2.3 :  //Offset with typ travel
              (probeSeries == "RSPro19") ? 1.3 : 0;  //Drill Diameter for probes
probesCnt= len(probePositions);





// -- PressPlate Dimensions and Position

pPlateLength=lengthFromCoords(probePositions)+matThck*2;

//calculate Offset from CenterOf mass
pPlateOffCntr=(balancePlate) ? centerOfMass(probePositions,len(probePositions)-1)-lengthFromCoords(probePositions)/2 : 0;

pPlateXOffset=pPlateLength/2+PCBOffsetFix+xyMin(probePositions,len(probePositions)).x-matThck+pPlateOffCntr;

//Positions from lever rotation
hRot = heightFromAngle(leverRotation,pPlateXOffset,maxAngle);
pPlateZOffset=(probesFromTop) ? (probeZOffset+  hRot) : (probeZOffset+  hRot) + matThck*2;

// --- Pivot Axis ---

//Limit Z Offset of Pivot Point
//pivotZOffsetMin = matThck*2.5;// matThck*3-matThck/2;
pivotZOffset= (probesFromTop) ? probeZOffset-matThck/2 : probeZOffset+matThck*1.5;
pivotDrill=matThck*(1/sqrt(2))-kerf; //circumscribe circleh

// -- Lever --
leverLengthMin=PCBOffsetFix+PCBLength+2*matThck;
leverLengthPlate=(pPlateXOffset+pPlateLength/2-pPlateOffCntr+matThck*2)/cos(maxAngle);
leverLength= (leverLengthPlate<leverLengthMin) ? leverLengthMin : leverLengthPlate; //decide which length to take
leverYOffset=(PCBWidth+matThck+PCBYClrnc*2)/2+matThck;
leverHght=pivotZOffset*2-matThck; //is limited as to (matThck*3-matThck/2)*2-matThck=matThck*4



if (showDebug) color("red") translate([pPlateXOffset,0,pivotZOffset+matThck/2]) sphere(1);
            

echo("lever Height",leverHght);
ovWidth=PCBWidth+PCBYClrnc*2+matThck*8;

fudge=0.1;
if (showLocking){
  lock();  
}
module lock(){
  //second try.. add lock to the very end of lever
 
  rad=1;
}


if (showGears){
  //TODO: write function to calculate Mod and teeth from dia and matthck (df,da,and db)
  teeth=14;
  cstmMod=dist2Mod(pivotZOffset+matThck/2,teeth);
  
  mx=pi*cstmMod;//*(1-0.05); //Teilung unter berücksichtigung von Spiel 0.05
  
  rb=cos(20)*cstmMod * teeth /2; //grundkreisradius
  rackPinDist=cstmMod * teeth /2;
  xOffset=(2*pi*rackPinDist)/360*leverRotation;
  rackZOffset=pivotZOffset-rackPinDist;
  rackHght=pivotZOffset+matThck*2.5-rackPinDist;
  echo("mx",mx*4);
  
  
  //-- create two rack-pistons and two pinions
  for (i=[-1,1]){
    color("seaGreen") translate([0,i*leverYOffset+matThck/2,pivotZOffset]) rotate([90,-leverRotation+90,0]) 
      stirnrad(modul=cstmMod, zahnzahl=teeth, breite=matThck+fudge, bohrung=6, eingriffswinkel=20, schraegungswinkel=0, optimiert=false);
    color("darkOliveGreen") translate([xOffset,i*leverYOffset,0]) union(){
      translate([0,matThck/2,rackZOffset])
      rotate([90,0,0]) zahnstange(modul=cstmMod, laenge=mx*4, hoehe=rackHght, breite=matThck, eingriffswinkel=20, schraegungswinkel=0);
      translate([mx*1.5,-matThck/2,-matThck*2.5]) cube([pPlateXOffset-mx*1.5,matThck,matThck]);
      translate([pPlateXOffset,matThck/2,-matThck*1.5]) rotate([90,0,0]) rndRect(center=true,[matThck,matThck*2,matThck],1,0);
    }
  }
  
  // -- and a pusher plate --
  color("OliveDrab") translate([xOffset,0,0]) difference(){
    union(){
      translate([pPlateXOffset,0,-matThck*1.5]) rndRect(center=true,[matThck*3,leverYOffset*2+matThck],matThck,2,0);
      translate([PCBOffsetCntr+matThck,0,-matThck*1.5]) rndRect(center=true,[PCBLength+matThck*2,PCBWidth+matThck*2.5,matThck],2,0);
    }
    translate([PCBOffsetCntr-fudge,0,-matThck]) cube([PCBLength+fudge,PCBWidth+matThck,matThck+fudge],true);
    
      
    for (i=[-1,1]){
      translate([pPlateXOffset,i*leverYOffset,-matThck]) cube(matThck+fudge,true);
      translate([PCBOffsetCntr+PCBLength/2+matThck,i*(PCBWidth+matThck)/2,-matThck]) cylinder(d=2.0,h=matThck+fudge,center=true);
    }
  }
  
  // -- with a spring pusher --
  color("Olive") translate([xOffset+PCBOffsetCntr+PCBLength/2+matThck,0,-matThck/2]){
    difference(){
      rndRect(center=true,[matThck*2,PCBWidth+matThck*2.5,matThck],2,0);
      translate([-matThck+2,0,0]) rndRect(center=true,[2,PCBWidth,matThck+fudge],2,0);
      translate([-matThck+0.5,0,matThck/2]) cube(matThck+fudge,true);
      translate([0,(PCBWidth+matThck)/2,matThck/2]) cylinder(d=2.5,h=matThck+fudge,center=true);
      translate([0,-(PCBWidth+matThck)/2,matThck/2]) cylinder(d=2.5,h=matThck+fudge,center=true);
    }
    translate([-matThck+0.5,matThck/2,0]) cylinder(d=2,h=matThck);
    translate([-matThck+0.5,-matThck/2,0]) cylinder(d=2,h=matThck);
  }
}

if (showDebug) {
  echo("height from Rotation:", hRot); 
}
  
//--- draw Pressplate ---
if (showPressPlate || (expPart=="PressPlate"))

translate([pPlateXOffset,0,pPlateZOffset]) {
  pressPlate(pPlateLength,PCBWidth+PCBYClrnc*2,probePositions,pPlateOffCntr);
}

if (showTestProbes){
  for (pos=probePositions){
    if (probeSeries=="S27") translate([PCBOffsetFix+pos.x,-PCBWidth/2+pos.y,probeZOffset+hRot]) Series_S27(travel="typ"); 
    if (probeSeries=="RSPro19") translate([PCBOffsetFix+pos.x,-PCBWidth/2+pos.y,probeZOffset+hRot]) RSPro19(travel="typ");
  }
}

//--- draw PCB ---
if (showPCB){
  
  translate([PCBOffsetCntr,0,PCBThick-matThck/2])
    PCB(PCBWidth,PCBLength,PCBThick);
  for (pos=probePositions)
      color("gold") translate([PCBOffsetFix+pos.x,-PCBWidth/2+pos.y,PCBThick-matThck/2]) cylinder(d=1,h=0.05);
}


//--- draw levers ---

if (expPart=="Levers"){
 !projection(){
    translate([0,-leverHght,0]) rotate([90,0,0]) lever(leverHght, leverLength);
    translate([0,+leverHght,0]) rotate([-90,0,0]) lever(leverHght, leverLength);
 }
}
else if(showLevers){
color("grey") 
  translate([0,leverYOffset,pivotZOffset]) 
    rotate([0,-leverRotation,0]) lever(leverHght,leverLength);

color("grey") 
  translate([0,-leverYOffset,pivotZOffset]) 
    rotate([0,-leverRotation,0]) lever(leverHght,leverLength);
}


//--- draw crossbar ---
if (expPart == "CrossBars") {
  !projection(){
    translate([0,matThck*2.5,0]) crossBar(showLocking);
    translate([0,-matThck*2.5,0]) 
    difference(){
      crossBar();
      translate([0,0,-(matThck+fudge)/2]) 
            linear_extrude(matThck+fudge,convexity=2) 
              boxHeader(connPins, shape="lockings");
  }
}
}
else if (showCrossBar) {
  
  translate([0,0,pivotZOffset]){
  rotate([0,maxAngle-leverRotation,0]) 
    translate([-leverHght*0.75,0,0])
      rotate([-90,0,90]) {
      difference(){
        crossBar();  
          translate([0,0,-(matThck+fudge)/2]) 
            linear_extrude(matThck+fudge,convexity=2) 
              boxHeader(connPins, shape="lockings");
        }
        if (showConnector) translate([0,0,-matThck*1.5]) boxHeader(connPins,zOffset="bottom");
    }
    
      rotate([0,-leverRotation,0])
      translate([leverLength,0,0]) rotate([0,0,90]) crossBar(showLocking); //handle cross bar
    
  }
}

// --- draw sides ---
slotHeight= heightFromAngle(maxAngle,pPlateXOffset,maxAngle)+matThck*2;

if (expPart=="Sides") {
  !projection(){
  translate([-pPlateXOffset/2,-matThck*2,0]) rotate([90,0,0])
    sidePlate(pivotZOffset,slotHeight,pPlateXOffset);
  translate([-pPlateXOffset/2,matThck*2,0]) rotate([-90,0,0])
    sidePlate(pivotZOffset,slotHeight,pPlateXOffset);
  }
}
else if (showSides){
color("orange")
  translate([0,-leverYOffset+matThck,0])
    sidePlate(pivotZOffset,slotHeight,pPlateXOffset);
color("orange")
  translate([0,leverYOffset-matThck,0])
    sidePlate(pivotZOffset,slotHeight,pPlateXOffset);
}



// --- draw layers ---
if (showBase) base();

// --- draw pivotAxis and plates --

if (expPart=="PivotAxis"){
  !projection(){
    rotate([0,90,0]) pivotAxis(pivotZOffset);
    translate([pivotZOffset+matThck*2,(leverHght+matThck/2)/2,0]) rotate([90,0,0]) pivotPlate(pivotZOffset);
    translate([pivotZOffset+matThck*2,-(leverHght+matThck/2)/2,0]) rotate([-90,0,0]) pivotPlate(pivotZOffset);
  }
}
else if (showPivotAxis){
  color("purple")
  translate([0,0,pivotZOffset]) pivotAxis(pivotZOffset);
  translate([0,-leverYOffset-matThck,pivotZOffset]) pivotPlate(pivotZOffset);
  translate([0,(leverYOffset+matThck),pivotZOffset]) pivotPlate(pivotZOffset);
}

//plate to hold levers on pivotaxis
module pivotPlate(height) {
  ovLength=leverHght/2+matThck+PCBLength+PCBOffsetFix;
  baseXOffset=ovLength/2-leverHght/2-matThck;
  
  if (screwLess) {
    
    difference(){
      union(){
        translate([baseXOffset,0,-height-matThck]) rotate([90,0,0]) rndRect(center=true,[ovLength,matThck*5,matThck],1,0);
        rotate([90,0,0]) cylinder(d=leverHght,h=matThck,center=true);
        translate([0,0,-(height-matThck/2)/2]) cube([leverHght,matThck,height-matThck/2],true);
      }
      translate([baseXOffset,0,-height-matThck]){ 
        cube([ovLength-matThck*2-kerf,matThck+fudge,matThck*3-kerf],true);
        for (i=[-1,1],j=[-1,1]) //stress release
          translate([i*(ovLength/2-kerf/2-matThck),(matThck+fudge)/2,j*(matThck*3-kerf)/2]) rotate([90,0,0]) cylinder(d=0.5,h=matThck+fudge);
      }
      cube([matThck-kerf*2,matThck+fudge,matThck-kerf*2],true); //receptor for pivotaxis
   }
  }
  else {
    difference(){
      union(){
        rotate([90,0,0]) cylinder(d=leverHght,h=matThck,center=true);
        translate([0,0,-(height+matThck*1.5)/2]) cube([leverHght,matThck,height+matThck*1.5],true);
      }
      translate([-(leverHght-matThck+fudge)/2,0,-height+kerf/2]) cube([matThck+fudge,matThck+fudge,matThck-kerf],true); //nudge for locking
      cube([matThck-kerf*2,matThck+fudge,matThck-kerf*2],true); //receptor for pivotaxis
    }  
  }
}

module pivotAxis(height){
  rad=matThck/4;
  
  difference(){
    union(){
      rotate([0,90,0]) 
        rndRect(center=true,[matThck,ovWidth-matThck*2-fudge*2,matThck],rad,0);
      translate([0,0,-matThck/2]) rotate([0,90,0]) 
        rndRect(center=true,[matThck*2,ovWidth-matThck*6-fudge*2,matThck],rad,0);
      translate([0,0,-(height-matThck)/2-matThck]) rotate([0,90,0]) 
        rndRect(center=true,[height+matThck*2,ovWidth-matThck*8,matThck],rad,0); //main body
    }
    translate([0,0,-height+kerf/2]) cube([matThck+fudge,PCBWidth,matThck-kerf],true); //nudge for locking
    cube([matThck+fudge,(connPins/2+1)*2.54,2.54*3],true); //nudge for connector
  }
}

module base(){
  //radius for rounded edges
  rad=matThck/4;
  
  leftLength=leverHght/2+matThck; //distance from pivot center to left edge
  
  ovLengthPre= leftLength+PCBLength+PCBOffsetFix;
  ovLength= (screwLess) ? ovLengthPre-matThck*2 : ovLengthPre;//+kerf;
  
  //ovOffset=[PCBLength*0.75-(matThck*3.5)/2,0,-matThck/2]; //offset from Pivot to base center
  ovOffsetPre=[ovLength/2-leftLength,0,0]; //offset from Pivot to base center
  ovOffset = (screwLess) ? ovOffsetPre+[matThck,0,0] : ovOffsetPre;
  
  drillOffset=[matThck/2,matThck*4];
  lockOffset= locked ? 0 : -matThck;
  drill= (screwLess) ? 0 : 2.5; //no kerf
  echo("lefti",leftLength);

  
  if (expPart=="Base") {
    !projection(){
      translate([0,-ovWidth-matThck,0]) Layer0();
      translate([0,0,0]) Layer1();
      translate([0,ovWidth+matThck,0]) Layer2();
    }
  }
  else {
    color("mediumSlateBlue") if (showLayer0) Layer0();
    color("slateBlue") if (showLayer1) Layer1();
    color("darkSlateBlue") if (showLayer2) Layer2();
  }
  
  module Layer0(){ //slots without kerf for easy assembly
    translate([lockOffset,0,0]){
      difference(){
        union(){
          translate(ovOffset) rndRect(center=true,[ovLength,ovWidth,matThck],3,drill,drillOffset=drillOffset);
          if (screwLess) translate(ovOffset) rndRect(center=true,[ovLength+matThck*2,ovWidth-matThck*4,matThck],1,drill,drillOffset=drillOffset);
        }
        translate([PCBOffsetCntr,0,0]) cube([PCBLength+fudge,PCBWidth,matThck+fudge],true); //cutout for PCB
        translate([matThck/2,0,0]) cube([matThck*2,ovWidth-matThck*8,matThck+fudge],true); //slot for pivotAxis locking
        if (!screwLess){
          translate([matThck,leverYOffset+matThck,0]) cube([leverHght,matThck,matThck+fudge],true);// pivotPlate locking
          translate([matThck,-leverYOffset-matThck,0]) cube([leverHght,matThck,matThck+fudge],true);
        }
        if (rackPinion){
          translate([0,leverYOffset,0]) cube([pivotZOffset*2+matThck*2,matThck,matThck+fudge],true);
          translate([0,-leverYOffset,0]) cube([pivotZOffset*2+matThck*2,matThck,matThck+fudge],true);
        }
        if (springLock){ //add slots for spring mechanism
          for (i=[-1,1],j=[-1,1])
          translate([0,i*leverYOffset+j*(matThck/2),0]) cube([leverHght+leftLength-matThck,0.2,matThck+fudge],true);
          
        }
        for (i=[0.25,0.75],j=[1,-1]){ //slots for SidePlate locking
          translate([i*pPlateXOffset+matThck*1.5,j*(leverYOffset-matThck),0]) 
            cube([matThck*3,matThck,matThck+fudge],true);
        }
        //add slots for fixation rings
        echo("zOff",3*matThck,pPlateZOffset);
        if ((screwLess) && ((3*matThck)>probeZOffset))
          for (i=[-1,1])
            //PCBWidth+PCBYClrnc*2
            translate([pPlateXOffset-pPlateOffCntr,i*(leverYOffset-matThck*3-fudge),fudge/2]) 
              cube([pPlateLength+fudge,matThck+fudge,matThck+fudge],true);
      }
    translate([-matThck/2,0,0]) rndRect(center=true,[matThck*2,PCBWidth,matThck],rad,0); //feather for pivotaxis locking
    }
  }
  module Layer1(){
    translate([0,0,-matThck*1])
    difference(){
      union(){
          translate(ovOffset) rndRect(center=true,[ovLength,ovWidth,matThck],3,drill,drillOffset=drillOffset);
          if (screwLess) translate(ovOffset) rndRect(center=true,[ovLength+matThck*2,ovWidth-matThck*4,matThck],1,drill,drillOffset=drillOffset);
        }
      translate([0,0,0]) cube([matThck-kerf,ovWidth-matThck*8-kerf,matThck+fudge],true); //slot for pivotAxis locking
      for (i=[0.25,0.75],j=[1,-1]){
        translate([i*pPlateXOffset+matThck/2,j*(leverYOffset-matThck),0]) 
          cube([matThck*3-kerf,matThck-kerf,matThck+fudge],true);//slots for SidePlates locking
      }
      if (springLock){
        translate([0,-leverYOffset,0]) cube([leverHght+leftLength-matThck,matThck+fudge+kerf,matThck+fudge],true);
        translate([0,leverYOffset,0]) cube([leverHght+leftLength-matThck,matThck+fudge+kerf,matThck+fudge],true);
      }
      if (showLocking){
        translate([ovOffset.x+(ovLength-matThck)/2,leverYOffset,0]) cube(matThck+fudge,true);
        translate([ovOffset.x+(ovLength-matThck)/2,-leverYOffset,0]) cube(matThck+fudge,true);
      }
      if (!screwLess) {
        translate([0,leverYOffset+matThck,0]) cube([leverHght-kerf,matThck-kerf,matThck+fudge],true);// pivotPlate locking
        translate([0,-leverYOffset-matThck,0]) cube([leverHght-kerf,matThck-kerf,matThck+fudge],true);
      }
      if (rackPinion){
        translate([pivotZOffset/2,leverYOffset,0]) cube([pivotZOffset*3+matThck*2,matThck,matThck+fudge],true);
        translate([pivotZOffset/2,-leverYOffset,0]) cube([pivotZOffset*3+matThck*2,matThck,matThck+fudge],true);
      }
    }
  }
  
  // -- Layer 2 --
  module Layer2(){
   translate([0,0,-matThck*2])
    union(){
          translate(ovOffset) rndRect(center=true,[ovLength,ovWidth,matThck],3,drill-0.5,drillOffset=drillOffset);
          if (screwLess) translate(ovOffset) rndRect(center=true,[ovLength+matThck*2,ovWidth-matThck*4,matThck],1,drill,drillOffset=drillOffset);
        }
  }
}

module pressPlate(length, width, probeCoords, xOffset=0){ //Dimensions without lockings
  
  //xOffset can be used for balancing the probe force
  
  //Offset for screw holes
  drillXOffset=-xyMin(probeCoords,len(probeCoords)).x+matThck-length/2;
  drillYOffset=-width/2+PCBYClrnc;
  
  //Y-Offset for Fixation rings
  slFixYOffset=(screwLess) ? 2*matThck+fudge: 0; 
  
  if (expPart=="PressPlate"){ //put parts next to each other for export
    !projection(){
      translate([-(length+matThck)/2,0,0]) topPlate();
      translate([(length+matThck)/2,0,0]) bottomPlate();
    }
  }
  else {
    color("purple") translate([0,0,-matThck]) topPlate();
    translate([0,0,-matThck*2]) bottomPlate(); 
  }
  
  module topPlate(){ //Top Plate with cam
      difference(){
        union(){
          translate([-xOffset,0,matThck/2])rndRect(center=true,[length,width-slFixYOffset*2,matThck],1,0);
          translate([0,0,matThck/2]) rndRect(center=true,[matThck,width+matThck*4,matThck],0.5,0);//cam
          if (screwLess) translate([-xOffset,0,matThck/2]) rndRect(center=true,[length-matThck*2,width,matThck],1,0);
          
        }
        for (pos=probeCoords){ //drill the holes
          translate([pos.x+drillXOffset-xOffset,pos.y+drillYOffset,-fudge/2]) cylinder(d=probeDrillDia,h=matThck+fudge);
        }
        if (!screwLess){ 
          translate([0,width/2-PCBYClrnc/2,-fudge/2]) cylinder(d=2.5,h=matThck+fudge);
          translate([0,-(width/2-PCBYClrnc/2),-fudge/2]) cylinder(d=2.5,h=matThck+fudge);
        }
    }
  }
    module bottomPlate(){ //bottom Plate with guidance
      difference(){
        union(){
          translate([-xOffset,0,matThck/2]) rndRect(center=true,[length,width-slFixYOffset*2,matThck],1,0);
          translate([0,0,matThck/2]) rndRect(center=true,[matThck,width+matThck*2,matThck],0.5,0); //guide
          if (screwLess) translate([-xOffset,0,matThck/2]) rndRect(center=true,[length-matThck*2,width,matThck],1,0);
        }
       for (pos=probeCoords){ //drill holes for probes
        translate([pos.x+drillXOffset-xOffset,pos.y+drillYOffset,-fudge/2]) cylinder(d=probeDrillDia,h=matThck+fudge);
       }
       if (!screwLess){ 
          translate([0,width/2-PCBYClrnc/2,-fudge/2]) cylinder(d=2.0,h=matThck+fudge);
          translate([0,-(width/2-PCBYClrnc/2),-fudge/2]) cylinder(d=2.0,h=matThck+fudge);
        }
    }
  }
  //fixation Rings
  if (screwLess) for (i=[(width/2+matThck-slFixYOffset),-width/2+slFixYOffset])
  translate([-xOffset,i,-matThck]) {
    difference(){
      translate([0,-matThck/2,0]) rotate([90,0,0]) rndRect(center=true,[length,matThck*4,matThck],1,0);
      translate([0,-matThck/2,0]) cube([length-matThck*2-kerf,matThck+fudge,matThck*2-kerf],true);
      for (i=[-1,1],j=[-1,1]) //stress release
          translate([i*(length/2-kerf/2-matThck),fudge/2,j*(matThck-kerf/2)]) rotate([90,0,0]) cylinder(d=0.5,h=matThck+fudge);
      
    }
   }
    
}

module PCB(width, length, thick=1.5){
  translate([0,0,-thick/2]) color("darkgreen") cube([length, width, thick],true);
}

module sidePlate(pivotHght,slotHght,slotXOffset){ //kerf nOK
  //slotZOffset=probeZOffset-2*matThck;
  slotZOffset=(probesFromTop) ? (probeZOffset-2*matThck) : probeZOffset;
  
  crnrRad=leverHght/2; //Radius of Corners (and thickness of border)
  
  difference(){
    union(){
      hull(){//outline
        translate([0,0,pivotHght]) rotate([90,0,0]) 
          cylinder(r=crnrRad+kerf,h=matThck,center=true);
        translate([slotXOffset,0,pivotHght]) rotate([90,0,0]) 
          cylinder(r=crnrRad+kerf,h=matThck,center=true);
        translate([slotXOffset,0,slotZOffset+slotHght]) rotate([90,0,0]) 
          cylinder(r=crnrRad+kerf,h=matThck,center=true);
      }
      translate([slotXOffset*0.25,0,matThck/2]) hook();
      translate([slotXOffset*0.75,0,matThck/2]) hook();
    }
    //slot for pressPlate
    translate([slotXOffset,0,slotHght/2+slotZOffset]) cube([matThck,matThck+fudge,slotHght],true);
    //slot for pivotAxis
    translate([0,0,slotZOffset+matThck]) cube([matThck,matThck+fudge,matThck*2],true);
  }
}
//leverHeight is limited to 4*matThck
module lever(height,length){ //kerf OK
  $fn=150;
  edgeDist=((height+kerf)/2)/cos(maxAngle/2); //distance from center to intersection of base lines
  
  nobDia=(edgeDist-(height+kerf)/2)*2;
  
  // vars for locking mechanism
  edge=PCBOffsetFix+PCBLength;
  hookStrngth=0.6; //hook strength
  hookRad=0.5; //hook edge radi
  pvtDia=matThck*2; //
  fxThck=matThck; //thickness of pivot fixation
  
  fxAng=asin(fxThck/pvtDia);//sin()=GK/HYP
  opnAng=atan(matThck/(height/2+matThck));//tan()=GK/AK opening angle
  pvtDist=cos(fxAng+opnAng)*(height/2); //AK=cos()*HYP
  basDist=cos(fxAng)*(height/2);//AK=cos()*HYP
  basHghtTop=sin(fxAng)*(height/2);//sin()=GK/HYP
  basHghtBtm=-height/2;//-tan(fxAng+opnAng)*basDist;//tan()=GK/AK

  echo("BasHght",basHghtTop,basHghtBtm);
  hndlOffset = ((expPart=="Levers") && (showLocking)) ? height/2 : 0; //move handle outwards for export
  echo("Angles",fxAng,opnAng);
  
  
  
  rotate([90,0,0]) 
  difference(){
    union(){
      rotate(-maxAngle) 
        hull(){//crossbar slot
          cylinder(d=height+kerf,h=matThck,center=true);
          translate([-height*0.75-matThck/2,matThck,-matThck/2]) cylinder(d=(matThck+kerf)*2,h=matThck);
          translate([-height*0.75-matThck/2,-matThck,-matThck/2]) cylinder(d=(matThck+kerf)*2,h=matThck); 
            //4*matThck which is limit as well
        }
        
      if(showLocking){//short connection
        difference(){
          translate([0,-(height+kerf)/2,-matThck/2]) cube([edge-pvtDist, height+kerf, matThck]);
          translate([edge,0,0]) cylinder(d=height,h=matThck+fudge,center=true);
        }
        translate([edge+hndlOffset,-height/2,0]) lHook(hookStrngth,hookRad); //hook
        translate([edge,0,0]) cylinder(d=pvtDia+kerf,h=matThck,center=true); //pivot
        translate([0,0,-matThck/2]) linear_extrude(matThck) 
          polygon([[edge-height/2, basHghtTop], //top left
                  [edge-height/2,basHghtBtm], //btm left
                  [edge-basDist,basHghtBtm], //btm right
                  [edge,0], //center
                  [edge-basDist,basHghtTop], //top right
                  [edge-basDist,basHghtTop]]); //connecting triangle
        }
      else {
        translate([0,-(height+kerf)/2,-matThck/2]) cube([length, height+kerf, matThck]); //long connection
      }
      
      translate([hndlOffset,0,0]){
        translate([edge,0,0]) difference(){
          union(){
            translate([length-edge,0,0]) cylinder(d=height+kerf,h=matThck,center=true);
            translate([0,-(height+kerf)/2,-matThck/2]) cube([length-edge,height+kerf,matThck]);
            cylinder(d=height+kerf,h=matThck,center=true);
          }
          cylinder(d=pvtDia-kerf,h=matThck+fudge,center=true); //pivot
          translate([0,0,-(matThck+fudge)/2]) linear_extrude(matThck+fudge) 
            polygon([[-height/2-fudge,-basHghtBtm],[-height/2-fudge,basHghtBtm],[-basDist,basHghtBtm],[0,0],[-basDist,-basHghtBtm]]);
        }
        
      }
    } //union end
    
    cylinder(r=pivotDrill,h=matThck+fudge,center=true);//hole for lever pivot axis
    translate([0,0,-(matThck+fudge)/2]) slotCalc(); // <-- MAGIC!
    rotate (-maxAngle) translate([-height*0.75,0,0]) cube([matThck-2*kerf,matThck*2-kerf,matThck+fudge],true); //crossbar
    if (showLocking)
      translate([length+hndlOffset+matThck*1.5,0,0]) cube([(matThck)*3,matThck-kerf,matThck+fudge],true); //crossbar
    else 
      translate([length,0,0]) cube([(matThck-kerf)*2,matThck-kerf,matThck+fudge],true); //crossbar
  }//diff end
  
}

module slotCalc(){
  
  upperSlotCoords=[];
  lowerSlotCoords=[];

  linear_extrude(matThck+fudge)
  newSlot(upperSlotCoords, lowerSlotCoords,pPlateXOffset,maxAngle,quadSize=matThck-kerf);
  
}

*hook();
module hook(){ //kerf OK
  mt=matThck;
  k=kerf;
  poly=[[-k,fudge],[-k,-mt+k],[-mt,-mt+k],[-mt,-mt*2+mt/4],
        [-mt+mt/4,-mt*2],[mt*2-mt/4,-mt*2],[mt*2,-mt*2+mt/4],[mt*2+k,fudge]];
    
  rotate([90,0,0]) translate([0,0,-matThck/2]) linear_extrude(matThck) polygon(poly);
}

//edge=PCBOffsetFix+PCBLength;
//translate([edge+matThck/2,-leverYOffset,-matThck/2]) lHook();
module lHook(strength=0.7, rad=0.5){
  deep=matThck*strength;//
  
  hull(){
    translate([-deep+rad,-matThck-rad,0]) cylinder(r=rad,h=matThck,center=true);
    translate([rad,-matThck*2+rad,0]) cylinder(r=rad,h=matThck,center=true);
    translate([matThck-rad,-matThck*2+rad,0]) cylinder(r=rad,h=matThck,center=true);
    translate([matThck-rad,-matThck-rad,0]) cylinder(r=rad,h=matThck,center=true);
  }
  hull(){
    translate([matThck*2,0,0]) cylinder(r=rad,h=matThck,center=true);
    translate([rad,0,0]) cylinder(r=rad,h=matThck,center=true);
    translate([rad,-matThck,0]) cylinder(r=rad,h=matThck,center=true);
    translate([matThck-rad,-matThck*2+rad,0]) cylinder(r=rad,h=matThck,center=true);
  }
}


module crossBar(lock=false){
  edge=PCBOffsetFix+PCBLength; //base edge
  lockLength=leverLength+leverHght/2-edge;
  
  if (lock)
      union(){
        translate([0,-matThck/2,0]) rndRect(center=true,[leverYOffset*2-matThck+kerf,matThck*4,matThck],1,0);
        translate([0,-matThck*1.25,0]) rndRect(center=true,[leverYOffset*2+matThck*3+kerf,matThck*2.5,matThck],1,0);
        translate([leverYOffset+matThck,-matThck*2.5+lockLength/2,0]) rndRect(center=true,[matThck+kerf,lockLength,matThck],1,0);
        translate([-(leverYOffset+matThck),-matThck*2.5+lockLength/2,0]) rndRect(center=true,[matThck+kerf,lockLength,matThck],1,0);
      }
    
  else 
    rotate([0,90,-90])
      union(){
        cube([matThck,leverYOffset*2-matThck,matThck*4],true);
        translate([0,0,0]) cube([matThck,leverYOffset*2+matThck,matThck*2],true);
      }  
  
}


module newSlot(upperObj, lowerObj, lZero, angleMax, quadSize=3, iter=0, iterations=60,dwnPolyPre=[0,0],lastCoord=[0,0]){
  lMax = lZero/cos(angleMax);
  lMid = lZero/cos(angleMax/2);
  lDiag=sqrt(2*pow(quadSize/2,2));
  hZero = (lMax-lZero)/tan(angleMax);
  
  
  if (iter<=iterations){//one more to achieve max angle
    angSweep=iter*(angleMax/iterations);//current sweep angle
    
    //Point M: Center of rotation for slot 
    yM=sin(angSweep-angleMax/2)*lMid;
    xM=sqrt(pow(lMid,2)-pow(yM,2));
    
    //Point P: crossing of slotcircle with vertical axis
    yP=yM+sqrt(pow(hZero,2)-pow(lZero-xM,2));
    lP=sqrt(pow(lZero,2)+pow(yP,2));
    
    //corrected angle for Point P
    angP=atan(yP/lZero);
    
    //if (showDebug) echo(angSweep,yM,xM,yP,lP,angP);
    //Point Q: angle relative to zero Position
    angQ=angSweep-angP; 
    
    //Point Q: final center Point of rotated and translated square
    yQ=sin(-angQ)*lP; 
    xQ=sqrt(pow(lP,2)-pow(yQ,2));
    
    
    if (showDebug){ //draw the square to see if it is right
      //echo("angle,xQ,yQ,angQ",angSweep,xQ,yQ,angQ);
      if (angSweep==leverRotation) #translate([xQ,yQ]) rotate(-angSweep) square(quadSize,true);
    }
    
    
    //calculation of polygon vertices (upper left and lower right corner of square
    angQuad=45-angSweep;//diagonal angle relative to x-axis
    xPoly=sin(angQuad)*lDiag; //xdistance Mid-Poly
    yPoly=sqrt(pow(lDiag,2)-pow(xPoly,2)); //yDistance Mid-Poly
    upLftPoly=[xQ-xPoly,yQ+yPoly];//abolute coordinates
    dwnRghtPoly=[xQ+xPoly,yQ-yPoly];//absolute coordinates
    
    if (debugVerts) { //show verts created from corners
      //echo("xPoly,yPoly",xPoly,yPoly);
      color("red") translate(upLftPoly) circle(0.01);
      if ((angC2C<angSweep) && (angC2C>0)){
          color("red") translate(dwnRghtPoly) circle(0.01); //only used corners
          translate(dwnRghtPoly) rotate(-90) text(str(iter),0.01,valign="center",halign="left");
      }
    }

    //calculate angle between lower right corners of this and previous iteration
    deltaC2C= (iter>0) ? dwnPolyPre-dwnRghtPoly : [0,0]; //x and y distance between verts
    angC2C= (iter>0) ? atan(-deltaC2C[1]/deltaC2C[0]) : 0;
    
    
    //Intersection of Baselines 
    angPre= (iter-1)*(angleMax/iterations);//angle of previous step
    pa2 = dwnPolyPre + [cos(-angPre),sin(-angPre)]; //convert angle to 2nd point
    pb2 = dwnRghtPoly + [cos(-angSweep),sin(-angSweep)]; //convert angle to 2nd point
    PX=IntersectionOfLines(dwnPolyPre, pa2, dwnRghtPoly, pb2);
    
    if (debugVerts) echo(iter,angSweep,angC2C,angC2C-angSweep);
        
    //TODO.. check if this is before any previous drawn corner
    
    
    
    upperObj=concat(upperObj,[upLftPoly]);//add at back
    //lowerObj=concat([dwnPoly],lowerObj);
    
    //if lower right corner is inside add intersection point of baselines (but not for the first iteration)
    /*lowerObj = ((angC2C<angSweep) 
                && (iter!=1) 
                && (angC2C>0)) 
                ? concat([dwnRghtPoly],lowerObj) : concat([PX],lowerObj);//add in front
    */
    //choose between line Intersec or lower Right corner
    addCoord= ((angC2C<angSweep) && (iter!=1) && (angC2C>0)) ? dwnRghtPoly : PX;
    
    //calculate if below right previous coord
    biggestLastCoord= ((lastCoord.x<addCoord.x)&&(lastCoord.y>=addCoord.y)) ? addCoord : lastCoord;
    
    //check for continuity
    lowerObj= (biggestLastCoord != lastCoord) ? concat([addCoord],lowerObj) : lowerObj;
    
    if (debugVerts && (angC2C>angSweep) && (biggestLastCoord != lastCoord)){ //Show baseline intersections
      color("green") translate(PX) circle(0.01);
    }
    
    if (iter==iterations){//last iteration - one before drawing the polygon
      upRghtPoly=[xQ+yPoly,yQ+xPoly];//for the top right edge the triangle is rotate by 90°
      upperObj=concat(upperObj,[upRghtPoly]);
      
      dwnRghtPoly=[xQ+xPoly,yQ-yPoly];//additional lower right edge (if baseline intersection is used)
      lowerObj=concat([dwnRghtPoly],lowerObj);
      
      newSlot(upperObj, lowerObj, lZero, angleMax, quadSize,iter+1,dwnPolyPre=dwnRghtPoly,lastCoord=biggestLastCoord);
    }
    else if (iter==0) {//first iteration
      dwnLftPoly=[xQ-yPoly,yQ-xPoly];//for the lower left edge the triangle is rotate by -90°
      lowerObj=concat(lowerObj,[dwnLftPoly]);//add in front
      
      newSlot(upperObj, lowerObj, lZero, angleMax, quadSize,iter+1,dwnPolyPre=dwnRghtPoly,lastCoord=dwnLftPoly);
    }

    else
      newSlot(upperObj, lowerObj, lZero, angleMax, quadSize,iter+1,dwnPolyPre=dwnRghtPoly,lastCoord=biggestLastCoord);
  }
  if (iter== iterations+1){ //last iteration only draws the polygon
    
    polygon(concat(upperObj,lowerObj));
  }
}

function  IntersectionOfLines(pa1, pa2, pb1, pb2)=
//test for intersection
  let(

  da = [(pa1.x-pa2.x),(pa1.y-pa2.y)], 
  db = [(pb1.x-pb2.x),(pb1.y-pb2.y)],
  the = da.x*db.y - da.y*db.x                 )

  (the == 0)? undef : /* no intersection*/

//calculate intersection  
  let (
    A = (pa1.x * pa2.y - pa1.y * pa2.x),
    B = (pb1.x * pb2.y - pb1.y * pb2.x)       )

    [( A*db.x - da.x*B ) / the , ( A*db.y - da.y*B ) / the]
;


function heightFromAngle(angle,lZero,angleMax)=
  let (
   lMax = lZero/cos(angleMax),
   lMid = lZero/cos(angleMax/2),
   yM=sin(angle-angleMax/2)*lMid,
   xM=sqrt(pow(lMid,2)-pow(yM,2)),
   hZero = (lMax-lZero)/tan(angleMax),
   height=yM+sqrt(pow(hZero,2)-pow(lZero-xM,2))
  )
  height;


function xyMax(coordsList, iter, result=[0,0])=
  let (
    maxX = (coordsList[iter].x>result.x) ? coordsList[iter].x : result.x,
    maxY = (coordsList[iter].y>result.y) ? coordsList[iter].y : result.y
    )
  (iter>0) ? xyMax( coordsList, iter-1, [maxX,maxY]) :result;
  
function xyMin(coordsList, iter, result=undef)=
  let (
    minX = (result.x==undef) || (coordsList[iter].x<result.x) ? coordsList[iter].x : result.x,
    minY = (result.y==undef) || (coordsList[iter].y<result.y) ? coordsList[iter].y : result.y
    )
  (iter>0) ? xyMin( coordsList, iter-1, [minX,minY]) :result;

function lengthFromCoords(coordsList)=
  xyMax(coordsList,len(probePositions)-1).x-xyMin(coordsList,len(probePositions)-1).x;
 
 
echo("CenterOfMass:",centerOfMass(probePositions,len(probePositions)-1));
echo("pPlateLength:",pPlateLength-matThck*2);
function centerOfMass(coordsList, iter, result=0)=
//calculate the center of mass in x direction, with equal force for each testprobe
//xs=(x1*m1+x2*m2+...+xn*mn)/(m1+m2+...+mn)
//xs=(x1+x2+...+xn)/n //with mass=1
// substract minimum x-value in the end to set first probe Pos to zero
  let(
    sum=result + coordsList[iter].x
  )
(iter>0) ? centerOfMass(coordsList,iter-1, sum) : sum/len(coordsList)-xyMin(coordsList,len(coordsList)).x;
  
function dist2Mod(dist,N)=(dist*2)/(N-2+1/3);