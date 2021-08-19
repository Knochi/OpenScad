use <ecad/MPEGarry.scad>



for (iy=[-1,1])
translate([0,iy*2.54*9/2,0]) MPE_087(1,16,center=true,markPin1=false);


color("darkgreen") translate([-0,0,-1.6/2]) cube([2.54*16,2.54*10,1.6],true);

