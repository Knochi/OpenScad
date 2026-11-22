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
hldrWallThck=1.2;
hldr2BoxSpcng=0.3;

/* [Hidden] */
fudge=0.1;
hldrBxDims=batBoxDims + [(hldrWallThck+hldr2BoxSpcng)*2,(hldrWallThck+hldr2BoxSpcng)*2,(hldrWallThck+hldr2BoxSpcng)];
hldrBxRad=batBoxRad+hldr2BoxSpcng+hldrWallThck;

$fn=48;

translate([0,-batBoxDims.y/2,batBoxDims.z/2]){
  batBox();
 holder();  
}

module batBox(){
  difference(){
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
    rotate([0,-90,0])
    difference(){
        linear_extrude(hldrBxDims.x,center=true) semiRndSquare([hldrBxDims.z,hldrBxDims.y],hldrBxRad);
        linear_extrude(hldrBxDims.x-hldrWallThck*2,center=true) 
          translate([(hldrWallThck+fudge)/2,0,0]) 
            semiRndSquare([hldrBxDims.z-hldrWallThck+fudge,hldrBxDims.y-hldrWallThck*2],hldrBxRad-hldrWallThck);
      //cable slit
      #linear_extrude(hldrBxDims.x/2+fudge) square([hldrBxDims.z/2-batBoxCblPos.z,batBoxCblDias],true);
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
  