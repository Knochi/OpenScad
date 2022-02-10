use <Getriebe.scad>


/*
Modul: m=d/z; (durchmesser/zähnezahl)
Abstand: d=(m/2)*(za+zb)
*/
mod=1; //modul
zCnt=20; //zähne
dist=(mod/2)*zCnt*2; //abstand
matThck=3;
beamWdth=10;
drillDia=3.2;
spcng=0.2;
fudge=0.1;

main();

module main(){
  translate([0,-(matThck+spcng)/2,0]) rotate([90,-90,0]) quadGear();
  translate([0,(matThck+spcng)/2,0]) rotate([90,-90,180]) quadGear();
  color("darkred") difference(){
    hull(){
      for (iz=[0,1])
        translate([0,0,iz*dist*3]) rotate([90,0,0]) cylinder(d=beamWdth,h=matThck,center=true);
    }
    for (iz=[0:3])
      translate([0,0,iz*dist]) rotate([90,0,0]) cylinder(d=drillDia,h=matThck+fudge,center=true);
  }
  
  module quadGear(){
    for(ix=[0:3]){
      ang=(ix %2) ? -20 : 20 ;
      rot=(ix %2) ? 0 : 360/(zCnt*2) ;
      translate([dist*ix,0,0])  rotate(rot)
        pfeilrad(mod, zCnt, 4, drillDia, eingriffswinkel = 20, schraegungswinkel=ang, optimiert=true);
    }
  }
}
