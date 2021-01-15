fudge=0.1;
$fs=0.5;

HBVCAM();
module HBVCAM(){
  //https://www.banggood.com/HBV-5640-FF-Fixed-Focus-5MP-USB-OV5640-Laptop-Camera-Module-5-Million-Pixels-Camera-2592+1944-p-1709224.html
  ovDims=[60,8.5,6.5];
  camDims=[8.2,8.2,5.3];
  PCBThick=1.2;
  drillPos=[[-22.5,-2.2],[28.1,2.2],[28.1,-2.2]]; //from board center
  difference(){
    color("darkslategrey") translate([0,0,PCBThick/2]) cube([ovDims.x,ovDims.y,PCBThick],true);
    translate([0,0,-fudge/2]) linear_extrude(PCBThick+fudge) for (pos=drillPos) translate(pos) circle(d=2.6);
  }
  translate([0,0,(camDims.z+PCBThick)/2]) cube(camDims,true);
}