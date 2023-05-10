// FreeCad CSG import issue with offset
fudge=0.1;
$fn=50;

body();

module body(D=16,L=30){
  rad=0.5;
  notch=1.0;
  foilThck=0.1;
  foilOpnDia=12.8;
  ringPos=0.15;
  
    rotate_extrude(){     
      difference(){
        offset(rad) 
          difference(){
            translate([0,rad]) square([D/2-rad,L-rad*2]);
            //notch ring
            translate([(D+notch-rad)/2,L*ringPos]) circle(notch+rad);
          }
      //cut away excess from offset
      translate([-(rad+fudge),-fudge]) square([rad+fudge,L+fudge]);
      }
    }
  }