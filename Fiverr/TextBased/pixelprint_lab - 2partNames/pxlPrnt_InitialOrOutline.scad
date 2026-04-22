/*
  Fiverr Order from pixelprint_kab Order No 
  
  You need to install the latest openSCAD developer snapshot (https://openscad.org/downloads.html#snapshots) and activate "textmetrics".
  Open Edit -> Preferences -> Features and check "textmetrics" and "roof"
*/

/* [Name] */
name="Pixel";
nameTxtSize=11;
nameOutlineWdth=0.8;
//how much the name protrudes above the back or intial
nameThck=3;
nameSpacing=1; //[0.8:0.05:1.2]
nameFont="Noto Sans"; //font 
nameDir="ltr"; //["ltr":"left to right","rtl":"right to left"]
nameLang="en"; //["en","ar","ch"]
nameScript="latin"; //["latin","arabic","hani"]
//depth of the recess, adds to total thickness of name
nameRecessDpth=1;
nameRecessSpcng=0.15;

/* [Initial] */
initial="O";
//Initial size relative to name width
iniSizeRel=1; //[0.5:0.05:2]
iniOutlineWdth=2;
iniThck=5;
iniFont="Noto Sans"; //font
iniLang="en"; //["en","ar","ch"]
iniScript="latin"; //["latin","arabic","hani"]
nameYOffset=0; //[-0.5:0.05:0.5]
nameXOffset=0; //[-0.5:0.05:0.5]
nameRotation=0;
iniBaseCutoffPercent=5; //[0:0.5:10]

/* [BackPlate] */
 //thickness of the backplate, set to "0" for none
backThck=3;
//contour Width of the backplate
backContour=3.1;

/* [WallMounts] */
wmHeadDia=3;
wmScrewDia=2;
wmHeadThck=1;
wmOvThck=2;
wmDistRel=1; //[0:0.05:1.5]
wmXOffset=0;
wmYOffset=0;

/* [Colors] */
backColor="#660000"; //color
nameColor="#DDDDDD"; //color

/* [show] */
variant="nameInlaySet"; // ["standingInitial","nameInlaySet"]
quality=50; //[20:4:100]
showBack=true;
showName=true;
showInitial=true;
showWallMount=true;


/* [Hidden] */
txtZOffset= backThck>0 ? backThck : 0;
$fn=quality;
fudge=0.1;

tmName = textmetrics(name, size=nameTxtSize, font=nameFont);

//size of the initial with size 10
tmInitialTen=textmetrics(initial, size=10, font=iniFont, halign="center");
initialScaling=((tmName.size.x+nameOutlineWdth*2)/tmInitialTen.size.x)*iniSizeRel;
initialTxtSize=10*initialScaling;
iniSize=[tmInitialTen.size.x*initialScaling,tmInitialTen.size.y*initialScaling];


if (variant=="standingInitial"){
  //render the initial and the name in front
  
  if (showInitial)
    color(backColor) difference(){
      linear_extrude(iniThck, convexity=3) offset(iniOutlineWdth) 
        difference(){
          text(initial,size=initialTxtSize,font=iniFont,halign="center",valign="center");
          translate([-iniSize.x/2,-iniSize.y/2]) square([iniSize.x,iniSize.y*iniBaseCutoffPercent/100]);
        }
      nameOnInitial(nameRecessSpcng);
    }
  if (showName)
    color(nameColor) nameOnInitial();
  }
  
else {
  
  //back,
  if (showBack && backThck)
    color(backColor) difference(){
      linear_extrude(backThck, convexity=3) offset(backContour) txtLine();
      for (ix=[-1,1]) 
        translate([ix*tmName.size.x/2*wmDistRel+wmXOffset,wmYOffset,0]) mirror([0,0,1]) wallHanger();
      translate([0,0,backThck-nameRecessDpth-nameRecessSpcng]) 
        linear_extrude(nameThck+nameRecessDpth+nameRecessSpcng, convexity=3) offset(nameOutlineWdth+nameRecessSpcng) txtLine();
    }

  if (showName)
    color(nameColor) translate([0,0,backThck-nameRecessDpth]) 
      linear_extrude(nameThck+nameRecessDpth, convexity=3) offset(nameOutlineWdth) txtLine();
  }
  

module nameOnInitial(spcng=0){
  translate([nameXOffset*tmInitialTen.size.x*initialScaling,nameYOffset*tmInitialTen.size.y*initialScaling,iniThck-nameRecessDpth-spcng]) 
    rotate(nameRotation) linear_extrude(nameThck+nameRecessDpth+spcng, convexity=3) offset(nameOutlineWdth+spcng) txtLine();
}
  
  
module txtLine(txt=name, size=nameTxtSize) {
        text(
            text = txt,
            font = nameFont,
            size = size,
            valign = "center",
            halign = "center",
            spacing = nameSpacing,
            direction = nameDir,
            
        );
}
 
*wallHanger();
module wallHanger(){
  translate([0,0,-wmOvThck]){
    linear_extrude(wmOvThck+fudge) wmShape();
    linear_extrude(wmHeadThck) wmShape(false);
  }
  
  module wmShape(keyHole=true){
    smallDia = keyHole ? wmScrewDia : wmHeadDia;
    circle(d=smallDia);
    translate([0,-wmHeadDia]) circle(d=wmHeadDia);
    translate([0,-wmHeadDia/2]) square([smallDia,wmHeadDia],true);
  }
}

