use <ttf/D-DINCondensed-Bold.ttf>
use <eCad/elMech.scad>
use <eCad/connectors.scad>

$fn=20;
fudge=0.1;
matThck= 2;

/*-- [show] -- */
export="none"; //["none","outline","mask","silkscreen"]

/*-- [label] --*/
lineWdth=0.4;
lblColor="gold";
plateColor="black";

/*-- [newPanel] -- */
encPos=[[-20,0,0],[0,0,0],[20,0,0]];


newPanel();


module newPanel(){
  for (pos=encPos) 
    translate(pos+[0,0,-7.6]) rotEncoder();
  
}

module panel1U(HP=20,center=false, holes=true){
  ovHght=39.65;
  ovWdth= HP*5.08; 
  holeSpc=[7.5,3]; //spacing hole-edge
  holeDim=[5.9,3.3];
  cntrOffset= center ? [0,0,0] : [ovWdth/2, ovHght/2, matThck/2];
  translate(cntrOffset)
    difference(){
      cube([ovWdth,ovHght,matThck],true);
      if (holes) for (ix=[-1,1],iy=[-1,1])
        translate([ix*(ovWdth/2-holeSpc.x),iy*(ovHght/2-holeSpc.y),0]) 
          hole();
    }
  module hole(){
    hull() for (ix=[-1,1])
      translate([ix*(holeDim.x-holeDim.y)/2,0,0]) cylinder(d=holeDim.y,h=matThck+fudge,center=true);
  }
}

module sepLine(length=10,width=0.8){
  hull(){
    for (iy=[-1,1])
      translate([0,iy*(length-width)/2,0]) circle(d=width);
  }
}

*arrows(type="1to3",center=true);
module arrows(size=[10,10],type="1to3",w=0.5,spc=1, points=0.5, center=false){

  cntrOffset= center ? [-size.x/2,-size.y/2] : [0,0];
  translate(cntrOffset){
    if (type=="1to3"){
      arrow([0,size.y],[0,0],width=w,spacing=spc);
      arrow([0,size.y],[size.x,size.y],width=w,spacing=spc);
      arrow([0,size.y],[size.x,0],width=w,spacing=spc);
    }
    if (type=="3to1"){
      arrow([size.x,size.y],[0,0],width=w,spacing=spc);
      arrow([0,size.y],[0,0],width=w,spacing=spc);
      arrow([size.x,0],[0,0],width=w,spacing=spc);
    }
    if (type=="2to2"){
      arrow([0,0],[size.x,0],width=w,spacing=spc);
      arrow([0,size.y],[size.x,size.y],width=w,spacing=spc);
      arrow([0,0],[size.x,size.y],width=w,spacing=spc);
      arrow([0,size.y],[size.x,0],width=w,spacing=spc);
    }
    if (points) for (ix=[0,size.x],iy=[0,size.y])
        translate([ix,iy]) circle(points);
  }
}

*arrow(start=[0,0],end=[0,-10],width=0.5,spacing=3);
module arrow(start=[0,0],end=[15,15],width=0.5,spacing=3){
  //draws an arrow on a line between start and end with spacing to start/endpoints
  x=(end.x-start.x);
  y=(end.y-start.y);
  Q2= (x>0 && y<0) ? 270 : 0;
  Q3= (x<=0 && y<=0) ? 180 : 0;
  Q4= (x<0 && y>0) ? 90 :0;
  angle=abs(atan(y/x))+Q2+Q3+Q4;
  //angle=atan2(norm(cross(start,end)),start*end);
  echo("angle",atan((end.y-start.y)/(end.x-start.x)),angle);
  hyp=norm(end-start);
  tipLen=4;
  tipWdth=1.5;
  //shaft
  translate(start) rotate(angle) translate([spacing,0])
  hull(){
    circle(d=width);
    translate([hyp-spacing*2,0]) circle(d=width);
  }
  //tip
  translate(start) rotate(angle) translate([hyp-spacing,0,0]) hull(){
    translate([-width*tipLen,width*tipWdth]) circle(d=width);
    circle(d=width);
    translate([-width*tipLen,-width*tipWdth]) circle(d=width);
  }
}

module washer(dia=7.5,thck=0.6){
  difference(){
    cylinder(d=dia,h=thck);
    translate([0,0,-fudge/2]) cylinder(d=6.1,h=thck+fudge);
  }
}