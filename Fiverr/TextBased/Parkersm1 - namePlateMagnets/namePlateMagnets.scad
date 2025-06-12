/* [Dimensions] */
//thickness of the text
txtThck=3;
//add an outline to the text
outlineWdth=0.0;
 //thickness of the backplate 
backThck=3;
//contour Width of the backplate
backContour=3.1;

/* [Magnets] */
magDia=6;
magThck=2;
//minimum thickness to close pocket
magMinLayerThck=0.6;
//spacing to add in Z
magZSpcng=0.1;
//spacing to add in X-Y
magLatSpcng=0.1;
//where to place magnets relative to width
magXPosRel=[0.2,0.8];

/* [Text] */
txtLine="Parker";
txtSize=11;
txtYSpacing=0.8;
txtFont="Noto Sans"; //font
txtStyle="bold"; //["regular","bold","italic"]

/* [Colors] */
backColor="#0F0F0F"; //color
txtColor="#DDDDDD"; //color

/* [show] */
quality=50; //[20:4:100]
showBack=true;
showText=true;
showSectionCut=false;
showMagnets=false;
export="none"; //["none","Text","Back","Complete"]

/* [Hidden] */
limBackThck=max(backThck,magThck+(magZSpcng+magMinLayerThck)*2);
txtZOffset= limBackThck>0 ? limBackThck : 0;
$fn=quality;
fudge=0.1;

tm = textmetrics(txtLine, size=txtSize, font=str(txtFont, ":style=", txtStyle));
echo(tm);
ovDims=[tm.size.x + 2*backContour,tm.size.y + 2*backContour,limBackThck+txtThck];


if (export=="Text")
  color(txtColor) translate([0,0,txtZOffset]) 
        linear_extrude(txtThck, convexity=3) offset(outlineWdth) txtLine();
else if (export=="Back")
  color(backColor) back();
else if (export=="Complete"){
  color(txtColor) translate([0,0,txtZOffset]) 
    linear_extrude(txtThck, convexity=3) offset(outlineWdth) txtLine();
  color(backColor) back();
  }
  
else difference(){
  union(){
    if (showBack)
      color(backColor) back();

    if (showText)
      //text Fill
      color(txtColor) translate([0,0,txtZOffset]) 
        linear_extrude(txtThck, convexity=3) offset(outlineWdth) txtLine();
  }
  
  if (showSectionCut) color("darkRed") 
    translate([-backContour-fudge/2+tm.position.x,-ovDims.y/2-fudge,-fudge/2]) 
      cube([ovDims.x+fudge,ovDims.y/2+fudge,ovDims.z+fudge]);
}

if (showMagnets && export=="none")
  color("silver") for (pos=magXPosRel*ovDims.x)
      translate([pos,0,magMinLayerThck+magZSpcng]) cylinder(d=magDia,h=magThck);
   
  
module back(){
  //back with embedded magnets
  difference(){
    linear_extrude(limBackThck, convexity=3) offset(backContour) txtLine();
    for (pos=magXPosRel*ovDims.x)
      translate([pos,0,magMinLayerThck]) cylinder(d=magDia+2*magLatSpcng,h=magThck+2*magZSpcng);
      }
}
  


module txtLine(txt=txtLine, size=txtSize) {
        text(
            text = txt,
            font = str(txtFont, ":style=", txtStyle),
            size = size,
            valign = "center",
            halign = "left"
        );
}
