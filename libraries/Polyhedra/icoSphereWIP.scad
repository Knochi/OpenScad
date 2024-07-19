// icosphere code copied with pride from Andreas Kahler
// http://blog.andreaskahler.com/2009/06/creating-icosphere-mesh-in-code.html

// A great repository for all kinds of polyhedra
// http://dmccooey.com/polyhedra/GeodesicIcosahedra.html

$fn=10;


/* [show] */

showStatistics=true;
icosphere();
*test();


// set recursion to the desired level. 0=20 tris, 1=80 tris, 2=320 tris
module icosphere(radius=1,recursion=0,icoPnts,icoTris){
  //t = (1 + sqrt(5))/2;
  //comment from monfera to get verts to unit sphere
  t= sqrt((5+sqrt(5))/10);
  s= sqrt((5-sqrt(5))/10);
  
  init=(icoPnts||icoTris) ? false : true; //initial call if icoPnts is empty
  
  // 1 --> draw icosphere from base mesh
  // 2 --> loop through base mesh and subdivide by 4 --> 20 steps
  // 3 --> loop through subdivided mesh and subdivide again (or subdivide by 16) --> 80 steps
  // 4 ...
  
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
  tris=  [
  //5 faces around point 0
    [ 0,11, 5], //0
    [ 0, 5, 1],
    [ 0, 1, 7],
    [ 0, 7,10],
    [ 0,10,11], 
  // 5 adjacent faces
    [ 1, 5, 9], //5
    [ 5,11, 4],
    [11,10, 2],
    [10, 7, 6],
    [ 7, 1, 8], 
  //5 faces around point 3
    [ 3, 9, 4], //10
    [ 3, 4, 2],
    [ 3, 2, 6],
    [ 3, 6, 8],
    [ 3, 8, 9], 
  //5 adjacent faces 
    [ 4, 9, 5], //15
    [ 2, 4,11],
    [ 6, 2,10],
    [ 8, 6, 7],
    [ 9, 8, 1]  //19
    ];
    
  if (recursion){
    verts= (init) ? verts : icoPnts;
    tris= (init) ? tris : icoTris;
    
    newSegments=recurseTris(verts,tris);
    newVerts=newSegments[0];
    newTris= newSegments[1];
    icosphere(radius,recursion-1,newVerts,newTris);
    
  }
  else if (init){//draw the base icosphere if no recursion and initial call
    scale(radius) polyhedron(verts,tris); 
    if (showStatistics)
      for (tri=tris){ //calculate the length of each tris edges
        l1=norm(verts[tri[0]]-verts[tri[1]]);
        l2=norm(verts[tri[1]]-verts[tri[2]]);
        l3=norm(verts[tri[2]]-verts[tri[0]]);
        lmin=min(l1,l2,l3); 
        lmax=max(l1,l2,l3);
        ldev=lmax-lmin; //deviation between edges
        echo(l1,l2,l3,ldev);
      }
    }
  else{ // if not initial call some recursion has to be happened
    scale(radius) polyhedron(icoPnts,icoTris); 
    if (showStatistics)
      for (tri=icoTris){ //calculate the length of each tris edges
        l1=norm(icoPnts[tri[0]]-icoPnts[tri[1]]);
        l2=norm(icoPnts[tri[1]]-icoPnts[tri[2]]);
        l3=norm(icoPnts[tri[2]]-icoPnts[tri[0]]);
        lmin=min(l1,l2,l3); 
        lmax=max(l1,l2,l3);
        ldev=lmax-lmin; //deviation between edges
        echo(l1,l2,l3,ldev);
      }
    
  }
}




/*adds verts if not already there, 
 takes array of vertices and indices of a tri to expand
 returns expanded array of verts and indices of new polygon with 4 faces
 [[verts],[0,(a),(c)],[1,(b),(a)],[2,(c),(b)],[(a),(b),(c)]] */
function addTris(verts,tri)= let(
    a= getMiddlePoint(verts[tri[0]],verts[tri[1]]), //will produce doubles
    b= getMiddlePoint(verts[tri[1]],verts[tri[2]]), //these are unique
    c= getMiddlePoint(verts[tri[2]],verts[tri[0]]), //these are unique
    
    aIdx = search(verts, a), //point a already exists
    l=len(verts)                       
  ) len(aIdx) ? [concat(verts,[a,b,c]),[[tri[0],l,l+2],   //1
                                        [tri[1],l+1,l],   //2
                                        [tri[2],l+2,l+1], //3
                                        [l,l+1,l+2]] ] :  //4

                [concat(verts,[b,c]), [[tri[0],aIdx,l+1], //1
                                      [tri[1],l,aIdx],    //2
                                      [tri[2],l+1,l],     //3
                                      [aIdx,l,l+1]] ];    //4


// recursive function that does one recursion on the whole icosphere (auto recursion steps derived from len(tris))
function recurseTris(verts,tris,newTris=[],steps=0,step=0)= let(
    stepsCnt = steps ? steps : len(tris)-1, //if initial call initialize steps
    newSegment=addTris(verts=verts,tri=tris[step]),
    newVerts=newSegment[0], //all old and new Vertices
    newerTris=concat(newTris,newSegment[1]) //only new Tris
  ) (stepsCnt==(step)) ? [newVerts,newerTris] :
                           recurseTris(newVerts,tris,newerTris,stepsCnt,step+1);
                
                
                
//get point between two verts on unity sphere
/* Point3D middle = new Point3D(
            (point1.X + point2.X) / 2.0, 
            (point1.Y + point2.Y) / 2.0, 
            (point1.Z + point2.Z) / 2.0);  --> (p1+p2)/2
            */
            
function getMiddlePoint(p1,p2)=fixPosition((p1+p2)/2);
//function getMiddlePoint(p1,p2)=(p1+p2)/2;



//fix position to be on unit sphere
/*
private int addVertex(Point3D p)
    {
        double length = Math.Sqrt(p.X * p.X + p.Y * p.Y + p.Z * p.Z);                --> norm(p)
        geometry.Positions.Add(new Point3D(p.X/length, p.Y/length, p.Z/length)); 
        return index++;
    }
    */
function fixPosition(p)=let(l=norm(p)) [p.x/l,p.y/l,p.z/l];
verts=[[-0.525731, 0.850651, 0], [0.525731, 0.850651, 0], [0, 0.525731, 0.850651]];
/* test if norm equals quadric mean and vector/2 = x/2,Y/2,Z/2
p=(verts[0]+verts[1])/2;
q=[(verts[0].x+verts[1].x)/2,
   (verts[0].y+verts[1].y)/2,
   (verts[0].z+verts[1].z)/2];

l=(verts[0]+verts[1])/2;
m=norm(p);
echo(q,l);
echo(l,m);
*/
module test(separate=false, inWhole=true){
  t= sqrt((5+sqrt(5))/10);
  s= sqrt((5-sqrt(5))/10);
  
  //1st and 2nd tri
  p0=[-s, t, 0];
  p1=[ s, t, 0];
  p11=[-t, 0, s];
  p5=[ 0, s, t];
  
  sideLngth=norm(p0-p11);
  r=sideLngth/(sqrt(3));
  rot=90;
  
        //0  1  2  3
  tVerts=[p0,p1,p5,p11];
  tTris=[[0,3,2],[0,2,1]];
    
  //         a       b       c
  //tVerts=tPoly;
  a=getMiddlePoint(tVerts[0],tVerts[1]);
  b=getMiddlePoint(tVerts[1],tVerts[2]);
  c=getMiddlePoint(tVerts[2],tVerts[0]);
  
  //create two separate new segments
  newSegment1=addTris(tVerts,tTris[0]);
  newSegment2=addTris(tVerts,tTris[1]);
  
  newVerts1=newSegment1[0]; //put just the new vertices in a new array
  newFaces1=newSegment1[1]; //indicies for the 1st new segment
  
  
  translate(a) sphere(0.05);
  echo(str("a,b,c: ",a,b,c));
  
           
  //base tris 
  color("green",0.5) polyhedron(tVerts,tTris); //"old" tris
  //separate segments of new tris
  if(separate){
    color("red",0.5) polyhedron(newSegment1[0],newSegment1[1]);
    color("orange",0.5) polyhedron(newSegment2[0],newSegment2[1]);
  }
  else if (inWhole){//create one new Segment (out of two tris) in whole
    newerSegments=recurseTris(tVerts,tTris);
    newVerts=newerSegments[0];
    newFaces=newerSegments[1];
    color("blue",0.5) polyhedron(newVerts,newFaces);
    echo(str("\ninput Verts    (",len(tVerts),"): ", tVerts,"\n",
             "output Verts (",len(newVerts),"): ", newVerts,"\n",
             "input Faces (",len(tTris),"): ", tTris,"\n",
             "output Faces (",len(newFaces),"): ", newFaces));
  }
  
  else{ //create one new Segment using the first one
    newSegments=addTris(newVerts1,tTris[1]); //new Segments using the new array
    newVerts=newSegments[0]; //all old and new vertices for two new segments
    newFaces2=newSegments[1]; //indicies for the 2nd new segment
    newFaces=concat(newFaces1,newFaces2);
    color("blue",0.5) polyhedron(newVerts,newFaces);
  }
}

  