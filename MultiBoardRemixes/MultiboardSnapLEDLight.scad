$fn=50;
pcbDia=18.6;
fudge=0.1;
latSpcng=+0.25;
zSpcng=0.1;
lidDia=21.6;
lidLensThck=0.6;
pcbZOffset=1.1;

/* [show] */
showLid=true;
showPCB=true;
showSnap=true;
sectionCut=true;

difference(){
  union(){
    if (showLid) lid();
    if (showPCB) PCB();
    if (showSnap) snap();
  }
  if (sectionCut) color("darkRed") translate([0,(6+fudge/2),4.5]) cube([24+fudge,12+fudge,9+fudge],true);
}

//lid
module lid(){
  sprngSlt=1;
  difference(){
    union(){
      translate([0,0,0.4]) rotate(180/8) cylinder(d=lidDia,h=2.6,$fn=8);
      rotate(180/8) cylinder(d1=lidDia-2.1,d2=lidDia,h=0.4,$fn=8);
    }
    //cutout for battery holder
    translate([+0,0,1.5+fudge/2]) cube([4,20,1+fudge],true);
    //cutout for PCB flats
    translate([+0,0,2.5+fudge/2]) cube([18,20,1+fudge],true);
    //cutout for PCB circlular
    translate([0,0,lidLensThck]) cylinder(d=pcbDia-1,h=2-lidLensThck+fudge);
    //cutout for snap springiness
    for (ix=[-1,1])
      translate([ix*(18/2-sprngSlt/2),0,2.5]) cube([sprngSlt,20,3],true);
    //part cutouts
    rotate(158) translate([8.4,0,1.5+fudge/2]) cube([1.4,3,1+fudge],true);
    rotate(233) translate([8.4,0,1.5+fudge/2]) cube([1.4,3,1+fudge],true);
    
  }
  //snaps
  for (im=[0,1])
    mirror([im,0,0]) translate([9.98,0,2.3]) snapHook();
  //center dome
  translate([0,0,lidLensThck]) cylinder(d=3,h=2-lidLensThck);
  
}

module snap(){//snap
  difference(){
    solidSnap();
    translate([0,0,-fudge]) rotate(180/8) cylinder(d=lidDia+latSpcng,h=3+fudge+latSpcng,$fn=8);
    cylinder(d=17.0,h=10);
    for (iy=[-1,1])
      translate([0,iy*8,6.5/2]) cube([3,3,6.5],true);
    for (im=[0,1])
      mirror([im,0,0]) translate([9.98,0,2.3]) snapHook(width=6,spacing=latSpcng-0.08);
    
  }
}
  
module solidSnap(){
  import("Multiboard Snap.stl",convexity=3);
  rotate(180/8) cylinder(d=19,h=8.8,$fn=8);
}

module PCB(){
  color("darkgreen") translate([0,0,1+fudge])
    rotate([180,0,0]) translate([-17.5/2,-18.6/2,-5.83]) 
      import("D18X6.5MM KC012-13.STL",convexity=3);
}
    
*snapHook();
module snapHook(spacing=0.0, width=5){
  dia=1;
  height=2.6;
  rotate([90,0,0]) linear_extrude(width,center=true) difference(){
    offset(spacing) hull(){
      circle(d=dia+spacing);
      translate([-fudge/2,-0.6]) square([fudge,height+spacing],true);
    }
    translate([-(fudge+dia)/2,-0.6]) square([fudge+dia,height+spacing*3],true);
  }
}
