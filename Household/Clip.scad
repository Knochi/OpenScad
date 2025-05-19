
$fn=50;

thick=2.5;
mainDia=100;
hookDia=15;
hookCount=5;
minWallThck=3;

snapInnerDia=2.8;
snapFingThck=1;

/* [Hidden] */
snapOuterDia=snapInnerDia+snapFingThck*4+minWallThck*2;



module pin(){
  cylinder(d=5,h=145);
  translate([0,0,145]) cylinder(d=2.8,h=4);
  translate([0,0,145+4]) cylinder(d=5,h=5);
  translate([0,0,145+4+5]) cylinder(d1=5,d2=2.8,h=6);
}


!stabiRing();
module stabiRing(){
  linear_extrude(thick) difference(){
    circle(d=mainDia);
    circle(d=mainDia-minWallThck*2);
  }
  for (r=[0:360/hookCount:360-hookCount])
    rotate(r) translate([mainDia/2-snapOuterDia/2,0,0]) pinSnap();
}



*pinSnap();
module pinSnap(){
  ang=30;
  
  linear_extrude(thick) difference(){
    circle(d=snapOuterDia);
    circle(d=snapInnerDia+snapFingThck*4);
    }
  
  rotate(ang) for(ix=[-1,1]){
    linear_extrude(thick) translate([ix*(snapInnerDia+snapFingThck)/2,0]) circle(d=snapFingThck);
    rotate(0) translate([ix*snapFingThck,0,0]) rotate_extrude(angle=180) translate([ix*(snapInnerDia/2+snapFingThck*1.5),thick/2]) square([snapFingThck,thick],true);
    }
}

module hook(dia=15,length=20){
  
}

