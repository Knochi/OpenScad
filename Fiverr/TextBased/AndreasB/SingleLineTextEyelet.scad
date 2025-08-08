/*
  Fiverr Order from AlexB Order No ##FO82174B98582
  Extruded Text with adjustable offsets, backplate and Eyelet
  You need to install the latest openSCAD developer snapshot (https://openscad.org/downloads.html#snapshots) and activate "textmetrics".
  Open Edit -> Preferences -> Features and check "textmetrics"
*/

// add custom fonts here!
use <gill-sans-ultra-bold.ttf>

/* [Dimensions] */
//thickness of the text
txtThckMin=3;
txtThckMax=4;
//width of the outline of the text
outlineWdth=0.8;
//shift the outline outwards (+) or inwards (-)
outlineOffset=0.2;
 //thickness of the backplate set to "0" for none
backThck=2;
//contour Width of the backplate
backContour=3.1;

/* [Eyelet] */
holeDia=3;
annularWdth=2;
eyeletXOffset=-4;
eyeletYOffset=0;

/* [Text] */
txtLine="AVAVAV";
txtSize=11;
txtSpacing=1; //[0.8:0.05:1.2]
txtFont="Gill Sans Ultra Bold"; //["Gill Sans Ultra Bold","Noto Sans"]
txtStyle="Regular"; //["regular","bold","italic"]
txtDir="ltr"; //["ltr":"left to right","rtl":"right to left"]
txtLang="en"; //["en","ar","ch"]
txtScript="latin"; //["latin","arabic","hani"]


/* [Colors] */
backColor="#660000"; //color
txtOutlineColor="#006600"; //color
txtFillColor="#000066"; //color

/* [show] */
quality=50; //[20:4:100]
showBack=true;
showTextOutline=true;
showTextFill=true;
showEyeLet=true;

/* [Hidden] */
txtZOffset= backThck>0 ? backThck : 0;
$fn=quality;
fudge=0.1;

tm1 = textmetrics(txtLine, size=txtSize, font=txtFont);
//echo(tm1);


txtThck=txtThckMin;

//eyeLet
if (showEyeLet)
  color(backColor) eyeLet();

//back,
if (showBack)
  color(backColor) linear_extrude(backThck) offset(backContour) txtLine();

if (showTextOutline)  
//outlineText
  color(txtOutlineColor)
    translate([0,0,txtZOffset]) 
      linear_extrude(txtThck) outlineTxt();

if (showTextFill)
//text Fill
  color(txtFillColor) translate([0,0,txtZOffset]) 
    linear_extrude(txtThck) offset(outlineOffset) txtLine();
  
  
*outlineTxt();
module outlineTxt(){
 
  outOffset=outlineWdth+outlineOffset;
  
  difference(){
    offset(outOffset) txtLine();
    offset(outlineOffset) txtLine();
    }
}  


module txtLine(txt=txtLine, size=txtSize) {
        text(
            text = txt,
            font = str(txtFont, ":style=", txtStyle),
            size = size,
            valign = "baseline",
            halign = "left",
            spacing = txtSpacing,
            direction = txtDir,
            
        );
}

module eyeLet(){
  translate([eyeletXOffset,eyeletYOffset,0]) 
    linear_extrude(backThck) difference(){
      circle(d=holeDia+2*annularWdth);
      circle(d=holeDia);
    }
}


!charByChar();
module charByChar(string=txtLine,sum=0,iter=0){

  cm=textmetrics(string[iter],size=txtSize, font=txtFont);
  
  echo(string[iter],cm.size.x);
  
  if (iter<len(string)-1){
    translate([sum,0,0]) txtLine(string[iter]);
    //metrics of this and next char together
    tm2=textmetrics(str(string[iter],string[iter+1]),size=txtSize, font=txtFont);
    //metrics of next char alone
    cmNxt=textmetrics(string[iter+1],size=txtSize, font=txtFont);
    spcng=tm2.size.x
          //-(cm.advance.x-cm.size.x)
          //-(cmNxt.advance.x-cmNxt.size.x)
          //-cmNxt.position.x
          -cm.size.x-cmNxt.size.x;
    charByChar(string,sum+cm.size.x+spcng,iter+1);
    }
  else{
    tm=textmetrics(string,size=txtSize, font=txtFont);
    echo(tm);
    echo(sum+cm.size.x);
    translate([0,tm.size.y,0]) txtLine();
    translate([sum,0,0]) txtLine(string[iter]);
    }
}