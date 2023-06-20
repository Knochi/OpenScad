$fn=50;

dia=17.5;
length=20;
drillDia=3.2;
chamfer=2;
fudge=0.1;

embedNut=false;
nutS=7.7;
nutM=5;
nutSpcng=0.1;

difference(){
  //body
  union(){
    cylinder(d=dia,h=length-chamfer);
    translate([0,0,length-chamfer]) cylinder(d1=dia,d2=dia-chamfer*2,h=chamfer);
  }
  //cutouts for welds
  for (ix=[-1,1])
    translate([ix*dia/2,0,-fudge/2]) cylinder(d=chamfer,h=length+fudge);
  
  translate([0,0,8.5]) rotate([-90,0,0]){
    //drill hole
    cylinder(d=drillDia,h=dia+fudge,center=true);
    //cutout for nut
    if (embedNut) hull(){
      rotate([0,0,30]) nut(nutS+nutSpcng*2,nutM+nutSpcng*2);
      translate([0,8.5,0]) rotate([0,0,30])  nut(nutS+nutSpcng*2,nutM+nutSpcng*2);;
      }
    }
}

*rotate([90,30,0]) nut(nutS,nutM);
module nut(s=7,m=2){
  nutODia=2*s/sqrt(3);
  translate([0,0,-m/2]) cylinder(d=nutODia,h=m,$fn=6);
}