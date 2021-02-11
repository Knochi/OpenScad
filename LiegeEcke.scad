$fn=50;
wallThck=3;
stampDia=31;
holeDist=45;
spacer=15;
hght=40;
rad=5;
fudge=0.1;

foot();
//spacer();

module spacer(){
  translate([holeDist,holeDist,-spacer]) difference(){
    cylinder(d=stampDia,h=spacer);
    translate([0,0,-fudge/2]) cylinder(d=8,h=spacer+fudge);
  }
}

module foot(){
  // cos a=AK/HYP
  d=stampDia/2*sqrt(2);
  
  difference(){
    wall();
    translate([holeDist,holeDist,-wallThck-fudge/2]) cylinder(d=8,h=wallThck+fudge);
  }
  translate([0,-wallThck,0]) rotate([90,0,0]) wall([holeDist*2+d,hght]);
  translate([-wallThck,0,0]) rotate([0,-90,0]) wall([hght,holeDist*2+d]);
  
  module wall(dims=[holeDist*2+d,holeDist*2+d]){
    translate([0,0,-wallThck/2]) hull(){
      translate([dims.x+wallThck/2,-wallThck/2,0]) sphere(d=wallThck);
      translate([-wallThck/2,dims.y+wallThck/2,0]) sphere(d=wallThck);
      translate([-wallThck/2,-wallThck/2,0]) sphere(d=wallThck);
    }
  }
}