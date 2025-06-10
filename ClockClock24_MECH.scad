// VID28-05 double shaft Motor
// information from https://blog.drorgluska.com/2019/03/a-million-times.html


minWallThck=1.2;

clockDist=100; //distance between the shafts
clockDia=96; 
clock2HandSpcng=1;
clockCount=[8,3];

handWidth=10;
handThck=2;
handTopAng=-90;
handBotAng=90;
handShortOffset=4;

fudge=0.1;
$fn=64;



//clocks
for(ix=[0:clockCount.x-1],iy=[0:clockCount.y-1]){
  
  translate([ix*clockDist,iy*clockDist]){
    //motors
    VID28_05();

    //hands
    color("white") translate([0,0,15.8]) rotate(handTopAng) hand();
    color("white") translate([0,0,9]) rotate(handBotAng) hand(false);
    
    //diameters
    %circle(d=clockDia);
  }
}


module hand(top=true){
  if (top){
    linear_extrude(handThck) difference(){
      handShape();
      circle(d=1.5);
    }
    }
  else
    linear_extrude(handThck) difference(){
      handShape();
      circle(d=4);
    }
    
  module handShape(){
    lngth = top ? clockDia/2 : 
    intersection(){
      union(){
        circle(d=handWidth);
        translate([0,-handWidth/2]) square([clockDia/2,handWidth]);
      }
      circle(d=clockDia-clock2HandSpcng*2);
    }
  }
}

module VID28_05(){
  bdyDims=[64,35,9.2];
  shaftOffset=9.5;
  baseDia=5+2*(tan(4)*(11.2-4.8));
  
  //body
  translate([-shaftOffset,0,-bdyDims.z]) linear_extrude(bdyDims.z) 
    hull() for (ix=[-1,1])
      translate([ix*(bdyDims.x-bdyDims.y)/2,0]) circle(d=bdyDims.y);
      
  //shaft
  color("silver") cylinder(d=1.5,h=17.4);
  difference(){
    union(){
      cylinder(d=4,h=11.2);
      cylinder(d1=baseDia,d2=5,h=11.2-4.8);
    }
    cylinder(d=2,h=11.2+fudge);
  }
  //pins
  color("silver") for (ix=[-1,1],ixx=[0,1],iy=[-1,1])
    translate([ix*(23.24/2+ixx*7.76)-shaftOffset,iy*22.86/2,0]) cylinder(d=0.5,h=2.8);
  
  //studs
  color("grey"){ 
    for(ix=[-1,1])
      translate([ix*25-shaftOffset,9.0]) cylinder(d=2.5,h=3.8);
    translate([-shaftOffset,-12.0]) cylinder(d=2.5,h=3.8);
  }
  
}