/* [Text] */
txtString="RAZOMUK";
txtString2="";

txtFont="Anton"; //font
txtSize=14.7;
txtMargin=2;

txtLineSpacing=0.81;

/* [Dimensions] */
quality=50; //[20:10:100]
plateThck=3.5;
plateCornerRad=1.5;

//Minimum Dimensions of the plate
plateMinDims=[93,23.44];
//Elevation of the embossing
embossThck=1.5;

//thickness of the band in the flag
bandThck=0.2;
//width of the band in the flag
bandWdth=1.34;
//dimensions of the flag
flagDims=[33.1,17.18];

keyHoleDia=4.6;


/* [Positioning] */

keyHoleOffset=[4.5,4.5];
//flagPos=[23.7,11.7];
flagXOffset=23.7;
/* [Colors] */
colBack="#222222"; //color
colText="white"; //color
colFlag="white"; //color
colBand="#CC0000"; //color

/* [Show] */
showPlate=true;
showFlag=true;
showText=true;
showBand=true;

/* [Hidden] */

flagOutrLineWdths=[0.9,0.7];

tm = textmetrics(txtString, size=txtSize, font=txtFont);
tm2 = textmetrics(txtString2, size=txtSize, font=txtFont);

txtAreaMinDims=[plateMinDims.x-flagDims.x/2-flagXOffset,plateMinDims.y];

txtOvSize=[max(tm.size.x,tm2.size.x),(tm.size.y + tm2.size.y) * txtLineSpacing*1.5+txtMargin*2];

plateGrowWdth= ((txtOvSize.x+txtMargin*2) > txtAreaMinDims.x) ? txtOvSize.x-txtAreaMinDims.x+txtMargin*3: 0;
plateGrowHght= (txtOvSize.y > txtAreaMinDims.y) ? txtOvSize.y-txtAreaMinDims.y: 0;
plateGrow=[plateGrowWdth,plateGrowHght];

plateDims=plateMinDims+plateGrow;

txtOffset=[flagXOffset+flagDims.x/2+txtMargin+txtOvSize.x/2,0];


$fn=quality;

//SHOW
if (showPlate)
  plate();

if (showFlag)
  flag();

if (showBand)
  band();

if (showText){
  if (txtString2){
    translate([0,txtSize * txtLineSpacing]) myText();
    translate([0,-txtSize * txtLineSpacing]) myText(txtString2);
    }
  else
  myText();
  }
  
//translate([flagXOffset+flagDims.x/2+txtMargin, 0,plateThck]) linear_extrude(1) square(txtOvSize);
  
module plate(){
  color(colBack) linear_extrude(plateThck) difference(){
    rndRect(plateDims,plateCornerRad);
    translate([keyHoleOffset.x,plateDims.y-keyHoleOffset.y]) circle(d=keyHoleDia);
  }
}

module flag(){
  color(colFlag)
  translate([flagXOffset,plateDims.y/2,plateThck]) linear_extrude(embossThck){  
      difference(){
        square(flagDims,true);
        unionJack(flagDims-flagOutrLineWdths*2);
      }
      square([flagDims.x-flagOutrLineWdths.x*2,bandWdth],true);
    }  
}
  
module band(){
  color(colBand) translate([flagXOffset,plateDims.y/2,plateThck+embossThck]) linear_extrude(bandThck)
    square([flagDims.x-flagOutrLineWdths.x*2,bandWdth],true);
    }

    
module myText(string=txtString){
  color(colText) translate([txtOffset.x,plateDims.y/2,plateThck])
    linear_extrude(embossThck) text(string, size=txtSize, font=txtFont,halign="center",valign="center");
}
    
module unionJack(size=flagDims, center=false){
  //https://www.flaginstitute.org/wp/uk-flags/union-flag-specification  3:5
  //https://www.jdawiseman.com/papers/union-jack/union-jack.html 1:2
  
  jackDims=[60,30];
  inCrossWdth=6;
  inCrossBrim=2;
  
  crnrSquareDims=[jackDims.x/2-inCrossWdth/2-inCrossBrim,jackDims.y/2-inCrossWdth/2-inCrossBrim];
  diagAng=atan(jackDims.y/jackDims.x);
  diagLen=norm([60,30]);
  
  cntrOffset= center ? [0,0] : [jackDims.x/2,jackDims.y/2];
  
  scale([size.x/jackDims.x,size.y/jackDims.y]) {
    crnrSquares();
    square([inCrossWdth,jackDims.y],true);
    square([jackDims.x,inCrossWdth],true);
    }
  
  module crnrSquares(){
    for (r=[0,180]){
      rotate(r){
        translate([-jackDims.x/2,-jackDims.y/2]) difference(){
          square(crnrSquareDims);
            rotate(diagAng) {
              square([diagLen/2,3]);
              //color("#CC0000") translate([0,-2])  square([diagLen/2,2]);
              translate([0,-3])  square([diagLen/2,1]);
            }
        }
      
      
      translate([jackDims.x/2,-jackDims.y/2]) difference(){
        translate([-crnrSquareDims.x,0]) square(crnrSquareDims);
        rotate(-diagAng){
          translate([-diagLen/2,-3]) square([diagLen/2,3]);
          translate([-diagLen/2,2]) square([diagLen/2,1]);
        }
      }
    }
  }
  }
}

 module rndRect(size=[10,10],radius=cornerRad){
  crnrRadius = radius > 0 ? radius : 0;
  translate([radius,radius]) offset(radius) square(size+[-radius*2,-radius*2]);
 }