magnetDims=[5,1.5,1];
poles=6;
rotorDia=20;
minWallThck=0.8; //2 lines
PCBThick=1;

for (ir=[0:360/poles:360*(1-1/poles)])
  rotate(ir) translate([rotorDia-magnetDims.x/2-minWallThck,0,0]) cube(magnetDims,true);

