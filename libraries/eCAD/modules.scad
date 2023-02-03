 $fn=20;

 use <MPEGarry.scad>
 include <KiCADColors.scad>

cameraBoard();
module cameraBoard(type="OV5640"){
  // Waveshare OV5640(A,B,C), OV2640 and OV9655 camera boards
  // OV9655 & OV2640 has no holes and sharp corners
  //
  // https://www.waveshare.com/ov5640-camera-board-a.htm

  brdDims=[35.7,23.9,1.6];
  rad=1.5; 
  pcbDims= (type=="OV5640") ? [brdDims.x-rad,brdDims.y] : [brdDims.x,brdDims.y];
  drill=2.7;
  conPos=[1.5,1.92]; //pin1 offset from top left corner
  camXPos=30.7;
  camDims=[8.5,7.8,3];
  pin1Offset=[-conPos.x,-brdDims.y+conPos.y,2.5];

  translate(pin1Offset){
    color(pcbBlackCol) 
      linear_extrude(brdDims.z) 
        !difference(){
          union(){
            square(pcbDims);
            //if (type=="OV5640") 
            hull() for(iy=[-1,1]) translate([brdDims.x-rad,iy*(brdDims.y/2-rad)+brdDims.y/2]) circle(rad);
          }
      //if (type=="OV5640") 
          for (iy=[-1,1])
            translate([brdDims.x-3,iy*(brdDims.y/2-3)+brdDims.y/2]) circle(d=drill);
    }
    translate([conPos.x,brdDims.y-conPos.y,0]) //pin1 is defined from top but connector inserted from bottom!
      mirror([0,0,1]) rotate([0,0,-90]) MPE_087(2,18);

    //camera dummy
    color(blackBodyCol) translate([camXPos,brdDims.y/2,5/2+brdDims.z]) cube([8.5,7.8,5],true);
  }

}



module RYB080I(){
  //Reyax Bluetooth Module BLE 4.2 & 5.0
  //https://reyax.com/products/ryb080i/

  poly=[[-5.5,-5.5],[5.5,-5.5],[5.5,2.4],[5.5-2.8,2.4],
        [5.5-2.8,5.5],[-3.3,5.5],[-3.3,3.2],[-5.5,3.2]];
  padDims=[0.7,0.7,0.87];

  difference(){
    union(){
      color("darkSlateGrey") linear_extrude(0.8) polygon(poly);
      color("silver") translate([-4.6,-4.6,0.8]) cube([11-1.8,6.6,1.4]);
      color("ivory") translate([-1,2+1.8,0.8]) cube([3,1.6,0.8]);
      for (ix=[-1,1], iy=[0:6])
        color("gold") translate([ix*(5.535-padDims.x/2),-4.5+iy,0.4]) 
          cube(padDims,true);
      for (ix=[-3.5:3.5])
        color("gold") translate([ix,-5.5+padDims.x/2,0.4]) 
          rotate(90) cube(padDims,true);
    }
    for (ix=[-1,1], iy=[0:6])
        color("gold") translate([ix*(5.5),-4.5+iy,0.4]) 
          cylinder(d=0.5,h=0.9,center=true);
    for (ix=[-3.5:3.5])
        color("gold") translate([ix,-5.5,0.4]) 
          rotate(90) cylinder(d=0.5,h=0.9,center=true);
    color("darkgrey") translate([0,0,0.8+1.4-0.1]) linear_extrude(0.2) text("REYAX",size=1.2,valign="center",halign="center");
    color("darkgrey") translate([0,-2,0.8+1.4-0.1]) linear_extrude(0.2) text("RYB080I",size=1.2,valign="center",halign="center");
  }
}