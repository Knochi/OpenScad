//test threat for pipe
use <threads.scad>
$fn=50;

spcng=0.1;
threadLen_inch=0.65;
threadLen_mm=threadLen_inch*25.4;
pipeDia=21.6;
baseLen=10;
ovLen=baseLen+threadLen_mm;
fudge=0.1;

difference(){
  linear_extrude(ovLen-fudge) offset(3) circle(d=pipeDia*1.5,$fn=8);
  translate([0,0,-fudge/2]) cylinder(d=pipeDia+spcng*2,h=baseLen+fudge);
  translate([0,0,baseLen]) english_thread (diameter=0.85, threads_per_inch=14, length=0.65, taper=1/16,internal=true);
  }

