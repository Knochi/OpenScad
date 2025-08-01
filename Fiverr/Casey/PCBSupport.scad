/* customizable PCB support 
   remix of the AmpRipper support from DDD at https://www.thingiverse.com/thing:6625456
*/

/* [Dimensions] */
pcbHoleSpcng=[49,33.6];
//small support blocks from base to top
blockDims=[3,5,4]; 
//show the Original Design as a Ghost
showOriginal=false;

/* [Beams] */
beamWdth=6;
beamHght=2;
xBeamSpcng=19;

/* [Snaps] */
snapPinDia=2.9;
snapPinHght=3;
snapHeadDims=[3,4,2];
snapSlotWdth=1;
snapSlotDepthRel=0.9;

/* [Mountingholes] */
//enable mounting holes in the Side beams
enableMntSideBeams=true;
mntSideBeamSpcng=+47;
//enable mounting holes in the cross beams
enableMntXBeams=true; 
mntXBeamSpcng=28;

mntHoleDia=3.5;

/* [Countersink Tool]*/
//Countersunks max. Dia will be beamWdth
enableCounterSunks=true;
//the angle of the countersink
counterSunkAngle=90;
//how deep to do the countersunks
counterSinkDepth=3.5;


/* [Hidden] */
fudge=0.1;

sideBeamsLen=max(pcbHoleSpcng.y+blockDims.y,mntSideBeamSpcng+beamWdth);
xBeamsLen=max(pcbHoleSpcng.x,mntXBeamSpcng+beamWdth);

//countersink dimensions
cntrSnkDpth=beamHght-counterSinkDepth;
cntrSnkHght=(beamWdth/2)/tan(counterSunkAngle/2);
echo(cntrSnkDpth);

$fn=50;

if (showOriginal)
  %translate([16-55/2,2.5+38.5/2,0]) import("ampripper_support.stl");
  
support();

module support(){
  
  //-- Beams --
  //left and right
  difference(){
    union(){
      for (ix=[-1,1])
        translate([ix*pcbHoleSpcng.x/2,0,0]) rotate(90) beam([sideBeamsLen,beamWdth,beamHght]);

      //cross beams
      for (iy=[-1,1])
        translate([0,iy*xBeamSpcng/2,0]) beam([xBeamsLen,beamWdth,beamHght]);
    }
    if (enableMntSideBeams)
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*pcbHoleSpcng.x/2,iy*mntSideBeamSpcng/2,-fudge/2]){
            cylinder(d=mntHoleDia,h=beamHght+fudge);
            if (enableCounterSunks) translate([0,0,cntrSnkDpth]) counterSink();
            }
    if (enableMntXBeams)
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*mntXBeamSpcng/2,iy*xBeamSpcng/2,-fudge/2]){
          if (enableCounterSunks) translate([0,0,cntrSnkDpth]) counterSink(); 
            cylinder(d=mntHoleDia,h=beamHght+fudge);
            }
  }
  
  //blocks and pins
  for (ix=[-1,1], iy=[-1,1])
    translate([ix*pcbHoleSpcng.x/2,iy*pcbHoleSpcng.y/2,blockDims.z/2]){
      //blocks
      cube(blockDims,true);
      //snap pins
      translate([0,0,blockDims.z/2]) snap();
      }
  
  
}

*snap();
module snap(){
  slotDims=[max(snapHeadDims.x,snapPinDia)+0.1,snapSlotWdth,(snapPinHght+snapHeadDims.z)*snapSlotDepthRel];
  slotZOffset=snapPinHght+snapHeadDims.z-slotDims.z;
  difference(){
    union(){
      cylinder(d=snapPinDia,h=snapPinHght);
      translate([0,0,snapPinHght]) scale([snapHeadDims.x,snapHeadDims.y,snapHeadDims.z*2]) difference(){
        sphere(d=1);
        translate([0,0,-0.5]) cube(1,true);
      }
    }
    translate([0,0,slotDims.z/2+slotZOffset]) cube(slotDims,true);
  }
  
}

module counterSink(){
  ovHght=cntrSnkDpth+beamHght*3;
  translate([0,0,cntrSnkHght-0.01]) cylinder(d=beamWdth,h=ovHght-cntrSnkHght+fudge);
  cylinder(d1=0,d2=beamWdth,h=cntrSnkHght);
  
}

module beam(size=[10,beamWdth,beamHght]){
  //beams have an halfed-oval cross section
  rotate([90,0,90]) linear_extrude(size.x,center=true) scale([beamWdth,beamHght*2]) difference(){
    circle(d=1);
    translate([-0.5,-1]) square(1);
    }
  
}