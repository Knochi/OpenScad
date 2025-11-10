// simple bird feeder
// by Knochi

/* [Dimensions] */
//overall Width
ovWidth=100;
//overall extrusion depth
ovDepth=80;
//overall Height
ovHght=130;
//diameter of Logs
logDia=6;
//the minimum Overlap
logMinOverlap=1;
//the desired roof angle
roofAngle=90;
//hole Diameter
roofHoleDia=3;
//distance of the holes
roofHoleDist=60;
//desired tray height
trayHght=30;
trayWallThck=1.2;
trayCrnrRad=2;
trayHolderWdth=3;
traySpcng=0.2;
traySnapDia=3;

/* [show] */
variant="logs";//["flat"]
showBirdsHouse = true;
showTray = false;


/* [Hidden] */
$fn=50;
//how much logs to fit into the width
btmLogCnt=ceil(ovWidth/(logDia-logMinOverlap));
//adjust log overlap
logOverlap=logDia-((ovWidth-logDia)/(btmLogCnt-1));
logDist=logDia-logOverlap;

//roof lenght with given roof angle
roofLen=((ovWidth-logDia)/2)/sin(roofAngle/2); //tan(a)=GK/AK, sin(a)=GK/HYP, cos(a)=AK/HYP
roofHght=((ovWidth-logDia)/2)/tan(roofAngle/2);

sideLen=ovHght-roofHght;

// -- adjusted lengths
// bottom
adjOvWdth=(btmLogCnt-1)*logDist;
// roof
roofLogCnt=round(roofLen/logDist);
echo("roof",roofLen,roofLogCnt);
adjRoofLen=(roofLogCnt-1)*logDist;
adjRoofAng=asin(((ovWidth-logDia)/2)/adjRoofLen);
echo(adjRoofAng);

// side
sideLogCnt=round(sideLen/logDist);
adjSideLen=(sideLogCnt)*logDist;

// height of tray in logs
trayLogCnt=round((trayHght)/logDist);
adjTrayHght=(trayLogCnt)*logDist-logOverlap;



if (showBirdsHouse)
  birdsHouse();

if (showTray)
  translate([0,0,logDia/2]) tray();

  
  
module birdsHouse(){
  //add the holes
  difference(){
    if (variant=="logs")
      houseFrameLogs();
    else
      houseFrameFlat();
    for (iy=[-1,1])
      translate([0,iy*roofHoleDist/2,ovHght-logDia*3]) cylinder(d=roofHoleDia,h=logDia*4);
    translate([0,0,logDia/2]) tray(cut=true);
  }
}

*houseFrameFlat();
module houseFrameFlat(){
  poly=[
    [0,ovHght],
    [ovWidth/2,ovHght-roofHght],
    [ovWidth/2,0],
    [-ovWidth/2,0],
    [-ovWidth/2,ovHght-roofHght]
    ];
  translate([0,0,-logDia/2]) 
    rotate([90,0,0]) 
      linear_extrude(ovDepth,center=true, convexity=3) difference(){
        polygon(poly);
        offset(-logDia) polygon(poly);
      }
  }

// build the house frame
module houseFrameLogs(){
  rotate([90,0,0]) linear_extrude(ovDepth,center=true,convexity=4){
    //floor
    for (ix=[-(btmLogCnt-1)/2:(btmLogCnt-1)/2])
      translate([ix*(logDia-logOverlap),0]) circle(d=logDia);
    //side
    for (ix=[-1,1],iy=[0:sideLogCnt-1])  
      translate([ix*adjOvWdth/2,iy*logDist]) circle(d=logDia);
    //roof
    for (ix=[-1,1],iy=[0:roofLogCnt-1])
      translate([ix*adjOvWdth/2,adjSideLen]) rotate(ix*adjRoofAng) translate([0,iy*logDist]) circle(d=logDia);
    //tray holder 
    for (ix=[-1,1])
      translate([ix*(adjOvWdth-trayHolderWdth)/2,(trayLogCnt+1)*logDist]) 
        hull() for (ix=[-1,1]) translate([ix*trayHolderWdth/2,0]) circle(d=logDia);
  }
}

*tray();
module tray(cut=false){
  trayWdth=adjOvWdth-logDia-traySpcng*2;
  snapHght=trayWallThck*2+traySnapDia;
  
  if (cut)
    for (ix=[-1,1])
      translate([ix*trayWdth/2,0,(adjTrayHght-snapHght-traySpcng*2)]) 
        linear_extrude(snapHght+traySpcng*2) offset(traySpcng) rotate(ix*-90) halfDent();
      
  else {    
    difference(){
      linear_extrude(adjTrayHght-traySpcng) offset(trayCrnrRad) 
        square([trayWdth-trayCrnrRad*2,ovDepth-trayCrnrRad*2],true);
      translate([0,0,trayWallThck])
        linear_extrude(adjTrayHght) offset(trayCrnrRad-trayWallThck) 
          square([trayWdth-trayCrnrRad*2,ovDepth-trayCrnrRad*2],true);
    }
    
    //snaps
    for (ix=[-1,1])
      translate([ix*trayWdth/2,0,(adjTrayHght-traySpcng)]) rotate(ix*-90) snap();
      
    //perches
    for (iy=[-1,1])
      translate([0,iy*(ovDepth-trayWallThck)/2,adjTrayHght-traySpcng]) perch();
    }
    
    
  module perch(){
    hull() for (ix=[-1,1],iz=[0,1]){
      dia = iz ? trayWallThck : logDia ;
      translate([ix*trayWdth*0.33,0,iz*-logDia]) sphere(d=dia);
      }
  }  
  
  module snap(){
    
    translate([0,0,-trayWallThck*2]){
      linear_extrude(trayWallThck*2) halfDent();
      mirror([0,0,1]) linear_extrude(traySnapDia,scale=0) halfDent();
    }
  }
}



*halfDent();
module halfDent(thick=traySnapDia/2,rad=traySnapDia/2,filletRad=0.8){
//make nice dents
  debug=true;
//fillet y-Offset
  yOffset=sqrt(pow(filletRad+rad,2)-pow(filletRad+rad-thick,2));
  //x-Offset for radius (should be negative)
  xOffset=thick-rad;
  
  //angle at which the circles/arcs are tangential
  angle=acos((filletRad-xOffset)/(filletRad+rad)); //cos(alpha)=GK/HYP
  
  //calculate the arc polys
  filletArcPoly=arc(r=filletRad,angle=angle,startAngle=270-angle);
  outArcPoly=arc(r=rad,angle=angle,startAngle=90-angle);
  
  
  poly=concat(

    translate_poly([yOffset,filletRad],filletArcPoly),
    [[0,0]],
    translate_poly([0,xOffset],outArcPoly),
    [[0,0]]

    );
    
    polygon(poly);
    mirror([1,0]) polygon(poly);

}

//return an arc polygon
function arc(r=1,angle=45,startAngle=0, poly=[],iter=0)=let(
  facets= fragFromR(r,angle),
  iter = iter ? iter-1 : facets,
  aSeg=angle/facets,
  x= r * cos(aSeg*iter+startAngle),
  y= r * sin(aSeg*iter+startAngle),
  poly = concat(poly,[[x,y]])) (iter>0) ?
    arc(r,angle,startAngle,poly,iter) : poly;

    
function translate_poly(vec=[0,0],inPoly=[],outPoly=[],iter=0)=let(
  x=inPoly[iter].x+vec.x,
  y=inPoly[iter].y+vec.y,
  outPoly = concat(outPoly,[[x,y]])
) (iter<len(inPoly)-1) ? translate_poly(vec,inPoly,outPoly,iter+1) : outPoly;

//from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features
function fragFromR(r,ang=360)=$fn>0 ? ($fn>=3 ? $fn : 3) : ceil(max(min(360/$fa,r*2*PI*ang/(360*$fs)),5));
function framFromA()=360/$fa;
function fragFromS()=r*2*PI/$fs;

function ri2ro(r=1,n=$fn)=r/cos(180/n);
function ro2ri(r=1,n=$fn)=r*cos(180/n);