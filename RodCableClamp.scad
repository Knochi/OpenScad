rodDia=8;
cableDims=[1.5,3];
spcng=0.2;
rad=1;
clampHght=10;
minWallThck=2;

fudge=0.1;

wallThck=minWallThck+cableDims.x+spcng;

$fn=100;


difference(){
  rotate((360-270)/2) rotate_extrude(angle=270) translate([rodDia/2,0]) square([wallThck,clampHght]);
  translate([-rodDia/2,0,clampHght/2]) linear_extrude(clampHght+fudge,center=true) offset(spcng+rad) 
    square([(cableDims.x-rad)*2,cableDims.y-rad],true);
}

for (i=[-1,1])
  rotate(i*(360-270)/2) translate([(rodDia+wallThck)/2,0,0]) cylinder(d=wallThck,h=clampHght);

