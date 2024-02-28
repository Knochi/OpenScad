// Remix of the Radius Measuring Toolkit (RMT) from Keir30
// https://www.thingiverse.com/thing:4709316

/* [show] */
$fn=20; //[10:10:100]
showOrigTray=false;
showOrigPcs=false;
showPieces=true;
showTray=true;
export="all"; //["all","left","right"]

/* [pieces] */
pcsThck=2.4; 
pcsWdth=7.2; //width of the pieces at widest point
pcsOffset=[0,5,1.6]; //Offset origin (lower center bottom)
pcsDistance=0; //distance between left and right pieces
spcng=0.13; //spacing between the pieces and the tray

/* [tray] */
trayDims=[270,140,5];
chamfer=2.4;
crnrRad=10;
//width x height of the brim
brimDims=[2,1];
//diameter of the center groove
grooveDia=45; 
grooveDepth=1.35; //depth of the groove
splitTray=false;
splitSpacing=0.2;
splitDoveTails=true;

/* [labels] */
pcsLabelSize=4;
pcsLabelDpth=1;
topLeftLabel=["RADIUS","MEASURING","TOOLKIT"];
topLeftLabelSize=6;
topLeftLabelDpth=1;
topLeftLineSpcng=1.5;

/* [Hidden] */
// --- Original Dimensions ---
orgTrayDims=[140+125,10+130,5];
orgPcsThck=2.4;
orgPcsOffset=[2.5,5];
orgBrimHght=1;

fudge=0.1;


if (showOrigTray)
  %translate([-140+orgTrayDims.x/2,10,0]) rotate([90,0,0]) import("RMT_tray.stl");
if (showOrigPcs)
  %color("orange") translate([-140+orgTrayDims.x/2,10,1.6]) rotate([90,0,0]) import("RMT_pieces_complete.stl");


//tray
if (showTray)
  if (splitTray){
    //right
    if ((export=="all") || (export=="right")) difference(){
      intersection(){
        tray();
        translate([((trayDims.x+splitSpacing)/4+fudge/2),trayDims.y/2,trayDims.z/2]) 
          cube([trayDims.x/2-splitSpacing/2+fudge,trayDims.y+fudge,trayDims.z+fudge],true);
      }
      if (splitDoveTails)
        for (iy=[1/3,2/3])
          translate([0,trayDims.y*iy,-fudge/2]) linear_extrude(trayDims.z+fudge) offset(splitSpacing) doveTail();
    }
    //left
    if ((export=="all") || (export=="left")){
      intersection(){
        tray();
        translate([-((trayDims.x+splitSpacing)/4+fudge/2),trayDims.y/2,trayDims.z/2]) 
          cube([trayDims.x/2-splitSpacing/2+fudge,trayDims.y+fudge,trayDims.z+fudge],true);
      }
      if (splitDoveTails) intersection(){
        tray();
        for (iy=[1/3,2/3])
          translate([0,trayDims.y*iy,-fudge/2]) linear_extrude(trayDims.z+fudge) doveTail();
      }
    }
  }
  else
    color("grey") tray();

//pieces
if (showPieces)
  color("orange") translate(pcsOffset) difference(){
    linear_extrude(pcsThck) piecesShp();
    translate([0,0,pcsThck-pcsLabelDpth]) linear_extrude(pcsLabelDpth+fudge) labelsShp();
  }

module tray(){
  difference(){
    body();
    //groove
    translate([0,trayDims.y/2,grooveDia/2+trayDims.z-brimDims.y-grooveDepth]) 
      rotate([90,0,0]) cylinder(d=grooveDia,h=trayDims.y-brimDims.x*2,center=true,$fn=$fn*4);
    //pieces
    translate(pcsOffset) linear_extrude(pcsThck+fudge) offset(spcng) piecesShp();
    //pieces labels
    translate(pcsOffset+[0,0,-pcsLabelDpth]) linear_extrude(pcsLabelDpth+fudge) labelsShp();
    //top left Text
    for (i=[0:2])
      translate([-trayDims.x/2+crnrRad,trayDims.y-crnrRad-i*topLeftLabelSize*1.5,trayDims.z-brimDims.y-topLeftLabelDpth]) 
        linear_extrude(topLeftLabelDpth+fudge) text(topLeftLabel[i],size=topLeftLabelSize,valign="top");
  }
  module body(){
      poly=[[0,0],[0,trayDims.z-brimDims.y],[crnrRad-brimDims.x,trayDims.z-brimDims.y],
            [crnrRad-brimDims.x,trayDims.z],[crnrRad,trayDims.z],
            [crnrRad,chamfer],[crnrRad-chamfer,0]
            ];
  
      //corners
      for (ix=[-1,1],iy=[-1,1]){
        rot=  (ix<0 && iy<0) ? 180 : //bottom left
              (ix<0 && iy>0) ? 90 : //top left
              (ix>0 && iy<0) ? -90 : //bottom right
             0;
        translate([ix*(trayDims.x/2-crnrRad),iy*(trayDims.y/2-crnrRad)+trayDims.y/2]) rotate(rot) rotate_extrude(angle=90) polygon(poly);
      }
     //edges left&right
      translate([trayDims.x/2-crnrRad,trayDims.y/2]) rotate([90,0,0]) linear_extrude(trayDims.y-crnrRad*2,center=true) polygon(poly);
      translate([-(trayDims.x/2-crnrRad),trayDims.y/2]) rotate([90,0,180]) linear_extrude(trayDims.y-crnrRad*2,center=true) polygon(poly);
      
      //edges front&back
      translate([0,trayDims.y/2-crnrRad+trayDims.y/2]) rotate([90,0,90]) 
        linear_extrude(trayDims.x-crnrRad*2,center=true,convexity=5) polygon(poly);
      translate([0,-(trayDims.y/2-crnrRad)+trayDims.y/2]) rotate([90,0,-90]) 
        linear_extrude(trayDims.x-crnrRad*2,center=true) polygon(poly);
      
      //core
      translate([0,trayDims.y/2,(trayDims.z-brimDims.y)/2]) 
        cube([trayDims.x-crnrRad*2,trayDims.y-crnrRad*2,trayDims.z-brimDims.y],true);
  }
}



//arrange pieces
module piecesShp(){
  
  //left (even)
  for (r=[10:10:120])
    translate([-pcsDistance/2,0]) rotate(90) piece(r);
  
  //right (odd)
  for (r=[5:10:125])
    translate([pcsDistance/2,0]) rotate(0) piece(r);
}

//arrange labels
module labelsShp(){
  
  //left (even)
  for (r=[10:10:120])
    translate([-pcsDistance/2,0]) rotate(45) translate([0,r+pcsWdth/2]) text(str(r),size=pcsLabelSize,valign="center",halign="center");
  
  //right (odd)
  for (r=[5:10:125])
    translate([pcsDistance/2,0]) rotate(-45) translate([0,r+pcsWdth/2]) text(str(r),size=pcsLabelSize,valign="center",halign="center");
}

module piece(r=1){
  pcsWdth=[pcsWdth/sqrt(2),pcsWdth/sqrt(2)];
  poly1=arc(r,angle=90);
  poly2=reversePoints(translatePoints(poly1,pcsWdth));
  polygon(concat(poly1,poly2));
}

// tools

//return an arc polygon
function arc(r=1,angle=45,poly=[],iter=0)=let(
  facets= fragFromR(r,angle),
  iter = iter ? iter-1 : facets,
  aSeg=angle/facets,
  x= r * cos(aSeg*iter),
  y= r * sin(aSeg*iter),
  poly = concat(poly,[[x,y]])) (iter>0) ?
    arc(r,angle,poly,iter) : poly;


function fragFromR(r,ang=360)=$fn>0 ? ($fn>=3 ? $fn : 3) : ceil(max(min(360/$fa,r*2*PI*ang/(360*$fs)),5));

function translatePoints(pointsIn,vector,pointsOut=[],iter=0)=
  iter<len(pointsIn) ? 
    translatePoints(pointsIn,vector,pointsOut=concat(pointsOut,[pointsIn[iter]+vector]),iter=iter+1) : 
    pointsOut;
    
function reversePoints(pointsIn,pointsOut=[],iter=0)=
  iter<len(pointsIn) ? 
    reversePoints(pointsIn,concat(pointsOut,[pointsIn[len(pointsIn)-iter-1]]),iter=iter+1) :
    pointsOut;
    
//-- a dovetail shape to link objects
*doveTail();
module doveTail(size=[5,10],angle=60,radius=0.5,flap=1){
  dy= (size.x-radius)/tan(angle); //y offset of narrow part //tan(alpha)=GK/AK
  cy= (radius/cos(90-angle))-radius; //correction of width because of radii //cos(alpha)=GK/HYP
  difference(){
    mirror([1,0]) hull()for (ix=[0,1],iy=[-1,1])
      translate([ix*(size.x-radius)-size.x+radius,iy*(size.y/2-radius-ix*dy)]) circle(radius,$fn=50);
    //cut away left part
    translate([-(radius+fudge)/2,0]) square([radius+fudge,size.y+fudge],true);
  }
  if (flap)
    square([flap*2,size.y-dy*2+cy*2],true);
}