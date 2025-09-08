/*
  Fiverr Order from faisalalrajhi Order No #FO51AE1015D83
  Extruded Text with brick pattern
  You need to install the latest openSCAD developer snapshot (https://openscad.org/downloads.html#snapshots) and activate "textmetrics".
  Open Edit -> Preferences -> Features and check "textmetrics"
*/

/* [Dimensions] */
//thickness of the text
txtThck=2;
//width of the outline of the text
outlineWdth=0.8;
//thickness of the backplate set to "0" for none
backThck=2;
//contour Width of the backplate
backContour=3.1;
backVariant= "none"; //["none","plate","contour"]

/* [Text] */
txtLine="Faisal";
txtSize=50;
txtSpacing=1; //[0.8:0.05:1.2]
txtFont="Noto Sans"; //font
txtStyle="Regular"; //["regular","bold","italic"]
txtDir="ltr"; //["ltr":"left to right","rtl":"right to left"]
txtLang="en"; //["en","ar","ch"]
txtScript="latin"; //["latin","arabic","hani"]

/* [Colors] */
backColor="#660000"; //color
txtColor="#006600"; //color


/* [studs] */
studXOffset=0; //[-1:0.1:1]
studYOffset=0; //[-1:0.1:1]
studDia=4.85;
studHght=1.85;
studSpcng=8;

/* [show] */
quality=50; //[20:4:100]

/* [Hidden] */
$fn=quality;
fudge=0.1;
tm=textmetrics( text = txtLine,
            font = str(txtFont, ":style=", txtStyle),
            size = txtSize,
            valign = "center",
            halign = "left",
            spacing = txtSpacing,
            direction = txtDir);
echo(tm);            

studCount=[ceil((tm.size.x+outlineWdth*2)/studSpcng)+2,ceil((tm.size.y+outlineWdth*2)/studSpcng)+2];
studOffset=[studXOffset*studSpcng,studYOffset*studSpcng,0];
plateThck= backVariant == "none" ? 0 : backThck;
plateDims= [(studCount.x)*studSpcng,(studCount.y)*studSpcng,plateThck];
studDims= [(studCount.x)*studSpcng,studCount.y*studSpcng,plateThck]; 
plateRad=studSpcng/2;


//back
if (backVariant=="plate")
  color(backColor) linear_extrude(plateDims.z) hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(plateDims.x/2-plateRad)+plateDims.x/2,iy*(plateDims.y/2-plateRad)]) circle(plateRad);
else if (backVariant=="contour")
  color(backColor) linear_extrude(backThck) offset(backContour) txtLine();

//text
color(txtColor) translate([0,0,plateDims.z]) linear_extrude(txtThck) offset(outlineWdth) txtLine();

//studs
color(txtColor)
  intersection(){
    translate([plateDims.x/2,0,plateDims.z+txtThck]+studOffset) 
      studs(studCount,true);
    translate([0,0,plateDims.z]) linear_extrude(txtThck+studHght+fudge,convexity=4) offset(outlineWdth) txtLine();
    }
  
module studs(count=[4,4], center=true){
  cntrOffset= center ? [-studSpcng*(count.x-1)/2,-studSpcng*(count.y-1)/2,0] : [0,0,0];
  translate(cntrOffset)
    for (ix=[0:count.x-1],iy=[0:count.y-1])
      translate([ix*studSpcng,iy*studSpcng,0]) cylinder(d=studDia,h=studHght);
}

module txtLine(txt=txtLine, size=txtSize) {
        text(
            text = txt,
            font = str(txtFont, ":style=", txtStyle),
            size = size,
            valign = "center",
            halign = "left",
            spacing = txtSpacing,
            direction = txtDir
            
        );
}