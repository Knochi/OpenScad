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

/* [Colors] */
txtColor = "grey"; //color
svgColor = "BlueViolet"; //color
plateColor = "white"; //color
frameColor = "orange"; //color

/* [Text General] */
//relative text Area Size from with and height-tongue
txtAreaDimsRel=[0.90,1.0];
txtLineSpcng=2.2; //[1:0.1:2]
//caclulate size from textarea
txtAutoSize=false;

/* [Text Line1] */
txtLine1="Hold the vision";
txtFont1="Noto Sans";//Font
txtStyle1= "Regular";//["Regular","Bold","Italic"]
txtMod1= "none";//["none","Underline","Strikethrough"]
txtAlign1= "center";//["left","right"]
txtSize1= 10;
txtXOffset1= 0;
txtYOffset1= 0;

/* [Text Line2] */
txtLine2="TRUST";
txtFont2="Noto Sans";//Font
txtStyle2= "Regular";//["Regular","Bold","Italic","Underline","Strikethrough"]
txtMod2= "none";//["none","Underline","Strikethrough"]
txtAlign2= "center";//["left","right"]
txtSize2= 10;
txtXOffset2= 0;
txtYOffset2= 0;

/* [Text Line3] */
txtLine3="the process";
txtFont3="Noto Sans";//Font
txtStyle3= "Regular";//["Regular","Bold","Italic","Underline","Strikethrough"]
txtMod3= "none";//["none","Underline","Strikethrough"]
txtAlign3= "center";//["left","right"]
txtSize3= 10;
txtXOffset3= 0;
txtYOffset3= 0;

/* [SVG] */
svgFileName="default.svg";
svgScale=1.5;
svgThick=1;
svgXOffset=0; //[-1.5:0.1:1.5]
svgYOffset=0; //[-1.5:0.1:1.5]


/* [show] */
showTxt=true;
showSVG=true;
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

//make arrays to handle each line in one operation
txtLines=[txtLine1,txtLine2,txtLine3];
txtFontsStyles=[txtFontStyle1,txtFontStyle2,txtFontStyle3];
txtAligns=[txtAlign1,txtAlign2,txtAlign3];
txtMods=[txtMod1,txtMod2,txtMod3];
txtSizes= [txtSize1,txtSize2,txtSize3];
txtOffsets= [[txtXOffset1,txtYOffset1],[txtXOffset2,txtYOffset2],[txtXOffset3,txtYOffset3]];


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
  color(frameColor) frame();
if (showPlate)
  color(plateColor) plate();
if (showTxtArea) 
  #translate([0,txtAreaYOffset,plateThck]) linear_extrude(txtThck/2) square(txtAreaSize,true);
if (showTxt) color(txtColor)
  translate([0,txtAreaYOffset,0]) txtArea(txt=txtLines);
if (showSVG)
  color(svgColor) translate([svgXOffset*txtAreaSize.x/2,svgYOffset*txtAreaSize.y/2,0]) svg();

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


module svg(){
  translate([0,0,plateThck]) linear_extrude(svgThick) scale(svgScale) import(svgFileName);
}

module txtArea(size=txtAreaSize, txt=txtLines, font=txtFontsStyles, mod=txtMods, txtSize=txtSizes, offset=txtOffsets ){

  for (i=[0:len(txt)-1]){
    y=(len(txt)-1)/2*maxTxtSize-i*maxTxtSize;
    xOffset= txtAligns[i]=="left" ? -size.x/2 :
             txtAligns[i]=="right" ? size.x/2 :
             0;
    thisSize= txtAutoSize ? maxTxtSize : txtSize[i];
    echo(i,thisSize);
    translate([xOffset + offset[i].x,y*txtLineSpcng + offset[i].y,plateThck]) linear_extrude(txtThck){
      text(txt[i],size=thisSize,font=font[i],halign=txtAligns[i],valign="center");
      if (mod[i]=="Underline") underlineTxt(txt=txt[i],size=thisSize,font=font[i],align=txtAligns[i]);
      if (mod[i]=="Strikethrough") strikethroughTxt(txt=txt[i],size=thisSize,font=font[i],align=txtAligns[i]);
    }
  }
}

*underlineTxt();
module underlineTxt(txt="My text",size=10,font="Noto Sans:style=Regular",align="center"){
  //adds a line to a given text
  ulTm=textmetrics(txt,size,font,halign=align,valign="center");
  lineThck= size/10;
  lineXOffset= align=="left" ? ulTm.size.x/2 : 
               align=="right" ? -ulTm.size.x/2 :
               0;
  lineYOffset=ulTm.offset.y-lineThck*2;
 
  
  difference(){
    translate([lineXOffset,lineYOffset]) square([ulTm.size.x,size/10],true);
    offset(size/10) text(txt,size,font,halign=align,valign="center");
  }
}

module strikethroughTxt(txt="My text",size=10,font="Noto Sans:style=Regular",align="center"){
  //adds a line to a given text
  stTm=textmetrics(txt,size,font,halign=align,valign="center");
  lineThck= size/10;
  lineXOffset= align=="left" ? stTm.size.x/2 : 
               align=="right" ? -stTm.size.x/2 :
               0;
  lineYOffset=0;
  
  
  translate([lineXOffset,lineYOffset]) square([stTm.size.x,size/10],true);
  
}