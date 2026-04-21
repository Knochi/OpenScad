/*
  VWIF Decision Finder for Girls Day 2026
  POP-000181-001 https://inventree.vwinf.vw.vwg/part/28413/
  15 individual part codes
  
  Osifont can be obtained here:
  https://github.com/hikikomori82/osifont
*/

use <osifont.ttf>

/* [PCB] */
pcbDims=[85.6,54,1.6];
pcbRad=3;
pcbSpcngXY=0.1;
pcbSpcngZ=0.1;

/* [Parts Storage] */
cavBrmWdth=6; 
cavCounts=[6,4];
cavCountAtPCB=[4,2];
cavDpth=4;
cavRad=3;
trayFloorThck=2;
tray2PCBSpcng=0.3;
tray2BtnSpcng=0.3;
//WIP! define Excel style ranges i.e. "A1:C2,F1:F2" to combine cells
cavCombineStr="A1:C2";
//relative text size to brim width
cavLabelSizeRel=0.7;
cavLabelDpth=0.4;
cavLabelFont="Osifont";
cavLabelOffset=0.1;

/* [Housing] */
minWallThck=1.2;
brimWidth=2;
brimThck=1.2;
floorThck=2;
highestPart=1.9;

/* [Button] */
btnDims=[4.5,2.6,2.9];
btnHghtFromSurface=0.95;
btnActHght=0.35;
btnSpcngs=[0.1,0.3,0.2];

/* [show] */
showPCB=false;
showBtnCutOut=false;
showHousing=false;
showPartsTray=true;
showRowColumnLabels=true;
testPrint=false;

/* [Hidden] */
fudge=0.1;
$fn=50;

// combine cells ranges
cavCombine=[[[5,1],[5,2]]];

// label cells
//           A       B       C      D       E          F 
cavLabels=[["U03","U01|U02","SW01","R0-R15","S01","R04-R07"],
          ["R02",                                    "R01|R03"],
          ["Q03",                                    "Q01|Q02"],
          ["D01-D08","C10","C07|C09","C08","C01-C06", "CR2016"]
          ];


hsngDims=[pcbDims.x+pcbSpcngXY*2+minWallThck*2,
          pcbDims.y+pcbSpcngXY*2+minWallThck*2+btnActHght,
          pcbDims.z+pcbSpcngZ*2+floorThck*2+highestPart];
hsngRad=pcbRad+pcbSpcngXY+minWallThck;

if (showPartsTray)
  intersection(){
    partsTray();
    if (testPrint)
      translate([0,0,-pcbDims.z]) 
        linear_extrude(pcbDims.z*2) offset(cavBrmWdth) square([pcbDims.x,pcbDims.y],true);
  }
  
if (showHousing)
  housing();
if (showPCB)
  PCB();
//PCB
module PCB(){
  color("darkGreen") roundedCube();
  color("grey") translate([0,pcbDims.y/2-btnDims.y/2+btnActHght,btnDims.z/2-btnHghtFromSurface]) cube(btnDims,true);
  if (showBtnCutOut)
    %translate([-hsngDims.x/4+btnDims.x/4+btnSpcngs.x/2,
              pcbDims.y/2-btnDims.y/2+btnSpcngs.y+btnActHght,
              btnDims.z/2-btnHghtFromSurface]) 
        cube([(hsngDims.x+btnDims.x)/2+btnSpcngs.x+fudge,btnDims.y+btnSpcngs.y*2,btnDims.z+btnSpcngs.z*2],true);
}


module partsTray(){
  cavDims=[(pcbDims.x+tray2PCBSpcng*2-cavBrmWdth*(cavCounts.x-3))/(cavCounts.x-2),
            (pcbDims.y+tray2PCBSpcng*2-cavBrmWdth*(cavCounts.y-3))/(cavCounts.y-2)];
  cavDist=cavDims+[cavBrmWdth,cavBrmWdth];
  ovDims=[cavDims.x*cavCounts.x+cavBrmWdth*(cavCounts.x-1),
          cavDims.y*cavCounts.y+cavBrmWdth*(cavCounts.y-1),
          cavDpth+trayFloorThck];
  holeDia=min(pcbDims.x,pcbDims.y)/2;
          
  difference(){
    translate([0,0,-ovDims.z+pcbDims.z]) linear_extrude(ovDims.z) offset(cavBrmWdth) square([ovDims.x,ovDims.y],true);
    //PCB
    linear_extrude(pcbDims.z+fudge) offset(tray2PCBSpcng) rndRect([pcbDims.x,pcbDims.y],pcbRad);
    //button
    translate([0,pcbDims.y/2-btnDims.y/2+btnActHght,btnDims.z/2-btnHghtFromSurface]) 
      cube(btnDims+[tray2BtnSpcng*2,tray2BtnSpcng*2,tray2BtnSpcng*2],true);
    
    //top & bottom cavities wth. labels
    for (ix=[-(cavCounts.x-1)/2:(cavCounts.x-1)/2],iy=[-1,1]){
      col=ix+(cavCounts.x-1)/2;
      row= iy<0 ? cavCounts.y-1 : 0;
      translate([ix*cavDist.x,iy*(cavDist.y*(cavCounts.y-1)/2),pcbDims.z]){
        cavity();
        translate([0,cavDims.y/2+cavBrmWdth/2,-cavLabelDpth]) 
          linear_extrude(cavLabelDpth+fudge) 
            label(cavLabels[row][col]);
      }
    }
    //left & right cavities wth. labels
    for (iy=[-(cavCounts.y-3)/2:(cavCounts.y-3)/2],ix=[-1,1]){
      col= ix<0 ? 0 : 1;
      row= iy*-1+(cavCounts.y-1)/2;
      echo(col,row);
      translate([ix*cavDist.x*(cavCounts.x-1)/2,iy*cavDist.y,pcbDims.z]){
        cavity();
        translate([0,cavDims.y/2+cavBrmWdth/2,-cavLabelDpth]) 
          linear_extrude(cavLabelDpth+fudge) 
            label(cavLabels[row][col]);
      }
    }
    //center hole for PCB removal
    translate([0,0,-ovDims.z+pcbDims.z-fudge/2]) cylinder(d=holeDia,h=ovDims.z+fudge);
    }
    // Row and Column Labels
    if (showRowColumnLabels)
      for (ix=[-(cavCounts.x-1)/2:(cavCounts.x-1)/2],iy=[-(cavCounts.y-1)/2:(cavCounts.y-1)/2]){
        if (ix==-(cavCounts.x-1)/2) //first column
          translate([-ovDims.x/2-cavBrmWdth-5,iy*cavDist.y,0]) 
            linear_extrude(1) text(str(iy*-1+1+(cavCounts.y-1)/2),valign="center",halign="center");
        if (iy==-(cavCounts.y-1)/2) //first row
          translate([ix*cavDist.x,ovDims.y/2+cavBrmWdth+5,0]) 
            linear_extrude(1) text(chr(65+ix+(cavCounts.x-1)/2),valign="center",halign="center");
      }

  module cavity(){
    //straight section
    translate([0,0,-cavDpth+cavRad]) linear_extrude(cavDpth-cavRad+fudge) rndRect(cavDims,cavRad);
    //rounded section
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(cavDims.x/2-cavRad),iy*(cavDims.y/2-cavRad),-cavDpth+cavRad]) sphere(cavRad);
    
  }
  
  
  module label(txt){
    offset(cavLabelOffset) text(txt,size=cavBrmWdth*cavLabelSizeRel, font=cavLabelFont, valign="center",halign="center");
  }
  /* WIP
  //go through a given string and generate nested lists for further processing
  function combineStr2List(string, iter=0)= let(
    c = ord(string[iter]),
    col = (c>64 && c<91) ? c-65 : 0;
    row = (
  )
  */
}

module housing(){
  difference(){
    translate([0,btnActHght/2,-hsngDims.z+floorThck+pcbDims.z]) roundedCube(hsngDims,hsngRad);
    
    //pcb
    roundedCube(cut=true);
    //window
    translate([0,0,pcbDims.z-fudge/2]) linear_extrude(floorThck+fudge) offset(-brimWidth) rndRect(pcbDims,pcbRad);
    //slot
    translate([-(pcbDims.x+minWallThck-pcbRad)/2-pcbSpcngXY,0,-pcbSpcngZ]) linear_extrude(pcbDims.z+pcbSpcngZ*2) 
      square([minWallThck+pcbRad+fudge,pcbDims.y+pcbSpcngXY*2],true);
    //components
    translate([-(minWallThck)/2-pcbSpcngXY,0,-pcbSpcngZ-highestPart]) 
      linear_extrude(highestPart+pcbSpcngZ+fudge) 
        square([pcbDims.x+pcbSpcngXY+minWallThck+fudge,pcbDims.y+pcbSpcngXY*2-brimWidth*2],true);
    //button
    translate([-hsngDims.x/4+btnDims.x/4+pcbSpcngXY/2,
               pcbDims.y/2-btnDims.y/2+pcbSpcngXY+btnActHght,
               btnDims.z/2-btnHghtFromSurface]) 
      cube([(hsngDims.x+btnDims.x)/2+pcbSpcngXY+fudge,btnDims.y+pcbSpcngXY*2,btnDims.z+pcbSpcngZ*2],true);
  }
}

//pcb outline
module roundedCube(size=pcbDims,rad=pcbRad,cut=false){
  spcngXY= cut ? pcbSpcngXY : 0;
  spcngZ= cut ? pcbSpcngZ : 0;
  
  translate([0,0,-spcngZ]) linear_extrude(size.z+spcngZ*2)
    offset(spcngXY) rndRect(size,rad);
}

module rndRect(size, rad){
  hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
}
