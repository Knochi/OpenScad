// Tried to replicate from 
// https://github.com/hbaktash/resting-rigid-bodies/blob/main/src/mesh_factory.cpp
// but hendecahedron.stl is missing

%import("hendecahedron_2d6.stl");
$fn=20;

//trace points
tipVert=[[16.15,11.68,24.89]]; //0
topVerts=[[8.15,4.94,20.08],[16.15,0,16.22],[24.13,4.94,20.08],[24.65,18.84,20.65],
          [16.15,24.94,17.03],[7.65,18.84,20.65]]; //1-6
          
bottomVerts=[[0,11.24,1.4],[16.15,0.77,2.62],[32.29,11.25,1.42],[16.15,23.35,0]]; //7-10

vertices=concat(tipVert,topVerts,bottomVerts);
echo(vertices);
faces=[[0,1,2,3],[0,3,4],[0,4,5,6],[0,6,1],
       [1,2,8,7],[2,3,9,8],[3,4,9],[4,5,10,9],
       [5,6,7,10],[6,1,7],
       [7,8,9,10]];

polyhedron(vertices,faces);

i=+6;
color("red") translate(vertices[i]) sphere(1);

*generate_11sided_poly();
module generate_11sided_poly(type = "triangular"){

  if (type == "triangular"){
    n=10;
    translate([0,0,1])  sphere(0.1); //v0
    for (i=[0:n-1]){
      theta = 360*i/n;
      translate([cos(theta),sin(theta),-0.5]) sphere(0.1);
      // faces: faces.push_back({0, i+1, (i+2 == n+1) ? 1 : i+2});
      }
      //for (i=[2:n-1])
        //faces:  faces.push_back({1, i+1, i}); // orient outwards
    }
  else if (type == "circus"){
    n=5;
    z0=1;
    z1=0;
    z2=-1;
    translate([0,0,z0]) sphere(0.1); //v0
    
    //layer 1
    for (i=[0:n-1]){
      theta = 360*i/n;
    
      translate([cos(theta),sin(theta),z1]) sphere(0.1);
      //faces: faces.push_back({0, i+1, (i+2 == n+1) ? 1 : i+2}); // Inward normal
      }
      
    //layer 2
    for (i=[0:n-1]){
      theta = 360*i/n;
    
      translate([cos(theta),sin(theta),z1]) sphere(0.1);
      //faces: faces.push_back({(i+2 == n+1) ? 1 : i+2 , i+1 , (i+2 + 5 == n+1 + 5) ? 1 + 5 : i+2 + 5});
      //faces: faces.push_back({(i+2 + 5 == n+1 + 5) ? 1 + 5 : i+2 + 5, i+1 , i+1 + 5});
    }
    
    /* bottom pentagon face
    faces.push_back({7,6,8});
    faces.push_back({8,6,9});
    faces.push_back({9,6,10});
    */
    
  }
  else if (type == "hendecahedron")
    import("hendecahedron.stl");
  else if (type == "prism")
    pointy_prism();
  else 
    echo("not recognized type");
}

module pointy_prism(n=5){
  z3 = 2.82;
  z2 = 1.52;
  z1 = -0.01;
  z0 = -1.32;
  
  alpha = 360/n;
  r = 1;
  
  //top
  translate([0,0,z3]) sphere(0.1);
  
  for (i=[0:n-1]){ //quads verts
    theta = 360*i/n;
    translate([r*cos(theta),r*sin(theta),z2]) sphere(0.1);
    translate([r*cos(theta),r*sin(theta),z1]) sphere(0.1);
    /* faces
    faces.push_back({0, i+1, (i+2 == n+1) ? 1 : i+2}); // top triangles
    faces.push_back({(i+2 == n + 1) ? 1 : i+2, i+1,  i+1 + n}); // mid quad face 1
    faces.push_back({(i+2 == n + 1) ? 1: i+2, i+1 + n, (i+2 == n + 1) ? n + 1: i+2 + n}); // mid quad face 2
    faces.push_back({2*n+1, (i+2 == n + 1) ? n + 1 : i+2 + n, i+1 + n}); // bottom triangles
    */
    }
  
  //bottom
  translate([0,0,z0]) sphere(0.1);
  
}