$fn=50;


/* [Dimensions] */
ttDia=40;
ttHght=10;
monOffset=[0,-5.5,3];
baseThick=3;
monTilt=20;
monOvDims=[192+187,235.5,9.5];;

spcng=0.25;

/* [Hidden] */
fudge=0.1;

turnTable();

*5translate(monOffset) rotate([-monTilt,0,0]) 
  translate([0,8,235.5/2]) rotate([90,0,0]) USBMon();

module turnTable(){
  flankAng=30;
  ttDia2=ttDia-(tan(flankAng)*ttHght)*2; //turntable upper Dia from flankAng
  basDia2=ttDia-(tan(flankAng)*baseThick)*2; //base upper Dia from flanAng
  
  YFudge= fudge/tan(flankAng);//fudge from flank Ang
  yDist= 100;//tan(monTilt)*monOvDims.y; //tan a = GK/AK
  beamPoly=[[basDia2/2-fudge,baseThick-YFudge],
            [yDist-(ttDia-basDia2)/2,baseThick],
            [ttDia2/2-fudge,ttHght]];
  
  monShapePoly=[[0,0],
                [1.5,0.5],[1.5,ttHght*2],
                [-7.6,ttHght*2],[-7.6,5.5/2]]; //section of usb Monitor for cutout
  
  *polygon(monShapePoly);
  
  for (ir=[-1,1]) rotate([90,0,90+ir*monTilt]) linear_extrude(3,center=true) polygon(beamPoly);
  hull(){ //the actual stand
    cylinder(d1=ttDia, d2=basDia2,h=baseThick);
    for (ix=[-1,1])
      translate([ix*(yDist-ttDia)/2,yDist-ttDia/2]) 
        cylinder(d1=ttDia,d2=basDia2,h=baseThick);
  }
  // the holder disc
  difference(){
    cylinder(d1=ttDia,d2=ttDia2, h=ttHght);
    translate(monOffset)
      rotate([90,-monTilt,-90]) linear_extrude(ttDia+fudge,center=true) 
        offset(spcng) polygon(monShapePoly);
  }
}

module USBMon(){
  backDim=[196+178,230];
  midDim=[192+187,235.5,8];
  frontDim=midDim-[1,1,6.5];
  backRad=2;
  midRad=(midDim.x-backDim.x)/2;
  sclMid=[midDim.x/backDim.x,midDim.y/backDim.y];
  sclFrnt=[frontDim.x/midDim.x,frontDim.y/midDim.y];
  
  linear_extrude(height=midDim.z,scale=sclMid) hull() for (ix=[-1,1],iy=[-1,1])
    translate([ix*(backDim.x/2-backRad),iy*(backDim.y/2-backRad)]) circle(backRad);
  translate([0,0,midDim.z]) linear_extrude(height=frontDim.z,scale=sclFrnt) 
    hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(midDim.x/2-backRad),iy*(midDim.y/2-backRad)]) circle(backRad);
}