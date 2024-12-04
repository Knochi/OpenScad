$fn=100;

rad=3;
ovHght=43;
ovDia=85.4;

fudge=0.1;
cutOutDims=[ovDia+fudge,64,15.1];

difference(){
  body();
  translate([0,0,13+cutOutDims.z/2]) cube(cutOutDims,true);
  for (iy=[-1,1])
    translate([0,iy*ovDia/2,ovHght/2]) cube([10,10,ovHght+fudge],true);
}


module body(){
  translate([0,0,ovHght-rad]){
   rotate_extrude() translate([ovDia/2-rad,0]) circle(rad);
   cylinder(d=ovDia-rad*2,h=rad);
  }

  cylinder(d=ovDia,h=ovHght-rad);
}

