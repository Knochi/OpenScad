// Loosing your USB Dongle, because it's so tiny? 
// Here's the answer!

/* [Cap] */
capDims=[14.35,6.75,6.15];
capRad=0.3;
capRecessWdth=1;
capRecessDpth=0.5;
capTxt="KNOCHI";
capFont="Arial:style=Bold";
capTxtSize=2.2;
capTxtDpth=0.4;
capTxtThck=0.0; 

/* [Magnet] */
magnetDia=5;
magnetThck=1;
magnetSpcng=0.1;

/* [General] */
//spacing for the dongle
dongleSpcng=0.2;
//spacing for fitting parts into each other
glueSpcng=0.15;
minWallThck=0.8;

/* [show] */
showCap=true;
showSheet=true;
showContacts=true;
showPlastics=true;
showText=true;
showOriginal=true;

$fn=50;

/*[Hidden]*/
//usb.org
//https://www.usb.org/sites/default/files/CCWG_A_Plug_Form_Factor_Guideline_Revision_1.0_.pdf
usbPlugDims=[12,12,4.5];
usbPlugSheetThck=0.15;
usbPlugSheetRad=0.64;
usbPlugHoleDims=[2.5,2];
usbPlugHolesYOffset=3.5+usbPlugHoleDims.y/2;
usbPlugHolesDist=5.16+usbPlugHoleDims.x;
usbPlugUpperSpacing=1.95;
usbPlugDepth=8.65;

fudge=0.1;

donglePos=[0,+9.0,+4.0];

dongleScale=3.5;

grabDia=12;
grabWidth=1;
grabZOffset=3;

intersection(){
  difference(){
    scale(dongleScale){
     usbDongle();
    }
    translate(donglePos+[0,0,-dongleSpcng]){
      //cap
      linear_extrude(capDims.y+dongleSpcng+fudge) 
        offset(dongleSpcng) square([capDims.x,capDims.z],true);
      //grab sphere
      for (iy=[-1,1]) translate([0,iy*grabWidth,capDims.y+grabZOffset]) sphere(d=12);
      //plug
      translate([0,0,-usbPlugDims.y]) 
        linear_extrude(usbPlugDims.y+dongleSpcng+fudge) 
          offset(dongleSpcng) USB_A_plug(true);
      //magnet cavity
      translate([0,0,-usbPlugDims.y-magnetThck-magnetSpcng*2]) 
        linear_extrude(magnetThck+magnetSpcng*2+fudge){
          circle(d=magnetDia+magnetSpcng*2);
          translate([0,-capDims.y/4*dongleScale]) square([magnetDia+magnetSpcng*2,capDims.y/2*dongleScale],true);
        }
    }
  }
  color("darkRed") translate([0,4,2.5-capDims.z/2*dongleScale-fudge]) cube([capDims.x*1.2,capDims.y*dongleScale,5],true);
}

if (showOriginal) translate(donglePos) rotate([90,0,0]) 
  usbDongle(scale=1);

    
module usbDongle(scale=dongleScale){
  USB_A_plug(scale=scale);
  cap(scale=scale);
}

module cap(size=capDims,rad=capRad,scale=1){

  if (showCap)
    color("red") difference(){
      body();
      capTxt(true);
    }
  if (showText)
    color("black") capTxt();
  
  //cap with a recess
  module body(){
    translate([0,size.y/2,0]) difference(){
      //body
      hull() for (ix=[-1,1], iy=[-1,1], iz=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad),iz*(size.z/2-rad)]) sphere(rad);
      //recess
      translate([0,size.y/2-1.5,0]) rotate([90,0,0]) 
        linear_extrude(capRecessWdth,center=true,convexity=3) 
          difference(){
            square([size.x+fudge,size.z+fudge],true);
            offset(capRad-capRecessDpth) square([size.x-capRad*2,size.z-capRad*2],true);
          }
      //cutout for plug
      translate([0,-size.y/2,0]) rotate([-90,0,0]) linear_extrude(1) offset(glueSpcng/dongleScale) USB_A_plug(true,scale=1);
    }
  }
  //text
  module capTxt(cut=false){
    height= cut ? capTxtDpth+fudge : capTxtDpth+capTxtThck;
    translate([0,capDims.y-capTxtDpth,0]) rotate([90,0,180]) 
      linear_extrude(capTxtDpth+capTxtThck, convexity=3)
        text(capTxt,capTxtSize,font=capFont, valign="center",halign="center");
  }
}



module USB_A_plug(cut=false, scale=1){
  //limit the sheet thickness to minWallThck 
  //consider only for spacings and sheet thickness, not for positioning!
  sheetThck = max(usbPlugSheetThck/scale,minWallThck/scale);
  if (cut)
    offset(usbPlugSheetRad) 
          square([(usbPlugDims.x-usbPlugSheetRad*2),(usbPlugDims.z-usbPlugSheetRad*2)],true);
  else {
    if (showPlastics)
    color("darkSlateGrey") difference(){
      plastic();
      pins(true);
    }
    if (showContacts)
      color("gold") pins();
    if (showSheet)
      color("silver") sheet();
  }
  //calculate the height of the cutout with the regulat sheetThck
  plasticZOffset=usbPlugDims.z/2-usbPlugSheetThck-usbPlugUpperSpacing;
  
  module sheet(){
    translate([0,1,0]) difference(){
      rotate([90,0,0]) linear_extrude(usbPlugDims.y+1,convexity=4) difference(){
        offset(usbPlugSheetRad) 
          square([usbPlugDims.x-usbPlugSheetRad*2,usbPlugDims.z-usbPlugSheetRad*2],true);
        offset(usbPlugSheetRad - sheetThck) 
          square([usbPlugDims.x-usbPlugSheetRad*2,usbPlugDims.z-usbPlugSheetRad*2],true);
      }
      for (ix=[-1,1])
        translate([ix*usbPlugHolesDist/2,-usbPlugDims.y+usbPlugHolesYOffset-1,0]) 
          linear_extrude(usbPlugDims.z+fudge,center=true) square(usbPlugHoleDims,true);
    }
  }
  *plastic();
  module plastic(){
    difference(){ 
      //body
      rotate([90,0,0]) 
        translate([0,0,-1]) linear_extrude(usbPlugDims.y+1,convexity=4)
          offset(usbPlugSheetRad-sheetThck-glueSpcng/scale) 
            square([usbPlugDims.x-usbPlugSheetRad*2,usbPlugDims.z-usbPlugSheetRad*2],true);
      //wedge      
      translate([0,-usbPlugDims.y,plasticZOffset]){ 
        rotate([90,0,90]) linear_extrude(usbPlugDims.x,center=true) 
          polygon([[-0.1,0.1],[-0.1,-0.38],[0.1+(0.38+0.1)/tan(30),0.1]]);
      //cutout (calculate with regular sheetThck)
      translate([0,-fudge,0]) rotate([-90,0,0]) 
        linear_extrude(usbPlugDepth+fudge) 
          translate([0,-(usbPlugDims.z-usbPlugUpperSpacing)/2+usbPlugSheetThck*2-fudge/2]) 
            square([usbPlugDims.x-usbPlugSheetThck*2+fudge,usbPlugUpperSpacing+fudge],true);
      }
    }
  }
    
  //pins
  module pins(cut=false){
    shortPin=6.41;
    longPin=7.41;
    pinThck=0.2;
    plating=cut ? 0.1+fudge :0.05;
    
    for (ix=[-1,1]){
      translate([ix*1,-usbPlugDims.y+usbPlugDepth-shortPin/2,plasticZOffset-pinThck]) 
        linear_extrude(plating+pinThck) square([1,shortPin],true);
      translate([ix*3.5,-usbPlugDims.y+usbPlugDepth-longPin/2,plasticZOffset-pinThck]) 
        linear_extrude(plating+pinThck) square([1,longPin],true);
    }
    
  }
}