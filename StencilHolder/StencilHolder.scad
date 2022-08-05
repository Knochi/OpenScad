$fn=20;
maxWdth=180;
baseThck=16.2;
pcbThck=1.6;
stnclThck=0.5;
spacerThck=4;
screwCount=4;
bearingDims=[8,22,7]; //di, do, thck
rodDia=8;
pfSpcng=0.15; //Spacing for press Fit
topClampDims=[maxWdth,30,6.5];
botClampDims=[maxWdth,30,7];
topClampOffset=[0,21,0];
botClampOffset=[0,21,baseThck+pcbThck-botClampDims.z];
fudge=0.1;

/* [Hidden] */
M4_s=7; //width of M4 nut
M4_sDia=2/sqrt(3)*(M4_s);
M4_thck=3.2;
M3_s=5.5; //width of M4 nut
M3_sDia=2/sqrt(3)*(M3_s);
M3_thck=2.4;


for (ix=[-1,1])
  translate([ix*((maxWdth+10)/2+spacerThck),0,0]) rotate([-90,0,ix*90]){
    color("blue") rotate([90,0,0]) rodHolder(); // import("x1_rodholder.stl");
    color("silver") translate([0,-(baseThck+pcbThck),-2]) bearing();
    color("darkGreen") translate([0,-(baseThck+pcbThck),5]) spacerRing();//import("x5_spacerring.stl");
  }

translate([0,0,botClampOffset.z]) bottomClamp();
  //import("x2_bottomclamp.stl");

color("darkred")translate([0,21,baseThck+pcbThck+1+stnclThck]) rotate([0,180,0]) import("x3_topclamp.stl");

color("grey") for (ix=[-(screwCount-1)/2:(screwCount-1)/2])
  translate([ix*maxWdth/screwCount,topClampOffset.y,baseThck+pcbThck+topClampDims.z+15]) mirror([0,0,1]) import("x4_knop.stl");

//simple bearing (id, od, thick)
module bearing(dims=[8,22,7]){
  linear_extrude(dims.z) difference(){
    circle(d=dims[1]);
    circle(d=dims[0]);
  }
}

*bottomClamp();
module bottomClamp(){
  *import("x2_bottomclamp.stl");
  hngDims=[10,18,20];
  //clmpDims=[maxWdth,30,7];
  hngDrillDia=3.4;
  clmpDrillDia=4.4;
  
  for (ix=[-1:1])
    translate([ix*(maxWdth-hngDims.x)/2,0,0]) hingeBlock();
  
  translate([0,botClampOffset.y,0])
    difference(){
      translate([0,0,botClampDims.z/2]) cube(botClampDims,true);
      for (ix=[-(screwCount-1)/2:(screwCount-1)/2])
        translate([ix*maxWdth/screwCount,0,-fudge/2]){
          cylinder(d=clmpDrillDia,h=botClampDims.z+fudge);
          cylinder(d=M4_sDia+pfSpcng,h=M4_thck+fudge,$fn=6);
        }
      
    }
  
  module hingeBlock(){
    difference(){
      translate([0,0,hngDims.z/2]) cube(hngDims,true);
      translate([0,0,botClampDims.z]){
        cylinder(d=hngDrillDia,h=hngDims.z-botClampDims.z+fudge);
        rotate([0,90,0]) cylinder(d=rodDia,h=hngDims.x+fudge,center=true);
      }
      translate([hngDims.x/4+fudge/2,0,hngDims.z*0.7]) cube([hngDims.x/2+fudge,M3_s+fudge,M3_thck+fudge],true);
      translate([0,0,hngDims.z*0.7]) cylinder(d=M3_sDia,h=M3_thck+fudge,$fn=6,center=true);
    }
  }
}

*spacerRing();
module spacerRing(){
  *import("x5_spacerring.stl");
  difference(){
    union(){
      cylinder(d=14,h=3.2);
      cylinder(d=10,h=4);
    }
    translate([0,0,-fudge/2]) cylinder(d=8,h=4+fudge);
  }
}


*rodHolder();
module rodHolder(){
  
  wallThck=3;
  *rotate([-90,0,0]) import("x1_rodholder.stl");
  //foot
  ftDims=[48,bearingDims.z+wallThck,5];
  drillDist=38;
  drillDia=4.4;
  
  linear_extrude(ftDims.z) difference(){
    square([ftDims.x,ftDims.y],true);
    for (ix=[-1,1])
      translate([ix*drillDist/2,0]) circle(d=drillDia);
  }
  //bearing holder
  
  translate([0,0,baseThck+pcbThck]) rotate([-90,0,0]) 
    difference(convexity=2){
      linear_extrude(ftDims.y,center=true,convexity=3) difference(){
        union(){
          circle(d=bearingDims[1]+wallThck*2);
          translate([0,(baseThck+pcbThck)/2]) square([bearingDims[1]+wallThck*2,baseThck+pcbThck],true);
        }
        circle(d=bearingDims[1]-4+pfSpcng*2);
      }
      translate([0,0,-ftDims.y/2+(ftDims.y-bearingDims.z)]) cylinder(d=bearingDims[1]+pfSpcng*2,h=bearingDims.z+fudge);
    }
}