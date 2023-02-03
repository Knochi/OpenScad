diceDim=15;
edgeRad=1.5;
crnrRad=0;
emboss=0.3;
dR=diceDim*sqrt(3);
fudge=0.1;
$fn=50;



module dice(){
  intersection(){
    hull() for (ix=[-1,1],iy=[-1,1],iz=[-1,1])
      translate([ix*(diceDim/2-edgeRad),iy*(diceDim/2-edgeRad),iz*(diceDim/2-edgeRad)]) 
        sphere( edgeRad);
      sphere(d=dR-2*crnrRad);
  }
}

difference(){
  dice();
  //top
  translate([0,0,diceDim/2-emboss])
   faceHugger();
  //bottom
  rotate([0,-180,0]) translate([0,0,diceDim/2-emboss])
    framedNumber(6);
  //left
  rotate([0,-90,0]) translate([0,0,diceDim/2-emboss])
    framedNumber(2);
  //right
  rotate([0,90,0]) translate([0,0,diceDim/2-emboss])
    framedNumber(5);
  //front
  rotate([90,0,0]) translate([0,0,diceDim/2-emboss])
    framedNumber(3);
  //back
  rotate([-90,0,0]) translate([0,0,diceDim/2-emboss])
    framedNumber(4);
 
}

*faceHugger();
module faceHugger(no=1, scl=0.8){
   linear_extrude(emboss+fudge)
    scale(scl){
      translate([-7.5,-7.5])  import("faceHuggerSymbol.svg");
      translate([0,4.5]) text(str(no),size=2.5,valign="center",halign="center",font="arial:style=bold");
    }
}

*framedNumber();
module framedNumber(no=2, scl=0.8){
  size=15;
  rad=2;
  lineWdth=1;
  linear_extrude(emboss+fudge)
  scale(scl){
    difference(){
      offset(rad) square(size-rad*2,center=true);
      offset(rad-lineWdth) square(size-(rad)*2,true);
    }
  text(str(no),size=size*0.5,valign="center",halign="center",font="arial:style=bold");
  }
}


  