// Inspired by "Franz" from buildify
// https://cdn.hornbach.de/cmsm/de/e-de-buildify-anleitung-franz-wandsekretaer-0420.pdf

echo([ -350.35, -125.88, 429.34 ]-[ 349.91, -129.57, 487.24 ]);


/* [show] */
tblAng=0; //[0:90]
showSides=true;
showBack=true;
showMonitor=true;
showTable=true;

/* [Dimensions] */
matThck=18; //Material thickness
ovDpth=100; //depth of side top
ovWdth=600;
proTrude=50; //how much should the front protrude the backplate
tblDpth=600;
tblHght=810; //height of table (surface)
monHght=1300;
cornerRad=55; //Radius of table and front plate

/* [variants] */
footLeft=true;

/* [Hidden] */
$fn=20;
fudge=0.1;

// colors

backCol="BurlyWood";
sideCol="NavajoWhite";
topCol="Bisque"; //top and shelfes
tblCol="ivory";


bckDims=[ovWdth,tblHght+tblDpth+ovDpth]; //back Dimensions

//from top to bottom 
shelfYOffsets=[bckDims.y-matThck/2,           //top
              tblHght+ovDpth+matThck*1.5,     //shelf1
              tblHght-matThck*1.5-proTrude*2, //shelf2
              230+matThck/2];                 //shelf3

// --- Assembly ---
//back
if (showBack) color(backCol) rotate([90,0,0]) back();
//Monitor
if (showMonitor) translate([0,-matThck-20,monHght]) rotate([90,0,0]) asusVA24D();//20mm VESA mount
//table wth hinges
if (showTable) translate([0,-matThck,tblHght-matThck]) table();
//hinges

//sides Top
if (showSides) color(sideCol) for (ix=[-1,1])
  translate([ix*(bckDims.x+matThck)/2,0,tblHght+ovDpth]) sideTop();

//foot
mx= (footLeft) ? 0 : 1;
color(sideCol) mirror([mx,0,0]) translate([-(bckDims.x-matThck)/2,-matThck,0]) foot();

//sideBottom
color(sideCol) mirror([mx,0,0]) translate([(bckDims.x-matThck)/2,-matThck,0]) sideBottom();

//top plate and shelfes
  color(topCol) for (i=[0:len(shelfYOffsets)-1]){
    xOffset = (i>1) ? (footLeft) ? -matThck/2 : matThck/2 : 0;
    translate([xOffset,-matThck,shelfYOffsets[i]]) shelf(i);
  }  
//front
color(tblCol) translate([0,-ovDpth-matThck,proTrude*2]) front();

module back(){
  drillMatrix=[[-bckDims.x/2+25,-bckDims.x/6,bckDims.x/6,bckDims.x/2-25],
               shelfYOffsets]; //4x3 Matrix from center

    linear_extrude(matThck) difference(){
        translate([0,bckDims.y/2]) square(bckDims,true);
        for (ix=drillMatrix.x,iy=drillMatrix.y)
          translate([ix,iy]) circle(d=3);
            }
}

*table();
module table(){ //Tischplatte: 450x700, Stützbrett: 110x600

tblDims=[bckDims.x+2*proTrude,tblDpth,matThck];
supportDims=[bckDims.x,matThck,ovDpth+0];
tblRotOffset=[0,1,-supportDims.z-matThck-1];

  color(tblCol) translate(-tblRotOffset) 
    rotate([-tblAng,0,0]) 
        translate(tblRotOffset){
          translate([0,-tblDims.y/2,matThck/2]) rndRect(tblDims,cornerRad,0,true);
          translate([0,-matThck/2,matThck+supportDims.z/2]) cube(supportDims,true);
        }
  for (ix=[-1,1])
  translate([ix*(bckDims.x-50-64)/2,0,supportDims.z+matThck+1]) rotate([90,0,0]) hinge(angle=90+tblAng);

}

module front(){ //Front: 650x700mm
  ovDims=[bckDims.x+2*proTrude,shelfYOffsets[2]+matThck/2,matThck];
  echo(ovDims);
  rotate([-90,0,0]) translate([0,-ovDims.y/2,-matThck/2]) rndRect(ovDims,cornerRad,0,true);
}

*sideTop();
module sideTop(){ //obere Seitenwand: 118x440 (table-10)
ovDims=[tblDpth,ovDpth+matThck];
  
  translate([0,-ovDims.y/2,ovDims.x/2]) rotate([0,90,0]) 
    linear_extrude(matThck,center=true)
    difference(){
      square(ovDims,true);
      holes(7);
    }
}
module holes(count=5){
  for (ix=[0:count-1])
  translate([50+ix*10,40]) circle(d=5);
}

module sideBottom(){//untere Seitenwand: 100x618
  ovDims=[shelfYOffsets[2]+matThck/2,100];
  translate([0,-ovDims.y/2,ovDims.x/2]) rotate([0,90,0]) 
    linear_extrude(matThck,center=true)
      square(ovDims,true);
}

*shelf(2);
module shelf(no=1){ //No0: top, No1..3 shelfes
  ovDims = (no<=1) ? [bckDims.x,ovDpth] : [bckDims.x-matThck,ovDpth];

  linear_extrude(matThck,center=true) translate([0,-ovDims.y/2]) 
    difference(){
      mx = (footLeft) ? 1 : 0;
      square(ovDims,true);
      if (no==2) mirror([mx,0,0]) translate([-(ovDims.x-95)/2,(ovDims.y-80)/2]) square([95,80],true);
    }
}

module foot(){
  ovDims=[230,ovDpth];
  translate([0,-ovDims.y/2,ovDims.x/2]) rotate([0,90,0]) 
    linear_extrude(matThck,center=true)
      square(ovDims,true);
}

module top(){ //Deckel: 100x600 
  linear_extrude(matThck,center=true) translate([0,-ovDpth/2]) 
    square([bckDims.x,ovDpth],true);
}

module rndRect(size, rad, drill=0, center=true){  
  if (len(size)==2) //2D shape
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(d=drill);
    }
  else
    
    linear_extrude(size.z,center=center) 
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(d=drill);
    }
}
*asusVA24D();
module asusVA24D(){
  //dummy of asus monitor
  ovDims=[539.7,323.55,59.30];
  bezelThck=14.39;
  AADims=[527.04,296.46]; //active area
  AAcntrPos=[0,18.83/2];

  difference(){
    color("darkSlateGrey") translate([0,-AAcntrPos.y,0]) union(){
      translate([0,0,-bezelThck/2+ovDims.z]) cube([ovDims.x,ovDims.y,bezelThck],true);
      translate([0,0,(ovDims.z-bezelThck)/2]) cube([ovDims.x*0.7,ovDims.y*0.5,ovDims.z-bezelThck],true);
    }
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*100/2,iy*100/2,-fudge/2]) cylinder(d=4,h=20);
      color("grey") translate([0,0,ovDims.z]) cube([AADims.x,AADims.y,fudge],true);
    }
  
}

*hinge();
module hinge(size=[64,34,1],angle=0){
color("gold"){
    translate([0,0,size.z]) rotate([0,90,0]) cylinder(d=2*size.z,h=size.x,center=true);
    translate([0,(size.y/2)/2,size.z/2]) cube([size.x,size.y/2,size.z],true);
    translate([0,0,size.z]) rotate([-angle,0,0]) translate([0,-(size.y/2)/2,-size.z/2]) cube([size.x,size.y/2,size.z],true);
    }
}