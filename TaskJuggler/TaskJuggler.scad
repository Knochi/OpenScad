use <eCAD/Displays.scad>
$fn=50;

//check for Multibin compatibility

wallThck=3;
binDims=[50,50];
binFloorHght=6;
insrtDims=[43,193];
insrtFlorrHght=4.2;
ballDia=12.7;
slndLen=35.3;
slndBdyDia=8;
slndActDia=3;
LCDDims=[36,2.7,64];
/* [show] */
showBin=true;
showPCB=true;
/* [Hidden] */
slndPos=[0,binDims.y/2-wallThck,slndBdyDia/2+binFloorHght]+[0,6,0];
ballPos=[0,slndPos.y-slndLen,slndPos.z+ballDia/2+slndActDia/2]+[0,-4,0];
LCDPos=[0,ballPos.y+ballDia/2+wallThck,slndPos.z+LCDDims.z/2]+[0,-2,6.1];
translate(ballPos) ball();

translate(LCDPos) rotate([90,0,0]) DisplayRound_1_28();//OLED0_96inch4pin();

translate(slndPos) rotate([90,180,0]) solenoid();


if (showBin){
  *import("4x1x1 - Multibin Shell.stl");
  *import("4x1 - Micro Multibin Shell.stl");
  %import("4x1x0.25 - Multibin Insert.stl");
  *import("4x1x1 - Multibin Insert.stl");
  }
if (showPCB)
  translate([0,0,LCDPos.z]) rotate([90,0,0]) import("TaskJugglerPCB.stl");

module ball(){
  color("silver") sphere(d=25.4/2);
}

*solenoid();
module solenoid(){
  //Mini Solenoid 8mm x 
  //e.g. https://www.aliexpress.com/item/1005005005000501.html
  color("silver"){
    cylinder(d=8,h=20);
    cylinder(d=3,h=20+7.8+7.5);
    translate([0,0,20+7]) cylinder(d=5,h=1);
  }
  color("red") translate([0.5,-3,1]) 
    rotate([90,0,0]) cylinder(d=1,h=10);
  color("black") translate([-0.5,-3,1]) 
    rotate([90,0,0]) cylinder(d=1,h=10);
}