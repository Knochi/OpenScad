

/* [Dimensions] */
pcbInnerDia=80;
pcbThck=1.6;

/* [Components] */
LEDCount=8;
LEDCircleDia=50;
switchDims=[2.8,3.5,1.5]; //[2.8,3.5,1.5]
svnSegmentDims=[30,14,8];

svnSegmentYPos=-0.5; //[-1:0.01:0]
/* [show] */
showPCB=true;

/* [Hidden] */
fudge=0.1;
LEDAng=360/LEDCount;
$fn=50;
svnSegmentXPos=0; //[-0.5:0.01:0.5]
PCBOuterDia=ri2ro(pcbInnerDia,6);
svnSegmentPos=[svnSegmentXPos*PCBOuterDia,svnSegmentYPos*PCBOuterDia];


if (showPCB)
  PCBDummy();

module PCBDummy(){
  //PCB
  color("darkGreen") translate([0,0,-pcbThck]) linear_extrude(pcbThck) circle(d=PCBOuterDia,$fn=6);
  //LEDs
  for (ir=[0:LEDAng:360-LEDAng])    
    rotate(ir) translate([LEDCircleDia/2,0,0]) LED5050();
  //Switch
  translate([0,0,switchDims.z/2]) cube(switchDims,true);
  //7-Segment Display
  translate([svnSegmentPos.x,svnSegmentPos.y,svnSegmentDims.z/2]) cube(svnSegmentDims,true);
}

function ri2ro(r=1,n=$fn)=r/cos(180/n);

module LED5050(pins=4){
  // e.g. WS2812(B)
  dims=[5,5,1.5];
  pitch= (pins==6) ? 0.9 : 1.8;
  grvHght=1;
  marking=[0.7,0.2]; //width,height
  fudge=0.1;
  //body
  color("ivory")
    difference(){
      translate([0,0,(dims.z+0.1)/2]) cube(dims-[0,0,0.1],true);
      translate([0,0,dims.z-grvHght]) cylinder(d1=3.2,d2=4,h=grvHght+0.01);
      //marking
      translate([dims.x/2,dims.y/2,dims.z-marking[1]]) linear_extrude(marking[1]+fudge)      
        polygon([[-marking.x-fudge,fudge],[fudge,fudge],[fudge,-marking.x-fudge]]);
    }
  color("grey",0.6)
    translate([0,0,dims.z-grvHght]) cylinder(d1=3.2,d2=4,h=grvHght);
  
  //leads
  color("silver")
    for (i=[-pins/2+1:2:pins/2],r=[-90,90])
      rotate([0,0,r]) translate([dims.x/2-0.8,i*pitch,0.3])
        jLead();
        //translate([-1.1/2+0.2,0,0.1]) cube([1.1,1.0,0.2],true);
        //translate([0.1,0,0.45]) cube([0.2,1.0,0.9],true);
      
  *color("silver") jLead();
  module jLead(size=[1,1,0.6]){
    leadThck=0.10;
    bendRad=0.17;
    //top & bottom
    for (iz=[-1,1]){
      translate([(size.x-bendRad)/2,0,iz*(size.z-leadThck)/2]) 
        cube([size.x-bendRad,size.y,leadThck],true);
      translate([size.x-bendRad,0,iz*(size.z/2-bendRad)]) 
      rotate([iz*90,0,0]) rotate_extrude(angle=90) 
        translate([bendRad-leadThck/2,0]) #square([leadThck,size.y],true);
        }
    translate([size.x-leadThck/2,0,0]) cube([leadThck,size.y,size.z-bendRad*2],true);
  }
}