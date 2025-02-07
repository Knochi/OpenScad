/* Streak Counter */

/* [Dimensions] */
crnrRad=3;
bdyDims=[150,70,3];
minWallThck=2;


body();
color("darkBlue") translate([0,0,1]) ratchedMechanism();
/* [Hidden] */
scale2Wdth=0.8;

module body(){
  linear_extrude(1) rndRect([bdyDims.x,bdyDims.y],crnrRad);
}

module ratchedMechanism(){
  
  slotWdth=3;
  ratchedThck=1;
  teethLen=3;
  
  linear_extrude(ratchedThck) 
    translate([0,-bdyDims.y/4+minWallThck,0]) difference(){
      rndRect([bdyDims.x-minWallThck*2,bdyDims.y/2],crnrRad);
    hull() for (ix=[-1,1])
      translate([ix*(bdyDims.x/2*scale2Wdth),0]) circle(d=10);
    }
  
}

echo(rack());
!polygon(rack());
function rack(toothSize=[2,2],count=10,poly=[],iter=0)=
  let(
    x0 = iter*toothSize.x
  ) (iter<count) ? rack(toothSize, 
                         count, 
                         concat(poly,[[x0,0],[x0+toothSize.x,toothSize.y],[x0+toothSize.x,0]]),iter+1) 
                         : poly;


module rndRect(size=[10,10],rad=3){
  offset(rad) square([size.x-rad*2,size.y-rad*2],true);
}
