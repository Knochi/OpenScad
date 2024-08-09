    $fn=20;
    
    baseDims=[30,31,1.7];
    rad=1.5;
    baseThck=1.7;
    baseZOffset=1.6;
    fudge=0.1;
    
    //base
    translate([0,0,baseZOffset]) linear_extrude(baseThck) 
      //difference(){
        hull() for (ix=[-1,1], iy=[-1,1])
          translate([ix*(baseDims.x/2-rad),iy*(baseDims.y/2-rad)]) circle(rad);
        //square([baseDims.x+fudge,opnWdth],true);
      //}