// implementation of http://paperjs.org/examples/meta-balls/
// using bezier paths to render metaballs


ballPositions = [[25.5, 12.9], [61.0, 7.3], [48.6, 36.3],
	[11.7, 45.9], [48.4, 72.6], [84.3, 30.6], [78.9, 61.5], [104.9, 8.2],
	[129.2, 42.8], [111.7, 73.3], [135.2, 8.6], [9.2, 79.8]];

handle_len_rate = 2.4;
circlePaths = [];
radius = 5;

lCirclePos=[96,30];
lCircleRad=10;

color("lightgreen") translate(lCirclePos) circle(lCircleRad);

for (i=[0:len(ballPositions)-1])
  translate(ballPositions[i]) difference(){
    circle(radius);
    text(str(i),size=radius,valign="center",halign="center");
  }

echo([lCirclePos,lCircleRad],[ballPositions[7],radius]);
  
metaball([lCirclePos,lCircleRad],[ballPositions[7],radius]);

//this will be translated to a function giving the control points 
//for bezier paths between two circles
  
module metaball(ball1, ball2, v, handle_len_rate, maxDistance=30){
  //ball array [[pos.x,pos.y],radius]
  pos1=ball1[0];
  pos2=ball2[0];
  rad1=ball1[1];
  rad2=ball2[1];
  
  dist = norm(pos1-pos2);
  echo(pos1,pos2,rad1,rad2,dist);
  
  assert((rad1 != 0) || (rad2 != 0), "one of the balls is zero");
  // to far or overlapping completly
  if ((dist>maxDistance) || (dist<=abs(rad1-rad2))) echo("out of bounds");
    
  
  //overlapping
  if (dist < rad1+rad2){ 
    u1 = acos((rad1*rad1 + dist * dist -rad2*rad2)/(2*rad1*dist));
    u2 = acos((rad2*rad2 + dist * dist -rad1*rad1)/(2*rad2*dist));
    echo(u1,u2);
  }
  else {
    u1 = 0;
    u2 = 0;
    echo(u1,u2);
  }
    
}
