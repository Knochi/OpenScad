$fn=50;
include <eCAD/KiCADColors.scad>

TP_TOX32();
module TP_TOX32(){
  
  glassThck=0.5;
  
  //Flex
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
  
  //Panel
  panelDims=[9.96,8.85,1.0];
  polDims=[9.36,6,0.05];
  botGlassDims=[panelDims.x,6.27,glassThck];
  chipDims=[5.2,0.7,0.3];
  
  //Active Area
  AADims=[7.06,3.82,0.01]; //active Area
  
  //panel offsets from top left corner
  pol2PanelOffset=[0,-0.2,glassThck+polDims.z/2];
  AA2PanelOffset=[0,-1.2,AADims.z/2];
  bot2PanelOffset=[0,0,-glassThck/2];
  chip2PanelOffset=[0,-6.8,-chipDims.z/2];
  //
  panel2CenterOffset=[0,-panelDims.y/2+1.2+AADims.y/2,0];
  
  padPitch=0.62;
  padDims=[0.32,1.8,0.01];
  padCnt=14;
  
  
//Panel
translate(panel2CenterOffset){
  //Active Area
  *color(darkGreyBodyCol) translate([0,(panelDims.y-AADims.y)/2,0]+AA2PanelOffset) cube(AADims,true);
  //Polarizer
  *color(glassBlueCol)
    translate([0,(panelDims.y-polDims.y)/2,0]+pol2PanelOffset) cube(polDims,true);
  //topGlass
  color(glassGreyCol) 
    translate([0,0,glassThck/2+AADims.z]) cube([panelDims.x,panelDims.y,glassThck-AADims.z],true);

  //btmGlass
  color(glassGreyCol)
    translate([0,(panelDims.y-botGlassDims.y)/2,0]+bot2PanelOffset) cube(botGlassDims,true);
  //chip
  color(blackBodyCol)
    translate([0,(panelDims.y-chipDims.y)/2,0]+chip2PanelOffset) cube(chipDims,true);
}
  //flex();
  translate([0,-panelDims.y/2,-flxThck]+panel2CenterOffset) flex();

  module flex(){
    //top
    color(glassOrangeCol) translate([0,0,flxThck-padDims.z]) linear_extrude(padDims.z) difference(){
      flexShape();
      translate([0,-flxLen+padDims.y/2]) square([flxTapDims.x,padDims.y],true);
    }
    //core
    color(FR4Col) translate([0,0,padDims.z]) linear_extrude(flxThck-padDims.z*2) flexShape();
    //bottom
    color(glassOrangeCol) linear_extrude(padDims.z) difference(){
      flexShape();
      translate([0,-flxLen+padDims.y/2]) square([flxTapDims.x,padDims.y],true);
    }
    
    //pads
    color(metalGoldPinCol) for (i=[-(padCnt-1)/2:(padCnt-1)/2],iz=[0,1])
      translate([0,0,iz*(flxThck-padDims.z)]) linear_extrude(padDims.z) 
        translate([i*padPitch,-flxLen+padDims.y/2]) square([padDims.x,padDims.y],true);
    
  module flexShape(){
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
  }
}
}

*snakeBend();
module snakeBend(size=[0.1,5.3],length=2,stepHeight=0.35){
  //bend rectangular crossection to change height
  t=stepHeight;
  l=length;
  r=(pow(l,2)+pow(t,2))/(4*t);
  dy=r-t/2;
  ang=asin((l/2)/r);
  lfn=110;
  echo(dy,r,ang);
  
  rotate([0,90,0]) translate([-dy-stepHeight/2,0,-size.y/2]){ 
    rotate_extrude(angle=ang) 
      translate([r-size.x/2,0]) square(size);
    translate([dy*2,0.70,0]) rotate(180) rotate_extrude(angle=ang,$fn=lfn) 
      translate([r-size.x/2,0]) square(size);
  }
  //translate([0,l]) rotate(180) translate([-dy-size.x/2,0])  
}
