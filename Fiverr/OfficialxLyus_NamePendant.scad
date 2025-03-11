/* [Dimensions] */
//thickness of the backpkate
backThck=1;
//thickness of the text
txtThck=1;
//contour Width of the backplate
backContour=1.5;

//width of the outline of the text
outlineWdth=1;
//shift the outline outwards (+) or inwards (-)
outlineOffset=0;
 
/* [Text] */
txtLine1="MR";
txtSize1=11;
txtXOffset=-5;
txtYSpacing=0;
txtLine2="TORRES";
txtSize2=12;
txtFont="Comic Sans MS"; //font
txtStyle="Regular"; //["regular","bold","italic"]

/* [Colors] */
backColor="blue"; //color
txtOutlineColor="white"; //color
txtFillColor="orange"; //color

/* [show] */
quality=50; //[20:4:100]
showBack=true;
showTextOutline=true;
showTextFill=true;

/* [Hidden] */
txtZOffset= backThck>0 ? backThck : 0;
$fn=quality;
fudge=0.1;

tm1 = textmetrics(txtLine1, size=txtSize1, font=txtFont);
tm2 = textmetrics(txtLine2, size=txtSize2, font=txtFont);


//back,
if (showBack)
  color(backColor) linear_extrude(backThck) offset(backContour) twoLine();

if (showTextOutline)  
//outlineText
color(txtOutlineColor) translate([0,0,txtZOffset]) 
  linear_extrude(txtThck) outlineTxt();

  if (showTextFill)
//text Fill
color(txtFillColor) translate([0,0,txtZOffset]) 
  linear_extrude(txtThck) offset(outlineOffset) twoLine();
  
*outlineTxt();
module outlineTxt(){
  inOffset=outlineWdth+outlineOffset;
  outOffset=outlineWdth+outlineOffset;
  
  echo(inOffset,outOffset);
  difference(){
    offset(outOffset) twoLine();
    offset(outlineOffset) twoLine();
    }
}  

*twoLine();  
module twoLine(){
    translate([txtXOffset,(tm1.size.y+txtYSpacing)/2]) txtLine(txtLine1,txtSize1);
    translate([0,-(tm2.size.y+txtYSpacing)/2]) txtLine(txtLine2,txtSize2);
    }

module txtLine(txt="test2", size=12) {
        text(
            text = txt,
            font = str(txtFont, ":style=", txtStyle),
            size = size,
            valign = "center",
            halign = "left"
        );
}