/* 
  Custom tap handle 
  use the latest openSCAD development snapshot from https://openscad.org/downloads.html#snapshots
  enable "textmetrics" from Edit-->Preferencs-->advanced
  it is recommended to set the Backend to "manifold" as well
 
*/
 
/* [Dimensions] */
boreDia =12.7;
boreLen= 30;
baseBottomWidth=30;
baseHeight=50;
baseTopWidth=40;
baseCornerRad=3;
poleWidth=20;
poleCornerRad=1;
poleMinHeight=100;
//spacing to the base
txtBaseSpacing=0;
//spacing to the top of the pole 
txtTopSpacing=0; 
txtThickness=2;

/* [Text] */
txtString="Delirium Tremens";
txtSize=21;
txtDirection="left"; //["left","right"]
txtFont="Arial"; //["Liberation Sans", "Arial"]
txtStyle1=""; //["","Narrow","Condensed"]
txtStyle2="Bold"; //["Regular", "Light", "Medium", "Bold", "ExtraBold"]
txtVertOffsetFront=+0;
txtVertOffsetSide=+0;
/* [Colors] */
txtColor="#f28a9f"; //color
bodyColor="#5493d0"; //color

/* [show] */
quality=50; //[20:4:100]

/* [Hidden] */
txtStyle= txtStyle1 ? str(txtStyle1," ",txtStyle2) : txtStyle2;
txtDims=textmetrics(txtString,txtSize,str(txtFont, ":style=", txtStyle),
                valign = "center",
                halign = "center").size;

txtTotalDims=txtDims.x+txtBaseSpacing+txtTopSpacing;
poleHght= txtTotalDims > poleMinHeight ? txtTotalDims : poleMinHeight;

echo(txtStyle);
$fn=quality;
fudge=0.1;

body();
attachText();

module body(){
  sFac=baseTopWidth/baseBottomWidth;
  color(bodyColor) difference(){
    union(){
      base();
      translate([0,0,baseHeight]) linear_extrude(poleHght) 
        offset(poleCornerRad) square(poleWidth-poleCornerRad*2,true);
      }
    translate([0,0,-fudge/2]) cylinder(d=boreDia,h=boreLen+fudge);
  }
  
  module base(){
    hull() for (ix=[-1,1],iy=[-1,1],iz=[0,1]){
      width= iz ? baseTopWidth : baseBottomWidth;
      translate([ix*(width/2-baseCornerRad),
                 iy*(width/2-baseCornerRad),
                 iz*(baseHeight-baseCornerRad*2)+baseCornerRad]) sphere(baseCornerRad);
                 }
  }
}

module attachText(){
  color(txtColor) translate([txtVertOffsetFront,-poleWidth/2,baseHeight+txtBaseSpacing]) 
    rotate([90,-90,0]) linear_extrude(txtThickness) txtLine();
  color(txtColor) rotate(90) translate([txtVertOffsetSide,-poleWidth/2,baseHeight+txtBaseSpacing]) 
    rotate([90,-90,0]) linear_extrude(txtThickness) txtLine();
}


module txtLine() {
  
        text(
            text = txtString,
            font = str(txtFont, ":style=", txtStyle),
            size = txtSize,
            valign = "center",
            halign = "left"
        );
}