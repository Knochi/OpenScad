fudge=0.1;

module duraClikRA(pos,diff="none"){
  //Molex DuraClik Right Angle
  A=4+2*pos; //ovWith
  
  ovHght=6.4;
  baseHght=5.7;
  ovDpth=9.4;
  resess=[4,2.4+fudge,2.3+fudge];
  plug=[1+2*pos,5+fudge,4.7];
  plugZ=0.7;
  

  translate([0,ovDpth/2,0])
  if (diff=="housing"){
    translate([0,0,ovHght/2]) cube([A+fudge,ovDpth+fudge,ovHght+fudge],true);
  }
  
  else {
   color("GhostWhite")
    difference(){
      translate([0,0,ovHght/2]) cube([A,ovDpth,ovHght],true);//body
      translate([0,(-ovDpth+plug[1])/2-fudge,plug[2]/2+plugZ])
        difference(){//plug
          cube(plug,true);
          translate([0,-plug[1]/2+0.5,plug[2]/2-0.25+fudge]) cube([1.8,1,0.5],true);
        }
       translate([0,ovDpth/2-resess[1]/2+fudge,resess[2]/2-fudge]) cube(resess,true);
       translate([0,(ovDpth-resess[1])/2+fudge,(ovHght+resess[2]-fudge)/2]) cube([A+fudge,resess[1],ovHght-resess[2]+2*fudge],true);
    }
  }
}

//!duraClik(2);
module duraClik(pos=2){
  A= (pos>2) ? 6.6+2*pos : 10.9;
  B= (pos>2) ? 3.7+pos*2 : 8;
  C= (pos>6) ? pos*2-0.9 : (pos>2) ? pos*2 : 0;
  D= (pos>5) ? 11.8 : (pos>2) ? -0.2+2*pos : 6.3;
  
  ovDpth=7.8;
  
  
  baseThck=3;
  scktThck=5.05;
  ovHght=baseThck+scktThck;
  resess=[4.3,1.6+fudge,7.2+fudge]; //resess
  
  iLckDpth=3;
  
  plug=[1+2*pos,4.7,5+fudge];
  plgY=2.3;
  
  echo("A,B,C,D",A,B,C,D);
  color("GhostWhite")
  difference(){
    union(){
      translate([0,0,baseThck/2]) cube([A,ovDpth,baseThck],true); //base
      translate([0,0,baseThck+(scktThck/2)-fudge/2]) cube([B-2,ovDpth,scktThck+fudge],true); //socket
      translate([0,0,baseThck+(scktThck/2)-fudge/2]) cube([B,iLckDpth,scktThck+fudge],true); //flange
    }
    translate([0,-(ovDpth-plug[1])/2+plgY,ovHght-plug[2]/2+fudge]) 
      difference(){
        cube(plug,true); //plug
        translate([0,-plug[1]/2+0.24,plug[2]/2-0.5+fudge]) cube([1.8,0.5,1],true);
      }
    if (C) {
      translate([-C/2,-(ovDpth)/2-fudge,-fudge/2]) cube([(C-D)/2,2.3,scktThck+fudge]);
      translate([D/2,-(ovDpth)/2-fudge,-fudge/2]) cube([(C-D)/2,2.3,scktThck+fudge]); 
    }
    else translate([0,-(ovDpth-resess[1])/2-fudge,resess[2]/2-fudge]) cube(resess,true); //resess
  
  }
  
}