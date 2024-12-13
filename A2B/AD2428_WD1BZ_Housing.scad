include <ecad/kicadcolors.scad>
use <ecad/connectors.scad>

$fn=50;

WD1BZ();

module WD1BZ(){
  //Analog Devices AD2428WD1BZ Eval Board  
  pads2scadMil=[-250,250]; //Offset from pads Origin to openscad origin
  ovDims=[4.2*25.4,3.925*25.4,1.6];
  drillOffset=[3.175,3.175];
  drillDist=[ovDims.x-drillOffset.x*2,ovDims.y-drillOffset.y*2];
  drillDia=3.175;
  
  dClickPosMil=[[1200,3675],[1775,3675]];
  boxHdrPosMil=[3100,2225];
  probePointPosMil=[1200,2487.5];
  
  translate([0,0,ovDims.z]){
    for (pos=dClickPosMil)
      translate(mil2mm(pos+pads2scadMil)) rotate(180) duraClikRA();
    translate(mil2mm(boxHdrPosMil+pads2scadMil)) rotate(90) boxHeader(10,center=true);
    color("red") translate(mil2mm(probePointPosMil+pads2scadMil)) sphere(d=2);
  }
  color(pcbGreenCol) linear_extrude(ovDims.z) difference(){
   square([ovDims.x,ovDims.y]);
    for (ix=[0,1],iy=[0,1])
      translate([drillOffset.x+ix*drillDist.x,drillOffset.y+iy*drillDist.y]) circle(d=drillDia);
  }
}


function mil2mm(mil=[1,1])=[mil.x*0.0254,mil.y*0.0254];