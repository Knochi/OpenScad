use <tangentLines.scad>

$fn=50;

P1= [-17,-5];
P2= [12,5];

r1=6;
r2=10;

lineWdth=0.2;
dotDia=1.4;

color("darkGreen") translate(P1) circle(r1);
color("darkRed") translate(P2) circle(r2);

T=PointForExternal(P1,r1,P2,r2);
color("red") translate(T) circle(d=dotDia);

pts1=TangentPoints(P1,r1,T);

for (p=pts1)
  color("green") translate(p) circle(d=dotDia);
pts2=TangentPoints(P2,r2,T); 

for (p=pts2)
  color("red") translate(p) circle(d=dotDia);

color("purple") DrawLine(pts1[0],pts2[0],lineWdth);