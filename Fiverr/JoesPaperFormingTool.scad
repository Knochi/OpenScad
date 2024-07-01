/* [Quality] */
$fn=50; //[20:100]

/* [Dimensions] */
baseHght=120; 
baseWdth=140; 
topPlaneHght=150;
topPlaneWdth=170;
crnrRad=3;
foldedHght=30;
thickness=10;
mntHoleDist=45;
mntHoleDia=9;

/* [Notches] */
ntchCrnrDist=30;
ntchCutDist=4;
ntchCrnrRad=1;

/* [Ventholes] */
ventHoleCountWdth=5;
ventHoleCountHght=5;
ventHoleDia=9;
ventHoleToMountHole=4;
ventHoleMinWallThck=2;

/* [Hidden] */
modelHght=0.75*foldedHght;
fudge=0.1;
mntHoleChamfer=thickness/2;

formingTool();

module formingTool(){
  difference(){
    //loftOuter
    hull(){
      rndRectPlane([baseWdth,baseHght],crnrRad);
      translate([0,0,modelHght]) mirror([0,0,1]) 
        rndRectPlane([topPlaneWdth,topPlaneHght],crnrRad);
    }
    //loftInner
    translate([0,0,thickness]) hull(){
      rndRectPlane([baseWdth-thickness*2,baseHght-thickness*2],crnrRad);
      translate([0,0,modelHght-thickness+fudge]) mirror([0,0,1]) 
        rndRectPlane([topPlaneWdth-thickness*2,topPlaneHght-thickness*2],crnrRad);
    }
  
    //notches
    for (i=[-1,1]){
      translate([0,i*topPlaneHght/2,-fudge/2]) linear_extrude(modelHght+fudge)
        rndRect([topPlaneWdth-ntchCrnrDist*2,ntchCutDist*2],ntchCrnrRad);
      translate([i*topPlaneWdth/2,0,-fudge/2]) linear_extrude(modelHght+fudge)
        rndRect([ntchCutDist*2,topPlaneHght-ntchCrnrDist*2],ntchCrnrRad);
    }
    
    //mounting holes
    for (i=[-1,1]){
      translate([i*mntHoleDist/2,0,-fudge/2]){
        cylinder(d=mntHoleDia,h=modelHght+fudge);
        translate([0,0,-fudge]) 
          cylinder(d2=mntHoleDia,d1=mntHoleDia+mntHoleChamfer*2,h=mntHoleChamfer+fudge);
      }
      translate([0,i*mntHoleDist/2,-fudge/2]){
        cylinder(d=mntHoleDia,h=modelHght+fudge);
        translate([0,0,-fudge]) 
          cylinder(d2=mntHoleDia,d1=mntHoleDia+mntHoleChamfer*2,h=mntHoleChamfer+fudge);
      }
    }
    ventHoles();
  }
}


module ventHoles(){
  //dimensions of keepout area in center
  cntrKeepOutMin=mntHoleDist/2-mntHoleDia/2-ventHoleMinWallThck-ventHoleDia/2;
  cntrKeepOutMax=mntHoleDist/2+mntHoleDia/2+ventHoleMinWallThck+ventHoleDia/2;
  
  //area available for vent holes along edge
  vntHoleEdgeArea=[(baseWdth-ventHoleDia-ventHoleMinWallThck*2),
                   (baseHght-ventHoleDia-ventHoleMinWallThck*2)
                  ];
  
  //Distance between ventholes along the edges
  vntHoleDistEdge=[vntHoleEdgeArea.x/(ventHoleCountWdth-1),
                   vntHoleEdgeArea.y/(ventHoleCountHght-1)
                  ];
  
  //check if holes fit in with given distance
  fitX=vntHoleEdgeArea.x-(ventHoleDia+ventHoleMinWallThck)*(ventHoleCountWdth-1);
  fitY=vntHoleEdgeArea.y-(ventHoleDia+ventHoleMinWallThck)*(ventHoleCountHght-1);
  echo(fitX);
  assert(fitX>0,"Ventholes not fitting in width with given dimensions, count and minimum wall thickness");
  assert(fitY>0,"Ventholes not fitting in height with given dimensions, count and minimum wall thickness");

  //distribute vent holes along wdth and height and don't drill in the mounting holes
    for (ix=[-(ventHoleCountWdth-1)/2:(ventHoleCountWdth-1)/2],
         iy=[-(ventHoleCountHght-1)/2:(ventHoleCountHght-1)/2]){
           
      pos=[ix*vntHoleDistEdge.x,iy*vntHoleDistEdge.y];
      
      
      keepOutX=  (abs(pos.x) > cntrKeepOutMin) 
              && (abs(pos.x) < cntrKeepOutMax)
              && (abs(pos.y) < (mntHoleDia/2+ventHoleMinWallThck+ventHoleDia/2));
              
      keepOutY=  (abs(pos.y) > cntrKeepOutMin) 
              && (abs(pos.y) < cntrKeepOutMax) 
              && (abs(pos.x) < (mntHoleDia/2+ventHoleMinWallThck+ventHoleDia/2));
           
      if (!keepOutX && !keepOutY)
        translate([pos.x,pos.y,-fudge/2]) 
          cylinder(d=ventHoleDia,h=modelHght+fudge);
    }
      
}

*rndRectPlane();
module rndRectPlane(size=[30,30],rad=3){
  //a 3D plane
  linear_extrude(0.2,scale=0.1) hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
}

*rndRect();
module rndRect(size=[30,30],rad=3){
  hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
}