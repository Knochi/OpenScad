
/*
  Print in Vase mode 
  - Others-->Special Modes-->Spiral Vase
  - set Nozzle Dia, layerHght and bottom Shell Layers accordingly
*/

/* [Dimensions] */
nozzleDia=0.8; //[0.2,0.4,0.6,0.8]
layerHght=0.4; //[0.2,0.24,0.32,0.4,0.48]
innerDia=24;
innerHght=23*5+2.3;
botLayers=3;
lidSpcng=0.2; //spacing between lit and container
lidHght=10;

/* [Snap] */
snapThck=0.5;
snapRad=2;
snapFillet=3;

/*[Show]*/
showContainer=true;
showLid=true;
showCut=false;
export="none";//["none","container","lid"]

/* [Hidden] */
ovHght=innerHght+botLayers*layerHght;
ovDia=innerDia+nozzleDia*2;
lidDia=innerDia+nozzleDia*4+lidSpcng*2;
botHght=botLayers*layerHght;
fudge=0.1;

$fn=64;


if (export=="container")
  container();
else if (export=="lid")
  translate([0,0,lidHght]) mirror([0,0,1]) lid();
  
else {
  
      if (showContainer) difference(){
        container();
        if (showCut) color("darkGreen") translate([-(lidDia/4+snapThck/2),0,(ovHght+botHght)/2]) cube([lidDia/2+snapThck+fudge,lidDia+snapThck*2+fudge,ovHght+botHght*2+fudge],true);
        }
      if (showLid) difference(){
        translate([0,0,ovHght-lidHght+lidSpcng+botHght]) lid();
        if (showCut) color("darkRed") translate([-(lidDia/4+snapThck/2)+fudge,0,(ovHght+botHght)/2]) cube([lidDia/2+snapThck+fudge,lidDia+snapThck*2+fudge,ovHght+botHght*2+fudge],true);
        }
    }
    
  
  

//container
module container(){
  cylinder(d=ovDia,h=ovHght);
  translate([0,0,ovHght-lidHght/2]) snap(segments=6);
}

//lid
module lid(){
   cylinder(d=innerDia+nozzleDia*4+lidSpcng*2,h=lidHght);
   translate([0,0,lidHght/2-botHght-lidSpcng]) snap(dia=lidDia,thick=snapThck,rad=snapRad+lidSpcng,filletRad=snapFillet+lidSpcng);
}

*snap();
module snap(dia=ovDia,thick=snapThck,rad=snapRad,filletRad=snapFillet, segments=1){
  
  debug=false;
  segAng=segments>2 ? 360/segments/2 : 360;
  segCount=segments>2 ? segments : 1;
  
  assert(rad!=undef,"rad undefined");
  assert(filletRad!=undef,"filletRad undefined");
  
  //fillet y-Offset
  yOffset=sqrt(pow(filletRad+rad,2)-pow(filletRad+rad-thick,2));
  //x-Offset for radius (should be negative)
  xOffset=thick-rad;
  
  //angle at which the circles/arcs are tangential
  angle=acos((filletRad-xOffset)/(filletRad+rad)); //cos(alpha)=GK/HYP
  
  //calculate the arc polys
  filletArcPolyTop=arc(r=filletRad,angle=angle,startAngle=180);
  outArcPoly=arc(r=rad,angle=angle*2,startAngle=-angle);
  filletArcPolyBot=arc(r=filletRad,angle=angle,startAngle=180-angle);
  
  poly=concat(
    [[0,-yOffset]],
    translate_poly([dia/2+filletRad,-yOffset],filletArcPolyBot),
    translate_poly([dia/2+xOffset,0],outArcPoly),
    translate_poly([dia/2+filletRad,yOffset],filletArcPolyTop),
    [[0,yOffset]]
    );
  for (i=[1:segCount])
    rotate(segAng*i*2)
      rotate_extrude(angle=segAng)
        polygon(poly);
    
  if (debug){
    #translate([dia/2+filletRad,-yOffset]) circle(filletRad);
    #translate([dia/2+xOffset,0]) circle(rad);
    #translate([dia/2+filletRad,yOffset]) circle(filletRad);
    }
  
}

*halfDent();
module halfDent(thick=snapThck,rad=snapRad,filletRad=snapFillet){
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
    
    rotate_extrude(angle=180)
    polygon(poly);
    

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