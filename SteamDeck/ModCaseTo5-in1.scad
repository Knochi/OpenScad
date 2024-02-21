$fn=20;
use <polyRound.scad>

spacing=0.1;

/* [JSAUX dock Dims] */
//Dimensions of the JSAUX 5-in-1 dock HB0602 (old version)
jsxOvDims=[113.5,66,27.85]; //overall Dimensions without feet
jsxBevAng=34.5;
jsxWallThck=2.2; //wall thickness of the groove
jsxBackAng=24; //angle of the back wall of the groove#
jsxFrntHght=17; //height of the front wall
jsxGrvBtmWdth=18.3; //width without the chamfer \__
jsxGrvChmfr=2; //45° chamfer size [2,2]
jsxGrvChmfrOut= jsxGrvChmfr+jsxWallThck-tan(45/2)*jsxWallThck;

jsxBdyChmfr=[8,4]; //chamfer at the body (outer)
jsxGrvOffset=-(jsxOvDims.y-jsxGrvBtmWdth-jsxGrvChmfr-jsxWallThck);

//pads
jsxPadDimsBck=[90,9,1.1];
jsxPadHghtBck=+20; //mounting height of back pad
jsxGrvPadDims=[19.7,1.5]; //width * thickness
jsxGrvChmfrPad= jsxGrvChmfr-jsxGrvPadDims.y+tan(45/2)*jsxGrvPadDims.y;
jsxGrvPadDist=70;
  
//assembly
//jsxDock();
minWallThck=1.6;

grvOffset=[1.2,7.7]; //Offset between the two grooves


//rotate([90,0,-90]) 
  difference(){
    linear_extrude(jsxOvDims.x+minWallThck*2,center=true,convexity=3)  
      grooveShp();
    translate([grvOffset.x,-grvOffset.y,0])
      linear_extrude(jsxOvDims.x+spacing*2,center=true,convexity=3)  offset(spacing) jsxDock("body");
    for (iz=[-1,1])
      translate([grvOffset.x,-grvOffset.y,iz*jsxGrvPadDist/2])
        linear_extrude(jsxGrvPadDims.x+2*spacing,center=true,convexity=3) offset(spacing) jsxDock("pad");
  }



module jsxDock(shp=false){
  
  //shape of the extrusion, origin at lower back corner of the groove
  //tan(alpha)=GK/AK
  realBdyPoly=[
    [jsxGrvOffset,jsxBdyChmfr.y], //bottom left
    [jsxGrvOffset+jsxBdyChmfr.x,0],
    [jsxGrvOffset+jsxOvDims.y-jsxGrvChmfrOut,0],
    [jsxGrvOffset+jsxOvDims.y,jsxGrvChmfrOut],
    [jsxGrvOffset+jsxOvDims.y,jsxFrntHght],
    [jsxGrvOffset+jsxOvDims.y-jsxWallThck,jsxFrntHght],
    [jsxGrvOffset+jsxOvDims.y-jsxWallThck,jsxWallThck+jsxGrvChmfr],
    [jsxGrvOffset+jsxOvDims.y-jsxWallThck-jsxGrvChmfr,jsxWallThck],
    [0,jsxWallThck],
    [-tan(jsxBackAng)*(jsxOvDims.z-jsxWallThck),jsxOvDims.z],
    [jsxGrvOffset+jsxBdyChmfr.x,jsxOvDims.z],
    [jsxGrvOffset,jsxOvDims.z-jsxBdyChmfr.y],
  ];
  
  poly=[
    [jsxGrvOffset,jsxBdyChmfr.y], //bottom left
    [jsxGrvOffset+jsxBdyChmfr.x,0],
    [jsxGrvOffset+jsxOvDims.y,0],
    [jsxGrvOffset+jsxOvDims.y,jsxFrntHght],
    [jsxGrvOffset+jsxOvDims.y-jsxWallThck,jsxFrntHght],
    [jsxGrvOffset+jsxOvDims.y-jsxWallThck,jsxWallThck+jsxGrvChmfr],
    [jsxGrvOffset+jsxOvDims.y-jsxWallThck-jsxGrvChmfr,jsxWallThck],
    [0,jsxWallThck],
    [-tan(jsxBackAng)*(jsxOvDims.z-jsxWallThck),jsxOvDims.z],
    [jsxGrvOffset+jsxBdyChmfr.x,jsxOvDims.z],
    [jsxGrvOffset,jsxOvDims.z-jsxBdyChmfr.y],
  ];
  
  //groove Pads
  padPoly=[[0,0],
          [jsxGrvBtmWdth,0],
          [jsxGrvBtmWdth+jsxGrvChmfr,jsxGrvChmfr],
          [jsxGrvBtmWdth+jsxGrvChmfr,jsxFrntHght-jsxWallThck],
          [jsxGrvBtmWdth+jsxGrvChmfr-jsxGrvPadDims.y,jsxFrntHght-jsxWallThck],
          [jsxGrvBtmWdth+jsxGrvChmfr-jsxGrvPadDims.y,jsxGrvPadDims.y+jsxGrvChmfrPad],
          [jsxGrvBtmWdth+jsxGrvChmfr-jsxGrvPadDims.y-jsxGrvChmfrPad,jsxGrvPadDims.y],
          [-tan(jsxBackAng)*jsxGrvPadDims.y,jsxGrvPadDims.y]
          ];
          
  if (shp=="body")
    polygon(poly);
  else if (shp=="pad")
    translate([0,jsxWallThck]) polygon(padPoly);
  else {
    color("grey") rotate([90,0,-90]) linear_extrude(jsxOvDims.x,center=true) polygon(realBdyPoly);
    //back Pad
    color("darkSlateGray") translate([0,tan(jsxBackAng)*(jsxPadHghtBck-jsxWallThck),jsxPadHghtBck]) 
      rotate([90-jsxBackAng,0,0]) 
        translate([0,0,jsxPadDimsBck.z/2]) cube(jsxPadDimsBck,true);
    
    
    for (ix=[-1,1])
      color("darkSlateGRey") 
        translate([ix*jsxGrvPadDist/2,0,jsxWallThck]) 
          rotate([90,0,-90]) linear_extrude(jsxGrvPadDims.x,center=true) 
            polygon(padPoly);
  }
}

module grooveShp(){
  /* Dimensions of the groove, 
    measured with the bottom of the groove flat 
    from the JSAUX official SteamDeckDockAdapter delivered with the ModCase
  */
  bottomWdth=20.6; //bottom width of the groove without radii
  cornerRad=2.75;
  frntAng=7; //angle of the front wall relative to the bottom  -> \__/
  backAng=11; //angle of the back wall relative to the bottom \__/ <-
  frntHght=14; //vertical height of the groove relative to the bottom
  backHght=20; //vertical height of the groove relative to the bottom

  tiltAng=13; // tilt of the whole groove \__/ against the base

  
  groovePoly=[
    concat(rotatePoint([-tan(backAng)*backHght,backHght],tiltAng),0),
    [0,0,cornerRad],
    concat(rotatePoint([bottomWdth,0],tiltAng),cornerRad),
    concat(rotatePoint([tan(frntAng)*frntHght+bottomWdth,frntHght],tiltAng),0)
  ];
  
  adaptPoly= [
    //concat(rotatePoint([-tan(backAng)*backHght,backHght],tiltAng),0),
    [-1.3,0,0],
    concat(rotatePoint([bottomWdth,0],tiltAng),cornerRad),
    concat(rotatePoint([tan(frntAng)*frntHght+bottomWdth,frntHght],tiltAng),0),
    concat(rotatePoint([tan(frntAng)*frntHght+bottomWdth,frntHght],tiltAng).x,jsxOvDims.z-grvOffset.y,1),
    [jsxGrvOffset+jsxOvDims.y+grvOffset.x+minWallThck,jsxOvDims.z-grvOffset.y,1],
    [jsxGrvOffset+jsxOvDims.y+grvOffset.x+minWallThck,-grvOffset.y,1],
    [grvOffset.x+tan(jsxBackAng)*jsxGrvPadDims.y,-grvOffset.y,1]
    ];
    polygon(polyRound(adaptPoly,30));
}

  

*echo(concat(rotatePoint([0,20],45),20));
//rotate a point around [0,0]
function rotatePoint(point,angle=90)=let(
  r=norm(point),
  a=atan2(point.y,point.x)
  )[cos(angle+a)*r,sin(angle+a)*r];