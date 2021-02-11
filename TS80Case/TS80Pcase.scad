$fn=20;

/* -- [Dimensions] -- */
ovDims=[170,60,20];
magnetHght=2;
magnetDia=4;
minWallThck=2;
mainCompDims=[104,30];
cleanCompDia=50;
cleanCompOpening=40;
//array of distances and diameters
TS80Tip=[[14,3.5],[2.9,5],[23.5,8.4],
         [2.8,10.6],[14.6,10.6,6.6],
         [14.2,2.8],[1,2.8,3.8],[12.2,3.8],
         [0.5,3.8,4.9],[6,4.9],[1.2,4],
         [7.2,4,0.2]];

/* -- [show] -- */
showOrig=true;
showRemix=true;
showTS80P=true;
showTip=true;
showCentered=false;

/* [Hidden] */
compDims=[mainCompDims.x,mainCompDims.y,ovDims.z-minWallThck];
fudge=0.1;

if (showOrig) translate([0,ovDims.y,0]) rotate([90,0,0]) import("ts80_case_main.stl");
if (showTS80P) translate([160,ovDims.y-12.5,4+13/2]) rotate([0,-90,0]) TS80P();
if (showTip) translate([161,32.7,4+13/2]) rotate([0,-90,0]) color("silver") lathe(TS80Tip);
if (showRemix) mainCase(showCentered);
  
module mainCase(center=false){
  crnRad=8;
  chamfer=2;
  rMag=crnRad-minWallThck-magnetDia/2;
  magCoord=[rMag*cos(45),rMag*sin(45)];
  mainHght=ovDims.z;
  //Offset of main compartment from center
  mainCompOffset=[(ovDims.x-compDims.x)/2-minWallThck,
                  (ovDims.y-compDims.y)/2-minWallThck,
                   -mainHght/2+minWallThck];
  
  solderCompDims=[compDims.x,ovDims.y-compDims.y-minWallThck*3,compDims.z];
  solderCompOffset=[(ovDims.x-compDims.x)/2-minWallThck,
                  (-ovDims.y+solderCompDims.y)/2+minWallThck,
                   -mainHght/2+minWallThck];
  cntrOffset= center ? [0,0,0]: ovDims/2;
 
  translate(cntrOffset) difference(){
    body();
    magnets();
    translate(mainCompOffset) 
      compartment(compDims,crnRad-minWallThck);
    translate(solderCompOffset)
      compartment(solderCompDims,crnRad-minWallThck);
  }
  
  cleanComp();
  
  module body(){
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(ovDims.x/2-crnRad),iy*(ovDims.y/2-crnRad),-mainHght/2]){ 
        translate([0,0,chamfer]) cylinder(r=crnRad,h=mainHght-chamfer);
        cylinder(r1=crnRad-chamfer,r2=crnRad,h=chamfer);
      }
  }
  
  module magnets(){
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*(ovDims.x/2+magCoord.x-crnRad),
                 iy*(ovDims.y/2-crnRad+magCoord.y),
                 mainHght/2-magnetHght]) 
        cylinder(d=magnetDia,h=magnetHght+fudge);
    }
  //main compartment  
  
  module compartment(size=[100,20,40],radius=3,roundTop=false){  
    x= roundTop ? 2 : 1;
        hull() for (ix=[-1,1],iy=[-1,1]){
          translate([ix*(size.x/2-radius),iy*(size.y/2-radius),0]){ 
            translate([0,0,radius]) cylinder(r=radius,h=size.z-radius*x+fudge);
            translate([0,0,radius]) sphere(radius);
            if (roundTop) translate([0,0,size.z-radius]) sphere(radius);
          }
     }
  }
  
  module cleanComp(dia=cleanCompDia,hght=10,radius=3){
    for (iz=[0,1])
      rotate_extrude() translate([cleanCompDia/2-radius,radius+iz*(hght-radius*2)]) circle(r=radius);
    
    translate([0,0,radius]) cylinder(d=dia,h=hght-radius*2);
    cylinder(d=dia-radius*2,h=hght);
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
*fluxer();
module fluxer(){
  //stannol mini-fluxer 10ml
  dims=[[2.5,13.1],[109.3,15.6],[3.5,16.8],[4,15.6,11.7],[21.7,11.7,11.3]];
  lathe(dims);
}

module lathe(dimensions=[],zOffset=0,iter=0){
 
  d= dimensions[iter][1];
  d1= dimensions[iter][1];
  d2= dimensions[iter][2];
  h= dimensions[iter][0];

  // if one diameter make cylinder else make cone
  if (dimensions[iter][2]==undef)
  translate([0,0,zOffset]) cylinder(d=d,h=h);
  else
  translate([0,0,zOffset]) cylinder(d1=d1,d2=d2,h=h);
  
  if (iter<len(dimensions)-1) lathe(dimensions,zOffset+h,iter+1);
  else echo(str("[Lathe] Total Length: ",zOffset+h));
}
