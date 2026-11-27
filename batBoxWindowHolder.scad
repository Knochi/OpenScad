/* [Battery Box] */
//oriented as on Window
batBoxDims=[68,19,64.5]; 
batBoxRad=2;
batBoxCblPos=[-34,-2.1,-23.75];
batBoxCblDias=1.5;
batBoxBtnPos=[-29,-9.5,21.75];
batBoxBtnDims=[4,1.5,7.5];
batBoxWallThck=2; //just for btn cutout
batBoxConDia=5.8;
batBoxConLen=10.6;

/* [Holder] */
//This depends on your window frame
hldrHookWdth=40;
hldrWallThck=2.0;
hldrBldThck=1.2;
hldrBldLen=15;
hldrOutRad=0.5; //not yet!
hldr2BoxSpcng=0.3;
hldr2CblSpcng=0.5;
hldr2BtnSpcng=0.5;


/* [Cable Spool] */
cblSpoolRad=3;
cblSpoolThck=5;

/* [WindowFrame] */
//distance front to frame
wndwFrmThck=19;

/* [show] */
showHldr=true;
showBox=true;

/* [Hidden] */
fudge=0.1;
hldrBxDims=batBoxDims + [(hldrWallThck+hldr2BoxSpcng)*2,(hldrWallThck+hldr2BoxSpcng)*2,(hldrWallThck+hldr2BoxSpcng)];
hldrBxRad=batBoxRad+hldr2BoxSpcng+hldrWallThck;

$fn=48;

translate([0,-batBoxDims.y/2,batBoxDims.z/2]){
 if (showBox) batBox();
 if (showHldr) holder();  
}

*batBox();
module batBox(){
  difference(){
  //body
    rotate([0,-90,0]) linear_extrude(batBoxDims.x,center=true) offset(batBoxRad) 
      square([batBoxDims.z-batBoxRad*2,batBoxDims.y-batBoxRad*2],true);
    translate(batBoxBtnPos+[0,batBoxWallThck/2,0]) 
      cube([batBoxBtnDims.x,batBoxWallThck+fudge,batBoxBtnDims.z],true);
  }
  // cables
  translate(batBoxCblPos) rotate([0,-90,0]) 
    for(i=[-1,1]) translate([i*batBoxCblDias/2,0,0]) cylinder(d=batBoxCblDias,h=10);

  //button
  translate(batBoxBtnPos+[0,(batBoxBtnDims.y+batBoxWallThck)/2-batBoxBtnDims.y,0]) 
    cube([batBoxBtnDims.x,batBoxBtnDims.y+batBoxWallThck,batBoxBtnDims.x],true);
}  

module holder(){
  slitLen=hldrBxDims.z/2-batBoxCblPos.z+batBoxCblDias/2;
  cblSpoolHght=30;
  cblSpoolZPos=-hldrBxDims.z/2+cblSpoolHght/2+batBoxRad+hldrWallThck+hldr2BoxSpcng;
  //body
  rotate([0,-90,0])
    difference(){
        linear_extrude(hldrBxDims.x,center=true) semiRndSquare([hldrBxDims.z,hldrBxDims.y],hldrBxRad);
        linear_extrude(hldrBxDims.x-hldrWallThck*2,center=true) 
          translate([(hldrWallThck+fudge)/2,0,0]) 
            semiRndSquare([hldrBxDims.z-hldrWallThck+fudge,hldrBxDims.y-hldrWallThck*2],hldrBxRad-hldrWallThck);
      //cable slit
      translate([(hldrBxDims.z-slitLen+fudge)/2,batBoxCblPos.y,hldrBxDims.x/2-hldrWallThck]) 
        linear_extrude(hldrWallThck+fudge) offset(hldr2CblSpcng){
          square([slitLen,batBoxCblDias],true);
          translate([-slitLen/2,0]) circle(d=batBoxCblDias);
          #translate([-slitLen/2+batBoxCblDias/2,-(batBoxDims.y/2-batBoxCblPos.y)/2]) square([batBoxCblDias*2,batBoxDims.y/2-batBoxCblPos.y],true);
        }
      //Button Window
      translate([batBoxBtnPos.z,0,-batBoxBtnPos.x]) rotate([90,0,0]) 
        linear_extrude(hldrBxDims.y/2+fudge) offset(hldr2BtnSpcng) square([batBoxBtnDims.z,batBoxBtnDims.x],true);
      //Button cutout channel
      translate([batBoxBtnPos.z,-batBoxDims.y/2,-batBoxBtnPos.x]) rotate([0,90,0])
        linear_extrude(hldrBxDims.z/2-batBoxBtnPos.z+fudge) offset(hldr2BoxSpcng) square([batBoxBtnDims.x,batBoxBtnDims.y*2],true);
    }
  //clamp roof
  translate([0,(hldrBxDims.y+wndwFrmThck)/2,(hldrBxDims.z-hldrWallThck)/2]) cube([hldrBxDims.x,wndwFrmThck,hldrWallThck],true);
  //clamp blade
  translate([0,hldrBxDims.y/2+wndwFrmThck,hldrBxDims.z/2-hldrBldLen-hldrWallThck]) 
    rotate([90,0,-90]) linear_extrude(hldrBxDims.x,center=true) 
      polygon([[0,0],[0,hldrBldLen],[hldrBldThck,hldrBldLen],[hldrBldThck,hldrBldLen/2]]);
  //cable Spool Front
  translate([0,-hldrBxDims.y/2-cblSpoolThck,cblSpoolZPos]) rotate([90,0,0]){ 
    linear_extrude(hldrWallThck) offset(cblSpoolRad) square([hldrBxDims.x-cblSpoolRad*2,cblSpoolHght-cblSpoolRad*2],true);
    //cable Spool Core
    translate([0,0,-cblSpoolThck]) linear_extrude(cblSpoolThck) offset(cblSpoolRad) 
      square([hldrBxDims.x-(cblSpoolRad+cblSpoolThck)*2,cblSpoolHght-(cblSpoolRad+cblSpoolThck)*2],true);
  }
  
}


module rndSquare(size, rad){
  offset(rad) 
    square([size.x-rad*2,size.y-rad*2],true);
}

module semiRndSquare(size, rad){
  offset(rad) 
    square([size.x-rad*2,size.y-rad*2],true);
  translate([(size.x-rad)/2,0]) square([rad,size.y],true);
}

*bvldSlot();
module bvldSlot(size=[5,10,2], rad=1){
  rotate_extrude(angle=90) translate([rad,0]) difference(){
    square(size.z);
    circle(size.z);
  }

}  