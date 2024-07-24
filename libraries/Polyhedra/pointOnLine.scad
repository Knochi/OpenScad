$fn=50;

lineThck=0.2;
markerDia=0.3;

relPos=0.3; //[0.0:0.1:1.0]

verts=[[2,1,5],[30,5,9]];

//vector
v=verts[1]-verts[0];

hull() for (vert=verts)
  translate(vert) sphere(lineThck);

mid=centroid([verts[0],verts[1]]);

*color("red") translate(mid) sphere(markerDia);

//around z
phi=atan2(v.y,v.x);

//around y 
theta=atan2(v.z,v.x);

color("green") translate(verts[0]) rotate([0,-theta,phi]) 
  translate([norm(v)*relPos,0,0])  
    sphere(markerDia);

function centroid(verts,sum=[0,0,0],iter=0)=
  iter<len(verts) ? centroid(verts,sum+verts[iter]/len(verts),iter+1) : sum;