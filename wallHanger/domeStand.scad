use <eCad/devBoards.scad>
use <threads.scad>

/* [show] */
showThreads=false;
showPico=false;
showBaseTop=true;
showBaseBottom=true;
showDome=true;
showCut=false;

/* [DomeDimensions] */
domeOuterDia=90;
domeHeight=170;
domeWallThck=2.5;

/* [ModelDimensions] */
minWallThck=2;
spacing=0.5;
topHght=15;
botHght=30;
baseHght=topHght+botHght;

/* [Hidden] */
baseDia=domeOuterDia+minWallThck*2+spacing*2;
fudge=0.1;
$fn=100;

difference(){
  base();
  if (showCut) color("darkRed") translate([0,-baseDia/4,baseHght/2]) cube([baseDia+fudge,baseDia/2,baseHght+fudge],true);
}

if (showDome)
  translate([0,0,baseHght-minWallThck]) glassDome();

if (showPico)
  translate([0,-domeOuterDia,0]) piPico(false);

//base with drainslots and reservoir for condensing water 
module base(){
  
  
  slotCount=12;
  threadLen=5;
  angInc=360/slotCount;
  threadSpcng=0.2;
  rodDia=2.2;
  rodDistDia=30; 
  chamfer=1;
  
  innerDia=domeOuterDia-domeWallThck*2-spacing*2;
  slotDims=[4,2,topHght+fudge];
  if (showBaseTop)
    translate([0,0,botHght]) top();
  
  if (showBaseBottom)
    bottom();
  
  module top(){  
    difference(){
      cylinder(d=baseDia,h=topHght);
        rotate_extrude() translate([(domeOuterDia-domeWallThck)/2,topHght-minWallThck]) circle(d=domeWallThck+spacing*2);
 
        translate([0,0,topHght-minWallThck]) 
          linear_extrude(minWallThck+fudge) difference(){
          circle(d=domeOuterDia+spacing*2);
          circle(d=innerDia);
          }
        
        //slots
        for (ir=[0:angInc:360-angInc])
          rotate(ir) translate([(innerDia-slotDims.x)/2+spacing+domeWallThck/2,0,topHght/2]) cube(slotDims,true);
        //holes for metal rods
        for (ir=[0:120:240])
          rotate(ir) translate([rodDistDia/2,0,0]){
            cylinder(d=rodDia,h=topHght+fudge-chamfer);
            translate([0,0,topHght-chamfer]) cylinder(d1=rodDia,d2=rodDia+(chamfer+fudge)*2,h=chamfer+fudge);
          }
        //thread
        if (showThreads)
          translate([0,0,-fudge]) metric_thread(diameter=baseDia-minWallThck+threadSpcng, 
                                                pitch=2, 
                                                length=topHght-minWallThck*3-spacing+fudge, 
                                                internal=true, leadin=0);
        else
          color("cyan") translate([0,0,-fudge]) cylinder(d=baseDia-minWallThck*2,h=topHght-minWallThck*3-spacing+fudge);
      }
      //sockets for metal rods
        for (ir=[0:120:240])
          rotate(ir) translate([rodDistDia/2,0,0]) difference(){
            cylinder(d=rodDia+2*minWallThck,h=topHght-chamfer);
            translate([0,0,minWallThck]) cylinder(d=rodDia,h=topHght);
          }
    }
      
  module bottom(){
    difference(){
      union(){
        cylinder(d=baseDia,h=botHght);
        if (showThreads)
          translate([0,0,botHght]) metric_thread(diameter=baseDia-minWallThck-threadSpcng, 
                                                 pitch=2, 
                                                 length=threadLen, 
                                                 internal=false, leadin=0);
        else
          color("cyan") translate([0,0,botHght]) cylinder(d=baseDia-minWallThck,h=threadLen);
      }
      
      translate([0,0,minWallThck]) cylinder(d=baseDia-4*minWallThck,h=botHght+threadLen);
      //thread on top
      
    }
  }
}

//glass dome
*glassDome();
module glassDome(dia=90, height=170, wallThck=2.5){
  fudge=0.1;
  color("white",0.2) difference(){
    union(){
      translate([0,0,height-dia/2]) 
        //half sphere
        difference(){ 
          sphere(d=dia);
          translate([0,0,-(dia+fudge)/2]) cylinder(d=dia+fudge,h=dia+fudge,center=true);
        }
      cylinder(d=dia,h=height-dia/2);
    }
    union(){
      translate([0,0,height-dia/2-wallThck]) sphere(d=dia-wallThck*2);
      translate([0,0,-fudge]) cylinder(d=dia-wallThck*2,h=height-dia/2-wallThck+fudge);
    }
  }
}