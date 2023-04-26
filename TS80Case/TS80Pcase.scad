include <eCAD/KiCADColors.scad>
$fn=20;

/* -- [Dimensions] -- */
//overall Dimensions
ovDims=[164.8,95,25];
//Omnifix IO plate dimensions
OFDims=[160,90,1.2];
//main corner radius
ovCrnrRad=10.4;
//magnets height
magnetHght=2;
//magnets diameter
magnetDia=4;
//minimum Wall thickness
minWallThck=2;
//circumfence ledge (kante)
ledge=[1,1,1.2]; 
mainCompDims=[104,30];
cleanCompDia=50;
cleanCompOpening=40;

/* -- [Positions] --*/
TS80TipPos=[161,67.8,10.5];

/* -- [show] -- */
showOrig=true;
showRemix=true;
showTS80P=true;
showTip=true;
showCentered=false;
showSection=false;
sectionOffset=150;

/* -- [Configure] -- */
original="OF-TS80P"; // ["OF-TS80P","TS80Case","OF-FieldBox"]

originalFile= (original=="OF-TS80P") ? "omnifixo_box.stl" :
              (original=="TS80Case") ? "ts80_case_main_fixed.stl" :
              (original=="OF-FieldBox") ? "OMNIFIXO_FIELD_BOX.stl" : "ts80_case_main.stl";
ogRotation= (original=="OF-TS80P") ? [0,0,90] :
            (original=="TS80Case") ? [90,0,0] :
            (original=="OF-FieldBox") ? [90,0,0] : [0,0,0];
ogTranslation = (original=="OF-TS80P") ? [187.4,-77.9,0] :
                (original=="TS80Case") ? [0,ovDims.y,0] :
                (original=="OF-FieldBox") ? [0,0,0] : [0,0,0];

echo(original,originalFile);
/* [Hidden] */
/* --- Compartments --- */
//add height to the main compartment dimensions
compDims=[mainCompDims.x,mainCompDims.y,ovDims.z-minWallThck];

//Offset of main compartment from center
  mainCompOffset=[(ovDims.x-compDims.x)/2-minWallThck-ledge.x,
                  (ovDims.y-compDims.y)/2-minWallThck-ledge.y,
                   -ovDims.z/2+minWallThck];
  //rest
  solderCompDims=[compDims.x,ovDims.y-compDims.y-minWallThck*3-ledge.y*2,compDims.z];
  solderCompOffset=[(ovDims.x-compDims.x)/2-minWallThck-ledge.x,
                  (-ovDims.y+solderCompDims.y)/2+minWallThck+ledge.y,
                   -ovDims.z/2+minWallThck];


//configure x-y positions for magnets
magPos=[[ovDims.x-minWallThck-ledge.x-magnetDia/2,ovDims.y-minWallThck-ledge.y-mainCompDims.y-minWallThck/2]];
fudge=0.1;

difference (){
  union(){
    if (showOrig) translate(ogTranslation) rotate(ogRotation) import(originalFile, convexity=5);
    if (showTS80P) translate([160,ovDims.y-12.5,4+13/2]) rotate([0,-90,0]) TS80P();
    if (showTip) translate(TS80TipPos) rotate([0,-90,0]) color("silver") TS80PTip();
    if (showRemix) mainCase(showCentered);
  }
    if (showSection) color("darkred") 
      translate([-fudge/2+sectionOffset,-fudge/2,-fudge/2]) 
        cube(ovDims+[fudge-sectionOffset+20,fudge+20,fudge+10]);
  }
  
module mainCase(center=false){
  crnRad=ovCrnrRad;
  chamfer=2;
  rMag=crnRad-minWallThck-magnetDia/2;
  magCoord=[rMag*cos(45),rMag*sin(45)];
  mainHght=ovDims.z;
  
  
  cntrOffset= center ? [0,0,0]: ovDims/2;
 
  difference(){
    body();
    //magnets();
    for (pos=magPos)
      translate([pos.x,pos.y,ovDims.z-OFDims.z-magnetHght]) cylinder(d=magnetDia,h=magnetHght+fudge);

    translate([cntrOffset.x,cntrOffset.y,ovDims.z-(OFDims.z-fudge)/2]) rndRect(OFDims+[0,0,fudge],8,0,true);
    translate(mainCompOffset) 
      compartment(compDims,crnRad-minWallThck-ledge.x);
    translate(solderCompOffset)
      compartment(solderCompDims,crnRad-minWallThck);
  }
  
  *cleanComp();
  
  module body(){
    translate(cntrOffset) hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(ovDims.x/2-crnRad),iy*(ovDims.y/2-crnRad),-mainHght/2]){ 
        translate([0,0,chamfer]) cylinder(r=crnRad,h=mainHght-chamfer);
        cylinder(r1=crnRad-chamfer,r2=crnRad,h=chamfer);
      }
  }
  
  module magnets(){
    translate(cntrOffset) for (ix=[-1,1],iy=[-1,1])
      translate([ix*(ovDims.x/2+magCoord.x-crnRad),
                 iy*(ovDims.y/2-crnRad+magCoord.y),
                 mainHght/2-magnetHght]) 
        cylinder(d=magnetDia,h=magnetHght+fudge);
    }
    
  //generic compartment
  module compartment(size=[100,20,40],radius=3,roundTop=false){  
    x= roundTop ? 2 : 1;
    translate(cntrOffset) hull() for (ix=[-1,1],iy=[-1,1]){
          translate([ix*(size.x/2-radius),iy*(size.y/2-radius),0]){ 
            translate([0,0,radius]) cylinder(r=radius,h=size.z-radius*x+fudge);
            translate([0,0,radius]) sphere(radius);
            if (roundTop) translate([0,0,size.z-radius]) sphere(radius);
          }
     }
  }
  
  //compartment for cleaning sponge/brass spiral wool
  module cleanComp(dia=cleanCompDia,hght=10,radius=3){
    for (iz=[0,1])
      rotate_extrude() translate([cleanCompDia/2-radius,radius+iz*(hght-radius*2)]) circle(r=radius);
    
    translate([0,0,radius]) cylinder(d=dia,h=hght-radius*2);
    cylinder(d=dia-radius*2,h=hght);
  }
}

/* --- Dummys ---*/
*OmnifixoPlate();
module OmnifixoPlate(){
  //https://omnifixo.com/
  baseDims=OFDims; //[160.2,90.2,1.2];
  baseRad=8;
  drillDia=3;
  drillOffset=[148,47.8];

  //plate
  color(blackBodyCol) linear_extrude(baseDims.z) difference(){
    rndRect([baseDims.x,baseDims.y],radius=baseRad,drillDia=0, center=true);
    for (ix=[-1,1],iy=[-1,1]){
      translate([0,iy*(drillOffset.y-drillDia)/2]){
        translate([ix*(drillOffset.x-drillDia)/2,0]) circle(d=drillDia);
        translate([ix*(baseDims.x)/2,0]) square([4,4.8],true);
      }
    }
  }
  //feet
  color(darkGreyBodyCol) for (ix=[-1,1],iy=[-1,1])
    translate([ix*(baseDims.x/2-baseRad),iy*(baseDims.y/2-baseRad),0]) 
      mirror([0,0,1]) lathe([[0.5,16],[1.7,15,14.8],[2.4,9.8,9]]);

}
*OFMagFoot();
//magnetic foot
module OFMagFoot(){
  color(yellowBodyCol) lathe([[0.6,14.2],[6.4,15,14.6],[0.9,14.6,13.5]]);
}

*OFClip();
module OFClip(){
  ovHght=41.6;
  discDia=9.8;
  discHght=1.5;
  sheetThck=1;
  jawZPos=-26.1; //from top

  color(metalSilverCol){
    translate([0,0,5]) sphere(d=10);
    translate([0,0,5]) cylinder(d=4.9,h=ovHght-5);
    translate([0,0,ovHght-discHght]) cylinder(d=discDia,h=discHght);
    //bottom, fixed jaw
    translate([0,0,ovHght-discHght-sheetThck]) 
      linear_extrude(sheetThck){
        translate([-11.4/2,0]) rndRect([11.4,6],1,0,true);
        circle(d=discDia);
        translate([14/2,0]) rndRect([14,discDia],1,0,true);
        translate([14+10/2-1,0]) rndRect([10+2,2.5],1,0,true);
      }
    //top, movable jaw
    translate([0,0,ovHght+jawZPos]){
      linear_extrude(sheetThck){
        translate([-11.4/2,0]) rndRect([11.4,7.1],2,0,true);
        circle(d=discDia);
        translate([11.1/2-sheetThck/4,0]) square([11.1-sheetThck/2,discDia],true);
      }
      translate([11.1,0,sheetThck/2]) rotate([0,-90,0]) linear_extrude(sheetThck){
        translate([10.5/2,0]) square([10.5,discDia],true);
        translate([10.5+17.2/2,0]) square([17.2,5.4],true);
      }
      translate([25.3-10/2,0,-jawZPos]) linear_extrude(sheetThck) rndRect([10,2.5],1,0,true);
    }
  }
}
//a TS80P dummy
module TS80P(){
  ovLngth=96.3;
  baseDia=13;
  baseLngth=69.5;
  //base
  color("darkSlateGrey"){
    cylinder(d=baseDia,h=baseLngth);
  //pusher
  translate([0,0,baseLngth]) cylinder(d1=baseDia,d2=15.9,h=21);
  translate([0,0,baseLngth+21]) cylinder(d1=15.9,d2=18,h=2.8);
  translate([0,0,baseLngth+21+2.8]) cylinder(d=18,h=1.5);
  translate([0,0,baseLngth+21+2.8+1.5]) cylinder(d1=18,d2=16.5,h=1.5);
  }
}

module TS80PTip(){
  //array of distances and diameters
  TS80Tip=[[14,3.5],[2.9,5],[23.5,8.4],
          [2.8,10.6],[14.6,10.6,6.6],
          [14.2,2.8],[1,2.8,3.8],[12.2,3.8],
          [0.5,3.8,4.9],[6,4.9],[1.2,4],
          [7.2,4,0.2]];
  lathe(TS80Tip);
}

*fluxer();
module fluxer(){
  //stannol mini-fluxer 10ml
  dims=[[2.5,13.1],[109.3,15.6],[3.5,16.8],[4,15.6,11.7],[21.7,11.7,11.3]];
  lathe(dims);
}

/* --- Tools ---*/

*rndRect(size=[20,10,3],radius=20,center=false);
module rndRect(size=[10,10,2],radius=3,drillDia=1,center=false){
  //set to cube if size.y not defined
  dims = (size.y==undef) ? [size.x,size.x,size.x] : size;
  comp = (size.x>size.y) ? size.y : size.x; //which value to compare to
  radius = (radius>(comp/2)) ?  comp/2 : radius; //set and limit radius
  cntrOffset = center ? len(size)<3 ? [0,0] : // center && len(size)<3
                                      [0,0,-size.z/2] : //else if center
                                      [size.x/2,size.y/2,0]; //else
  echo(cntrOffset);
  if (len(size)<3)
    translate(cntrOffset) shape();
  else
    translate(cntrOffset) linear_extrude(size.z)  shape();

  module shape(){
    difference(){
      hull() for (ix=[-1,1], iy=[-1,1])
        translate([ix*(dims.x/2-radius),iy*(dims.y/2-radius)])
          circle(r=radius);//cube

      if (drillDia) for (ix=[-1,1],iy=[-1,1]) //drill holes
          translate([ix*(dims.x/2-radius),iy*(dims.y/2-radius)]) 
            circle(d=drillDia);
    }
  }
}

// a lathe tool that accepts diameters and offsets [[h,d1,d2],[h,d],..]
module lathe(dimensions=[],zOffset=0,iter=0){
 
  d1= dimensions[iter][1];
  d2= dimensions[iter][2];
  h= dimensions[iter][0];

  // if one diameter make cylinder else make cone
  if (dimensions[iter][2]==undef)
    translate([0,0,zOffset]) cylinder(d=d1,h=h);
  else
    translate([0,0,zOffset]) cylinder(d1=d1,d2=d2,h=h);
  
  //cumulate offset and process next section
  if (iter<len(dimensions)-1) lathe(dimensions,zOffset+h,iter+1);
  else echo(str("[Lathe] Total Length: ",zOffset+h));
}
