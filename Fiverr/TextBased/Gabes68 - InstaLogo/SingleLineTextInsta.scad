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

/* [Text] */
txtLine="YourName";
txtSize=10;
txtSpacing=1; //[0.8:0.05:1.2]
txtFont="Noto Sans"; //font
txtStyle="Regular"; //["regular","bold","italic"]
txtDir="ltr"; //["ltr":"left to right","rtl":"right to left"]
txtLang="en"; //["en","ar","ch"]
txtScript="latin"; //["latin","arabic","hani"]

/* [Logo] */
logoXPos=0; //[-1:0.1:1]
logoSize=10;
logoInvert=false;

/* [Colors] */
backColor="#DDDDDD"; //color
txtOutlineColor="#222222"; //color
txtFillColor="#000000"; //color
logoColor="#654bcc"; //color

/* [show] */
quality=50; //[20:4:100]
showBack=true;
showTextOutline=true;
showTextFill=true;
showEyeLet=true;
showLogo=true;

/* [Hidden] */
txtZOffset= backThck>0 ? backThck : 0;
$fn=quality;
fudge=0.1;

logoBackFile= logoInvert ? "instagramInvBack-10x10.svg" : "instagramBack-10x10.svg";
logoFile =logoInvert ? "instagramInv-10x10.svg" : "instagram-10x10.svg";

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

if (showLogo)
  translate([logoXPos*logoSize-logoSize/2,0,0]) scale(logoSize/10) instaLogo();
  
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
            valign = "center",
            halign = "left",
            spacing = txtSpacing,
            direction = txtDir,
            
        );
}


*instaLogo();
module instaLogo(){
  
  translate([-5,-5,0]){
    color(backColor) linear_extrude(backThck)
      offset(backContour) import(logoBackFile);
    color(logoColor) translate([0,0,backThck])
      linear_extrude(txtThck) import(logoFile);

 }
 }
 