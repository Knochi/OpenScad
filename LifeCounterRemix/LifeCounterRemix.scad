// This is a remix of https://www.thingiverse.com/thing:3351902
// Tolerances where to thight and want to have it customizable

/* [General] */
minWallThck=6.75-5.35;
spcng=0.1;

/* [Spring] */
sprThck=1; //thickness of spring arms
sprWdth=3.85; //width of spring arms
sprDia=21.6; //outer Dia of spring

/* [Ring] */
digits=10;
digitWdth=8.33;

/* [Tube] */
tbDia=10.5;
ndgDims=[2.0,1.3]; 

/* [Clip] */
clipDims=[5.97,4.09];

/* [Side] */
sideDia=36; //outer dia of octagong
sideWdth=10;

/* [show] */
showSpring=true;
showTube=true;
showSide=true;
sideIsLeft=true;

/*[Hidden]*/
fudge=0.1;
$fn=100;

if (showSpring)
  spring();
if (showTube)
  tube();
if (showSide)
  side();

module spring(){
  cutWdth=sprDia/2-minWallThck-sprThck-tbDia/2-spcng;
  mainCutAng=[18,131]; //start and end of main cuts
  mainCutDia=tbDia/2+minWallThck+spcng;
  tipDia=2.2;
  tipAng=2*asin((tipDia/2)/sprDia); //angle from tip dia
  //template
  %translate([0.2,-12.85-21.6/2,0])
    import("Life_Counter_spring.stl");

  //spring arms
  difference(convexity=4){
    //body
    linear_extrude(digitWdth) difference(convexity=3){
      union(){
        circle(d=sprDia);
        for (im=[0,1]) mirror([im,0])
          rotate(90-360/(digits)) translate([sprDia/2,0]) circle(d=tipDia);
      }
      circle(d=tbDia+spcng*2);
    }
  //rotary cuts to the left and right side
    for (im=[0,1]) mirror([im,0,0]){
      //main
      rotate(90+mainCutAng[0]) rotate_extrude(angle=mainCutAng[1]-mainCutAng[0]) 
        translate([mainCutDia,-fudge/2]) square([cutWdth,digitWdth+fudge]);
      rotate(90+mainCutAng[1]) translate([mainCutDia+cutWdth/2,0,-fudge/2]) cylinder(d=cutWdth,h=digitWdth+fudge);
      //tips
      rotate(90+mainCutAng[0]) rotate_extrude(angle=360/digits-mainCutAng[0]-tipAng)
        translate([mainCutDia,-fudge/2]) square([cutWdth+sprThck+fudge,digitWdth+fudge]); 
      //flatten
      rotate(90+mainCutAng[0]) rotate_extrude(angle=mainCutAng[1]-mainCutAng[0]+15) 
        translate([mainCutDia,sprWdth]) square([cutWdth+sprThck+tipDia/2+fudge,digitWdth-sprWdth+fudge]);
    }
    //nudge
    translate([0,-tbDia/2,digitWdth/2]) cube([ndgDims.x+spcng*2,(ndgDims.y+spcng)*2,digitWdth+fudge],true);
  }
}

module tube(){
  tbLen=29.1;
  %translate([-24-10.5/2,42.75-4.3/2,0])
    import("Life_Counter_tube.stl");
  linear_extrude(height = tbLen){
    difference(){
      union(){
        circle(d=tbDia);
        translate([0,-tbDia/2]) square([ndgDims.x,ndgDims.y*2],true);
      }
      square(clipDims+[spcng*2,spcng*2],true);
    }
  } 
}

!ring();
module ring(){
  %translate([0,-41.11,0]) import("Life_Counter_ring.stl");
}

module side(isLeft=true){
  a=sideDia*sin(18); //decagon side length
  ri=0.5*sqrt(5+2*sqrt(5))*a; 
  echo(a,ri);
  %rotate(90) translate([-19.92+4.1/2,9.69+3,0]) import("Life_Counter_sides.stl");
  difference(){
    union(){
      cylinder(d=sideDia,h=sideWdth/1.5,$fn=10);
      translate([0,0,sideWdth/1.5]) cylinder(d1=sideDia,d2=28.3,h=sideWdth/3,$fn=10);
    }
    translate([0,0,-fudge]) linear_extrude(2+fudge) {
      circle(d=tbDia+spcng); //only 1 spncg for press fit
      translate([0,-tbDia/2]) square([ndgDims.x+spcng,ndgDims.y*2+spcng],true);
    }
    translate([0,0,-fudge/2]) linear_extrude(sideWdth+fudge) {
      square(clipDims+[spcng*2,spcng*2],true);
    }
    translate([0,0,sideWdth-minWallThck*2]) linear_extrude(sideWdth+fudge) {
      square([clipDims.x*2,clipDims.y]+[spcng*2,spcng*2],true);
    }
  }
  //arrow
  chmf=0.7;
  rotate(36*1.5) translate([ri-sideWdth/3,0,sideWdth/2]) chamferedCube([sideWdth/1.5,a+chmf*2,sideWdth],chmf,true);
}

function toRad(angDeg=90)=angDeg*PI/180;

*chamferedCube(method="hull");
module chamferedCube(size=[10,15,20], chamfer=1, center=false, method="hull"){
  //chamfered cube from intersected polygon
  xPoly=[
    [-size.y/2        , size.z/2-chamfer],
    [-size.y/2+chamfer, size.z/2],
    [ size.y/2-chamfer, size.z/2],
    [ size.y/2        , size.z/2-chamfer],
    [ size.y/2        ,-size.z/2+chamfer],
    [ size.y/2-chamfer,-size.z/2],
    [-size.y/2+chamfer,-size.z/2],
    [-size.y/2        ,-size.z/2+chamfer]
  ];
  yPoly=[
    [-size.x/2        , size.z/2-chamfer],
    [-size.x/2+chamfer, size.z/2],
    [ size.x/2-chamfer, size.z/2],
    [ size.x/2        , size.z/2-chamfer],
    [ size.x/2        ,-size.z/2+chamfer],
    [ size.x/2-chamfer,-size.z/2],
    [-size.x/2+chamfer,-size.z/2],
    [-size.x/2        ,-size.z/2+chamfer]
  ];
  zPoly=[
    [-size.x/2        , size.y/2-chamfer],
    [-size.x/2+chamfer, size.y/2],
    [ size.x/2-chamfer, size.y/2],
    [ size.x/2        , size.y/2-chamfer],
    [ size.x/2        ,-size.y/2+chamfer],
    [ size.x/2-chamfer,-size.y/2],
    [-size.x/2+chamfer,-size.y/2],
    [-size.x/2        ,-size.y/2+chamfer]
  ];

  centerOffset= center ? [0,0,0] : size/2;
  if (method=="intersect")
    translate(centerOffset) intersection(){
      rotate([90,0,90]) translate([0,0,-size.x/2]) linear_extrude(size.x) polygon(xPoly);
      rotate([90,0,0]) translate([0,0,-size.y/2]) linear_extrude(size.y) polygon(yPoly);
      translate([0,0,-size.z/2]) linear_extrude(size.z) polygon(zPoly);
    }
  else {  
    hull() for (ix=[-1,1],iy=[-1,1],iz=[-1,1])
      translate([ix*(size.x/2-chamfer),iy*(size.y/2-chamfer),iz*(size.z/2-chamfer)]) octahedron(chamfer);
  }
}

*octahedron();
module octahedron(r=10){
  //regular octahedron a=2*r/srqt(2)
  verts=[
    [-r, 0, 0], //0 left
    [ 0, r, 0], //1 back
    [ r, 0, 0], //2 right
    [ 0,-r, 0], //3 front
    [ 0, 0, r], //4 top
    [ 0, 0,-r]  //5 bottom
  ];
  faces=[
    [0,4,3], //CW
    [0,5,1], //CW
    [0,3,5], //CW
    [0,1,4], //CW
    [2,4,1], 
    [2,1,5],
    [2,5,3],
    [2,3,4]
  ];
  polyhedron(verts,faces);
}