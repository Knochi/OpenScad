/* [Monitor] */
monTopWidth=18.7;
monFramThck=0.6;
monFramWdth=1.8;
//space behind the monitor for the wedge
monBackSpcng=23.8;

/* [Dimensions] */
//the horizontal platform thickness
platformThck=2.7;
//the vertical beam thickness
beamThck=3.2;
//the front wall facing the user
frntWallThck=2;
//offset of the box center to monitor front
boxOffset=-58.8; //[-80:0.5:0]
cornerRad=3;
//cannot be larger than monBackSpcng
wedgeWdth=21.3;
wedgeHght=61.2;
wedgeWallThck=2;

/* [Hidden] */
fudge=0.1;
// -- keep this values to stay compatible with other parts!
hldrWdth=32.2;
//walls of the square box
boxWallThck=3;
boxDims=[hldrWdth,hldrWdth,10.1];
boxPos=monBackSpcng+monTopWidth+boxOffset;
boxHoleDist=13.5;
boxHoleDia=1.8;
wedgeTipRad=2.5;
wedgeTipHoleDia=2;

wedgeWdthLim=min(wedgeWdth,monBackSpcng);
$fn=64;
//only the positive part
platformWdth= monBackSpcng + monTopWidth + frntWallThck ;

*rotate(-90) translate([-10.1,-32.4,0]) import("Brio100Support.stl");

//box  
translate([boxPos,0,0]) box();
platform();
wedge();

module platform(){
  //platform
  linear_extrude(hldrWdth){
    difference(){
      translate([0,-platformThck]) square([platformWdth,platformThck]);
      translate([platformWdth-monTopWidth-frntWallThck,-platformThck]) square([monTopWidth,platformThck/2]);
    }
    //front hook
    translate([platformWdth-frntWallThck,-monFramWdth-platformThck]) square([frntWallThck,monFramWdth+platformThck]);
    translate([platformWdth-frntWallThck-monFramThck,-monFramWdth-platformThck]) square([monFramThck,platformThck/2]);
    //if box is behind zero
    if ((boxPos-boxDims.x/2)<0)
      translate([boxPos-boxDims.x/2,-platformThck]) square([-boxPos+boxDims.x/2,platformThck]);
    //round the corner if feasible
    echo((boxPos-boxDims.x/2));
    if ((boxPos-boxDims.x/2)<-cornerRad)
      translate([0,-platformThck]) rotate(180) difference(){
        square(cornerRad);
        translate([cornerRad,cornerRad]) circle(cornerRad);
      }
  }
    
}

module wedge(){

  // Kreis
  r = wedgeTipRad;
  H = wedgeHght;
  w = wedgeWdthLim;
  t = platformThck-wedgeWallThck;
  
  // Abstand vom Kreismittelpunkt zum oberen Punkt der Hypotenuse
  dx = w - r;
  dy = H - t;
  d2 = dx*dx + dy*dy;

  // Tangentialpunkt, rechte Tangente
  k = r*r/d2;
  q = r*sqrt(d2-r*r)/d2;

  tangentX = r + k*dx + q*dy;
  tangentY = -H + k*dy - q*dx;

  wedgePoly=[
    [0,-t],
    [w,-t],
    [tangentX,tangentY],
    [0,-H]
  ];

  linear_extrude(hldrWdth) difference(){
    wedgeShape();
    offset(cornerRad) offset(-cornerRad-wedgeWallThck) wedgeShape();
    translate([r,-H]) circle(d=wedgeTipHoleDia);
  }
    
  
  module wedgeShape(){    
    translate([r,-H])
      circle(r);
    polygon(wedgePoly);
  }
}
  
  
module box(){
  difference(){
    translate([0,boxDims.z/2,0]) linear_extrude(hldrWdth,convexity=3) difference(){
       square([boxDims.x,boxDims.z],true);
      for (ix=[-1,1])
        translate([ix*boxHoleDist/2,0]) circle(d=boxHoleDia);
    }
    translate([0,(boxDims.z+fudge)/2,boxDims.y/2]) cube([boxDims.x-2*boxWallThck,boxDims.z+fudge,boxDims.y-2*boxWallThck],true);
  }
}

