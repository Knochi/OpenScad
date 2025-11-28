// Loosing your USB Dongle, because it's so tiny? 
// Here's the answer!

capDims=[14.35,6.75,6.15];
capRad=0.3;
capRecessWdth=1;
capRecessDpth=0.5;
capTxt="KNOCHI";
capFont="Arial:style=Bold";
capTxtSize=2.2;
capTxtDpth=0.4;
capTxtThck=0.0;

magnetDia=5;
magnetThck=1;
magnetSpcng=0.2;

/* [show] */
showCap=true;
showSheet=true;
showContacts=true;
showPlastics=true;
showText=true;

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
dongleSpcng=0.2;

intersection(){
  difference(){
    scale(3.5){
     usbDongle();
    }
    translate(donglePos+[0,0,-dongleSpcng]){
      //cap
      linear_extrude(capDims.y+dongleSpcng+fudge) 
        offset(dongleSpcng) square([capDims.x,capDims.z],true);
      //grab sphere
      translate([0,0,capDims.y]) sphere(d=11);
      //plug
      translate([0,0,-usbPlugDims.y]) 
        linear_extrude(usbPlugDims.y+dongleSpcng+fudge) 
          offset(dongleSpcng) USB_A_plug(true);
      //magnet
      translate([0,usbPlugDims.z/2+dongleSpcng-fudge,-usbPlugDims.y/2]) 
        rotate([-90,0,0]) linear_extrude(magnetThck+magnetSpcng+fudge) 
          circle(d=magnetDia+magnetSpcng*2);
    }
  }
  *color("darkRed") translate([donglePos.x,donglePos.y,-50]) cube([100,100,100]);
}

*translate(donglePos) rotate([90,0,0]) 
  usbDongle();

    
module usbDongle(){
  USB_A_plug();
  cap();
}

module cap(size=capDims,rad=capRad){

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


module USB_A_plug(cut=false){
  if (cut)
    offset(usbPlugSheetRad) 
          square([usbPlugDims.x-usbPlugSheetRad*2,usbPlugDims.z-usbPlugSheetRad*2],true);
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
  
  
  plasticOffset=usbPlugDims.z/2-usbPlugSheetThck-usbPlugUpperSpacing;
  module sheet(){
    difference(){
      rotate([90,0,0]) linear_extrude(usbPlugDims.y,convexity=4) difference(){
        offset(usbPlugSheetRad) 
          square([usbPlugDims.x-usbPlugSheetRad*2,usbPlugDims.z-usbPlugSheetRad*2],true);
        offset(usbPlugSheetRad-usbPlugSheetThck) 
          square([usbPlugDims.x-usbPlugSheetRad*2,usbPlugDims.z-usbPlugSheetRad*2],true);
      }
      for (ix=[-1,1])
        translate([ix*usbPlugHolesDist/2,-usbPlugDims.y+usbPlugHolesYOffset,0]) 
          linear_extrude(usbPlugDims.z+fudge,center=true) square(usbPlugHoleDims,true);
    }
  }
  module plastic(){
    difference(){ 
      rotate([90,0,0]) 
        linear_extrude(usbPlugDims.y,convexity=4)
          offset(usbPlugSheetRad-usbPlugSheetThck) 
            square([usbPlugDims.x-usbPlugSheetRad*2,usbPlugDims.z-usbPlugSheetRad*2],true);
      translate([0,-usbPlugDims.y,plasticOffset]){ 
        rotate([90,0,90]) linear_extrude(usbPlugDims.x,center=true) 
          polygon([[-0.1,0.1],[-0.1,-0.38],[0.1+(0.38+0.1)/tan(30),0.1]]);
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
      translate([ix*1,-usbPlugDims.y+usbPlugDepth-shortPin/2,plasticOffset-pinThck]) 
        linear_extrude(plating+pinThck) square([1,shortPin],true);
      translate([ix*3.5,-usbPlugDims.y+usbPlugDepth-longPin/2,plasticOffset-pinThck]) 
        linear_extrude(plating+pinThck) square([1,longPin],true);
    }
    
  }
}