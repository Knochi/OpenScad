//remodelling MultiBoard Remix Components to produce consitent models

/* [push Fit Dimensions] */
pFbotIRad=6.75;
pFbotORad=ri2ro(pFbotIRad,8);
pFbotHght=1;
pFtopHght=0.5;
pFtopIRad=6.62;
pFtopORad=ri2ro(pFtopIRad,8);
pFovHght=8.4;

/* [show] */
showPushFit=true;

// -- Multiboard Pegs --
// - imports -
*import("./Push-Fits/Push-Fit - Horizontal, Positive.stl"); // done!

//show
if (showPushFit)
  MBpushFit();
  
module MBpushFit(isPositive=true, isHorizontal=true){
  //horizontal
  sFac=pFtopIRad/pFbotIRad;
  linear_extrude(pFbotHght) rotate(180/8) circle(r=pFbotORad,$fn=8);
  translate([0,-pFbotIRad,pFbotHght]) 
    linear_extrude(pFovHght-pFtopHght-pFbotHght,scale=[sFac,sFac]) 
      translate([0,pFbotIRad,0]) 
        rotate(180/8) circle(r=pFbotORad,$fn=8);
  difference(){        
    translate([0,pFtopIRad-pFbotIRad,pFovHght-pFtopHght])
      linear_extrude(pFtopHght,scale=0.93) rotate(180/8) circle(r=pFtopORad,$fn=8);
    translate([0,-4.55,pFovHght-0.1]) linear_extrude(0.2) printDir();
    }
}

// Symbols

module printDir(){
  square([1.6,0.4],true);
  translate([0,1.29]) rotate(30) circle(d=1.4,$fn=3);
}

// -- helper Functions -- 
function ri2ro(ri,N)=ri/cos(180/N);