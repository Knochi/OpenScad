$fn=100;

poleDia=30;
wallThck=1.2;
maxDia=160;
topHght=30;
drillDia=5.5;
fudge=0.1;

topDia=poleDia+2*wallThck;

difference(){
  union(){
    cylinder(d=topDia,h=maxDia/2+topHght);
    cylinder(d1=maxDia,d2=topDia,h=maxDia/2);
  }  
  translate([0,0,-fudge/2]) cylinder(d=poleDia,h=maxDia/2+topHght+fudge);
  translate([0,0,-fudge/2]) 
    cylinder(d1=maxDia-wallThck*2+fudge/4,d2=poleDia,h=maxDia/2);
  translate([0,0,(maxDia+topHght)/2]) for (ir=[0,120,240])
    rotate([90,0,ir]) cylinder(d=drillDia,h=topDia/2+fudge);
  for (r=[0:40:360])
    rotate(r) translate([0,-maxDia/2+36,33]) rotate([51,0,0]) linear_extrude(10) leaf();
}


*leaf();
module leaf(r=60,w=7){
  intersection(){
    for (ix=[-1,1]) translate([ix*(r-w),0]) circle(r);
  }
}