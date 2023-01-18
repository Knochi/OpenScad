minWallThck=0.1;
fudge=0.1;

/* [show] */
showDebug=false;

$fn=100;

//test diameters
*for (i=[0.1:0.1:0.5])
  translate([0,150*(i-0.1),0]) snapTest(i);

//test openings
step=0.2;
start=2;
stop=3;
*for (i=[start:step:stop])
  difference(){
    translate([0,(1/step)*17.4*(i-start),0])
      snapTest(0.2,4.65-i);
    translate([0,(1/step)*17.4*(i-start),0])
      translate([19.4/2-1+fudge,0,1]) rotate([90,0,90]) linear_extrude(1) text(str(i),size=5,halign="center");
  }

module snapTest(snapSpcng=0.1,opngSpcng=0,width=20){
  snapDia=4.65;
  //snapSpcng=0.1;
  snapWdth=15.2;
  ovWdth=19.4;
  snapSlotDims=[1.6,10];
  opening = (opngSpcng) ? opngSpcng : snapDia+snapSpcng*2;

  snapOffset=4.8;
  intsectX= (showDebug) ? -snapWdth/2 : 0;

  if (intsectX) translate([0,0,snapOffset]) rotate([0,90,0]) cylinder(d=0.1,h=10);
  intersection(){
    difference(){
      translate([0,0,-20+snapOffset+snapDia/2+snapSpcng]) rotate([0,90,0]) cylinder(d=40,h=width,center=true);
      translate([0,0,snapOffset]) rotate([0,90,0]) cylinder(d=snapDia+snapSpcng*2,h=snapWdth,center=true);
      translate([0,0,snapOffset+snapDia/2+snapSpcng]) rotate([0,90,0]) cylinder(d=snapDia+snapSpcng*2+opening,h=snapWdth,center=true,$fn=4);
      for (ix=[-1,1]) translate([ix*(snapWdth-snapSlotDims.x)/2,0,snapOffset-snapDia/2-snapSpcng]) hull()
        for (iy=[-1,1]) translate([0,iy*(snapSlotDims.y-snapSlotDims.x)/2,0])
          cylinder(d=snapSlotDims.x,h=snapDia+snapSpcng+fudge);
                
    }
    translate([intsectX,0,(snapOffset+snapDia/2+snapSpcng)/2]) cube([width+fudge,12.9,snapOffset+snapDia/2+snapSpcng],true);
  }

}

shovel();
module  shovel() {
  dims=[40,40];
  radius=70;
  extAng=25; //extension angle (length of shovel)
  wallThck=2;
  slotWdth=3;
  slotCnt= floor((dims.y-wallThck)/(slotWdth+wallThck));
  attAngle=-25;
  echo(slotCnt);
  slotDist= (dims.y-wallThck*2)/slotCnt+wallThck/(slotCnt-1);

*rotate(17) translate([15.9,-33.6,0]) import("loeffel.stl");

  difference(){
    union(){
      cylinder(d=dims.x,h=dims.y);
      //extend smooth
      translate([0,radius+dims.x/2,0]) rotate(-90) rotate_extrude(angle=extAng) translate([radius,0]) square([dims.x,dims.y]);
    }
    //cut out opening
    translate([dims.x*1.5,dims.x,-fudge/2]) cylinder(d=dims.x*2.5,h=dims.y+fudge);
    //cut off the tip
    translate([0,radius+dims.x/2,-fudge/2]) rotate(-66.4) rotate_extrude(angle=10) translate([radius,0]) square([dims.x+1,dims.y+fudge]);
    //hollow
    translate([0,0,wallThck]) cylinder(d=dims.x-wallThck*2,h=dims.y-wallThck*2);
    translate([0,radius+dims.x/2-wallThck,wallThck]) rotate(-90) rotate_extrude(angle=30) translate([radius,0]) square([dims.x-wallThck*2,dims.y-wallThck*2]);
    //slots
    for (i=[0:slotCnt-1])
      translate([0,0,wallThck+i*slotDist]){
        rotate(180) rotate_extrude(angle=80) translate([dims.x/2-wallThck-fudge/2,0]) square([wallThck+fudge,slotWdth]);
        translate([0,radius+dims.x/2,0]) rotate(-90) rotate_extrude(angle=extAng-5) translate([radius+dims.x-wallThck*1.5,0]) square([wallThck*2,slotWdth]);
    }
  }
  //attach interface
  rotate(attAngle) translate([-dims.x/2+wallThck,0,dims.y/2]) rotate([0,-90,0]) snapTest(0.2,4.65-2.8,dims.y);
}