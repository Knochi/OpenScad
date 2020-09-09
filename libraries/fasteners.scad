fudge=0.1;

$fn=20;

*M3Rivet();
DIN912(3);

module M3Rivet(){
  //RS Expansion insert 
  color("gold")
  
  difference(){
    union(){
      cylinder(h=4.78,d=4);
      cylinder(h=3.78,d=4.22);
    }
    translate([0,0,-fudge/2]) cylinder(h=4.78+fudge,d=2.5);
    translate([0,0,4/2]) cube([0.5,4.5,4+fudge],true);
  }
}


module DIN912(dia=3,length=20){
  
  s=(dia==6) ? 5 :
    (dia==5) ? 4 : 
    (dia==4) ? 3 : 
    (dia==3) ? 2.5 : 
    (dia==2.5) ? 2 : 2.5;
  dk=(dia==6) ? 10.22 :
     (dia==5) ? 8.72 : 
     (dia==4) ? 7.22 : 
     (dia==3) ? 5.68 : 
     (dia==2.5) ? 4.5 : 5.68;
  t=(dia==6) ?  5.72 :
     (dia==5) ? 4.58 : 
     (dia==4) ? 2.5: 
     (dia==3) ? 1.9 : 
     (dia==2.5) ?  1.1:1.9 ;
  k= dia;
  so=2*s/sqrt(3);
  
  difference(){
    cylinder(d=dk,h=k);
    translate([0,0,k+fudge-t]) cylinder(d=so,h=t+fudge,$fn=6);
  }
  translate([0,0,-length]) cylinder(d=dia,h=length);
}