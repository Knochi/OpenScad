/* [Text] */
txtString="Dextro";
txtFont="Anton"; //font
//total Margin (left&right)
txtMargin=+5;
txtSize=14.7;
txtThck=2.5;

/* [Positioning] */
txtXOffset=0;
txtYOffset=-0.7;
txtRotation=0;

/* [Clip] */
//the minimum Length (for short names)
clipMinLength=50;
//just the tip
clipSpringLength=20;
//bending angle of tip
clipSprngAngle=15;
//bending radius
clipRad=3;
//the width of the bar
clipWdth=2;
clipThck=2;

/* [Show] */
colTxt="darkRed"; //color
colClip="orange"; //color
roundEnds=true;

showTxt=true;
showClip=true;

quality=50; //[20:10:100]

/* [Hidden] */
tm = textmetrics(txtString, size=txtSize, font=txtFont);

txtOvSize=[tm.size.x+txtMargin,tm.size.y];

/*
plateGrowWdth= ((txtOvSize.x+txtMargin*2) > txtAreaMinDims.x) ? txtOvSize.x-txtAreaMinDims.x+txtMargin*3: 0;
plateGrowHght= (txtOvSize.y > txtAreaMinDims.y) ? txtOvSize.y-txtAreaMinDims.y: 0;
plateGrow=[plateGrowWdth,plateGrowHght];
txtOffset=[flagXOffset+flagDims.x/2+txtMargin+txtOvSize.x/2,0];
*/

clipLen=max(clipMinLength,txtOvSize.x);

if (showClip)
  clip();

if (showTxt)
  txtLine();
module clip(){
  
  color(colClip){
    if (roundEnds)
      translate([0,clipWdth/2,0]) cylinder(d=clipWdth,h=clipThck);
    cube([clipLen,clipWdth,clipThck]);
    translate([clipLen,-clipRad,0]) rotate(-(90+clipSprngAngle)) rotate_extrude(angle=180+clipSprngAngle) translate([clipRad,0]) square([clipWdth,clipThck]);
    //spring
    translate([clipLen,-clipRad,0]) rotate(180-clipSprngAngle) translate([0,clipRad,0]){
      cube([clipSpringLength,clipWdth,clipThck]);
      translate([clipSpringLength,clipWdth/2,0]) cylinder(d=clipWdth,h=clipThck);
      }
    }
}

module txtLine(){
  color(colTxt) translate([txtMargin/2-tm.position.x+txtXOffset,clipWdth+txtYOffset,0])
    linear_extrude(txtThck) text(text=txtString, size=txtSize, font=txtFont,halign="left",valign="bottom");
}

$fn=quality;
