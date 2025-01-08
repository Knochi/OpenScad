$fn=100;
ovDia=176.7;
hexInnerDia=90;
hexOuterDia=ovDia-13;
hexThck=2.2;
fudge=0.1;
addSlots=false;

/* [Faces] */
faceThck=2;
outerRingThck=3;
outerRingWdth=6;
//where to add holes in the outer ring
holeAngles=[80,100,260,280];
holeDia=3;
innerRingThck=3;
innerRingWdth=3;

/* [Core] */
//spool inner hole diameter
coreInnerDia=55;
coreInnerWallThck=1.5;
coreSpokeThck=1.2;
//filament winding diameter
coreOuterDia=82;
coreOuterWallThck=2;

/* [show] */
showOrig=true;
showFace=true;
processPart="A"; //["A","B"]


//Part A

  if (showOrig){
    if (processPart=="A") %rotate(-4.0) translate([-ovDia/2,-ovDia/2,-fudge/2]) import("A1mini-bambu_spool_hex_A.stl",convexity=4);
    else  %import("A1mini-bambu_spool_hex_B.stl");
  }
  
  if (addSlots) linear_extrude(hexThck+fudge) slots(true);  


      
  if (addSlots) color("green") linear_extrude(hexThck) slots();
  
*slot();
module slots(cut=false){
  slotBrim=3;
  slotWidth=5;
  ovWidth=slotBrim*2+slotWidth;
  
  for (ir=[0:90:270])
    rotate(ir) difference(){
      hull(){ 
        translate([0,hexInnerDia/2+ovWidth/2]) circle(d=ovWidth);
        translate([0,hexOuterDia/2-ovWidth/2]) circle(d=ovWidth);
      }
    if (!cut)
      hull(){ 
        translate([0,hexInnerDia/2+ovWidth/2]) circle(d=slotWidth);
        translate([0,hexOuterDia/2-ovWidth/2]) circle(d=slotWidth);
      }
    }
}

face();
module face(){
  //outer ring
  linear_extrude(outerRingThck) difference(){
    circle(d=ovDia);
    circle(d=ovDia-outerRingWdth*2);
    //holes
    for (rot=holeAngles)
      rotate(rot) translate([ovDia/2-outerRingWdth/2,0]) circle(d=holeDia);
  }
  //inner ring
  linear_extrude(innerRingThck) difference(){
    circle(d=coreOuterDia+innerRingWdth*2);
    circle(d=coreOuterDia);
  }
  //in between
  linear_extrude(faceThck) difference(){
    circle(d=ovDia-outerRingWdth*2);
    circle(d=coreOuterDia+innerRingWdth*2);
  }
}
