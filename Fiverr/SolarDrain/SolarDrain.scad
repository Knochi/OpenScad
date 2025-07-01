/* Fiverr request from user gilshemesh85. order #FO513ED973DC1

*/

/* [Body-Dimensions] */
bottomSquareDims=[107,107];
//Size of the top square
topSquareDims=[55,55];
//angles of the slopes
slpAngles=[45,45];
//determine the slp by angle or topSquare
slpByAngle=false;
totalHght=37;
//thickness of the straight bottom part
bottomThck=3;
cornerRad=4;
edgeRad=2.0;
//the minimum wall thickness
minWallThck=2;

/* [Solar Panels] */
topSolarDims=[50,50,2];
topSolarPCBThck=0.3;
topSolarCrnrRad=2;

sideSolarDims=[20,20,2];
sideSolarPCBThck=0.3;
sideSolarCrnrRad=2;

//spacing around solar panels
solarSpcng=0.2;

/* [Vents] */
sltHoleDia=15;
//relative Position on face
sltHoleXPosRel=-0.15; //[-0.5:0.01:0.5]
sltHoleYPosRel=0; //[-0.5:0.01:0.5]
sltHoleSltWdth=2;

dotHoleDia=20;
dotHoleXPosRel=0.15; //[-0.5:0.01:0.5]
dotHoleYPosRel=0; //[-0.5:0.01:0.5]
dotHoleDotDia=1;
dotHoleBrdgWdth=1;

/* [show] */
quality=24; //[24:4:120]
showBody=true;
showSolarTop=true;
showSolarSides=true;
showSectionCut="none"; //["none","Y-Z","X-Z"]

/* [Hidden] */
debug=false;
$fn=quality;
fudge=0.1;
//Difference between top and bottom square
botTopDiff= slpByAngle ? [tan(slpAngles.x)*totalHght,tan(slpAngles.y)*totalHght] : 
                          (bottomSquareDims-topSquareDims)/2;
slpAnglesCalc = slpByAngle ? slpAngles : 
                [atan(botTopDiff.x/(totalHght-bottomThck-edgeRad)),
                 atan(botTopDiff.x/(totalHght-bottomThck-edgeRad))];
topSquare= slpByAngle ? bottomSquareDims-[botTopDiff.x*2,botTopDiff.y*2] : topSquareDims;
slpLen = [(totalHght-bottomThck-edgeRad)/sin(90-slpAnglesCalc.x),(totalHght-bottomThck-edgeRad)/sin(90-slpAnglesCalc.x)];
//the offset of the slope due to the edgeRadius
slpOffset=[sin(90-slpAnglesCalc.x)*edgeRad,cos(90-slpAnglesCalc.x)*edgeRad];

if (debug){
  echo("angle:",slpAnglesCalc);
  echo("len:",slpLen);
}



difference(){
  union(){
    if (showBody)
      body();
    if (showSolarTop)
      translate([0,0,totalHght-topSolarDims.z+fudge]) solarModule(topSolarDims,topSolarPCBThck,topSolarCrnrRad);
    if (showSolarSides){
      placeOnSlope([0,0],"left") rotate([180,0,0]) translate([0,0,-2]) 
        solarModule(size=sideSolarDims,rad=sideSolarCrnrRad);
      placeOnSlope([0,0],"right") rotate([180,0,0]) translate([0,0,-2]) 
        solarModule(size=sideSolarDims,rad=sideSolarCrnrRad);
      }
  }
  if (showSectionCut=="Y-Z")
    translate([bottomSquareDims.x/4+fudge/2,0,totalHght/2]) color("darkRed") cube([bottomSquareDims.x/2+fudge,bottomSquareDims.y+fudge,totalHght+5],true);
  if (showSectionCut=="X-Z")
    translate([0,bottomSquareDims.y/4+fudge/2,totalHght/2]) color("darkRed") cube([bottomSquareDims.x+fudge,bottomSquareDims.y/2+fudge,totalHght+5],true);
}

module body(){
  
  sFact=[topSquare.x/bottomSquareDims.x,topSquare.y/bottomSquareDims.y];  
  difference(){
    pyramid();
    //top recess
    translate([0,0,totalHght-topSolarDims.z/2]) 
      rndRect(topSolarDims+[solarSpcng*2,solarSpcng*2,fudge],cornerRad=topSolarCrnrRad+solarSpcng, edgeRad=0);
    //holes on front
    placeOnSlope([sltHoleXPosRel,sltHoleYPosRel]) 
      cylinder(d=sltHoleDia,h=minWallThck*2+fudge);
    placeOnSlope([dotHoleXPosRel,dotHoleYPosRel])  
      cylinder(d=sltHoleDia,h=minWallThck*2+fudge);
    //recesses to the sides
    placeOnSlope([0,0],"left") translate([0,0,sideSolarDims.z/2])
      rndRect(sideSolarDims+[solarSpcng*2,solarSpcng*2,fudge],cornerRad=sideSolarCrnrRad+solarSpcng,edgeRad=0);
    placeOnSlope([0,0],"right") translate([0,0,sideSolarDims.z/2])
      rndRect(sideSolarDims+[solarSpcng*2,solarSpcng*2,fudge],cornerRad=sideSolarCrnrRad+solarSpcng,edgeRad=0);
    //inner
    pyramid(cut=true);
  }
  //diff to cut away excess
  difference(){
    union(){
      // place on slope front
      placeOnSlope([sltHoleXPosRel,sltHoleYPosRel]) 
        linear_extrude(minWallThck*2,convexity=4) slotPattern(sltHoleDia,sltHoleSltWdth);
      placeOnSlope([dotHoleXPosRel,dotHoleYPosRel]) 
        linear_extrude(minWallThck*2,convexity=4) dotHole();
      //place on sides
      
    }
    //cut away inner excess since wall thickness is not calculated properly at the moment
    pyramid(cut=true);
    
  }
}

module placeOnSlope(pos=[0,0],slope="front"){
  lr= (slope=="left") ? 1 : -1;
if (slope=="front")  
  translate([bottomSquareDims.x*pos.x,-bottomSquareDims.y/2-slpOffset.x+edgeRad,bottomThck+slpOffset.y]) 
      rotate([-slpAnglesCalc.x,0,0]) translate([0,0,slpLen.x*(0.5+pos.y)]) rotate([-90,0,0]) children();
else if (slope=="left" || slope=="right")
  translate([-lr*(bottomSquareDims.x/2-slpOffset.x+edgeRad),bottomSquareDims.y*pos.y,bottomThck+slpOffset.y]) 
      rotate([0,lr*slpAnglesCalc.y,0]) 
        translate([0,0,slpLen.x*(0.5+pos.y)]) 
          rotate([0,lr*90,0]) children();
}

*pyramid(cut=true);
module pyramid(flatBottom=bottomThck, cut=false){
  topDims= cut ? topSquareDims - [minWallThck*2,minWallThck*2] : topSquareDims ;
  botDims= cut ? bottomSquareDims- [minWallThck*2,minWallThck*2] : bottomSquareDims;
  eRad= cut ? (minWallThck>edgeRad) ? 0 : edgeRad-minWallThck : edgeRad;
  cRad= cut ? (minWallThck>cornerRad) ? 0 : cornerRad-minWallThck : cornerRad;
  tHght= cut ? totalHght-minWallThck-topSolarDims.z : totalHght;
  botThck= cut ? flatBottom+fudge : flatBottom;
  pyOffset= cut ? [0,0,-fudge] : [0,0,0];
  
  
  difference(){
    hull(){
      translate([0,0,bottomThck]) 
        rndRect([botDims.x,botDims.y,eRad*2],cornerRad=cRad, edgeRad=eRad);
      translate([0,0,tHght-eRad]) 
        rndRect([topDims.x,topDims.y,eRad*2],cornerRad=cRad, edgeRad=eRad);
    }
    translate([0,0,-(eRad+fudge)/2]) cube([botDims.x+fudge,botDims.y+fudge,eRad+fudge],true);
  }
  if (flatBottom)
    translate(pyOffset) linear_extrude(botThck) rndRect([botDims.x,botDims.y],cornerRad=cRad, edgeRad=0); 
}

*solarModule();
module solarModule(size=[50,50,2],pcbThck=0.8, rad=4){
  //Epoxy topped Solar panel
  epxHght=size.z-pcbThck;
  sFact= epxHght/rad;
  color("darkGreen") linear_extrude(pcbThck)
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
  
  color("#000033")
  translate([0,0,pcbThck]) 
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) 
        intersection(){
          scale([1,1,sFact])  sphere(rad);
          translate([0,0,epxHght/2]) cube([rad*2,rad*2,epxHght],true);
        }
}

*slotPattern();
module slotPattern(d=20, w=2.3){
  sltCnt=ceil((d/w-1)/2);
  *circle(d=d);
  difference(){
    circle(d=d);
      for (ix=[-(sltCnt-1)/2:(sltCnt-1)/2])
        intersection(){
          circle(d=d+fudge);
          translate([ix*w*2,0,0]) square([w,d+fudge*2],true);
    }
  }
  
}

*rndRect();                  
module rndRect(size=[20,20,5], cornerRad=4, edgeRad=1,center=true){
  //create a rectangle with rounded corners and edges
  if (len(size)==3 && edgeRad)
    hull() for (ix=[-1,1],iy=[-1,1], iz=[-1,1])
      translate([ix*(size.x/2-cornerRad),iy*(size.y/2-cornerRad),iz*(size.z/2-edgeRad)]) 
        rotate_extrude() translate([cornerRad-edgeRad,0]) 
          difference(){
            circle(edgeRad);
            translate([-edgeRad,0,0]) square(edgeRad*2+fudge,true);
          }
  //create a disc with rounded corners
  else if (len(size)==3 && size.z==0)
    mirror([0,0,1]) linear_extrude(0.1,scale=0) shape();
  else if (len(size)==3)
    linear_extrude(size.z, center=true) shape();
  else
    shape();
      
  module shape(){
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-cornerRad),iy*(size.y/2-cornerRad)]) circle(cornerRad);
  }
}

// Function to calculate the maximum number of holes that fit in the circle
function max_holes(d, hole_d, bridge_w) = floor((d - bridge_w) / (hole_d + bridge_w));

// Create the circle with holes
module dotHole() {
    difference() {
        // Outer circle
        circle(d = dotHoleDia);
        
        // Calculate the number of holes per row
        num_holes = max_holes(dotHoleDia, dotHoleDotDia, dotHoleBrdgWdth);
        
        // Create holes
        for (i = [0 : num_holes - 1]) {
            for (j = [0 : num_holes - 1]) {
                x = (i - (num_holes - 1) / 2) * (dotHoleDotDia + dotHoleBrdgWdth);
                y = (j - (num_holes - 1) / 2) * (dotHoleDotDia + dotHoleBrdgWdth);
                if (x * x + y * y <= (dotHoleDia / 2 - dotHoleDotDia / 2) * (dotHoleDia / 2 - dotHoleDotDia / 2)) {
                    translate([x, y]) {
                        circle(d = dotHoleDotDia);
                    }
                }
            }
        }
    }
}