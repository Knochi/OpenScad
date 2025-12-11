/* [Dimensions] */
ovWdth=100;
ovHght=78;
cornerRad=4;
frameThck=2.4;
frameWdth=2;
txtThck=1.2;
plateThck=1.2;
tongueHght=9;
tongueWdth=90;
minWallThck=0.8;
minFloorThck=0.4;
plateSpcng=0.1;

/* [Text] */
txtFont1="Noto Sans";//Font
txtStyle1= "Regular";//["Regular","Bold","Italic","Underline","Strikethrough"]
txtLine1="Hold the vision";

txtFont2="Noto Sans";//Font
txtStyle2= "Regular";//["Regular","Bold","Italic","Underline","Strikethrough"]
txtLine2="TRUST";

txtFont3="Noto Sans";//Font
txtStyle3= "Regular";//["Regular","Bold","Italic","Underline","Strikethrough"]
txtLine3="the process";

//relative text Area Size from with and height-tongue
txtAreaDimsRel=[0.90,1.0];
txtLineSpcng=2.2; //[1:0.1:2]

/* [show] */
showTxt=true;
showPlate=true;
showFrame=true;
showTxtArea=false;

$fn=48; //[20:4:100]

/* [Hidden] */
fudge=0.1;

//if style is given with text use that, otherwise use style
txtFontStyle1 = len(search(":",txtFont1)) ? txtFont1 : 
  str(txtFont1,":style=",txtStyle1);
txtFontStyle2 = len(search(":",txtFont2)) ? txtFont2 : 
  str(txtFont2,":style=",txtStyle2);
txtFontStyle3 = len(search(":",txtFont3)) ? txtFont3 : 
  str(txtFont3,":style=",txtStyle3);

txtLines=[txtLine1,txtLine2,txtLine3];
txtFontsStyles=[txtFontStyle1,txtFontStyle2,txtFontStyle3];
echo(search(":",txtFont3),txtFontsStyles);

//get Dimensions of size 10 text
tm1=textmetrics(txtLine1,size=10,txtFontStyle1,halign="center",valign="center");
tm2=textmetrics(txtLine2,size=10,txtFontStyle2,halign="center",valign="center");
tm3=textmetrics(txtLine3,size=10,txtFontStyle3,halign="center",valign="center");

//calculate the maximum size that fits into text area
txtAreaSize=[txtAreaDimsRel.x*(ovWdth-frameWdth*2),txtAreaDimsRel.y*(ovHght-frameWdth-tongueHght)];
txtAreaYOffset=ovHght/2-txtAreaSize.y/2-frameWdth-(1-txtAreaDimsRel.y)/2*ovHght;

txtSizeFromWidth=txtAreaSize.x/max(tm1.size.x,tm2.size.x,tm3.size.x)*10;
txtSizeFromHght=(txtAreaSize.y/(2*txtLineSpcng))/max(tm1.size.y,tm2.size.y,tm3.size.y)*10;
maxTxtSize=min(txtSizeFromWidth,txtSizeFromHght);

if (showFrame)
  color("orange") frame();
if (showPlate)
  color("white") plate();
if (showTxtArea) 
  #translate([0,txtAreaYOffset,plateThck]) linear_extrude(txtThck/2) square(txtAreaSize,true);
if (showTxt) color("Grey")
  translate([0,txtAreaYOffset,0]) txtArea(txtLines);

echo(txtSizeFromWidth,txtAreaSize);
  
module frame(){
  difference(){
    linear_extrude(frameThck,convexity=4) difference(){
      offset(cornerRad) square([ovWdth-cornerRad*2,ovHght-cornerRad*2],true);
      offset(cornerRad-frameWdth) square([ovWdth-cornerRad*2,ovHght-cornerRad*2],true);
      translate([0,-(ovHght-tongueHght)/2]) square([ovWdth,tongueHght],true);
    }
    plate(true);
  }
}


module plate(cut=false){
  cutSpcng= cut ? fudge : 0;
  
  //center part
  translate([0,0,minFloorThck]) linear_extrude(plateThck-minFloorThck) difference(){
    offset(cornerRad-minWallThck) square([ovWdth-cornerRad*2,ovHght-cornerRad*2],true);
    translate([0,-(ovHght-tongueHght+cutSpcng)/2]) square([ovWdth,tongueHght-cutSpcng],true);
  }
  //fill bottom
  linear_extrude(minFloorThck) difference(){
    offset(cornerRad-frameWdth) square([ovWdth-cornerRad*2,ovHght-cornerRad*2],true);
    translate([0,-(ovHght-tongueHght+cutSpcng)/2]) square([ovWdth,tongueHght-cutSpcng],true);
  }
  //tongue
  linear_extrude(plateThck) 
    translate([0,-(ovHght-tongueHght)/2]) square([tongueWdth,tongueHght],true);
}

module txtArea(size=txtAreaSize, txt=txtLines, font=txtFontsStyles){
  for (i=[0:len(txt)-1]){
    y=(len(txt)-1)/2*maxTxtSize-i*maxTxtSize;
    translate([0,y*txtLineSpcng,plateThck]) linear_extrude(txtThck) text(txt[i],size=maxTxtSize,font=font[i],halign="center",valign="center");
  }
  
}