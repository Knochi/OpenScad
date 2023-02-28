/* [Dimensions] */
areaSize=[140,140];
patchSize=[20,20];
//printed line thickness
lineWidth=0.4;
//minimum line count
minLines=8;
patchThick=0.2;

//gap sizes
gaps=[0.1,0.2,0.3];
conWidth=2;
centerHole=4;

/* [Options] */
patchCrnrs=true;
patchCntr=true;
patchScrw=false;
//connect patches with lines
patchCon=false; 
//use round patches
patchRound=true;
patchGaps=true;
screwPos=[[23,63],[114,63],[95,136]];
/* [Hidden] */
$fn=50;
minWdth=lineWidth*minLines;

if (patchCrnrs)
 linear_extrude(patchThick) 
  for (ir=[0:90:270])
    rotate(ir) translate([(areaSize.x-patchSize.x)/2,(areaSize.y-patchSize.y)/2]) patch(true);
if (patchCntr)
  linear_extrude(patchThick) patch(false);
if (patchScrw)
  linear_extrude(patchThick)
  for (pos=screwPos)
    translate(pos-areaSize/2) square(patchSize,true);
  
module patch(crnrPatch=true){
  if (patchRound)
    difference(){
      union(){
        circle(d=patchSize.x);
        if (crnrPatch) square(patchSize/2);
      }
      if (patchGaps) 
        for (i=[0:len(gaps)-1])
          hollowCircle(d=i*minWdth+minWdth+centerHole,lineWdth=gaps[i]);
        circle(d=centerHole);
    }
  else
    square(patchSize,true);
}

*hollowCircle();
module hollowCircle(d=10,lineWdth=0.2){
  difference(){
    circle(d=d+lineWdth);
    circle(d=d-lineWdth);
  }
}