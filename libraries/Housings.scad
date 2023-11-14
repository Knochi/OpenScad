$fn=50;


showTop=true;

 extrusionCase();
 module extrusionCase(size=[145,200,68],sheetThck=2, rad=3, split=0.4, center=false){
   //case made of Aluminum Extrusions
   cntrOffset= center ? [0,0,0] : size/2;
   
   //looking for global "show" variables
   showTop=     is_undef(showTop)     ? true : showTop;
   showBottom=  is_undef(showBottom)  ? true : showBottom;
   showFront=   is_undef(showFront)   ? true : showFront;
   showBack=    is_undef(showBack)    ? true : showBack;
   
   translate(cntrOffset) rotate([90,0,0]){
     //Top
     if (showTop) linear_extrude(size.y-sheetThck*2,center=true) difference(){
       shape();
       translate([0,-size.z/2*(1-split)]) square([size.y,size.z*split],true);
     }
     //Bottom
     if (showBottom) linear_extrude(size.y-sheetThck*2,center=true) difference(){
       shape();
       translate([0,size.z/2*split]) square([size.x,size.z*(1-split)],true);
     }
     if (showFront) translate([0,0,size.y/2-sheetThck]) linear_extrude(sheetThck) shape(false);
     if (showBack) translate([0,0,-(size.y/2)]) linear_extrude(sheetThck) shape(false);
   }
   
  module shape(hollow=true){
    difference(){
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.z/2-rad)]) circle(rad);
    if (hollow) hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.z/2-rad)]) circle(rad-sheetThck);
  }
  }
 }
 