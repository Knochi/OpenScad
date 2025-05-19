/* Fiverr order from Joseph C 
  backlit Sign
*/

/* [Dimensions] */
wallThck=2;
btmThck=3;
topThck=3;
lipWdth=2;

//lateral (X-Y) spacing
latSpcng=0.3;
//z-Spacing
zSpcng=0.1;
totalHeight=38;

/* [Text] */
//shift the outline outwards (+) or inwards (-)
txtOutline=+6;

txtString="JOSEPH";
txtSize=400;
txtFont="Anton"; //font
txtStyle="Regular"; //["regular","bold","italic"]

/* [Colors] */
botColor="#EEEEEE"; //color
shellColor="#444444"; //color
topColor="#FFFFFF88"; //color

/* [show] */
quality=50; //[20:4:100]
showBottom=true;
showShell=true;
showTop=true;
showSectionCut=false;

export="none"; //["none","bottom","shell","top"]
//set to 0 to show all
selectLetter=0;

/* [Hidden] */
$fn=quality;
fudge=0.1;
btmHght=totalHeight-topThck-zSpcng*2;

txt= selectLetter ? txtString[selectLetter-1] : txtString;
tm=textmetrics(txt,400,txtFont);
fm=fontmetrics(txtSize,txtFont);

// calculate the actual text size
txtTargetSize= (txtSize-(txtOutline+wallThck+latSpcng)*2);
txtNewSize= txtSize * (txtTargetSize / tm.ascent);


if (export=="bottom")
  !bottom();
else if (export=="top")
  !top();
else if (export=="shell")
  !translate([tm.size.x+tm.position.x,0,totalHeight]) rotate([180,0,180]) shell();
else
  difference(){
    union(){
      //Bottom
      if (showBottom)
        color(botColor) bottom();


      //Shell
      if (showShell)
        color(shellColor) shell();

      //Top
      if (showTop)
        color(topColor) translate([0,0,btmHght+zSpcng]) top();
      }
      if (showSectionCut)
      color("darkRed") translate([tm.position.x-fudge/2-wallThck*2-latSpcng*2,-fudge-wallThck*2+tm.position.y,-fudge/2]) 
        cube([tm.size.x+fudge+wallThck*4+latSpcng*4,tm.size.y/2+fudge+wallThck*4,totalHeight+fudge]);
    }

module bottom(){
  linear_extrude(btmThck)  txtLine();
  translate([0,0,btmThck]) linear_extrude(btmHght-btmThck, convexity=4) outlineTxt(wallThck);
}

module shell(){
  linear_extrude(totalHeight, convexity=4) outlineTxt(wallThck,wallThck+latSpcng);
  translate([0,0,totalHeight-topThck/2]) linear_extrude(topThck/2, convexity=4) outlineTxt(lipWdth+latSpcng,latSpcng );
}

module top(){
  linear_extrude(topThck/2, convexity=4) txtLine();
  linear_extrude(topThck, convexity=4) offset(-lipWdth-latSpcng) txtLine();
}


*outlineTxt();
module outlineTxt(thck=2, oOffset=0){
// create outline text with wallthickness and offset
  difference(){
    offset(oOffset) txtLine();
    offset(oOffset-thck) txtLine();
    }
}  

*txtLine();
module txtLine() {
    txt= selectLetter ? txtString[selectLetter-1] : txtString;
    translate([0,txtOutline+wallThck+latSpcng])
    offset(txtOutline)
        text(
            text = txt,
            font = str(txtFont, ":style=", txtStyle),
            size = txtNewSize,
            valign = "bottom",
            halign = "left"
        );
}