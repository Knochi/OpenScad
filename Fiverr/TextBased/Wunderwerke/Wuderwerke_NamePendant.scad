/* [Dimensions] */
backThck=1;
txtThck=1;
backContour=1.5;
txtContour=0;
holeDia=3;
annularWdth=2;
eyeletXOffset=-2;
eyeletYOffset=0;
 
/* [Text] */
txtString="Wuderwerke";
txtSize=12;
txtFont="Playball"; 
txtStyle="Regular"; //["regular","bold","italic"]

/* [Color] */
backColor="blue"; //color
txtColor="white"; //color


/* [show] */
quality=50; //[20:4:100]
showBody=true;
showText=true;
showEyelet=true;

/* [Hidden] */
//txtStyle= txtStyle1=="None" ? txtStyle2 : str(txtStyle1," ",txtStyle2);
$fn=quality;
fudge=0.1;


//back,
color(backColor) linear_extrude(backThck) offset(backContour) txtLine();
//text
color(txtColor) translate([0,0,backThck]) linear_extrude(txtThck) 
  offset(txtContour) txtLine();
//eyelet
color(backColor) translate([eyeletXOffset,eyeletYOffset]) 
  linear_extrude(backThck) difference(){
    circle(d=holeDia+2*annularWdth);
    circle(d=holeDia);
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