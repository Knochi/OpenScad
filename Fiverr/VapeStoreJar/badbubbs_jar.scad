include <BOSL2/std.scad>
include <BOSL2/threading.scad>

/* [Dimensions] */
ovDia=120;
//overall height including sprokes
ovHght=127;
minWallThck=1.2;
//minimum thickness for roof and floor
minFloorThck=1;
//must be smaller than ovDia
jarDia=100;
//sealingWdth
sealWdth=4;
//sealing thickness
sealThck=1;

/* [Rim] */
spokeCount=12;
spokeWdth=2;
spokeHght=5;
//how far to lift the center of the spokes
spokeCenterLift=50;
centerPostDia=7;
//height for the lid without sprokes
rimHght=20;
rimWallThck=3;
propeller=0;

/* [Logo] */
logoSizeRel=0.62; //[0.2:0.05:2]
logoXOffset=-8;
logoYOffset=-5;
fillColor="#b9d544"; 
fillThck=1;
highlightColor="#EEEEEE";
highlightThck=1;
outlineColor="#222222";
outlineThck=1;
jokeColor="#444444";
jokeThck=1;


/* [show] */
showLid=true;
showspokes=true;
showTopLogo=true;
showInnerLogo=true;
showLogoFill=true;
showLogoOutline=true;
showLogoHighlight=true;
showLogoJoke=true;
showRim=true;
showLidFloor=false;
showJar=true;

quality=48; //[20:4:200]

/* [hidden] */
$fn=quality;
fudge=0.1;
threadHght=rimHght/2-minFloorThck;//rimHght-spokeHght-spokeSpcng-minFloorThck-sealThck;
lidHght=threadHght+minFloorThck+sealThck;
jarHght=ovHght-rimHght-spokeCenterLift+threadHght;
threadPitch=threadHght/3;
threadH=0.866 * threadPitch * 0.62;
threadDia=jarDia+threadH*2;
  
if (showLid) translate([0,0,jarHght-threadHght]) {
  
  if (showRim)
     translate([0,0,threadHght+minFloorThck]) rim();
  if (showLidFloor)
    translate([0,0,0]) lid();
  if (showTopLogo)
    translate([logoXOffset,logoYOffset,rimHght/2]) scale(logoSizeRel) logo(scaleTo=ovDia-rimWallThck*2);
  
}
  if (showJar)
    jar();
  if (showInnerLogo)
    translate([0,0,minFloorThck]) scale(logoSizeRel) logo(scaleTo=jarDia-minWallThck*4-sealWdth*2);

*rim();
module rim(d=ovDia,h=rimHght){
  r=h/30;
  R=h/11;
  
  *linear_extrude(h-threadHght-minFloorThck) difference(){
    circle(d=d);
    circle(d=d-rimWallThck*2);
  }
  difference(){
    rotate_extrude(convexity=4) difference(){
      baseShape(0);
      baseShape(rimWallThck);
    }
    difference(){
      translate([0,0,-rimHght/2-fudge]) threaded_rod(d=threadDia,l=threadHght+fudge,end_len1=fudge,end_len2=sealThck,pitch=threadPitch,internal=true,anchor=BOTTOM,);
      //inner wall for seal
      translate([0,0,-minFloorThck-sealThck]) ring(d1=jarDia-minWallThck-sealWdth,h=sealThck);
    }
  }
  
  if (showspokes)
    translate([0,0,0]) spokes(d/2-R-r-rimWallThck);
  
  //center Post
  cylinder(d=centerPostDia,h=spokeCenterLift+spokeHght);
  
  module baseShape(cut=0){
    m = cut ? [0] : [0,1];
    for (im=m) mirror([0,im]){
      difference(){
        union(){
          if (cut==0)
            translate([d/2-r,h/2-r]) circle(r);
          translate([d/2-r-R,h/2-R]) offset(-cut) circle(R);
          translate([0,h/2-R]) square([d/2-r-cut,R]);
          square([d/2-r-R,h/2]);
        }
        translate([d/2-r-R,h/2-R*3]) circle(R+cut);
        translate([d/2-r-R*2-cut,-fudge]) square(h/2-R*3+fudge);
      }
    }
  }
  module ring(d1=10,w=minWallThck,h=1){
    linear_extrude(h) difference(){
      circle(d=d1);
      circle(d=d1-w*2);
    }
  }
}

*spokes();
module spokes(r=ovDia/2-rimWallThck){
  sprokAng=360/spokeCount;
  for (i=[0:spokeCount-1]) rotate(i*sprokAng) hull(){
    translate([centerPostDia/2,0,spokeCenterLift]) cylinder(d=spokeWdth,h=spokeHght);
    translate([r,0,0]) cylinder(d=spokeWdth,h=spokeHght);
    }
}

module lid(){
  difference(){
    cylinder(d=ovDia,h=lidHght);
    difference(){
      translate([0,0,-fudge]) threaded_rod(d=threadDia,l=threadHght+sealThck+fudge,end_len1=fudge,end_len2=sealThck,pitch=threadPitch,internal=true,anchor=BOTTOM,);
      //inner wall for seal
      translate([0,0,threadHght]) ring(d1=jarDia-minWallThck-sealWdth,h=sealThck);
    }
  }
  module ring(d1=10,w=minWallThck,h=1){
    linear_extrude(h) difference(){
      circle(d=d1);
      circle(d=d1-w*2);
    }
  }
}

module jar(){
  difference(){
    threaded_rod(d=threadDia,end_len1=jarHght-threadHght,l=jarHght,pitch=threadPitch,anchor=BOTTOM);
    translate([0,0,minFloorThck]) cylinder(d=jarDia-minWallThck*2,h=jarHght);
    }
}




*logo();
module logo(scaleTo=ovDia){
  logoSize=[100,100];
  scale(scaleTo/logoSize.x) translate([-logoSize.x/2,-logoSize.y/2]){
    if (showLogoFill)
      color(fillColor) linear_extrude(fillThck) import("CandyLogo_Fill.svg");
    if (showLogoHighlight)
      color(highlightColor) linear_extrude(highlightThck) import("CandyLogo_Highlights.svg");
    if (showLogoOutline)
      color(outlineColor) linear_extrude(outlineThck) import("CandyLogo_Outline.svg");
    if (showLogoJoke)
      color(jokeColor) linear_extrude(jokeThck) import("CandyLogo_Jokes.svg");
  }
}

