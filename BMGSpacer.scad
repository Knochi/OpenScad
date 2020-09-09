$fn=40;
fudge=0.1;
oDia=11.9;
iDia=7.9;
shift=(11.9-7.9)/2-3;
wallDims=[4.9,1.2,3.25]; //total dims of wall part
d=oDia*sqrt(2); 
thick=1.55;

difference(){
  cylinder(d=oDia,h=wallDims.z);
  translate([0,0,thick]) cylinder(d=oDia-wallDims.y,h=wallDims.z-thick+fudge);
  translate([0,shift,-fudge/2]) cylinder(d=iDia,h=thick+fudge);
  translate([0,shift,-fudge/2]) rotate(-90-45) cube([oDia,oDia,wallDims.z+fudge]);
  translate([0,shift-d/2,thick/4]) rotate(-45) 
    linear_extrude(height=thick*0.75+fudge,scale=1.4) square(oDia,true);
  for (ix=[-1,1])
    translate([ix*((oDia-wallDims.x)/4+wallDims.x/2),0,thick+(wallDims.z-thick+fudge)/2]) 
      cube([(oDia-wallDims.x)/2+fudge,oDia+fudge,wallDims.z-thick+fudge],true);
  
}