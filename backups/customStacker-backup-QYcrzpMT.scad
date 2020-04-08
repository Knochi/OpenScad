$fn=30;
/* [Dimensions] */
ovHeight=20;
gap=0.6;
count=4;

/* [Show] */
showCstmSup=false;


cstmSupPos=[[93,15.77,5],[-93,15.77,5],[29.55,69.4,5],[-29.55,69.4,5]];

for (i=[0:count-1]) 
  translate([0,0,ovHeight/2+i*(ovHeight+gap)]) import ("covid19_headband_rc3_no_text v1.stl");


if (showCstmSup) for (iPos=cstmSupPos) 
  translate(iPos) cstmSupport();

module cstmSupport(){
  cylinder(d=2,h=20-5);
}
