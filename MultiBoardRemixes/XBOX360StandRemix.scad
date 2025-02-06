// Remix of https://makerworld.com/de/models/667344

/* [Options] */
addHook=true;
addRail=true;

/* [Dimensions] */
standRad=0.5;
standDims=[124.62,46.5332,71.3515];

/* [show] */
showStand=true;
showPeg=true;
sectionCut=true;
sectionOffset=25.1;

/* [hidden] */
fudge=0.1;

if (showStand)
  stand();
  
if (showPeg)
  for (ix=[-1,1])
      translate([ix*25,0,50]) rotate([90,0,-90]) 
        peg();
*peg();

module stand(){
  difference(){
    cleanStand();
    if (sectionCut)
      color("darkRed") translate([sectionOffset,-47,-0.1]) cube([65,48,72]);
    if (addHook)
      for (ix=[-1,1])
        translate([ix*25,0.05,50]) rotate([90,0,-90]) 
          peg(true);
    if (addRail)
      translate([0,0.05,55+7.5]) rotate([90,0,0]) import("rails/Lite Multipoint Rail - Negative.stl");
    }
}

*peg(true);
module peg(cut=false){
  cavityTop=37.6;
  cavityBot=5.3;
  
  pegThck=2.85*2;
  cavityPoly=[[0,cavityBot],[4.1,cavityBot],[4.1,10.35],[7.8,10.35],[8.3,10.85],[9.2,10.85],[9.2,9.45],[13,9.45],
            [13,34.35],[9.2,34.35],[9.2,32.95],[8.3,32.95],[7.8,33.45],[4.1,33.45],[4.1,cavityTop],[0,cavityTop]];
  spcng=0.2;
  hookPoly=[[+0,-0.5],[0,8],[2,8],[3.5,6],[3.5,5],[2.5,5],[2.5,-0.5]];
  
  if (cut)
    union(){
      translate([0,-21.4,0]) linear_extrude(pegThck+spcng*2,center=true) polygon(cavityPoly);
      for (iy=[-1,1])
        translate([0,iy*15.55,0]) rotate([0,90,0]) rotate(180/8) 
          linear_extrude(4+spcng/2) offset(spcng) circle(d=6.18,$fn=8);
    }
  else
    for (im=[0,1]){
      translate([0,0.5,0]) mirror([0,im,0]) translate([4.5,-7.75-0.5,0]) 
        linear_extrude(pegThck,center=true) rotate(-90) polygon(hookPoly);
      translate([-2.6,0,-0.5]) import("Pegboard Click.stl");
      }
  }


module cleanStand(){
    difference(){
      translate([-standDims.x/2,-standDims.y,0]) 
        import("XBOX360Stand_Decimated.stl",convexity=3);
      translate([0,-13/2+0.5,35-0.1/2]) cube([50,15,70+0.1],true);
    }
    //fill the old cavities
    translate([0,-13.5/2,35]) cube([51,13.5,70],true);
}
*standModifier();
module standModifier(standExtrude=2){
  block=standDims.y-standRad+fudge;
  //tilt and extrude stand in Y
  //slice the radii
  intersection(){
    cleanStand();
    translate([0,-(standRad-fudge)/2,standDims.z/2]) 
      cube([standDims.x+fudge,standRad+fudge,standDims.z+fudge],true);
  }
  //slice and translate the rest
  translate([0,-standExtrude,0]) intersection(){
    cleanStand();
    translate([0,-standRad-(standDims.y-standRad+fudge)/2,standDims.z/2]) cube([standDims.x+fudge,standDims.y-standRad+fudge,standDims.z+fudge],true);
  }
  //insert the extrusion
  translate([0,-standRad-standExtrude,0]) rotate([-90,0,0]) 
    linear_extrude(standExtrude) standShape();
  *standShape();  
  module standShape(){
    projection()
      rotate([90,0,0]) 
        intersection(){
        cleanStand();
        translate([0,-standRad,standDims.z/2]) 
          cube([standDims.x+fudge,fudge,standDims.z+fudge],true);
      }
    
  }
}