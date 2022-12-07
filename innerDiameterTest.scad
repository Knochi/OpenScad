ovDims=[86,54,1];
rad=3;
count=[6,3];
start=3;
increment=0.2;

$fn=100;

maxDia=count.x*count.y*increment+start;

dist=ovDims.x/(count.x+1);

//inner Diameter test
linear_extrude(ovDims.z) difference(){
  hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(ovDims.x/2-rad),iy*(ovDims.y/2-rad)]) circle(rad);
  for (ix=[-(count.x-1)/2:(count.x-1)/2],iy=[0:(count.y-1)]){
    no=(ix+(count.x-1)/2)+iy*(count.x);
    dia= start+no*increment;
    translate([ix*dist,ovDims.y/2-iy*dist-dist]){
      circle(d=dia);
      *translate([0,maxDia/2,0]) text(str(dia),font="Stencil:style=Regular", size=dist/3,halign="center");
    }
    
  }
}
  