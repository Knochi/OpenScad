// This is a remix of https://www.thingiverse.com/thing:3351902
// Tolerances where to thight and want to have it customizable

//This is the font used in the provided STLs
//you can download it at: https://www.1001freefonts.com/de/morris-roman-black.font
//put it in an subfolder "Fonts" to this project project and uncomment the following line
//if you install the font to system, the following line is not needed
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


/* [Digits] */
digReverse=false; //reverse order of digits
digFont = "Nasa"; // [Inter, Inter Tight, Lora, Merriweather Sans, Montserrat, Noto Emoji, Noto Sans, Nunito, Nunito Sans, Noto Sans SC, Open Sans, Open Sans Condensed, Oswald, Playfair Display, Plus Jakarta Sans, Raleway, Roboto, Roboto Condensed, Roboto Flex, Roboto Mono, Roboto Serif, Roboto Slab, Rubik, Source Sans 3, Ubuntu Sans, Ubuntu Sans Mono, Work Sans]

digStyle = "Regular"; // [Regular,Black,Bold,ExtraBol,ExtraLight,Light,Medium,SemiBold,Thin,Italic,Black Italic,Bold Italic,ExtraBold Italic,ExtraLight Italic,Light Italic,Medium Italic,SemiBold Italic,Thin Italic]

digSize=9;
//roof() needs to be enabled for this
digRoof=false;

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

/* [show] */
showRings=true;
showSprings=true;
showTube=true;
showClip=true;
showSide=true;
//digits for 2-color
showDigits=false; 
//indicators for 2-color
showIndicators=false;

showCut="none"; //["none","x-y","y-z","x-z"]
cutOffset=0;
isolate="none"; //["none","spring","clip","left side", "right side", "tube", "ring", "tuneSpring", "testMagnets", "digits","arrow"]


/*[Hidden]*/
fudge=0.1;
digits=10; //some submodules doesn't calculate radii correctly when this changes!
tubeZPos=0.5*sqrt(5+2*sqrt(5))*sideDia*sin(18); ;
tbLen=ringsCnt*rngWdth+minWallThck*2+(ringsCnt+1)*rngSpcng;
sideXPos=ringsCnt/2*rngWdth+rngSpcng*(ringsCnt+1)/2;
ovDims=[(sideXPos+sideWdth*(1+feetProtrude))*2,sideDia*(1+feetProtrude),tubeZPos*2];
//clipLen=tbLen+sideWdth+minWallThck;//was 40.16;
clipLen=sideWdth+ringsCnt*rngWdth+(ringsCnt+1)*rngSpcng+minWallThck*2.5;
digFontStyle = str(digFont , ":style=", digStyle);
$fn=100;

// --- assembly ---
difference(){
  union(){
    if (showSprings)
      for (ix=[-(ringsCnt-1)/2:(ringsCnt-1)/2])
      translate([ix*rngWdth,0,tubeZPos]) 
        rotate([90,0,90]) translate([0,0,-rngWdth/2]) spring();

    if (showTube)
      translate([0,0,tubeZPos]) rotate([90,0,90]) translate([0,0,-tbLen/2]) tube();

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
      translate([-sideXPos-sideWdth,0,tubeZPos-clipXYDims.y/2]) rotate(-90) clip();
    
    if (showDigits)
      for (ix=[-(ringsCnt-1)/2:(ringsCnt-1)/2])
        color("white") translate([ix*(rngWdth+rngSpcng),0,tubeZPos]) 
          rotate([0,-90,0]) translate([0,0,-rngWdth/2]) ring(true);
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
  
else if (isolate=="digits")
  !ring(true);
  
else if (isolate=="arrow")
  !side(isLeft=true,arrowOnly=true);
  
  
*clip();
module clip(){
  tipDims=[4.4,4.5];
  tipPoly=[[-tipDims.x/2,0],[tipDims.x/2,0],[0,tipDims.y]];

  linear_extrude(clipXYDims.y,convexity=3) difference(){
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


module ring(digitsOnly=false){
  ri=rngSize;
  chmfr=0.5;
  emboss=1;
  roChmf=(ri-chmfr)*(1/cos(180/digits));
  ro=ri*(1/cos(180/digits)); //works only for 10 digits! //TODO make it work for n-gons
  nudgeDia=3.6+fudge;
  inc= digReverse ? 360/digits : -360/digits;
  
  //ro=ri*tan(180/digits)/(cos(180/digits));
  if (digitsOnly){
    rotate(-36) digits();
  }
  else{
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
      digits(emboss+fudge);
    
    }
  } //else

  
  *digits();
  module digits(hght=emboss){
    for (i=[0:(digits-1)]){
      rotate(i*inc){
        translate([ri-emboss,0,rngWdth/2]) 
          rotate([0,90,0]) linear_extrude(hght) 
            text(size=digSize,str(i),valign="center",halign="center",font=digFontStyle);
        if (digRoof) translate([ri,0,rngWdth/2]) 
          rotate([0,90,0]) roof() 
            text(size=digSize,str(i),valign="center",halign="center",font=digFontStyle);
      }
    }
  }
}

*side();
module side(isLeft=false, arrowOnly=false){
  a=sideDia*sin(18); //decagon side length
  ri=0.5*sqrt(5+2*sqrt(5))*a; 
  foodDims=[a,minWallThck*2,sideWdth*(1+feetProtrude)];
  tipRoomDia=12+spcng*2;

  //box for arrows
  emboss=1; //emboss of the arrows

  chmfSmall=1; //decorative inside
  chmfBig=sideWdth/3; //decorative outside

  boxRot= isLeft ? 90-36 : 90+36;
  
  //arrow orientation
  arRot= revArrows ? [90,-90,90] : [90,90,90];
  arZPos= revArrows ? sideWdth/2-chmfSmall : sideWdth/2+chmfSmall ; 
          

  if (!arrowOnly) {
    difference(){
      body();
      //recess for tube
      if (noSupportMod)
        tube(true);
      else
        translate([0,0,-fudge]) linear_extrude(minWallThck+fudge+spcng) {
          circle(d=tbDia+spcng*2);
          translate([0,-tbDia/2]) square([ndgDims.x+spcng,ndgDims.y*2+spcng],true);
        }
      translate([0,0,-fudge/2]) linear_extrude(sideWdth-minWallThck+fudge) {
        square([clipXYDims.x,clipXYDims.y]+[spcng*2,spcng*2],true);
      }
      if (isLeft)
      //recess for clip foot
      translate([0,0,sideWdth-minWallThck*2-spcng]) linear_extrude(minWallThck*2+fudge+spcng) {
        square([clipXYDims.x*2,clipXYDims.y]+[spcng*2,spcng*2],true);
      }
      //room for clip tip
      else {  
        translate([0,0,minWallThck*2.5-spcng]) rotate([90,0,0]) 
          rotate_extrude(angle=180) translate([0,-clipXYDims.y/2-spcng]) square([tipRoomDia/2,clipXYDims.y+spcng*2]);
      }
      //recess for arrow
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
    }
    //arrow
  if (showIndicators || arrowOnly) color("white")
    rotate(boxRot) 
      translate([ri-emboss,0,arZPos])
        rotate(arRot){
          linear_extrude(emboss) circle(d=a*0.8,$fn=3);
          if (digRoof) translate([0,0,emboss]) linear_extrude(emboss,scale=0.7) circle(d=a*0.8,$fn=3);
          }
  
        
  module body(){
    cylinder(d1=sideDia-chmfSmall*2,d2=sideDia,h=chmfSmall,$fn=digits);
    translate([0,0,chmfSmall]) cylinder(d=sideDia,h=sideWdth-chmfBig-chmfSmall,$fn=digits);
    translate([0,0,sideWdth/1.5]) cylinder(d1=sideDia,d2=sideDia-chmfBig*2,h=chmfBig,$fn=digits);
    //arrow box
    rotate(boxRot) translate([ri-sideWdth/3,0,(sideWdth+chmfSmall)/2]) chamferedCube([sideWdth/1.5,a+chmfSmall*2,sideWdth-chmfSmall],chmfSmall,true);
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