ovDims=[70.4,42.5,30];
rad=3;

poly=[[0,ovDims.y],[4.7,ovDims.y],[5,16.7],[5+7.2,16.7],[5+7.2,12.3],[12.2+45.7,12.3],[12.2+45.7,16.25],[ovDims.x,16.25],[ovDims.x,ovDims.y]];

difference(){
  translate([ovDims.x/2,(ovDims.y)/2+rad]) 
    hull() 
      for (ix=[-1,1],iy=[-1,1]) 
        translate([ix*(ovDims.x/2-rad),iy*ovDims.y/2]) circle(rad);
  polygon(poly);    
 }