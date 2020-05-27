
/* [Dimensions] */
wallThck=5;
minDia=3;
maxDia=4;
steps=5;
height=10;

/* [Hidden] */
fudge=0.1;
inc=(maxDia-minDia)/steps;

echo(inc);
$fn=20;

for (i=[0:steps-1]){
  dia=maxDia-inc*i;  
  translate([i*(maxDia+wallThck),0,0]) bore(dia);
}

module bore(dia){
  difference(){
    cylinder(d=dia+wallThck*2,h=height);
    translate([0,0,-fudge/2]) cylinder(d=dia,h=height+fudge);
  }
}
