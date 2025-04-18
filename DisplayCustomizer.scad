$fn=50;

TP_TOX32();
module TP_TOX32(){
  //https://tailorpixels.com/de/PRODUKTE/0-32-Zoll-oled-60x32-wei%C3%9F-i2c-ssd1315/
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
  
  pitch=0.62;
  padDim=[2,0.32,0.01];
  pads=14;
  
  
//Panel
translate(panel2CenterOffset){
  //Active Area
  color("SlateGrey") translate([0,(panelDims.y-AADims.y)/2,0]+AA2PanelOffset) cube(AADims,true);
  //Polarizer
  color("grey",0.5)
    translate([0,(panelDims.y-polDims.y)/2,0]+pol2PanelOffset) cube(polDims,true);
  //topGlass
  color("lightgrey",0.5) 
    translate([0,0,glassThck/2]) cube([panelDims.x,panelDims.y,glassThck],true);
  //btmGlass
  color("lightgrey",0.5)
    translate([0,(panelDims.y-botGlassDims.y)/2,0]+bot2PanelOffset) cube(botGlassDims,true);
  //chip
  color("darkSlateGrey")
    translate([0,(panelDims.y-chipDims.y)/2,0]+chip2PanelOffset) cube(chipDims,true);
}
  //flex();
  translate([0,-panelDims.y/2,-flxThck]+panel2CenterOffset) flex();
  module flex(){
    
    linear_extrude(flxThck) difference(){
      union(){
        //tap
        hull(){
          for (ix=[-1,1],iy=[-1,1])
            translate([ix*(flxTapDims.x/2-flxRad),iy*(flxTapDims.y/2-flxRad)-flxLen+flxTapDims.y/2]) circle(flxRad);
        }
        //main
        hull(){
          for (ix=[-1,1],iy=[-1,1])
            translate([ix*(flxPnlDims.x/2-flxRad),iy*((flxLen+flxPnlDims.y)/2-flxRad)-(flxLen-flxPnlDims.y)/2]) 
              circle(flxRad);
        }
        //45° transistion between tap an main flex
        hull(){
         for (ix=[-1,1])
            translate([ix*(flxPnlDims.x/2-flxRad),((flxLen+flxPnlDims.y)/2-flxRad)-flxLen+(flxTapDims.x-flxPnlDims.x)/2]) 
              circle(flxRad);
          for (ix=[-1,1])
            translate([ix*(flxTapDims.x/2-flxRad),(flxTapDims.y/2-flxRad)-flxLen+flxTapDims.y/2]) circle(flxRad);
          }
        }
      
      for (ix=[-1,1])
        translate([ix*flxHoleDist/2,flxHoleBtmOffset-flxLen]) circle(d=flxHoleDia);
    }
  }
}