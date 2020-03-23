LCD_20x4();
translate([100,0,0]) LCD_16x2();
translate([220,0,0]) FutabaVFD();

fudge=0.1;

module LCD_16x2(){
  chars=[16,2];
  chrDim=[2.95,4.35];
  chrPitch=[chrDim.x+0.7,chrDim.y+0.7];
  PCBDim=[80,36,1.6];
  dispDim=[71.3,26.8,8.9];
  viewArea=[64.5,13.8,0.5];
  dispOffset=[PCBDim.x/2-40,PCBDim.y/2-19.2,0]; //offset from lower left edge
  
  //PCB
  color("darkgreen") translate([0,0,-PCBDim.z/2]) cube(PCBDim,true);
  
  //Display
  difference(){
    color("darkSlateGrey") translate(dispOffset+[0,0,dispDim.z/2]) cube(dispDim,true);
    color("blue")translate(dispOffset+[0,0,(dispDim.z-viewArea.z/2)])  
      cube(viewArea+[0,0,fudge],true);    
  }
  //segments
  translate(dispOffset+[0,0,dispDim.z-viewArea.z]) 
    for (ix=[-(chars.x-1)/2:(chars.x-1)/2],iy=[-(chars.y-1)/2:(chars.y-1)/2])
      translate([ix*chrPitch.x,iy*chrPitch.y]) color("lightblue") square(chrDim,true);
}

module LCD_20x4(){
  chars=[20,4];
  chrDim=[2.95,4.75];
  chrPitch=[chrDim.x+0.6,chrDim.y+0.6];
  PCBDim=[98,60,1.6];
  dispDim=[96.8,39.3,9];
  viewArea=[77,25.2,0.5];
  dispOffset=[PCBDim.x/2-49,PCBDim.y/2-39.3/2-10.35,0]; //offset from lower left edge
  
  //PCB
  color("darkgreen") translate([0,0,-PCBDim.z/2]) cube(PCBDim,true);
  
  //Display
  difference(){
    color("darkSlateGrey") translate(dispOffset+[0,0,dispDim.z/2]) cube(dispDim,true);
    color("blue")translate(dispOffset+[0,0,(dispDim.z-viewArea.z/2)])  
      cube(viewArea+[0,0,fudge],true);    
  }
  //segments
  translate(dispOffset+[0,0,dispDim.z-viewArea.z]) 
    for (ix=[-(chars.x-1)/2:(chars.x-1)/2],iy=[-(chars.y-1)/2:(chars.y-1)/2])
      translate([ix*chrPitch.x,iy*chrPitch.y]) color("lightblue") square(chrDim,true);
}


module FutabaVFD(){
  // Type M162MD07AA-000 
  chars=[16,2];
  chrDim=[3.7,8.46];
  chrPitch=[4.95,9.74];
  PCBDim=[122,44,1.6];
  dispDim=[106.2,33.5,8];
  viewArea=[77.95,18.2,0.5];
  //offset from lower left edge of PCB to Display center
  dispOffset=[-(PCBDim.x-dispDim.x)/2,-(PCBDim.y-dispDim.y)/2,0]+[7.9,6.25,1.8]; 
 
  //PCB
  color("darkgreen") translate([0,0,-PCBDim.z/2]) cube(PCBDim,true);
  
  //Display
  difference(){
    color("darkSlateGrey") translate(dispOffset+[0,0,dispDim.z/2]) cube(dispDim,true);
    color("blue")translate(dispOffset+[0,0,(dispDim.z-viewArea.z/2)])  
      cube(viewArea+[0,0,fudge],true);    
  }
  //segments
  translate(dispOffset+[0,0,dispDim.z-viewArea.z]) 
    for (ix=[-(chars.x-1)/2:(chars.x-1)/2],iy=[-(chars.y-1)/2:(chars.y-1)/2])
      translate([ix*chrPitch.x,iy*chrPitch.y]) color("lightblue") square(chrDim,true);
}

module HCS12SS(){
  ovDim=[100,20.5,6.3];
  //Samsung VFD module 
  color("darkSlateGrey") translate([0,0,ovDim.z/2]) cube(ovDim,true);
  for (ix=[-11/2:11/2]) translate([ix*(74/11),0,ovDim.z]) pattern();
  
  module pattern(){
    pxDim=0.45;
    tilt=3;
    pitch=0.6;
    xyOffset=[tan(tilt)*pitch,pitch]; //tan(a)=GK/AK
    frm=[tan(tilt)*4.5,4.5];
    color("cyan") linear_extrude(0.1) 
      polygon([[-4.3/2+frm.x,frm.y],[4.3/2+frm.x,frm.y],
               [4.3/2-frm.x,-frm.y],[-4.3/2-frm.x,-frm.y]]);
    
    *translate(xTilt(1,tilt)) for (i=[0:4])
      translate(xyOffset*i) square(pxDim,true);
  }
}



function xTilt(dist,ang)=[tan(ang)*dist,dist];