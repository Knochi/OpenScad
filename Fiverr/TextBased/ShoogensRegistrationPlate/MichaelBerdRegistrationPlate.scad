//Get the length of a text and scale the underlying plate accordingly
//You need to activate the experimental textmetrics() and fontmetrics() functions
//got to Edit->Preferences->Features


/* 
  From EU Regulation NO 2411/98
  -----------------------------
  Colours:
  1. blue background (Munsell reference 5,9 pb 3,4/15,1)
  2. 12 yellow stars
  3. distinguishing sign of the member state in white or yellow
  
  Dimensions:
  1. Blue background:
     height= minimum 98mm
     width= min. 40mm, max. 50mm
     --> x,y ratio approx. 1:2 
  2. The Centers of the 12 stars to be arranged in a 15mm radius circle; 
     distance between two opposing peaks of any star 4 to 5mm
     --> 
  3. Distinguishing sing of the member state:
     height= min 20mm
     width of character stroke = 4 to 5mm
    
*/

/* [Dimensions] */
$fn=50;
plateThck=2;
plateMinDims=[50,15];
//Elevation of the embossing
embossThck=0.6;
//Width of the embossing
borderWdth=1;
//Embossing offset from edge
embossOffset=0.5;
cornerRad=3;
//Layer thickness
layerThick=0.2;
euBandLayers=3;
keyRingHole=4;
keyRingDia=8;

/* [Positioning] */
//Country Part
cntryPosRel=0.29; //[0:0.01:1]
//Stars
starsPosRel=0.71; //[0:0.01:1]
//Text X-Offset
txtXPosRel=0; //[-1:0.01:1]
//Text Y-Offset
txtYPosRel=0; //[-1:0.01:1]
keyRingPos="left"; //["left","right","none"]

/* [Colors] */
colBack="white";
colText="darkSlateGrey";
colEU="blue";
colCntry="white";
colStars="yellow";

/* [Text] */
txtString="Michaelberd";
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

/* [Hidden] */ 
plateDims=plateMinDims;
innerRadius=cornerRad-embossOffset-borderWdth;

euBandHght=plateDims.y-embossOffset*2-borderWdth*2;
euBandWdth=euBandHght/2;
euBandOffset=[embossOffset+borderWdth,embossOffset+borderWdth,plateThck-euBandLayers*layerThick];

tm = textmetrics(txtString, size=txtSize, font=txtFont);
echo(tm);
txtAreaDims=[plateMinDims.x-euBandWdth-borderWdth*2-embossOffset*2,0];


plateGrowWdth= ((tm.size.x+txtMargin*2) > txtAreaDims.x) ? tm.size.x-txtAreaDims.x+txtMargin*2: 0;
plateGrowHght= (tm.size.y > txtAreaDims.y) ? tm.size.y-txtAreaDims.y: 0;
plateGrow=[plateGrowWdth,plateGrowHght];

echo("grow",plateGrow);

//export

if (export=="colBack")
  !plate();
else if (export=="colText"){
  plateTxt();
  plateFrame();
  }
else if (export=="colEU")
  !euBand(false,true);
else if (export=="colCntry")
  !translate(euBandOffset) color(colCntry) linear_extrude(euBandLayers*layerThick) country();
else if (export=="colStars")
  !translate(euBandOffset) color(colStars) linear_extrude(euBandLayers*layerThick) stars();

else{
  //show
  if (showPlate)
    plate();
  if (showFrame)
    plateFrame();
  if (showBand)
    euBand();
  if (showText)
    plateTxt();
    }
  

 
 module plateFrame(){
  color(colText) 
    translate([0,0,plateThck]) linear_extrude(embossThck) difference(){
      translate([embossOffset,embossOffset]) rndRect(plateMinDims+[-embossOffset*2+plateGrow.x,-embossOffset*2],cornerRad-embossOffset);
      translate([embossOffset+borderWdth,embossOffset+borderWdth]) rndRect(plateMinDims+[-(embossOffset+borderWdth)*2+plateGrow.x,-(embossOffset+borderWdth)*2],innerRadius);
    }
  
 }
 
 module plate(){
  keyRingOffset= keyRingPos=="left" ? [-keyRingDia/2,plateDims.y/2] : [plateMinDims.x+plateGrow.x+keyRingDia/2,plateDims.y/2];
  keyRingRot= keyRingPos=="left" ? 90 : -90;
   //plate
  color(colBack) difference(){
    linear_extrude(plateThck) rndRect(plateMinDims+[plateGrow.x,0,0]);
    euBand(true);
  }
  if (keyRingPos!="none") 
    color(colBack) translate(keyRingOffset) linear_extrude(plateThck) rotate(keyRingRot) difference(){
      union(){
        circle(d=keyRingDia);
        translate([0,-keyRingDia/4]) square([keyRingDia,keyRingDia/2],true);
        }
        circle(d=keyRingHole);
      }
}
 
 module plateTxt(){
  color(colText) translate([(euBandWdth+euBandOffset.x+plateMinDims.x+plateGrow.x)/2+txtXPosRel*(plateMinDims.x+plateGrow.x),plateDims.y/2+txtYPosRel*plateDims.y,plateThck]) 
    linear_extrude(txtThck) text(txtString, size=txtSize, font=txtFont,halign="center",valign="center");
 }
 
 *rndRect();
 module rndRect(size=[10,10],radius=cornerRad){
  crnrRadius = radius > 0 ? radius : 0;
  translate([radius,radius]) offset(radius) square(size+[-radius*2,-radius*2]);
 }
 
 *euBand(false);
 
module euBand(cut=false,bandOnly=false){
  
  euBandThck= cut ? euBandLayers*layerThick+0.1 : euBandLayers*layerThick;
  //offset from origin
  
  translate(euBandOffset){
    //euBand
    color(colEU) linear_extrude(euBandThck) difference(){
        rndRect([euBandWdth+innerRadius,euBandHght],innerRadius);
        translate([euBandWdth,0]) square([innerRadius,euBandHght]);
        if (!cut){
          stars();
          country();
        }
      }
    if (!cut && !bandOnly){
      color(colStars) linear_extrude(euBandThck) stars();
      color(colCntry) linear_extrude(euBandThck) country();
      }
  }
}

module stars(){
  euStarsRad=euBandWdth/50*15;
  euStarsDia=euBandWdth/50*4.5;
  translate([euBandWdth/2,euBandHght*starsPosRel]) for (r=[0:360/12:360-12])
    rotate(r) translate([euStarsRad,0]) 
      rotate(-r+90) star(5,euStarsDia,euStarsDia*0.375);
}
      
module country(){
    //country
     translate([euBandWdth/2,euBandHght*cntryPosRel]) text(cntryString, size=cntrySize, font=cntryFont,halign="center",valign="center");
}
 
 module star(N=5,od=5,id=3,iter=0,poly=[]){
  if (iter<N){
    xo=od/2*cos((iter*360)/N);
    yo=od/2*sin((iter*360)/N);
    xi=id/2*cos((iter*360+180)/N);
    yi=id/2*sin((iter*360+180)/N);
    poly=concat(poly,[[xo,yo],[xi,yi]]);
    star(N,od,id,iter+1,poly);
  }
  else{
    polygon(poly);
  }
}
 