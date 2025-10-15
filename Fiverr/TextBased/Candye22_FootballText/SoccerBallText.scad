/* [Ball] */
ballVariant="SoccerHeart"; //["none","SoccerHeart","SoccerRound","customSVG"]
//thickness of the ball frame
ballFrameThick=2;
//thickness of the ball fields (0 for no fields)
ballFieldsThick=1;
//Y Offset of the ball shape
ballYOffset=0;
//relative scale to txtSize
ballRelScale=3; 

/* [Text] */
txtLine="Jordyn";
txtSize=10;
//select "custom" to enter font string below or choose from makerworld
txtFont="FreeSerif:style=Italic"; //["custom","FreeSerif:style=Italic","TeX Gyre Schola:style=Italic"]
txtCustomFont="Noto Sans"; //font

/* [TextDimensions] */
//thickness of the text
txtThck=3;
txtOutlineThck=3.4;
//width of the outline of the text
txtOutlineWidth=1.3;
//shift the outline outwards (+) or inwards (-)
txtOutlineOffset=0.4;

/* [Colors] */
ballFieldsColor="#FFFFFF"; //color
ballFrameColor="#222222"; //color
txtColor="#38b6ff"; //color
txtOutlineColor="#222222"; //color
//reduce colorThickness to optColorThck
txtColorOptimize=true;
//reduce colorThickness to optColorThck
ballColorOptimize=true;
optColorThck=1.2;

/*[TextParameters]*/
txtSpacing=1; //[0.8:0.05:1.2]
txtDir="ltr"; //["ltr":"left to right","rtl":"right to left"]
txtLang="en"; //["en","ar","ch"]
txtScript="latin"; //["latin","arabic","hani"]

/* [files] */
//for makerworld integration
mWorldFrameSVG="default.svg";
mWorldFieldsSVG="default.svg";


/* [show] */
showBall=true;
showFields=true;
showFrame=true;
showText=true;
showTxtOutline=true;
quality=50; //[20:4:100]

/* [Hidden] */
$fn=quality;

rndBallFrameSVG= "RoundBall_Frame.svg"; 
rndBallFieldsSVG= "RoundBall_Fields.svg"; 
heartBallFrameSVG= "HeartBall_Frame.svg"; 
heartBallFieldsSVG= "HeartBall_Fields.svg";

ballScale=0.01*txtSize*ballRelScale;
font= (txtFont=="custom") ? txtCustomFont : txtFont;


if (showBall)
    ball();
    
if (showText){
  textASY();
}



module textASY(){
  if (showTxtOutline)
    color(txtOutlineColor) linear_extrude(txtOutlineThck) outlineTxt();
  if (showText)  
    if (txtColorOptimize&& (optColorThck<txtThck)){
      color(txtColor) translate([0,0,txtThck-optColorThck]) linear_extrude(optColorThck) offset(txtOutlineOffset) txtLine();  
      color(txtOutlineColor) linear_extrude(txtThck-optColorThck) offset(txtOutlineOffset) txtLine();  
      }
    else
      color(txtColor) linear_extrude(txtThck) offset(txtOutlineOffset) txtLine();  
}

module ball(){

  //RoundBall is circle 100x100mm,HeartBall is shape 100x88.7mm
  svgFrameFile= (ballVariant=="SoccerRound") ? rndBallFrameSVG : (ballVariant=="customSVG") ? mWorldFrameSVG : heartBallFrameSVG;
  svgFieldFile= (ballVariant=="SoccerRound") ? rndBallFieldsSVG : (ballVariant=="customSVG") ? mWorldFieldsSVG : heartBallFieldsSVG;
  
  translate([0,ballYOffset,0]) scale(ballScale) translate([-50,0,0]) {
    if (showFrame)
      color(ballFrameColor) linear_extrude(ballFrameThick) diffText() import(svgFrameFile);
    if (showFields)
      if (txtColorOptimize && (optColorThck<ballFieldsThick)){
        color(ballFieldsColor) translate([0,0,ballFieldsThick-optColorThck]) 
          linear_extrude(optColorThck) diffText() import(svgFieldFile);
        color(ballFrameColor) linear_extrude(ballFieldsThick-optColorThck) diffText() import(svgFieldFile);
      }
      else
        color(ballFieldsColor) linear_extrude(ballFieldsThick) diffText() import(svgFieldFile);
        
  }
}

*outlineTxt();
module outlineTxt(){
 
  outOffset=txtOutlineWidth+txtOutlineOffset;

  difference(){
    offset(outOffset) txtLine();
    offset(txtOutlineOffset) txtLine();
    }
}  


module txtLine(){
    text(
            text = txtLine,
            font = font,
            size = txtSize,
            valign = "baseline",
            halign = "center",
            spacing = txtSpacing,
            direction = txtDir,
            
        );
}

module diffText(){
  difference(){
    children();
    translate([50,0,0]) scale(1/ballScale) offset(txtOutlineWidth+txtOutlineOffset) txtLine();
  }
}