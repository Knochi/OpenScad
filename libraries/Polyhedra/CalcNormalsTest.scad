/*[show]*/
showOrig=true;
showModified=true;


//translate a random polygon to origin and lay flat

verts= [[10,13,28],[15,20,30],[20,11,25]];

//calculate normal
v= cross(verts[2]-verts[0],verts[1]-verts[0]);

//calculate centroid
centroid=verts[0]/3+verts[1]/3+verts[2]/3;

//calculate rotation from normal
rotX=atan2(v.y,v.z);
rotY=atan2(v.x,v.z);
rotZ=atan2(v.y,v.x); //(not needed)

rot=[rotX,rotY,0];

if (showOrig){
  //normal vector
  color("green") translate(centroid) hull(){
      sphere(0.5);
      translate(v) sphere(0.5);
    }
  polyhedron(verts,[[0,1,2]]);
  } 

if (showModified)
  //rotate
  rotate(rot){
    //translate to origin
    translate(-centroid){
      polyhedron(verts,[[0,1,2]]);
      color("green") for (vert=verts)
        translate(vert) sphere(1);
    }
    //normal vector
    color("green") hull(){
      sphere(0.5);
      translate(v) sphere(0.5);
    }
  }






