$fn=50;

/* -- [show] -- */
showVertuo=false;
showNespresso=false;
showAdapter=true;
showCut=true;

/* -- [Adapter-Dimensions] -- */
 //thickness of the top Plate
topThck=2;

/* -- [hidden] -- */

fudge=0.1;
maxDia=60;
maxHght=35;

difference(){
  union(){
    if (showVertuo) vertuo();
    if (showAdapter) adapter();
    if (showNespresso){
      translate([0,0,fudge]) mirror([0,0,1]) import("Nepresso_Capsule_Shell.stl");
      
    }
  }
  if (showCut)
    color("darkred")
      translate([-maxDia/2,0,-maxHght+topThck/2]) cube([maxDia+fudge,maxDia/2+fudge,maxHght+fudge]);
}

module adapter(){
  bdDia=48.5; //Diamenter of the main body
  rngDia=58; //diameter of the outer ring
  fldThck=2; //thickness of the circular folded edge

  
  nesDia=37;
  nesThck=1.3;
  ovHght= 32; 
  cylHght=ovHght-bdDia/2;
 
  difference(){
    body();
    translate([0,0,-nesThck]) cylinder(d=nesDia,h=topThck/2+nesThck+fudge);
    translate([0,0,-24.7]) cylinder(d1=23.7,d2=29.4+fudge,h=22.2+fudge);
    translate([0,0,-2.6+fudge]) cylinder(d=16.2*2,h=2.6/2+fudge);
  }
  translate([0,0,-2.7]) rotate_extrude() translate([16.1,0,0]) circle(d=2.8);
  
  module body(){
  difference(){
      translate([0,0,-cylHght]) sphere(d=bdDia);
      translate([0,0,(bdDia+fudge)/2]) cube(bdDia+fudge,true);
    }
  translate([0,0,-cylHght]) cylinder(d=bdDia,h=cylHght);
  rotate_extrude() translate([(rngDia-fldThck)/2,0]) circle(d=fldThck);
  translate([0,0,-topThck/2]) cylinder(r=(rngDia-fldThck)/2,h=topThck);  
  }
}

module vertuo(size="alto",used=true){
  bdDia=48.5; //Diamenter of the main body
  rngDia=58; //diameter of the outer ring
  fldThck=2; //thickness of the circular folded edge
  
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
