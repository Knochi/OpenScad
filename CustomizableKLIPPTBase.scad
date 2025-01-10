$fn=64;
wallThck=1;
hexBaseInDia=18;
hexTopInDia=20;
ovHght=3;
baseHght=2;
recessHght=0.25;
crnrRad=1;
corners=8;

/* [Hidden] */
hexBaseOutDia=hexBaseInDia/cos(180/corners);
hexTopOutDia=hexTopInDia/cos(180/corners);
crnrOutRad=crnrRad/cos(180/corners);
wallThckOutRad=wallThck/cos(180/corners);
fudge=0.1;

//top
translate([0,0,baseHght]) linear_extrude(ovHght-baseHght) offset(crnrRad) circle(d=hexTopOutDia-crnrOutRad*2,$fn=corners);
//base
difference(){
  linear_extrude(baseHght) offset(crnrRad) circle(d=hexBaseOutDia-crnrOutRad*2,$fn=corners);
  translate([0,0,-fudge]) linear_extrude(recessHght) offset(crnrRad-wallThck) circle(d=hexBaseOutDia-wallThckOutRad*2,$fn=corners);
}