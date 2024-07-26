include <KiCADColors.scad>



!fuse();
module fuse(size=[6.1,2.5,2.5],capLen=1.4){
  //https://www.lcsc.com/datasheet/lcsc_datasheet_2305151203_Shenzhen-JDT-Fuse-JFC2410-0750TS_C136379.pdf
  crnRad=capLen*0.1;
  color(metalSilverCol) for (im=[0,1])
    mirror([im,0,0]) translate([size.x/2-capLen,0,size.z/2]) rotate([0,90,0]) cap();
  color(whiteBodyCol) translate([0,0,size.z/2]) rotate([0,90,0]) linear_extrude(size.x-capLen*2,center=true) 
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.y/2-crnRad*2),iy*(size.z/2-crnRad*2),capLen-crnRad]) circle(crnRad,$fn=21); 
  
  module cap(){
  linear_extrude(capLen-crnRad) 
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.y/2-crnRad),iy*(size.z/2-crnRad),capLen-crnRad]) circle(crnRad,$fn=21); 
  hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.y/2-crnRad),iy*(size.z/2-crnRad),capLen-crnRad]) sphere(crnRad,$fn=21); 
  }
}