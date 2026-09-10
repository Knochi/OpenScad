/* [Printing] */
//layer height
layerHght=0.2;
//how many layers above magnets
minTopLayers=2;
//how many layers below magnets
minBotLayers=2;

/* [Magnets] */
magShape="disc"; //["disc","block"]
magDiscDia=10;
magBlckXYDims=[4,8];
magThck=2;
magCount=[2,3];
magPitch=[12,12];
//lateral spacing for magnets
magLatSpcng=0.1;
//z-spacing for magnets
magZSpcng=0.1;

/* [Body] */
bdySizeMethod="fromMagnets"; //["fromMagnets" : "calculate minimal size","custom size"]
bdyEdgeStyle="sharp"; //["sharp", "chamfer", "round"]
//size of chamfer or rounding (limited)
bdyEdgeSize=2;
bdyBrmWdth=3;
bdyCstmDims=[20,20,5];
bdyRad=3;

/* [Colors] */
bdyCol="#DDDDDD"; //color
magCol="#888888"; //color

/* [show] */
showBody=true;
showMagnets=true;
showXRay=true;

quality=20; //[20:4:100]

/* [Hidden] */
$fn=quality;
fudge=0.1;

magDims= magShape=="disc" ? [magDiscDia,magDiscDia,magThck] : [magBlckXYDims.x,magBlckXYDims.y,magThck];
bdyDims= bdySizeMethod=="fromMagnets" ? 
  [(magCount.x-1)*magPitch.x+magDims.x+bdyBrmWdth*2,
   (magCount.y-1)*magPitch.y+magDims.y+bdyBrmWdth*2,
   magThck+layerHght*(minTopLayers+minBotLayers)+magZSpcng*2] :
  bdyCstmDims;

//-- ASY --

 
if (showBody)  
  if (showXRay) 
    %difference(){  
      body();  
      magnets(true);
    }
  else 
    color(bdyCol) difference(){  
      body();  
      magnets(true);
    }
   
if (showMagnets)
  color(magCol) magnets(false);

  
// -- Modules --  
module body(){
  hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(bdyDims.x/2-bdyRad),iy*(bdyDims.y/2-bdyRad)]) corner();;
  
  module corner(){
    
    edgeSize= min(bdyEdgeSize,bdyDims.z,bdyRad);
    if (bdyEdgeStyle=="sharp")
      cylinder(r=bdyRad,h=bdyDims.z);
    else {
      cylinder(r=bdyRad,h=bdyDims.z-edgeSize);
      cylinder(r=bdyRad-edgeSize,h=bdyDims.z);
    }
    if (bdyEdgeStyle=="round")
      translate([0,0,bdyDims.z-edgeSize]) rotate_extrude() 
        translate([bdyRad-edgeSize,0]) intersection(){
          circle(edgeSize);
          square(edgeSize);
        }
  }
}

module magnets(cut=true){
  spcng= cut ? [magLatSpcng,magLatSpcng,magZSpcng] : [0,0,0];
  zOffset= cut ? 0 : magZSpcng;
  fdg= cut && !(minTopLayers && minBotLayers) ? fudge : 0;
  thisMagThck=magThck+spcng.z*2+fdg;
  
  echo("fdg",fdg);
  translate([0,0,thisMagThck/2+layerHght*minBotLayers-fdg+zOffset]) linear_extrude(thisMagThck,center=true)
    for (ix=[-(magCount.x-1)/2:(magCount.x-1)/2],iy=[-(magCount.y-1)/2:(magCount.y-1)/2])
      translate([ix*magPitch.x,iy*magPitch.y]){
        if (magShape=="disc") circle(d=magDiscDia+spcng.x*2);
        else square(magBlckXYDims+[spcng.x,spcng.x],true);
    }
    
}
