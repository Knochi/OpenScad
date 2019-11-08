//use <bezier.scad>


$fn=50;
fudge=0.1;

/*-- [Burner-Dimensions] --*/
pipStrLngth=700; //length of the straight part
pipHndlLngth=80; //length of the straight handle part 
pipBendAng=133;
pipBendRad=90;
pipDia=16;
wThck=0.5;
canDia=80;
canHght=400;

/*-- [Tube-Dimensions] --*/
tubBendRad=80;
tubOutDia=31;
tubInDia=25;
exOutDia=150;
exInDia=140;
exLngth=200;

/* -- [3DP] -- */
minWallThck=2;

rotate([0,90,0]) burner(); 
tube();
translate([-200,0,tubOutDia]) rotate([0,-90,0]) exhaust();

module tube(){
  dIn=tubInDia;
  dOut=tubOutDia;
  mRad=tubBendRad;
  
  color("grey",0.5){
    rotate([0,-90,0]) linear_extrude(40) shape();
    translate([-40,0,-mRad]) rotate([90,-90,0]) 
      rotate_extrude(angle=180) translate([mRad,0,0]) shape();
    translate([-40,0,-mRad*2]) rotate([0,90,0]) linear_extrude(pipStrLngth) shape();
    translate([pipStrLngth-40,0,-mRad]) rotate([90,90,0]) 
      rotate_extrude(angle=120) translate([mRad,0,0]) shape();
  }
  
  module shape(){
    difference(){
      circle(d=dOut);
      circle(d=dIn);
    }
  }
}

*union(){
  translate([0,0,150]) exhaust();
  adapter();
}

*adapter();
module adapter(){
  
 // polygon(Bezier());
}

module exhaust(){
  color("grey",0.3)
  linear_extrude(exLngth) difference(){
    circle(d=exOutDia);
    circle(d=exInDia);
  }
}

*burner();
module burner(){
  //muzzle
  color("salmon") translate([0,0,-36]) rotate([0,0,0]) muzzle();
  
  color("silver"){
    //long straight part
    linear_extrude(pipStrLngth) shape();
    
    //radius
    translate([pipBendRad,0,pipStrLngth]) rotate([-90,0,180]) 
      rotate_extrude(angle=-pipBendAng) 
        translate([pipBendRad,0,0]) shape();
  }  
    //handle
    translate([pipBendRad,0,pipStrLngth]) rotate([0,-(180-pipBendAng),0]) 
      translate([pipBendRad,0,-pipHndlLngth]){
        color("silver") linear_extrude(pipHndlLngth) shape();
        translate([0,0,-canHght]) can();
      }
    
  
  module shape(){
    difference(){
      circle(d=pipDia);
      circle(d=pipDia-wThck*2);
    }
  }
  
  module can(){
    color("green") cylinder(d=canDia,h=canHght*0.75);
    color("yellow") translate([0,0,canHght*0.75]) cylinder(d=canDia,h=canHght*0.25);
  }
}

module muzzle(){
  wThck=1;
  
  difference(){
    union(){
      cylinder(d=16+2*wThck,h=53);
      cylinder(d=25,h=35);
      translate([0,0,35]) cylinder(d1=25,d2=18,h=5);
    }
    translate([0,0,-fudge/2]){
      cylinder(d=16,h=53+fudge);
      cylinder(d=25-wThck*2,h=35+fudge);
      translate([0,0,35]) cylinder(d1=25-wThck*2,d2=18-wThck*2,h=5+fudge);
    }
  }
}