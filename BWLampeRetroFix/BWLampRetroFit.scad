/* BW Lamp Conversion */
// 6230-12-120-3659

$fn=50;

lampBody();

fudge=0.1;


module lampBody(){
  //overall Dims including bulges and bends
  ovDims=[70,110,41];
  
  cntrBdyDims=[67,109,23]; //without the bulge
  bulgeRad=10;
  cntrBdyRad=3;
  flrDims=[66,108,6];
  flrRad=2.5;
  sheetThck=0.5;
  
  color("olive") difference(){
    flr();
    flr(true);
  }
  color("olive") difference(){
    cntrBdy();
    cntrBdy(true);
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(flrDims.x/2-flrRad),iy*(flrDims.y/2-flrRad),flrDims.z-cntrBdyRad-fudge/2]) cylinder(r=flrRad-sheetThck,h=cntrBdyDims.z+cntrBdyRad+fudge);
  }
  
  module flr(inner=false){
    //solid floor
    thck= inner ? sheetThck : 0;
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(flrDims.x/2-flrRad),iy*(flrDims.y/2-flrRad),flrRad]){ 
        sphere(flrRad-thck);
        cylinder(r=flrRad-thck,h=flrDims.z-flrRad+thck);
    }
  }
  
  module cntrBdy(inner=false){
    thck= inner ? sheetThck : 0;
    hull() for (ix=[-1,1],iy=[-1,1]){
      translate([ix*(cntrBdyDims.x/2-cntrBdyRad),iy*(cntrBdyDims.y/2-cntrBdyRad),flrDims.z+1.65]){ 
        sphere(cntrBdyRad-thck);
        //cylinder(r=cntrBdyRad,h=cntrBdyDims.z-cntrBdyRad*2);
        translate([0,0,cntrBdyDims.z-cntrBdyRad*2]) sphere(cntrBdyRad-thck);
      }
      if (iy<0) translate([ix*(ovDims.x/2-bulgeRad),0,flrDims.z-cntrBdyRad+1.65+cntrBdyDims.z/2]) rotate([90,0,0]) cylinder(r=bulgeRad-thck,h=cntrBdyDims.y-bulgeRad-thck,center=true);
    }
  }
}