use <eCad/devBoards.scad>
use <threads.scad>

/* [show] */
showThreads=false;
showPico=false;
showBaseTop=true;
showBaseBottom=true;

/* [DomeDimensions] */
domeDia=90;
domeHeight=170;
domeWallThck=2.5;

/* [ModelDimensions] */
minWallThck=2;

spacing=0.5;

/* [Hidden] */
fudge=0.1;
$fn=100;

base();

if (showPico)
  translate([0,-domeDia,0]) piPico(false);

//base with drainslots and reservoir for condensing water 
module base(){
  topHght=15;
  botHght=30;
  baseHght=topHght+botHght;
  baseDia=domeDia+minWallThck*2+spacing*2;
  slotCount=18;
  threadLen=5;
  angInc=360/slotCount;
  threadSpcng=0.2;
  
  innerDia=domeDia-domeWallThck-spacing;
  slotDims=[3,1,topHght+fudge];
  if (showBaseTop)
    translate([0,0,botHght]) top();
  
  if (showBaseBottom)
    bottom();
  
  module top(){  
    difference(){
      cylinder(d=baseDia,h=topHght);
      translate([0,0,topHght-minWallThck-spacing]) 
        linear_extrude(minWallThck*2+spacing+fudge) difference(){
          circle(d=domeDia+spacing);
          circle(d=innerDia);
        }
       //slots
        for (ir=[0:angInc:360-angInc])
          rotate(ir) translate([(innerDia-slotDims.x)/2,0,topHght/2]) cube(slotDims,true);
      //thread
        if (showThreads)
          translate([0,0,-fudge]) metric_thread(diameter=baseDia-minWallThck+threadSpcng, 
                                                pitch=2, 
                                                length=topHght-minWallThck*3-spacing+fudge, 
                                                internal=true, leadin=0);
        else
          color("cyan") translate([0,0,-fudge]) cylinder(d=baseDia-minWallThck*2,h=topHght-minWallThck*3-spacing+fudge);
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