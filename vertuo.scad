$fn=50;

fudge=0.1;
%vertuo();
translate([0,0,-28]) import("Nepresso_Capsule_Shell.stl");

module vertuo(size="alto",used=true){
  bdDia=48.5;
  rngDia=58;
  fldThck=2;
  ovHght= (size=="alto") ? 32 : 
          (size=="espresso") ? 22 : 
          (size=="lungo") ? 32 : 
          (size=="mug") ? 32 :
          (size=="dblEspresso") ? 32 : 32;
  
  cylHght=ovHght-bdDia/2;
 
  if (used)
    difference(){
      body();
      translate([0,0,-6]) cylinder(d=6.6,h=6.5);
      for (rot=[0:360/18:360])
        rotate(rot) translate([20.8,0,-0.7]) sphere(d=2.8,$fn=4);
    }
  else
    body();
  
  module body(){
  difference(){
      translate([0,0,-cylHght]) sphere(d=bdDia);
      translate([0,0,(bdDia+fudge)/2]) cube(bdDia+fudge,true);
    }
  translate([0,0,-cylHght]) cylinder(d=bdDia,h=cylHght);
  rotate_extrude() translate([(rngDia-fldThck)/2,0]) circle(d=fldThck);
  cylinder(d=rngDia-fldThck/2,h=0.2);  
  }
}

module nespresso(){
  
}
