

$fn=60;

linear_extrude(3) thumbScrewShape();

module thumbScrewShape(tips=5,outerDia=40,tipRad=5,drill=8){
  ang=360/tips;
  outRad=outerDia/2-tipRad;
  inRad=outRad*cos(ang/2);
  dist=outRad*sin(ang/2);
  nudRad=dist-tipRad;
  bodRad=sqrt(pow(inRad,2)+pow(nudRad,2));
  
  difference(){
    union(){
      for (ia=[0:ang:360-ang])
        rotate(ia) translate([outRad,0]) circle(tipRad);
     circle(bodRad);
    }
    for (ia=[0:ang:360-ang])
      color("red") rotate(ang/2+ia) translate([inRad,0]) circle(nudRad);
    circle(d=drill);
  }
}