//https://www.youtube.com/watch?v=tOx5UI8GGns
//https://benjaminwand.github.io/verbose-cv/projects/bezier_curves.html

$fn=20;

//points 

pts= [[10,7.5],[10,4],[6,1.7]];

n=12;

//linear interpolation between first two points
for (i=[0:1/n:1])
  translate(pts[0] * i + pts[1] * (1-i))
    circle(0.2);

//linear interpolation between 2nd two points
for (i=[0:1/n:1])
  translate(pts[1] * i + pts[2] * (1-i))
    circle(0.2);
  
// 2nd Order bezier curve
color("darkGreen")
  for (i=[0:1/n:1])
    //            0..1           1..0
    translate( (pts[0]*i + pts[1]*(1-i))*i + (pts[1] * i + pts[2] * (1-i)) * (1-i)) 
      circle(0.2);
  
//draw all points in a different color

for (pt=pts) translate(pt) color("darkRed") circle(0.2);