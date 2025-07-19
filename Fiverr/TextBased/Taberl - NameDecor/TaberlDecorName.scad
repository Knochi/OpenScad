/* Name Pendant with decor for Fiverr User Taberl, order #FO527F2A237C7 */

use <fonts/Pacifico-Regular.ttf>

/* [Setup Decor Anchor] */
//1. File Name
decorFileName="default.svg"; //file
//2.  Set to Zero, render (F5), doubleclick on the anchor and enter viewport translate, from the bottom status bar.
decorAnchor=[72.3,33.57];
//3. uncheck when done
setDecorAnchor=false;

/* [Tune Decor (ignored when "setDecor" is checked)] */
//Scale the Decor 
decorScale=1.0; //[0:0.1:2]
//Shift in X position
decorXPosRel=0.990; //[0.8:0.005:1] 
//Shift in Y position
decorYPosRel=0.220; //[0:0.01:1]
//rotate around anchor
decorRotate=0; //[-10:0.1:10]

/* [Dimensions] */
//thickness of the text
txtThck=3;
//thickness of the text infill
fillThck=3;
//width of the outline of the text
outlineWdth=0.1;
//shift the outline outwards (+) or inwards (-)
outlineOffset=0.0;
//enter desired dimensions of the text
txtTargetDims=[75,30];
//enable text scaling in X
enTxtScaleX=true;
//enable text scaling in Y
enTxtScaleY=true;

/* [Text] */
//basic, unscaled text size
txtSize1=10;
txtLine1="Alex";
txtFont="Pacifico"; //font
txtStyle="regular"; //["regular","bold","italic"]
txtFillColor="Orange"; //color
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
txtDimsFromSize= tm1.size + [outlineWdth+outlineOffset+tm1.position.x,outlineWdth+outlineOffset+tm1.position.y];

txtScaleXFac=enTxtScaleX ? txtTargetDims.x/txtDimsFromSize.x : 1;
txtScaleYFac=enTxtScaleY ? txtTargetDims.y/txtDimsFromSize.y : 1;

txtDims=[txtDimsFromSize.x*txtScaleXFac,txtDimsFromSize.y*txtScaleYFac];

echo([txtScaleXFac,txtScaleYFac]);

echo(tm1);
decorPos= setDecorAnchor ? -[decorAnchor.x*decorScale,decorAnchor.y*decorScale] : 
  [txtDims.x*decorXPosRel-decorAnchor.x,txtDims.y*decorYPosRel-decorAnchor.y,0];
  
decorScl = setDecorAnchor ? 1 : decorScale;
decorRot = setDecorAnchor ? 0 : decorRotate;

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
    translate(decorAnchor)
      rotate(decorRot)
        translate(-decorAnchor)
          color(txtOutlineColor) linear_extrude(txtThck) 
            scale(decorScl) import(decorFileName);
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
   scale([txtScaleXFac,txtScaleYFac]) text(
            text = txt,
            font = str(txtFont, ":style=", txtStyle),
            size = size,
            valign = "baseline",
            halign = "left"
        );
}
