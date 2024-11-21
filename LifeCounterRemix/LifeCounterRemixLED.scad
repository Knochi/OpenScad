// This is a remix of https://www.thingiverse.com/thing:3351902
// Tolerances where to thight and want to have it customizable

//This is the original Font used in the provided STL
//use <./Fonts/MorrisRomanBlack/MorrisRoman-Black.ttf>

/* [General] */
minWallThck=1.4;
ringsCnt=3;
spcng=0.3;

/* [Spring] */
sprThck=1; //thickness of spring arms
sprWdth=3.85; //width of spring arms
sprDia=21.6; //outer Dia of spring

/* [Ring] */
rngWdth=8.33;
rngSize=15; //inner radius of digitRing
rngSpcng=0.2; //spacing between the rings and to sides
revDigits=false; //reverse order of digits
rngFont="Morris Roman:style=Bold";
rngFntSz=9;

/* [Tube] */
tbDia=10.5;
ndgDims=[2.0,1.3]; 

/* [Clip] */
clipXYDims=[6,4];

/* [Side] */
sideDia=36; //outer dia of octagong
sideWdth=10;
feetProtrude=0.15; //percent
revArrows=true;
noSupportMod=false;

/* [LED] */
enableLED=true;

/* [show] */
showSTL=false; //show the original STL
showRings=true;
showSprings=true;
showTube=true;
showClip=true;
showSide=true;
showCut="none"; //["none","x-y","y-z","x-z"]
cutOffset=0;
isolate="none"; //["none","spring","clip","left side", "right side", "tube", "ring", "tuneSpring", "LED"]


/*[Hidden]*/
fudge=0.1;
digits=10; //some submodules doesn't calculate radii correctly when this changes!
tubeZPos=0.5*sqrt(5+2*sqrt(5))*sideDia*sin(18); ;
tbLen=ringsCnt*rngWdth+minWallThck*2+(ringsCnt+1)*rngSpcng;
sideXPos=ringsCnt/2*rngWdth+rngSpcng*(ringsCnt+1)/2;
ovDims=[(sideXPos+sideWdth*(1+feetProtrude))*2,sideDia*(1+feetProtrude),tubeZPos*2];
//clipLen=tbLen+sideWdth+minWallThck;//was 40.16;
clipLen=sideWdth+ringsCnt*rngWdth+(ringsCnt+1)*rngSpcng+minWallThck*2.5;
axisRotation= enableLED ? -(36+180) : 0;
$fn=100;


// --- assembly ---
difference(){
  union(){
    if (showSprings)
      for (ix=[-(ringsCnt-1)/2:(ringsCnt-1)/2])
      translate([ix*rngWdth,0,tubeZPos]) 
        rotate([90,axisRotation,90]) translate([0,0,-rngWdth/2]) spring();

    if (showTube)
      translate([0,0,tubeZPos]) rotate([90,axisRotation,90]) translate([0,0,-tbLen/2]) tube();

    if (showSide){
      translate([-sideXPos,0,tubeZPos]) 
        rotate([90,0,-90]) side(isLeft=true);
      translate([sideXPos,0,tubeZPos]) 
        rotate([90,0,90]) side(isLeft=false);
    }

    if (showRings)
      for (ix=[-(ringsCnt-1)/2:(ringsCnt-1)/2])
      translate([ix*(rngWdth+rngSpcng),0,tubeZPos]) 
        rotate([0,-90,0]) translate([0,0,-rngWdth/2]) ring();

    if (showClip)
      translate([-sideXPos-sideWdth,0,tubeZPos]) rotate([0,-axisRotation,-90]) clip();
  }
  if (showCut=="x-y")
    color("darkred") translate([0,0,tubeZPos+ovDims.z/4+cutOffset]) cube([ovDims.x+fudge,ovDims.y+fudge-cutOffset*2,ovDims.z/2+fudge],true);
  else if (showCut=="y-z")
    color("darkred") translate([ovDims.x/4+cutOffset,0,ovDims.z/2]) cube([ovDims.x/2+fudge-cutOffset*2,ovDims.y+fudge,ovDims.z+fudge],true);
  else if (showCut=="x-z")
    color("darkred") translate([0,-ovDims.y/4+cutOffset,ovDims.z/2]) cube([ovDims.x+fudge,ovDims.y/2+fudge+cutOffset*2,ovDims.z+fudge],true);
}

// -- isolate --
if (isolate=="spring")
  !spring();
else if (isolate=="clip")
  !clip();
else if (isolate=="left side")
  !side(isLeft=true);
else if (isolate=="right side")
  !side(isLeft=false);
else if (isolate=="tube")
  !tube();
else if (isolate=="ring")
  !ring();
else if (isolate=="tuneSpring")
  !union(){
    rotate(360/(digits*2)) ring();
    spring();
  }
else if (isolate=="testMagnets")
  !magTest();

*clip();
module clip(){
  tipDims=[4.4,4.5];
  tipPoly=[[-tipDims.x/2,0],[tipDims.x/2,0],[0,tipDims.y]];
  if (showSTL)
    %rotate(-90) translate([-12.54,43.9-6/2,0]) import("Life_Counter_clip.stl");

  linear_extrude(clipXYDims.y,convexity=3,center=true) difference(){
    union(){
      translate([-clipXYDims.x,0]) square([clipXYDims.x*2,minWallThck*2]);
      translate([-clipXYDims.x/2,0]) square([clipXYDims.x,clipLen]);
      //arrow tip
      for (ix=[-1,1])
        translate([ix*(clipXYDims.x-minWallThck)/2,clipLen]) polygon(tipPoly);
    }
    //slot
    hull() for (iy=[0,1])
      translate([0,minWallThck*3+iy*(clipLen/2-minWallThck*2)]) circle(d=clipXYDims.x-minWallThck*2);
    //springy tip
    hull(){
      translate([0,minWallThck*3+(clipLen/2+minWallThck*2)]) circle(d=clipXYDims.x-minWallThck*3);
      translate([0,minWallThck*3+(clipLen+minWallThck*2)]) circle(d=clipXYDims.x-minWallThck*1.5);
    }
    
  }
}

module spring(){
  cutWdth=sprDia/2-minWallThck-sprThck-tbDia/2-spcng;
  mainCutAng=[18,131]; //start and end of main cuts
  mainCutDia=tbDia/2+minWallThck+spcng;
  tipDia=2.5;
  tipAng=2*asin((tipDia/2)/sprDia); //angle from tip dia
  if (showSTL)
    %translate([0.2,-12.85-21.6/2,0]) import("Life_Counter_spring.stl");
  
  //spring arms
  difference(){
    //body
    linear_extrude(rngWdth,convexity=2) difference(){
      union(){
        circle(d=sprDia);
        //tips
        for (im=[0,1]) mirror([im,0])
          rotate(90-360/(digits)) translate([sprDia/2,0]) circle(d=tipDia);
      }
      circle(d=tbDia+spcng*2);
    }
  //rotary cuts to the left and right side
    for (im=[0,1]) mirror([im,0,0]){
      //main
      rotate(90+mainCutAng[0]) rotate_extrude(angle=mainCutAng[1]-mainCutAng[0]) 
        translate([mainCutDia,-fudge/2]) square([cutWdth,rngWdth+fudge]);
      rotate(90+mainCutAng[1]) translate([mainCutDia+cutWdth/2,0,-fudge/2]) cylinder(d=cutWdth,h=rngWdth+fudge);
      //tips
      rotate(90+mainCutAng[0]) rotate_extrude(angle=360/digits-mainCutAng[0]-tipAng)
        translate([mainCutDia,-fudge/2]) square([cutWdth+sprThck+fudge,rngWdth+fudge]); 
      //flatten
      rotate(90+mainCutAng[0]) rotate_extrude(angle=mainCutAng[1]-mainCutAng[0]+15) 
        translate([mainCutDia,sprWdth]) square([cutWdth+sprThck+tipDia/2+fudge,rngWdth-sprWdth+fudge]);
    }
    //nudge
    translate([0,-tbDia/2,rngWdth/2]) cube([ndgDims.x+spcng*2,(ndgDims.y+spcng)*2,rngWdth+fudge],true);
    //tip cuts
    for (im=[0,1]) mirror([im,0])
      rotate(90-360/(digits)) translate([sprDia/2,0,0]) rotate([0,-45,0]) translate([0,0,-tipDia/2]) cube([tipDia*2,tipDia,tipDia],true);
  }
}

*tube(true);
module tube(cut=false){
 
  poly=[[-tbDia/2+minWallThck,0],[-(clipXYDims.y/2+spcng),minWallThck+spcng],
        [(clipXYDims.y/2+spcng),minWallThck+spcng],[tbDia/2-minWallThck,0]
  ];
  
  if (cut)
    translate([0,0,minWallThck]) rotate([0,180,0]) difference(){
      union(){
        translate([0,0,-spcng]) cylinder(d=tbDia+spcng*2,h=minWallThck+spcng*2);
        translate([0,-tbDia/2,minWallThck/2]) cube([ndgDims.x+spcng*2,(ndgDims.y+spcng)*2,minWallThck+spcng*2],true);
      }
      //TODO calculate proper spcng 
      translate([0,0,-spcng]) rotate([90,0,90]) linear_extrude(tbDia+spcng*2+fudge,center=true) polygon(poly);
      
    }

  else{
    if (showSTL)
    %translate([-24-10.5/2,42.75-4.3/2,0]) import("Life_Counter_tube.stl");

    difference(){
      linear_extrude(height = tbLen,convexity=3){
        difference(){
          union(){
            circle(d=tbDia);
            translate([0,-tbDia/2]) square([ndgDims.x,ndgDims.y*2],true);
          }
          square([clipXYDims.x,clipXYDims.y]+[spcng*2,spcng*2],true);
        }
      } 
      if (noSupportMod){
        translate([0,0,-fudge/2]) 
         rotate([90,0,90]) linear_extrude(tbDia+fudge,center=true) polygon(poly);
        translate([0,0,tbLen+fudge/2]) 
         rotate([-90,0,90]) linear_extrude(tbDia+fudge,center=true) polygon(poly);
      }
    }
  }
}

*ring();
module ring(){
  ri=rngSize;
  chmfr=0.5;
  emboss=1;
  roChmf=(ri-chmfr)*(1/cos(180/digits));
  ro=ri*(1/cos(180/digits)); //works only for 10 digits! //TODO make it work for n-gons
  nudgeDia=3.6+fudge;
  //ro=ri*tan(180/digits)/(cos(180/digits));
  if (showSTL)
    %rotate(-18) translate([(15.08-14.93)/2,-41.11-31.55/2,0]) import("Life_Counter_ring.stl");
  //circle(ri);
  rotate(-36) difference(){
    //body
    rotate(18){
      cylinder(r1=roChmf,r2=ro,h=chmfr,$fn=digits);
      translate([0,0,chmfr]) cylinder(r=ro,h=rngWdth-2*chmfr,$fn=digits);
      translate([0,0,rngWdth-chmfr]) cylinder(r2=roChmf,r1=ro,h=chmfr,$fn=digits);
    }
    //nudges for spring
    translate([0,0,-fudge/2]) linear_extrude(rngWdth+fudge) {
      circle(d=sprDia+spcng*2);
      for (ir=[0:360/digits:360-(360/digits)]) rotate(ir) translate([sprDia/2-fudge,0]) circle(d=nudgeDia,$fn=4); //TODO needs tuning
    }
    //digits
    for (i=[0:(digits-1)]){
      inc= revDigits ? 360/digits : -360/digits;
      rotate(i*inc)
        translate([ri-emboss,0,rngWdth/2]) 
          rotate([0,90,0]) linear_extrude(emboss+fudge) 
            text(size=rngFntSz,str(i),valign="center",halign="center",font=rngFont);
    }
  }
  

}

*side(true);
module side(isLeft=false){
  a=sideDia*sin(18); //decagon side length
  ri=0.5*sqrt(5+2*sqrt(5))*a; 
  foodDims=[a,minWallThck*2,sideWdth*(1+feetProtrude)];
  tipRoomDia=12+spcng*2;

  //box for arrows
  emboss=1; //emboss of the arrows
  chmfSmall=1; //decorative inside
  chmfBig=sideWdth/3; //decorative outside

  boxRot= isLeft ? 90-36 : 90+36;
  axRot = isLeft ? axisRotation : -axisRotation;
  
  //concept for LED lightning
  if (enableLED && isLeft){
      translate([00,0,5.0]) rotate([90,0,-36]) translate([0,0,-11]) LED(bendRad=[10,6],bendAng=[157,109]);
      %for (ix=[-1,1])
        translate([ix*10,0,5.3]) coinCell("LR41");
    }
    
  if (showSTL)
    if (isLeft)
      %rotate(90) translate([-19.92+4.1/2,9.69+3,0]) import("Life_Counter_sides.stl");
    else
      %rotate(-90) translate([19.74-4.1/2,9.69+3,0]) import("Life_Counter_sides.stl");

  difference(){
    body();
    //recess for tube
    if (noSupportMod) //add a chamfered part from the tube
      tube(cut=true);
    else 
      rotate(axRot) translate([0,0,-fudge]) linear_extrude(minWallThck+fudge+spcng) {
        circle(d=tbDia+spcng*2);
        translate([0,-tbDia/2]) square([ndgDims.x+spcng,ndgDims.y*2+spcng],true);
      }
    translate([0,0,-fudge/2]) rotate(axRot) linear_extrude(sideWdth-minWallThck+fudge) {
      square([clipXYDims.x,clipXYDims.y]+[spcng*2,spcng*2],true);
    }
    if (isLeft)
      //recess for clip foot
    translate([0,0,sideWdth-minWallThck*2-spcng]) rotate(axisRotation) linear_extrude(minWallThck*2+fudge+spcng) {
      square([clipXYDims.x*2,clipXYDims.y]+[spcng*2,spcng*2],true);
    }
    
    if (isLeft && enableLED && isolate=="LED")
      color("darkRed") translate([0,0,-fudge/2]) linear_extrude(20) 
        polygon([[0,0],[20,tan(52)*20],[20,0]]) ;
        
    else {  
      //room for clip tip
      translate([0,0,minWallThck*2.5-spcng]) rotate([90,0,axRot]) 
        rotate_extrude(angle=180) translate([0,-clipXYDims.y/2-spcng]) square([tipRoomDia/2,clipXYDims.y+spcng*2]);
    }
    
    //arrows
    arRot= revArrows ? [90,-90,90] : [90,90,90];
    arZPos= revArrows ? sideWdth/2-chmfSmall : sideWdth/2 ; 
    rotate(boxRot) 
      translate([ri+fudge-emboss,0,arZPos]) 
        rotate(arRot) linear_extrude(emboss+fudge) circle(d=a*0.8,$fn=3);
  }
  //feet
  for (im=[0,1]) mirror([im,0,0])
    hull(){
      translate([sideDia*0.4,-ri+minWallThck,foodDims.z/2]) 
        //cube(foodDims,true);
        chamferedCube(foodDims, chmfSmall,true);
      intersection(){
        body();
        translate([sideDia/2-foodDims.x/2,-clipXYDims.y/2-minWallThck-spcng*2,foodDims.z/2]) 
          cube(foodDims,true);
          
      }
  }
  

  module body(){
    cylinder(d1=sideDia-chmfSmall*2,d2=sideDia,h=chmfSmall,$fn=digits);
    translate([0,0,chmfSmall]) cylinder(d=sideDia,h=sideWdth-chmfBig-chmfSmall,$fn=digits);
  
      translate([0,0,sideWdth/1.5]) cylinder(d1=sideDia,d2=sideDia-chmfBig*2,h=chmfBig,$fn=digits);
      //arrow box
      rotate(boxRot) translate([ri-sideWdth/3,0,(sideWdth+chmfSmall)/2]) 
        chamferedCube([sideWdth/1.5,a+chmfSmall*2,sideWdth-chmfSmall],chmfSmall,true);
    }
  
}



// --- functions and helpers ---

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


module coinCell(type="custom",dia=11.6,h=5.4){
  coinDims= (type=="custom") ?  [dia,h] :
            (type=="LR45") ? [11.6,5.4] :
            (type=="V364") ? [6.8,2.2] :
            (type=="LR41") ? [7.9,3.6] : [10,3];
  
  cylinder(d=coinDims[0],h=coinDims[1]);
}

*LED();
module LED(bend=true, bendRad=[10,10],bendAng=[90,90]){
  bdyDia=5;
  bdyHght=8.6;
  rngDia=5.6;
  rngHght=1;
  leadDims=[0.5,0.5,25.4];
  cathodeZOffset=-1; //cathode is shorter than anode
  pitch=2.54;
  minRad=1.5;
  
  //body
  color("red"){
    translate([0,0,bdyHght-bdyDia/2]) sphere(d=bdyDia);
    cylinder(d=bdyDia,h=bdyHght-bdyDia/2);
    linear_extrude(rngHght) difference(){
      circle(d=rngDia);
      translate([bdyDia/2,-(rngDia+fudge)/2]) square([rngDia-bdyDia+fudge,rngDia+fudge]);    
    }
  }
  //leads
  if (bend) color("silver"){
    
    for (ix=[-1,1])
      translate([ix*pitch/2,0,-minRad/2]) cube([leadDims.x,leadDims.y,minRad],true);
    
    //small bend
    //Anode
    translate([-(minRad+pitch/2),0,-minRad]) rotate([-90,0,0]) 
      rotate_extrude(angle=90) translate([minRad,0]) square(leadDims.x,true);
    //Cathode
    translate([(minRad+pitch/2),0,-minRad]) rotate([90,180,0]) 
      rotate_extrude(angle=90) translate([minRad,0]) square(leadDims.x,true);
    
    //big bend
    //Anode
    translate([-minRad-pitch/2,0,bendRad[0]-minRad*2]) rotate([-90,90,0]) 
      rotate_extrude(angle=bendAng[0]) translate([bendRad[0],0]) square(leadDims.x,true);
    //Cathode
    translate([(minRad+pitch/2),0,bendRad[1]-minRad*2]) rotate([90,90,0]) 
      rotate_extrude(angle=bendAng[1]) translate([bendRad[1],0]) square(leadDims.x,true);
  }
  else
    color("silver"){
      translate([-pitch/2,0,-leadDims.z/2]) cube(leadDims,true);
      translate([pitch/2,0,-leadDims.z/2-cathodeZOffset/2]) cube(leadDims+[0,0,cathodeZOffset],true);
    }
}