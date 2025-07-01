use <eCAD/packages.scad>



/* [Dimensions] */
pcbDia=80;
pcbThck=1.6;

/* [Components] */
LEDCount=8;
LEDCircleDia=50;
switchDims=[2.8,3.5,1.5]; //[2.8,3.5,1.5]
svnSegmentDims=[50.3,19,8];
svnSegmentPos=[0,-40];
/* [show] */
showPCB=true;

/* [Hidden] */
fudge=0.1;
LEDAng=360/LEDCount;

if (showPCB)
  PCBDummy();

module PCBDummy(){
  //PCB
  color("darkGreen") translate([0,0,-pcbThck]) linear_extrude(pcbThck) circle(d=pcbDia);
  //LEDs
  for (ir=[0:LEDAng:360-LEDAng])    
    rotate(ir) translate([LEDCircleDia/2,0,0]) LED5050();
  //Switch
  translate([0,0,switchDims.z/2]) cube(switchDims,true);
  //7-Segment Display
  translate([svnSegmentPos.x,svnSegmentPos.y,svnSegmentDims.z/2]) cube(svnSegmentDims,true);
}