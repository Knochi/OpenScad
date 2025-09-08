/*
  Fiverr Order from AlexB Order No ##FO82174B98582
  Extruded Text with alternatic thickness and Eyelet
  You need to install the latest openSCAD developer snapshot (https://openscad.org/downloads.html#snapshots) and activate "textmetrics".
  Open Edit -> Preferences -> Features and check "textmetrics"
*/

// add custom fonts here!
use <gill-sans-ultra-bold.ttf>

/* [Dimensions] */
//thickness of the text
txtThckOdd=3;
txtThckEven=4;
//width of the outline of the text
outlineWdth=0.0;

/* [Eyelet] */
holeDia=3;
annularWdth=2;
eyeletXOffset=-0.7;
eyeletYOffset=5;
eyeletThck=3;

/* [Text] */
txtLine="AndreasB";
txtSize=11;
txtSpacing=0.8; //[0.6:0.05:1.2]
txtFont="Gill Sans Ultra Bold"; //["Gill Sans Ultra Bold","Noto Sans"]
txtStyle="Regular"; //["regular","bold","italic"]

/* [Advanced] */
//arrays of offsets for each char
//needs to be edited in code if more than 4 items in list 
//because customizer no longer supports editable arrays
charXOffsets=[0,0,0,0];
charYOffsets=[0,0,0,0];
charZOffsets=[0,0,0,0];

/* [Colors] */
txtColor="#006600"; //color

/* [show] */
quality=50; //[20:4:100]
showText=true;
showEyeLet=true;

/* [Hidden] */
$fn=quality;
fudge=0.1;

//eyeLet
if (showEyeLet)
  color(txtColor) eyeLet();

if (showText)
  color(txtColor) charByChar();
  
  
module txtZeroTrailing(txt=txtLine, size=txtSize) {
  
  tm=textmetrics(txt,size,txtFont,spacing=txtSpacing);
  //remove the x-Position 
  translate([-tm.position.x,0]) offset(outlineWdth) text(
      text = txt,
      font = str(txtFont, ":style=", txtStyle),
      size = size,
      valign = "baseline",
      halign = "left",
      spacing = txtSpacing,
  );
}


module eyeLet(){
  translate([eyeletXOffset,eyeletYOffset,0]) 
    linear_extrude(eyeletThck) difference(){
      circle(d=holeDia+2*annularWdth);
      circle(d=holeDia);
    }
}



module charByChar(string=txtLine,sum=0,iter=0){
  charPositions=getCharPositions(string,txtSize,txtFont,txtSpacing);
  
  for (i=[0:len(txtLine)-1]){  
    xOffset= (charXOffsets[i] == undef) ? 0 : charXOffsets[i];
    yOffset= (charYOffsets[i] == undef) ? 0 : charYOffsets[i];
    zOffset= (charZOffsets[i] == undef) ? 0 : charZOffsets[i];
    
    extrude = i%2 ? txtThckEven : txtThckOdd;
    translate([charPositions[i]+xOffset,yOffset,0]) linear_extrude(extrude+zOffset) txtZeroTrailing(string[i]);
  }
}



function getCharPositions(string,size,font="",spacing=1,offsets=[],iter=0)=let(
  stringPos=textmetrics(text=string,size=size,font=font,spacing=spacing).position.x,
  thisChrSz=textmetrics(string[iter],size=size,font=font,spacing=spacing).size.x,
  prvChrSz= iter ? textmetrics(string[iter-1],size=size,font=font,spacing=spacing).size.x : 0,
  twoChrsSz=iter ? textmetrics(str(string[iter-1],string[iter]),size=size,font=font,spacing=spacing).size.x : 0,
  charSpcng=twoChrsSz-thisChrSz-prvChrSz,
  chrOffset= (iter==0) ? stringPos : offsets[iter-1]+prvChrSz+charSpcng
) iter<(len(string)) ? getCharPositions(string,size,font,spacing,concat(offsets,chrOffset),iter=iter+1) : offsets;
