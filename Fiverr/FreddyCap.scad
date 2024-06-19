
/* customizable cap with arrow and text for rectangular openings in Face panels */

/* [Dimensions] */
panelSlotDims=[26,9.7];
panelThck=1.2;
//the Face Dimensions
capFaceDims=[35,12,1.6];
capFaceChamfer=1.0;
//the part that goes into the slot
capPlugHeight=9;
//spacing between cap and slot
capToPanelSpcng=0.2;
//the minimum wall Thickness
minWallThck=1.2;

/* [Text] */
textString="test";
textSize=7;
textFont="Arial";
textStyle="Bold"; //["Regular","Bold","Italic","Light"]
//relative position to the center
textPosRel=0.15; //[-0.5:0.01:0.5]
//layer Thickness off the text
textThck=1;

/* [Arrow] */
arrowDirection="down"; //["left","up","right","down","none"]
arrowSize=[7,3.5];
//relative position to the center
arrowPosRel=-0.4; //[-0.5:0.01:0.5]

/* [Show] */
showPanel=true;
showCap=true;
showFace=true;
showText=true;
showArrow=true;

/* [Colors] */
panelColor="silver";
capColor="darkSlateGrey";
textColor="ivory";
arrowColor="darkRed";

/* [Hidden] */
capBodyDims=[panelSlotDims.x-capToPanelSpcng*2,panelSlotDims.y-capToPanelSpcng*2,capPlugHeight];
fudge=0.1;
$fn=50;

arrowRotDict=[["left", 180],["up", 90],["right",0],["down",-90]];

if (showPanel)
  color(panelColor) panel();

if (showCap)
  color(capColor) capBody();
if (showFace)
  capFace();

module panel(){
  translate([0,0,-panelThck]) linear_extrude(panelThck) difference(){
    square([capFaceDims.x*2,capFaceDims.y*2],true);
    square(panelSlotDims,true);
  }
}

*capBody();
module capBody(){
  difference(){
    translate([0,0,-capPlugHeight]) linear_extrude(capPlugHeight,convexity=3) difference() {
      offset(minWallThck) square([capBodyDims.x-minWallThck*2,capBodyDims.y-minWallThck*2],true);
      square([capBodyDims.x-minWallThck*2,capBodyDims.y-minWallThck*2],true);
    }
    translate([0,0,-capBodyDims.z/2+minWallThck+fudge/2]) 
      cube([capBodyDims.x+fudge,capBodyDims.y-minWallThck*3,capBodyDims.z-minWallThck*2+fudge],true);
  }
  for (mx=[0:1], iy=[-1,1])
   mirror([mx,0,0]) translate([capBodyDims.x/2-minWallThck,iy*minWallThck,-capBodyDims.z+minWallThck*2]) snapHook();
  
  module snapHook(){
    hookDims=[minWallThck*2,minWallThck,capBodyDims.z-minWallThck*2-panelThck-capToPanelSpcng];
    poly=[[0,0],[0,hookDims.z+panelThck-capToPanelSpcng],[minWallThck,hookDims.z+panelThck-capToPanelSpcng],
          [minWallThck,hookDims.z],[hookDims.x,hookDims.z],[minWallThck,0]];
    
    rotate([90,0,0]) translate([0,0,-hookDims.y/2]) linear_extrude(hookDims.y) polygon(poly);
  }
}

*capFace();
module capFace(){
  scaleFac=[1-capFaceChamfer*2/capFaceDims.x,1-capFaceChamfer*2/capFaceDims.y];
  baseThck= (capFaceDims.z>=capFaceChamfer) ? capFaceDims.z-capFaceChamfer : 0;

  color(capColor) difference(){
    union(){
      linear_extrude(baseThck) square([capFaceDims.x,capFaceDims.y],true);
      translate([0,0,baseThck]) linear_extrude(capFaceDims.z-baseThck,scale=scaleFac) 
        square([capFaceDims.x,capFaceDims.y],true);
    }
    //text
    translate([(capFaceDims.x-capFaceChamfer*2)*textPosRel,0,capFaceDims.z-textThck]) 
      linear_extrude(textThck+fudge, convexity=3) 
        text(text=textString,size=textSize,valign="center",halign="center", font=str(textFont,":style=",textStyle));
    //arrow
    translate([(capFaceDims.x-capFaceChamfer*2)*arrowPosRel,0,capFaceDims.z-textThck])
    linear_extrude(textThck+fudge, convexity=3) 
      rotate(arrowRotDict[search([arrowDirection],arrowRotDict)[0]][1]) customArrow(arrowSize);
    
  }
  
  //text
  if (showText)
  color(textColor) translate([(capFaceDims.x-capFaceChamfer*2)*textPosRel,0,capFaceDims.z-textThck]) 
    linear_extrude(textThck) 
      text(text=textString,size=textSize,valign="center",halign="center", font=str(textFont,":style=",textStyle));
  
 //arrow
  if (showArrow)
  color (arrowColor) translate([(capFaceDims.x-capFaceChamfer*2)*arrowPosRel,0,capFaceDims.z-textThck])
    linear_extrude(textThck) 
      rotate(arrowRotDict[search([arrowDirection],arrowRotDict)[0]][1]) customArrow(arrowSize);
}



//custom arrow
*customArrow();
module customArrow(size=[2,1]){
  bodySize=[size.x/2,size.y/2];
  headSize=[size.x/2,size.y];
           
  headPoly=[[0,headSize.y/2],[headSize.x,0],[0,-headSize.y/2]];
  bodyPoly=[[-bodySize.x,bodySize.y/2],[0,bodySize.y/2],[0,-bodySize.y/2],[-bodySize.x,-bodySize.y/2]];
  polygon(headPoly);
  polygon(bodyPoly);
}
