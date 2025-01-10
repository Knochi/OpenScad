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
plateMinDims=[180,50];
//Elevation of the embossing
embossThck=0.6;
//Width of the embossing
embossWdth=+2;
//Embossing offset from edge
embossOffset=1;
cornerRad=5;
//Layer thickness
layerThick=0.2;
euBandLayers=3;

/* [Positioning] */
cntryPosRel=0.25; //[0:0.01:1]
starsPosRel=0.71; //[0:0.01:1]

/* [Colors] */
colBack="white";
colText="darkSlateGrey";
colEU="blue";
colCntry="white";
colStars="yellow";

/* [Text] */
txtString="Shoooooooooooooooogen";
txtFont="Liberation Sans";
txtSize=24;
txtMargin=7;
txtThck=0.6;
cntryString="NL";
cntryFont="Liberation Sans";
cntrySize=10;


/* [Show] */
showPlate=true;
showText=true;
showBand=true;
showFrame=true;


export="none"; //["colBack","colText","colEU","colCntry","colStars"]

/* [Hidden] */ 
plateDims=plateMinDims;
innerRadius=cornerRad-embossOffset-embossWdth;

euBandHght=plateDims.y-embossOffset*2-embossWdth*2;
euBandWdth=euBandHght/2;
euBandOffset=[embossOffset+embossWdth,embossOffset+embossWdth,plateThck-euBandLayers*layerThick];

tm = textmetrics(txtString, size=txtSize, font=txtFont);
echo(tm);
txtAreaDims=[plateMinDims.x-euBandWdth-embossWdth*2-embossOffset*2,0];


plateGrowWdth= ((tm.size.x+txtMargin*2) > txtAreaDims.x) ? tm.size.x-txtAreaDims.x+txtMargin*2: 0;
plateGrowHght= (tm.size.y > txtAreaDims.y) ? tm.size.y-txtAreaDims.y: 0;
plateGrow=[plateGrowWdth,plateGrowHght];

echo("grow",plateGrow);

//export

if (export=="colBack")
  !plate();
if (export=="colText")
  !plateTxt();
if (export=="colEU")
  !euBand(false,true);
if (export=="colCntry")
  !translate(euBandOffset) color(colCntry) linear_extrude(euBandLayers*layerThick) country();
if (export=="colStars")
  !translate(euBandOffset) color(colStars) linear_extrude(euBandLayers*layerThick) stars();
  


  

//show
if (showPlate)
  plate();
if (showFrame)
  plateFrame();
if (showBand)
  euBand();
if (showText)
  plateTxt();
  

 
 module plateFrame(){
  color(colText) 
    translate([0,0,plateThck]) linear_extrude(embossThck) difference(){
      translate([embossOffset,embossOffset]) rndRect(plateMinDims+[-embossOffset*2+plateGrow.x,-embossOffset*2],cornerRad-embossOffset);
      translate([embossOffset+embossWdth,embossOffset+embossWdth]) rndRect(plateMinDims+[-(embossOffset+embossWdth)*2+plateGrow.x,-(embossOffset+embossWdth)*2],innerRadius);
    }
  
 }
 
 module plate(){
   //plate
  color(colBack) difference(){
    linear_extrude(plateThck) rndRect(plateMinDims+[plateGrow.x,0,0]);
    euBand(true);
  }
  }
 
 module plateTxt(){
  color(colText) translate([(euBandWdth+euBandOffset.x+plateMinDims.x+plateGrow.x)/2,plateDims.y/2,plateThck]) linear_extrude(txtThck) text(txtString, size=txtSize, font=txtFont,halign="center",valign="center");
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
 