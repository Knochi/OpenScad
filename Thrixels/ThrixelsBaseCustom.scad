/* [BaseDimensions] */
frameWdth=4;
frameHght=4;
frameCornerRad=2;
thxCountX=16;
thxCountY=16;

/* [show] */
showOriginal=false;
showFrame=true;
showField=true;

/* [ThrixelGeometry] */
thxCellSize=[4,4,3.5];
thxHoleDia=2.5;
thxBaseThck=0.5;
thxConHght=2.5;
//body channels dimensions
thxBdyChnlDims=[1.2,0.55];
//top channels dimensions
thxTopChnlDims=[1.7,0.605];
//slope on the corners
thxTopChnlSlpAng=125;
thxTopHght=0.5;
thxWallThck=0.15;
thxTopChnlBase=0.042;

$fn=50;

/* [Hidden] */
//center distance to outer wall
bChnDpth=thxCellSize.x/2-thxWallThck;
//center distance to corner of chamfer
bChnChmf=thxCellSize.x/2-thxWallThck-thxBdyChnlDims.y;
//half width of channel
bChnWdth=thxBdyChnlDims.x/2;
fieldDims=[thxCellSize.x*thxCountX,thxCellSize.y*thxCountY];


//cross sectioned channel shape
thxBdyChnlPoly=[
               [-bChnWdth,-bChnChmf],[-bChnWdth,-bChnDpth], //front
               [bChnWdth,-bChnDpth],[bChnWdth,-bChnChmf],
               [bChnChmf,-bChnWdth],[bChnDpth,-bChnWdth], //right
               [bChnDpth,bChnWdth],[bChnChmf,bChnWdth], 
               [bChnWdth,bChnChmf],[bChnWdth,bChnDpth], //back
               [-bChnWdth,bChnDpth],[-bChnWdth,bChnChmf],
               [-bChnChmf,bChnWdth],[-bChnDpth,bChnWdth], //left
               [-bChnDpth,-bChnWdth],[-bChnChmf,-bChnWdth],
                ];
                
//irregular octagon on top
tChnChmf=thxCellSize.x/2-thxTopChnlDims.y;
tChnWdth=thxTopChnlDims.x/2;

thxTopChnlPoly=[[-tChnWdth,-tChnChmf],[tChnWdth,-tChnChmf], //front
                [tChnChmf,-tChnWdth],[tChnChmf,tChnWdth], //right
                [tChnWdth,tChnChmf],[-tChnWdth,tChnChmf], //back
                [-tChnChmf,tChnWdth],[-tChnChmf,-tChnWdth], // left
               ];

               
// ASSEMBLY
if (showField)
  for (ix=[0:thxCountX-1],iy=[0:thxCountY-1])
    translate([ix*thxCellSize.x+thxCellSize.x/2,iy*thxCellSize.y+thxCellSize.y/2,0]) cell();
  
if (showFrame)
  linear_extrude(frameHght) difference(){
    offset(frameCornerRad) 
      translate([-frameWdth+frameCornerRad,-frameWdth+frameCornerRad,0])
        square([fieldDims.x+(frameWdth-frameCornerRad)*2,fieldDims.y+(frameWdth-frameCornerRad)*2]);
      square(fieldDims);
  }
               
//cut out one 4x4mm thrixelcells
if (showOriginal){
  
    %import("Thrixels v1.0 STL - 16x16 base.stl",convexity=5);
  
}


//remodel the thrixelcell
module cell(){
  //base
  linear_extrude(thxBaseThck) difference(){
    square([thxCellSize.x,thxCellSize.y],true);
    circle(d=thxHoleDia);
  }
  //body channel
  translate([0,0,thxBaseThck]) 
    linear_extrude(thxConHght) difference(){
      square([thxCellSize.x,thxCellSize.y],true);
      /*
      square([thxCellSize.x-thxWallThck*2,thxBdyChnlDims.x],true);
      square([thxBdyChnlDims.x,thxCellSize.x-thxWallThck*2],true);
      */
      polygon(thxBdyChnlPoly);
    }
  //corners
  for (r=[0:90:270])
    rotate(r)
      translate([-thxCellSize.x/2,-thxCellSize.y/2,thxBaseThck+thxConHght]) 
        corner();
  
  
  module corner(){
    crnrSize=(thxCellSize.x-thxTopChnlDims.x)/2;
    translate([crnrSize/2,crnrSize/2,0])
    difference(){
     linear_extrude(thxTopHght)
            square(crnrSize,true);
        
     translate([0,0,thxTopHght]) rotate([45,0,135])
        linear_extrude(thxTopHght*2)
          square(crnrSize*2,true);
    }
  }
}