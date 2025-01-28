$fn=100;


/* [Dimensions] */
coinDia=23.2;
edgeWdth=0.8;
supportOffset=0.2;
logoOffset=[-7.7,-7];
layerThck=0.16;
recessLayers=3;

/* [show] */
showCoin=true;
showHead=true;
showDog=true;
showEdge=true;
showSupport=true;

/* [Hidden] */
rcssHght=layerThck*recessLayers;


if (showCoin) 
  translate([0,0,rcssHght]) cylinder(d=coinDia,h=2.35-rcssHght*2);

if (showEdge)
  for (iz=[0,1])
  translate([0,0,iz*(2.35-rcssHght)]) linear_extrude(rcssHght) difference(){
    circle(d=coinDia);
    circle(d=coinDia-edgeWdth*2);
  }


for (iz=[0,1])
  mirror([iz,0,0]) mirror([1,0,0]) translate([logoOffset.x,logoOffset.y,iz*(2.35-rcssHght)]) {
    if (showHead) 
      color("green") linear_extrude(rcssHght)
        import("UnderDogsLogo_HeadCut.svg");
    if (showDog)
      color("brown") linear_extrude(rcssHght)
        import("UnderDogsLogo_Dog.svg");
}

//support
if (showSupport)
  color("grey") linear_extrude(rcssHght) difference() {
    circle(d=coinDia-(supportOffset+edgeWdth)*2);
    mirror([1,0,0]) translate(logoOffset) offset(supportOffset){
      import("UnderDogsLogo_HeadCut.svg");
      import("UnderDogsLogo_Dog.svg");
    }
  }