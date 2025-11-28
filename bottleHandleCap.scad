$fn=100;
gap=0.4;
capDia=15.8;
fudge=0.1;
floorThck=0.2;
postDia=4;
tipDia=4.2;
chamfer=0.5;


difference(){
  rotate([0,90,0]){
    cylinder(d=postDia,h=6*2+2+gap-postDia,center=true);
    for (iz=[-1,1])
      translate([0,0,iz*(6*2+2+gap-postDia)/2]) sphere(d=tipDia);
    for (mz=[0,1])
      mirror([0,0,mz]){
        translate([0,0,chamfer+gap/2]) cylinder(d=capDia,h=2+gap/2-chamfer);
        translate([0,0,gap/2]) cylinder(d1=capDia-chamfer*2,d2=capDia,h=chamfer);
      }
    cylinder(d=capDia-chamfer*2,h=gap,center=true);
  }
  translate([0,0,-(capDia+fudge)/2]) cube([6*2-2+tipDia+gap+fudge,capDia+fudge,capDia+fudge],true);
  translate([0,0,floorThck]) linear_extrude(capDia/2) square([gap,capDia],true);
}
