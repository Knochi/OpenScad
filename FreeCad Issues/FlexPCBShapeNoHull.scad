$fn=50;
flxRad=0.25; //edge rad of Flex
flxPnlDims=[5.3,0.9]; //Dimensions of Flex on Panel
flxTapDims=[9,6];
flxThck=0.15;
//Length of Flex from panel to tap
flxLen=11;
//holes in the flex
flxHoleDist=6.2;
flxHoleDia=0.8;
//offset from bottom
flxHoleBtmOffset=6;

linear_extrude(flxThck)
 difference(){
    flexContour(); 
    for (ix=[-1,1])
      translate([ix*flxHoleDist/2,flxHoleBtmOffset-flxLen]) circle(d=flxHoleDia);
  }
  
module flexContour(){
     //tap
      translate([0,-flxLen+flxTapDims.y/2]) offset(flxRad) square([flxTapDims.x-flxRad*2,flxTapDims.y-flxRad*2],true);
      //main
      translate([0,-(flxLen-flxPnlDims.y)/2]) offset(flxRad) square([flxPnlDims.x-flxRad*2,flxLen+flxPnlDims.y-flxRad*2],true);
      
      //45° transistion between tap an main flex
      poly=[[-(flxPnlDims.x/2-flxRad),((flxLen+flxPnlDims.y)/2-flxRad)-flxLen+(flxTapDims.x-flxPnlDims.x)/2],
            [(flxPnlDims.x/2-flxRad),((flxLen+flxPnlDims.y)/2-flxRad)-flxLen+(flxTapDims.x-flxPnlDims.x)/2],
            [(flxTapDims.x/2-flxRad),(flxTapDims.y/2-flxRad)-flxLen+flxTapDims.y/2],
            [-(flxTapDims.x/2-flxRad),(flxTapDims.y/2-flxRad)-flxLen+flxTapDims.y/2]
          ];
      offset(flxRad) polygon(poly);
}

