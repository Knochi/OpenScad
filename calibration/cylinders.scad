$fn=100;
fudge=0.1;

cylDist=50;
maxWallThck=3;

cylDias=[[ 1, 1,20],
         [ 1,-1,30],
         [-1, 1,40],
         [-1,-1,50]];

for (i=cylDias)
 translate([i.x*cylDist/2,i.y*cylDist/2,0]) stepCylinder(startDia=i.z,stopDia=i.z-maxWallThck);

module stepCylinder(startDia=20,stopDia=17,height=50,steps=5,minWallThck=0.4){
  stpHght=height/steps; //height per step
  diaDiff=(startDia-stopDia)/(steps-1); //difference in diameter per step
  
  difference(){
    for (i=[0:steps-1])
      translate([0,0,i*stpHght]) cylinder(d=startDia-diaDiff*i,h=stpHght);
    translate([0,0,minWallThck]) cylinder(d=stopDia-minWallThck*2,h=height);
  }
  
}