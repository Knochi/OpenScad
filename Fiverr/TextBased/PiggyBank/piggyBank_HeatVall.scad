/* Fiverr order from heathvall
*/

/* [Dimensions] */
wallThck=1;
btmThck=2;
topThck=4;
//increase until all holes filled
brimWdth=11;
//lateral (X-Y) spacing
latSpcng=0.2;
//z-Spacing
zSpcng=0.1;
totalThick=20;
totalHeight=50;

/* [Top-Text] */
txtString="HeatVall";
//shift the outline outwards (+) or inwards (-)
txtOutline=+0.5;
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

/* [Hidden] */
$fn=quality;
fudge=0.1;
txtHght=totalHeight;
btmHght=totalThick-wallThck*2-zSpcng*2-topThck;

txt= txtString;
tm=textmetrics(txt,txtHght,txtFont);
fm=fontmetrics(txtHght,txtFont);

// calculate the actual text size
txtTargetSize= (txtHght-(txtOutline+brimWdth)*2);
txtSize= txtHght * (txtTargetSize / tm.ascent);


if (export=="bottom")
  !bottom();
else if (export=="top")
  !top();
else if (export=="shell")
  !translate([tm.size.x+tm.position.x,0,totalThick]) rotate([180,0,180]) shell();
else //Assembly
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
        color(topColor) translate([0,0,totalThick-(topThck+wallThck*2)-zSpcng]) top();
      }
      if (showSectionCut)
      color("darkRed") 
        translate([tm.position.x-fudge/2-wallThck*2-latSpcng*2-brimWdth,-fudge-wallThck*2+tm.position.y-brimWdth,-fudge/2]) 
          cube([tm.size.x+fudge+wallThck*4+latSpcng*4+txtOutline,tm.size.y/2+fudge+wallThck*4+brimWdth,totalThick+fudge]);
    }

module bottom(){
  linear_extrude(btmThck, convexity=3)  offset(brimWdth-wallThck) txtLine();
  translate([0,0,btmThck]) linear_extrude(btmHght-btmThck, convexity=4) outlineTxt(wallThck,brimWdth-wallThck);
}

module shell(){
  //base
  linear_extrude(totalThick-topThck-wallThck, convexity=4) outlineTxt(wallThck,brimWdth+latSpcng);
  //roof with cutout
  translate([0,0,totalThick-wallThck-topThck]) linear_extrude(wallThck, convexity=4) 
    outlineTxt(brimWdth+latSpcng-txtOutline,brimWdth+latSpcng);
}

module top(){
  linear_extrude(wallThck, convexity=4) offset(brimWdth-wallThck) txtLine();
  linear_extrude(topThck+wallThck*2+zSpcng, convexity=4) offset(-latSpcng+txtOutline) txtLine();
}


*linear_extrude(2,convexity=3) outlineTxt();
module outlineTxt(thck=5, oOffset=+5){
// create outline text with wallthickness and offset
  difference(){
    offset(oOffset) txtLine();
    offset(oOffset-thck) txtLine();
    }
}  

*txtLine();
module txtLine() {
    txt= txtString;
    translate([0,txtOutline+wallThck+latSpcng])
      offset(txtOutline)
        text(
            text = txt,
            font = str(txtFont, ":style=", txtStyle),
            size = txtSize,
            valign = "bottom",
            halign = "left"
        );
}