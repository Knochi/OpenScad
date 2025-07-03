/* Name Pendant with decor for Fiverr User Taberl, order #FO527F2A237C7

use <fonts/Pacifico-Regular.ttf>

/* [1. Setup Decor] */
//File Name
decorFileName="default.svg"; //file
//Scale the Decor
decorScale=1; //[0:0.1:2]
//Doubleclick on the anchor and enter pos here
decorAnchor=[36.3,16.6];
//Shift in X position
decorXPosRel=0.98; //[0.8:0.005:1] 
//Shift in Y position
decorYPosRel=0.17; //[0:0.01:1]
//set the Anchor of the decor to the Origin and uncheck
setDecorAnchor=false;

/* [Dimensions] */
//thickness of the text
txtThck=3;
fillThck=2;
//width of the outline of the text
outlineWdth=0.8;
//shift the outline outwards (+) or inwards (-)
outlineOffset=0.2;

/* [Text] */
txtLine1="Alexander";
txtSize1=8;
txtFont="Pacifico"; //font
txtStyle="Regular"; //["regular","bold","italic"]
txtFillColor="darkRed"; //color
txtOutlineColor="orange"; //color


/* [show] */
quality=50; //[20:4:100]
showTextOutline=true;
showTextFill=true;
showDecor=true;


/* [Hidden] */
$fn=quality;
fudge=0.1;
tm1 = textmetrics(txtLine1, size=txtSize1, font=txtFont);
txtSize= tm1.size + [outlineWdth+outlineOffset+tm1.position.x,outlineWdth+outlineOffset+tm1.position.y];
echo(tm1);
decorPos= setDecorAnchor ? -decorAnchor : 
  [txtSize.x*decorXPosRel-decorAnchor.x,txtSize.y*decorYPosRel-decorAnchor.y,0];



if (showTextOutline && !setDecorAnchor)  
//outlineText
  color(txtOutlineColor)
      linear_extrude(txtThck) outlineTxt();

if (showTextFill && !setDecorAnchor)
//text Fill
  color(txtFillColor)
    linear_extrude(fillThck) offset(outlineOffset) txtLine();

if (showDecor)
  decor();
    
module decor(){
  //translate([tm1.size.x*decorXPosRel,tm1.size.y*decorYPosRel,0]) 
  translate(decorPos)
    color(txtOutlineColor) linear_extrude(txtThck) 
      scale(decorScale) import(decorFileName);
}
  
*outlineTxt();
module outlineTxt(){
 
  outOffset=outlineWdth+outlineOffset;
  
  difference(){
    offset(outOffset) txtLine();
    offset(outlineOffset) txtLine();
    }
}  

module txtLine(txt=txtLine1, size=txtSize1) {
        text(
            text = txt,
            font = str(txtFont, ":style=", txtStyle),
            size = size,
            valign = "baseline",
            halign = "left"
        );
}

module eyeLet(){
  translate([eyeletXOffset,eyeletYOffset,0]) 
    linear_extrude(backThck) difference(){
      circle(d=holeDia+2*annularWdth);
      circle(d=holeDia);
    }
}