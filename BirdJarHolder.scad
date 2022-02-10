$fn=60;
jarDia=80;
jarHght=80;
beamDia=15;
wallThck=2;
spcng=0.3;
hingeWdth=18;
beamAng=50;
screwDia=3.6;
screwLngth=40;
fudge=0.1;

mirror([0,0,1]) translate([0,0,-80])jar();
holder();

/* [Hidden] */


module holder(){
  difference(){
    for(ir=[-1,1])
      rotate(ir*beamAng) translate([(jarDia+beamDia)/2,0,0]){
        difference(){
          cylinder(d=beamDia,h=jarHght); //beams
          translate([0,0,-fudge]) cylinder(d=screwDia,h=screwLngth); //screwhole
        }
        translate([0,0,jarHght]) 
          cylinder(d=beamDia-wallThck*2-spcng*2,h=hingeWdth+wallThck); //hingePole
        translate([0,0,jarHght+hingeWdth]) cylinder(d=beamDia,h=wallThck); //hingeCap
        translate([0,0,jarHght+spcng]){
          difference(){ //hinge sleeves
            cylinder(d=beamDia,h=hingeWdth-spcng*2);
            translate([0,0,-spcng]) cylinder(d=beamDia-wallThck*2,h=hingeWdth);
            if (ir==1) rotate(90-beamAng){ //cut away on one side
              translate([-beamDia/2-fudge,-beamDia/2,-spcng])
                cube([beamDia/2+fudge,beamDia+fudge,hingeWdth]);
              translate([-fudge,-beamDia/2,-spcng])
                cube([beamDia/2+fudge,beamDia/2+fudge,hingeWdth]);
          }
          
          }
        }
      }//for
    }//diff
  difference(){
    hull() for(ir=[-1,1]) //latch
      rotate(ir*beamAng) translate([(jarDia+beamDia)/2,0,0])
        rotate(ir*(180-beamAng)) translate(([(beamDia-wallThck)/2,0,jarHght+spcng])) 
          cylinder(d=wallThck,h=hingeWdth-spcng*2);
  }
  
  
  difference(){
    rotate(-beamAng) rotate_extrude(angle=beamAng*2) //wallMount
      translate([(jarDia/2),0,0]) square([beamDia,wallThck]);
    for(ir=[-1,1])
      rotate(ir*beamAng) translate([(jarDia+beamDia)/2,0,0])
        translate([0,0,-fudge]) cylinder(d=screwDia,h=screwLngth);
  }
}

module jar(){
  cylinder(d=80,h=80);
  translate([0,0,80]) cylinder(d=65,h=20);
}