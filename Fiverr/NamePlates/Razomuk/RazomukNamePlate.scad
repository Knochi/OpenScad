/* [Dimensions] */
$fn=50;
plateThck=3.5;
plateMinDims=[50,15];
//Elevation of the embossing
embossThck=1.5;
flagDims=[33.1,17.18];
cornerRad=2.5;
//Layer thickness
layerThick=0.2;
euBandLayers=3;
keyHoleDia=4.6;

/* [Positioning] */
keyHolePos=[4.5,19.2];

/* [Colors] */
colBack="white";
colText="darkSlateGrey";
colFlag="blue";
colLine="white";

/* [Text] */
txtString="Shogen";
txtFont="Liberation Sans";
txtSize=7;
txtMargin=7;
txtThck=0.6;
cntryString="NL";
cntryFont="Liberation Sans";
cntrySize=3;


/* [Show] */
showPlate=true;
showText=true;
showBand=true;
showFrame=true;


export="all"; //["colBack","colText","colEU","colCntry","colStars"]


*translate([102.02,-47.87,0]) import("14068 Duty Officer.stl");

*projection(true) translate([94.91,-50.95,-4]) import("14068 Duty Officer.stl");

unionJack();
module unionJack(size=flagDims, center=false){
  //https://www.flaginstitute.org/wp/uk-flags/union-flag-specification  3:5
  //https://www.jdawiseman.com/papers/union-jack/union-jack.html 1:2
  
  jackDims=[60,30];
  inCrossWdth=6;
  inCrossBrim=2;
  outrLineWdths=[0.9,0.7];
  crnrSquareDims=[jackDims.x/2-inCrossWdth/2-inCrossBrim,jackDims.y/2-inCrossWdth/2-inCrossBrim];
  diagAng=atan(jackDims.y/jackDims.x);
  diagLen=norm([60,30]);
  
  cntrOffset= center ? [0,0] : [jackDims.x/2,jackDims.y/2];
  
  scale([size.x/jackDims.x,size.y/jackDims.y]) linear_extrude(2) difference(){
    square(jackDims+outrLineWdths*2,true);
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
