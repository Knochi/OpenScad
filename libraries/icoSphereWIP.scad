// icosphere code copied with pride from Andreas Kahler
// http://blog.andreaskahler.com/2009/06/creating-icosphere-mesh-in-code.html
$fn=10;

icosphere();

*sphere(1);


module icosphere(icoPnts,icoTris,recursion=1){
  //t = (1 + sqrt(5))/2;
  //comment from monfera to get verts to unit sphere
  t= sqrt((5+sqrt(5))/10);
  s= sqrt((5-sqrt(5))/10);
  
  verts = [[-s, t, 0],  //0
           [ s, t, 0],
           [-s,-t, 0],
           [ s,-t, 0],
           [ 0,-s, t],
           [ 0, s, t],
           [ 0,-s,-t],
           [ 0, s,-t],
           [ t, 0,-s],
           [ t, 0, s],
           [-t, 0,-s],
           [-t, 0, s]]; //11
  
  //base mesh with 20 faces
  faces=  [
  //5 faces around point 0
    [ 0,11, 5],
    [ 0, 5, 1],
    [ 0, 1, 7],
    [ 0, 7,10],
    [ 0,10,11],
  // 5 adjacent faces
    [ 1, 5, 9],
    [ 5,11, 4],
    [11,10, 2],
    [10, 7, 6],
    [ 7, 1, 8],
  //5 faces around point 3
    [ 3, 9, 4],
    [ 3, 4, 2],
    [ 3, 2, 6],
    [ 3, 6, 8],
    [ 3, 8, 9],
  //5 adjacent faces 
    [ 4, 9, 5],
    [ 2, 4,11],
    [ 6, 2,10],
    [ 8, 6, 7],
    [ 9, 8, 1]
    ];
  if (recursion){
    verts = icoPnts ? icoPnts : verts;
    faces = icoTris ? icoTris : faces;
      
    for (tri=faces){
      
      //middlepoints on each edge of the triangle
      a= getMiddlePoint(verts[tri[0]],verts[tri[1]]); //will produce doubles
      b= getMiddlePoint(verts[tri[1]],verts[tri[2]]); //these are unique
      c= getMiddlePoint(verts[tri[2]],verts[tri[0]]); //these are unique
      
      //draw small sphere on each edge
      *color("blue") translate(a) sphere(0.05);
      color("red") translate(b) cube(size=0.07,center=true);
      color("green") translate(c) sphere(0.07, $fn=3);
    }
    
    icosphere(verts,faces,recursion-1);
  }
  else{
    polyhedron(verts,faces);
  }
}

function getMiddlePoint(p1,p2)=fixPosition((p1+p2)/2);


test();
module test(){
  tVerts=[[1,2,3],[4,5,6],[7,8,9]];
  a=getMiddlePoint(tVerts[0],tVerts[1]);
  b=getMiddlePoint(tVerts[1],tVerts[2]);
  c=getMiddlePoint(tVerts[2],tVerts[0]);
  echo(a,b,c);
  echo(len(tVerts),addVerts(tVerts,[0,1,2]));
  

}


//adds verts if not already there, 
//takes array of vertices and indices of a tri
//returns expanded array of verts and indices of added verts [[verts],[p1,p2,p3]]
function addVerts(verts,tri)= let(
    a= getMiddlePoint(verts[tri[0]],verts[tri[1]]), //will produce doubles
    b= getMiddlePoint(verts[tri[1]],verts[tri[2]]), //these are unique
    c= getMiddlePoint(verts[tri[2]],verts[tri[0]]), //these are unique
    isNew= search(verts, a),
    l=len(verts)
  ) len(isNew) ? [concat(verts,[a,b,c]), l,l+1,l+2] : [concat(verts,[b,c]), isNew,l,l+1];




//fix position to be on unit sphere
function fixPosition(p)=let(l=norm(p)) [p.x/l,p.y/l,p.z/l];

  