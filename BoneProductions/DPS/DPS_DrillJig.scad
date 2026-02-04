include <BOSL2/std.scad>
include <BOSL2/threading.scad>


//Drill Jig for DPS 
/* [Dimensions] */
minWallThck=3;
minFloorThck=2;
peepHoleDia=15;
vacDia=35;

mountHoleDia=4.7;
mountHeadDia=8.7;
mountHoleCornerOffset=12;
proxSupportThck=7;
heatInsertDia=4.5;
heatInsertLen=6.5;

/*[Part]*/
partDims=[88.4,58,7.6];
partTopWdth=45;
partTopLen=17;
partSpcng=0.3;

partWallThck=1.3;
slotDims=[1.2,6.3,1.6];
slotZOffset=4.8;

/* [drill] */
drillDia=2;
drillLength=48.5;
drillOffset=1.2;
//from Surface
drillDepth=2;
//position from center
holeXPos=4.5;
holeZPos=-0.4; //

/* [Proxxon] */
proxFlangeDia=21;
proxFlangeHght=4.5;
proxFlangeSpcng=0.1;

proxBdyDims=[125,45.5,47];
proxBdyRad=8;
proxDrillZOffset=1.2;
proxNutLen=22.5;
proxClampThck=7;
proxClampSpcng=0.5;

/* [Pusher] */
pushYOffset=35;
threadSpcng=0.4;
threadPitch=2;

/* [options] */
vacChannel=true;
testClamp=false;

/* [show] */
versionLabel="V01";
showJig=true;
showSupport=true;
showClampUpper=true;

showPart=true;
showProxxon=true;
showPusher=true;
showPushScrew=true;

showPartFit=false;

showVacAdapter=true;

/* [Hidden] */
fudge=0.1;
$fn=100;

partOffset=[-holeXPos,-partDims.y-proxDrillZOffset-drillLength+drillDepth,-holeZPos];

proxClampDims=[proxFlangeDia+proxClampThck*2,proxClampThck,proxFlangeDia/2+proxClampThck];

//table
tableDims=[partDims.x,-partOffset.y+partTopLen,proxBdyDims.z/2-partDims.z/2+partOffset.z-partSpcng+proxSupportThck];
tablePos=[partOffset.x,-tableDims.y/2,-tableDims.z-partDims.z/2+partOffset.z-partSpcng];
tableRad=mountHoleCornerOffset;
tableSurfaceZOffset=-tablePos.z-tableDims.z;

//Guide Block
guideBlockDims=[tableDims.x,partTopLen+minWallThck,partDims.z+partSpcng*2+minFloorThck];
guideBlockPos=[tablePos.x,-guideBlockDims.y/2+partOffset.y+partDims.y+minWallThck+partSpcng,guideBlockDims.z/2-tableSurfaceZOffset];

vacChannelDia=tableDims.z-proxSupportThck;
vacChannelZPos=tablePos.z+vacChannelDia/2+minFloorThck;
vacChannelYPos=guideBlockPos.y+guideBlockDims.y/2-vacChannelDia/2-minWallThck;
  


if (showPart)
  color("lightgrey") difference(){
    translate(partOffset) part();
    rotate([90,0,0]) proxxonLWB();
  }
    
if (showProxxon)
  rotate([90,0,0]) proxxonLWB();
if (showJig)
  intersection(){
  color("darkgreen") drillJig();
  if (testClamp)
    translate([0,-proxClampThck,0]) cube([51,proxClampThck*2,proxBdyDims.z+proxSupportThck+fudge],true);
  }
if (showClampUpper)
  color("lightGreen") clampUpper();
if (showSupport)
  translate([-100.0,15,0]) proxxSupport();
if (showPusher)
  translate([0,pushYOffset,0]) pusher();
if (showPushScrew)
  translate([0,pushYOffset,0]) rotate([-90,0,0]) pushScrew();

if (showPartFit)
  !difference(){
    union(){
      translate(partOffset) part();
      drillJig();
    }
    color("darkRed") translate([-holeXPos,partOffset.y+partTopLen,-proxSupportThck-fudge]) 
      cube([partDims.x+fudge,partDims.y+partTopLen,proxBdyDims.z],true);
  }

if (showVacAdapter)
  color("violet"){
    translate([tableDims.x/2+tablePos.x-10,vacChannelYPos,vacChannelZPos]) rotate([90,-90,90]) vacAdapter();
    translate([-tableDims.x/2+tablePos.x-minFloorThck,vacChannelYPos,vacChannelZPos]) rotate([90,-90,90]) vacSeal();
    }

  
  
module pusher(){
  //press against the head of the drill
  pushBdyDia=proxFlangeDia+proxClampThck*2;
  pushBdyRad=5;
  pushBdyDims=[partDims.x,20,proxBdyDims.z/2+proxSupportThck];
  difference(){
    union(){
      rotate([-90,0,0]) cylinder(d=pushBdyDia,h=pushBdyDims.y);
        translate([partOffset.x,pushBdyDims.y/2,-proxBdyDims.z/2-proxSupportThck]) 
        linear_extrude(proxBdyDims.z/2+proxSupportThck) 
          offset(pushBdyRad) 
            square([partDims.x-pushBdyRad*2,pushBdyDims.y-pushBdyRad*2],true);
    }
    translate([0,pushBdyDims.y/2,0]) 
      rotate([-90,0,0]) threaded_rod(d=proxFlangeDia,l=pushBdyDims.y+fudge*2,pitch=threadPitch,bevel=true,internal=true);
      
    for (ix=[-1,1])
      translate([ix*(partDims.x/2-mountHoleCornerOffset)+partOffset.x,pushBdyDims.y/2,0]){ 
      translate([0,0,-proxBdyDims.z/2-proxSupportThck-fudge/2]) 
        linear_extrude(pushBdyDims.z+fudge) horizontalHole(mountHoleDia);
      screwHead();
    }
  }
}

module pushScrew(){
  pScrewHeadDia=33; //M20
  pScrewHeadThck=15;
  pScrewLen=50;
  pScrewWallThck=3;
  
  difference(){
    union(){
      threaded_rod(d=proxFlangeDia-threadSpcng,l=pScrewLen,pitch=threadPitch,anchor=BOTTOM);
      translate([0,0,pScrewLen-pScrewHeadThck]) cylinder(d=pScrewHeadDia,h=pScrewHeadThck,$fn=6);
    }
    translate([0,0,-fudge]){
      cylinder(d=proxFlangeDia-pScrewWallThck*2,h=pScrewLen+fudge*2);
      cylinder(d1=proxFlangeDia-pScrewWallThck*1.4,d2=proxFlangeDia-pScrewWallThck*2,h=1);
    }
  }
  
  
}
  
*clampUpper();  
module clampUpper(){

  difference(){
    rotate([90,0,0]) linear_extrude(proxClampThck,convexity=3) difference(){
      circle(d=proxClampDims.z*2);
      circle(d=proxFlangeDia);
      translate([0,-proxClampDims.z]) square(proxClampDims.z*2,true);
    }
    
    
    //holes and cutouts for screws
    for (im=[0,1]) mirror([im,0]) 
      translate([(proxClampDims.x/2-proxClampThck/2),-proxClampThck/2,-fudge]){
        linear_extrude(proxClampDims.z) horizontalHole(3.2); //cylinder(d=3.2,h=proxClampDims.z);
        translate([0,0,proxClampThck]){
          cylinder(d=6.5,h=proxClampDims.z);
          translate([6.5/2,0,proxClampThck/2]) cube([6.5,proxClampThck+fudge,proxClampThck],true);
          }
      }
    //spacing to clamp
    translate([0,-(proxClampDims.y)/2,0]) cube([proxClampDims.x+fudge,proxClampDims.y+fudge,proxClampSpcng],true);
  }
}


module proxxSupport(){
  chamfer=2;
  sprtDims=[mountHeadDia+minWallThck*2,proxBdyDims.y+(mountHeadDia+minWallThck*2)*2,proxSupportThck+proxBdyDims.z*0.75];
  translate([0,0,-proxBdyDims.z/2-proxSupportThck]) 
    difference(){
        linear_extrude(sprtDims.z,convexity=3) 
          difference(){
            offset(delta=chamfer,chamfer=true) square([sprtDims.x-chamfer*2,sprtDims.y-chamfer*2],true);
            for (iy=[-1,1])
              translate([0,iy*(sprtDims.y/2-mountHeadDia/2-minWallThck)]) rotate(90) horizontalHole(mountHoleDia);
          }
      //cutOut
      translate([0,0,proxBdyDims.z/2+proxSupportThck]) rotate([0,90,0])  
        linear_extrude(sprtDims.x+fudge,center=true) 
          offset(proxBdyRad) square([proxBdyDims.z-proxBdyRad*2,proxBdyDims.y-proxBdyRad*2],true);
      //screwHead
      for (iy=[-1,1])
        translate([0,iy*(sprtDims.y/2-mountHeadDia/2-minWallThck),tableDims.z]) screwHead(h=sprtDims.z);
    }
}
  
module drillJig(){
  
  //freecut
  freeCutWidth=-guideBlockPos.y-guideBlockDims.y/2-proxNutLen-proxFlangeHght;
  freeCutPos=[0,guideBlockPos.y+(guideBlockDims.y+freeCutWidth)/2,tablePos.z+minFloorThck];
  
  stopCollarLen=27;
  
  difference(){
    //table
    union(){
      translate(tablePos) linear_extrude(tableDims.z) offset(tableRad) 
        square([tableDims.x-tableRad*2,tableDims.y-tableRad*2],true); //cube(tableDims,true);
      //clamp bottom //clamp Spacing
      difference(){
        translate([0,-stopCollarLen/2,tablePos.z/2]) cube([proxClampDims.x,stopCollarLen,-tablePos.z],true);
        translate([0,-(proxClampDims.y)/2,0]) cube([proxClampDims.x+fudge,proxClampDims.y+fudge,proxClampSpcng],true);
      }
      //block for part guidance
      translate(guideBlockPos+[0,0,-(guideBlockDims.z+1)/2]) 
        rotate([90,0,0]) linear_extrude(guideBlockDims.y,center=true) offset(guideBlockDims.z) 
          square([guideBlockDims.x-guideBlockDims.z*2,1],true);
      
      //better stop collar
      translate([0,-proxFlangeHght-proxFlangeSpcng,0]) rotate([90,0,0]) 
        cylinder(d=proxFlangeDia-proxFlangeSpcng*2,h=stopCollarLen-proxFlangeHght-proxFlangeSpcng);
      translate([0,-proxFlangeHght-proxFlangeSpcng-5,tablePos.z/2]) cube([proxFlangeDia,10,-tablePos.z],true);
    }
    
    //proxxon
    rotate([90,0,0]) proxxonLWB(true);
    
    //drill& vac Channel connection
    translate([0,guideBlockPos.y+guideBlockDims.y/2+fudge/2,0]) rotate([90,0,0]) hull(){
      cylinder(d=drillDia*2,h=minWallThck+fudge);
      translate([0,vacChannelZPos,0]) cylinder(d=vacChannelDia,h=minWallThck+fudge);
    }
    
    translate([0,guideBlockPos.y+guideBlockDims.y/2+fudge/2,0]){
      cylinder(d=1,$fn=4,h=drillDia*4,center=true);
      rotate([0,90,0]) cylinder(d=1,$fn=4,h=drillDia*4,center=true);
    }
    
    //vac channel
    if (vacChannel)
      translate([0,vacChannelYPos,vacChannelZPos]){ 
        translate([tablePos.x,0,0]) rotate([90,0,90]) linear_extrude(tableDims.x+fudge,center=true) rotate(45) horizontalHole(vacChannelDia);
        rotate([90,0,180]) linear_extrude(guideBlockDims.y/2) circle(d=vacChannelDia);
      }
    
    
    //holes for heat inserts
    for (ix=[-1,1])
      translate([ix*(proxClampDims.x/2-proxClampThck/2),-proxClampThck/2,0]) 
        translate([0,0,fudge/2]) rotate([180,0,0]) cylinder(d=heatInsertDia,h=-tablePos.z+fudge*2);
        
    //cutout part from guide
    translate(partOffset) part(true);
    
    //compartment for plastic chips
    translate(freeCutPos) linear_extrude(tableDims.z+fudge)
      hull() for (ix=[-1,1]) 
        translate([ix*((vacChannelDia*2-freeCutWidth)/2),0]) circle(d=freeCutWidth);
        
    //peepHole
    translate([0,guideBlockPos.y+(guideBlockDims.y-peepHoleDia)/2-minWallThck,0]) linear_extrude(partDims.z+minFloorThck+fudge){
      circle(d=peepHoleDia);
      translate([0,-guideBlockDims.y/2]) square([peepHoleDia,guideBlockDims.y],true);
      }
      
    //mount holes
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*(tableDims.x/2-mountHoleCornerOffset)+tablePos.x,-tableDims.y/2+iy*(tableDims.y/2-mountHoleCornerOffset),0]){ 
        translate([0,0,tablePos.z-fudge/2]) cylinder(d=mountHoleDia,h=tableDims.z+fudge);
        translate([0,0,-tableSurfaceZOffset]) screwHead();
        }
    //slope for 45° printing
    translate([tablePos.x,0,tablePos.z]) rotate([0,90,0]) cylinder(d=20,h=tableDims.x+fudge,center=true,$fn=4);
    //version label
    translate([tablePos.x,-tableDims.y/2,tablePos.z-fudge]) 
      roof() 
        rotate(90) mirror([1,0]) text(versionLabel,halign="center",valign="center");
    } 
    
}
*screwHead();
module screwHead(h=proxSupportThck){
  translate([0,0,-proxSupportThck]){
    cylinder(d=mountHeadDia,h=h+fudge);
    translate([0,0,-(mountHeadDia-mountHoleDia)/2]) cylinder(d1=mountHoleDia,d2=mountHeadDia,h=(mountHeadDia-mountHoleDia)/2+0.01);
  }
}

*part(true);
module part(cut=false){
  spcng= cut ? partSpcng : 0;
  translate([0,0,-partDims.z/2-spcng])
    difference(){
      translate([-partDims.x/2,0,0]) linear_extrude(partDims.z+spcng*2,convexity=3) offset(spcng) import("KU4085_Gehaeuse.svg");
      if (!cut)
        translate([-partDims.x/2,0,1]) linear_extrude(partDims.z+spcng,convexity=3) offset(-partWallThck) import("KU4085_Gehaeuse.svg");
      for (ix=[-1,1])
        translate([ix*(partTopWdth-slotDims.x+spcng*2+fudge)/2,partDims.y-(slotDims.y-fudge)/2+spcng+fudge,slotZOffset+spcng]) cube(slotDims+[fudge,fudge-spcng,-spcng*2],true);
  }
}

*proxxonLWB();
module proxxonLWB(cut=false){
 
  //neck
  startDia=24;
  endDia=21;
  neckLen=69;
  
  if (cut) translate([0,0,-fudge]){
    cylinder(d=proxFlangeDia+proxFlangeSpcng*2,h=proxFlangeHght+proxFlangeSpcng+fudge);
    cylinder(d=15,h=30+fudge);
  }
  else {
    color("silver"){ 
      head();
      translate([-neckLen,0,-4.1-endDia/2]) 
        rotate([0,90,0]) cylinder(d1=startDia,d2=endDia,h=neckLen);
    }
    //drill
    color("darkSlateGrey")  translate([0,0,proxDrillZOffset]) cylinder(d=drillDia,h=drillLength);
  }
  
  module head(){
    //-- union nut
    //nut
    translate([0,0,22.5-17+proxFlangeHght]){
      cylinder(d=11,h=4.8);
      translate([0,0,4.8]){
        cylinder(d=12.4,h=7.2);
        translate([0,0,7.2])
          cylinder(d1=12.4,d2=8,h=5);
          }
        }
    //spindle
    difference(){
      cylinder(d=7.9,h=16.16+proxFlangeHght);
      translate([0,0,proxDrillZOffset]) cylinder(d=4.5,h=14.75+fudge);
      }
      
    //defined flange!
    cylinder(d=proxFlangeDia,h=proxFlangeHght);
    //head body
    translate([0,0,-19.5]){
      cylinder(d=22.25,h=19.5);
      translate([0,0,-2.5]){
        cylinder(d1=18.5,d2=22.25,h=2.5);
        translate([0,0,-5.8]) cylinder(d=18.5,h=5.8);
        }
      }
  }
}

*vacAdapter();
module vacAdapter(spacing=0.2,length=30,cut=false){
  din = vacChannelDia-spacing;
  dout= vacDia+spacing;
  midLen=(dout+minWallThck*2-din); //45° max angle
  botDia= cut ? vacChannelDia-minWallThck*2 : din;
  botLen= cut ? length+minWallThck : length;
  topDia= cut ? dout : dout + minWallThck*2;
  topLen= cut ? length-minWallThck : length;
  shiftX= cut ? minWallThck-din/2 :-vacChannelDia/2;
  flangeWdth= topDia+mountHoleCornerOffset*2;
  holeOffset=minWallThck+mountHoleDia/2;
  shiftZ= cut ? 0.1 : 0;
  
  difference(){
    union(){
      translate([botDia/2+shiftX,0,-shiftZ]) cylinder(d=botDia,h=botLen+shiftZ);
      translate([+shiftX,0,botLen]) 
        linear_extrude(midLen,scale=(topDia/botDia)) translate([botDia/2,0,0]) circle(d=botDia);
      translate([topDia/2+shiftX,0,botLen+midLen]) cylinder(d=topDia,h=topLen+shiftZ);
      //mounting structure
      if (!cut) translate([shiftX,0,0]) {
        translate([-minFloorThck,-topDia/2,botLen+midLen]) cube([topDia/2+minFloorThck,topDia,topLen]);
        translate([-minFloorThck,-flangeWdth/2,botLen+midLen]) rotate([90,0,90]) linear_extrude(minFloorThck) 
          difference(){
            translate([3,3]) offset(3) square([flangeWdth-6,topLen-6]);
            for (ix=[holeOffset,flangeWdth-holeOffset]) hull(){
              translate([ix,holeOffset]) circle(d=mountHoleDia);
              translate([ix,topLen-holeOffset]) circle(d=mountHoleDia);
            }
            
          }
      }
    }
    if (!cut) vacAdapter(spacing,length,true);
  }
}

*vacSeal();
module vacSeal(){
  cylinder(d=vacChannelDia-0.2,h=10);
  cylinder(d=vacChannelDia+minFloorThck*2,h=minFloorThck);
  translate([0,0,10]) cylinder(d1=vacChannelDia-0.2,d2=vacChannelDia-0.2-4,h=2);
}


//horizontal 3DP holes 
*horizontalHole(dia=25);
module horizontalHole(dia=1, ang=45){
  //https://www.hydraresearch3d.com/design-rules#holes-horizontal
  
  //sin(a)=GK/HYP
  //cos(a)=AK/HYP
  //tan(a)=GK/AK
  //f2(x)=
  a=0.3; //change to 0.6 for <0.1 layer thickness
  r=dia/2;
  
  //roof
  //tangent point
  p1=[cos(90-ang)*r,sin(90-ang)*r];
  //crossing point
  //px2=px1-tan(90-ang)*(r+a-py1);
  p2=[p1.x-tan(90-ang)*(r+a-p1.y),r+a];
  roofPoly=[[-p1.x,p1.y],[-p2.x,p2.y],p2,p1];

  //bottom
  x=sqrt(pow(r+a,2)-pow(r,2));
  px3=x*r/(r+a);
  py3=-(r+a)+sqrt(pow(x,2)-pow(px3,2));
  botPoly=[[-px3,py3],[0,-r-a],[px3,py3]];

  polygon(roofPoly);  
  polygon(botPoly);  
  
  circle(d=dia);
  
}

