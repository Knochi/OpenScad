/* Layer Test*/

/* [Import] */
fileName="default.stl"; //file
//1. this will be applied before other transformations
stlCntrOffset=[-117,-127,-100];
//2. scale
stlScale=1; //[0.1:0.05:1]
//3. rotate around new center
stlRotate=[0,0,-90];
//4. translate again
stlTranslate=[0,0,100];

/* [Dimensions] */
//bounding box of sculpture
maxSize=[120,100,100];

/* [Layers] */
layerWdth=2.8;
layerGapWdth=3.2;
layerOffset=-0.8;

/* [Show] */
showVolume=false;
showOriginal=false;

/* [Hidden] */
layersCount=maxSize.x/(layerWdth*2);
layerPitch=layerWdth+layerGapWdth;
fudge=0.1;

if (showVolume)
  translate([-maxSize.x/2,-maxSize.y,0]) cube(maxSize);

if (showOriginal)
  translate(stlTranslate) rotate(stlRotate) scale(stlScale) translate(stlCntrOffset) import(fileName,convexity=5);
else
  intersection(){
    translate(stlTranslate) rotate(stlRotate) scale(stlScale) translate(stlCntrOffset) import(fileName,convexity=5);
    translate([-maxSize.x/2,-maxSize.y,0]) cube(maxSize);
    for (ix=[-(layersCount/2)-1:(layersCount/2)-1])
      translate([ix*(layerPitch)+layerOffset-layerWdth/2,-maxSize.y,0]) 
        cube([layerWdth,maxSize.y+fudge,maxSize.z+fudge]);
    }