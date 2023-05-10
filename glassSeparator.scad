glassDiaTop=60;
glassDiaBot=50;

glassWallThck=2;
glassHghtTotal=70; //Total Height
glassHghtTop=0; //height of the straight top section
glassHghtBot=0; //height of the straight bottom section
$fn=50;

glass();

module separator(){
  
}
module glass(){
  tOffsetTop= glassHghtTop ? 0 :  -glassWallThck/2;
  tOffsetBot= glassHghtBot ? 0 :  glassWallThck/2;
  
  rotate_extrude(){
    //top
    if (glassHghtTop)
    translate([glassDiaTop/2-glassWallThck,glassHghtTotal]){
      translate([0,-glassHghtTop]) square([glassWallThck,glassHghtTop-glassWallThck/2]);
      translate([glassWallThck/2,-glassWallThck/2]) circle(d=glassWallThck);
    }
    //transistion
    hull(){
      translate([(glassDiaTop-glassWallThck)/2,glassHghtTotal-glassHghtTop+tOffsetTop]) circle(d=glassWallThck);
      translate([(glassDiaBot-glassWallThck)/2,glassHghtBot+tOffsetBot]) circle(d=glassWallThck);
    }
    //Bot
    if (glassHghtBot)
    translate([glassDiaBot/2-glassWallThck,glassWallThck/2]) square([glassWallThck,glassHghtBot-glassWallThck/2]);
    translate([(glassDiaBot-glassWallThck)/2,glassWallThck/2]) circle(d=glassWallThck);
    square([glassDiaBot/2-glassWallThck/2,glassWallThck]);
  }
}