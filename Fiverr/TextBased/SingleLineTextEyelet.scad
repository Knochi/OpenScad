/*
  Fiverr Order from faisalalrajhi Order No #FO72EAC3E4DC7
  Extruded Text with adjustable offsets, backplate and Eyelet
  You need to install the latest openSCAD developer snapshot (https://openscad.org/downloads.html#snapshots) and activate "textmetrics".
  Open Edit -> Preferences -> Features and check "textmetrics"
*/


/* [Dimensions] */
//thickness of the text
txtThck=3;
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
txtLine="Faisal";
txtSize1=11;
txtSpacing=1; //[0.8:0.05:1.2]
txtFont="Noto Sans"; //font
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

tm1 = textmetrics(txtLine, size=txtSize1, font=txtFont);

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


module txtLine(txt=txtLine, size=12) {
        text(
            text = txt,
            font = str(txtFont, ":style=", txtStyle),
            size = size,
            valign = "center",
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