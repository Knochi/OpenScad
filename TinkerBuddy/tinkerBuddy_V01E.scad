ovDimsOut=[400,300,120];
ovDimsIn=[358,258,99];
fudge=0.1;

*difference(){
  translate([0,0,ovDimsOut.z/2]) cube(ovDimsOut,center=true);
  translate([0,0,ovDimsOut.z-ovDimsIn.z/2+fudge/2]) cube(ovDimsIn+[0,0,fudge],true);
}

RAKO();
module RAKO(){
  ovDimsOut=[400,300,120];
  ovDimsIn=[358,258,99];
  
  outRad=10;
  minRad=1;
  wallThck=2;
  botDims=[ovDimsIn.x,ovDimsIn.y];
  topOffset=5;
  
  difference(){
    union(){
      body(wallThck);
      translate([0,0,ovDimsOut.z]) ring([ovDimsOut.x,ovDimsOut.y,3]);
    }
    translate([0,0,wallThck+fudge]) body();
  }
  
  module body(offSet=0){
  hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(botDims.x/2-minRad),iy*(botDims.y/2-minRad),0]) 
      cylinder(r1=minRad+offSet,r2=topOffset+offSet,h=ovDimsOut.z+offSet);
  }
  //horizontal rings
  module ring(dims=[100,80,3], rad=10){
    hull() for (ix=[-1,1], iy=[-1,1])
      translate([ix*(dims.x/2-rad),iy*(dims.y/2-rad),0]) cylinder(r=rad,true);
  }
}