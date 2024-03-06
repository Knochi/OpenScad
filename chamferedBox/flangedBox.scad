boxDims=[100,50,100];
chamfer=7;
wallThck=1;

/* [hidden] */
fudge=0.1;

chamfBox();

module chamfBox(){
  //inner chamfer from wallthck
  chmfIn=sqrt(2)*(sqrt(2)*chamfer/2-wallThck);
  echo(chmfIn);
  difference(){
    chamfCube(boxDims,chamfer);
    translate([0,0,-fudge]) chamfCube([boxDims.x-wallThck*2,boxDims.y-wallThck*2,boxDims.z-wallThck],chmfIn+0.7);
  }
}

module chamfCube(size=[10,10,10], chamferSize=1){
  echo(size);
  //create top with chamfer
  linear_extrude(size.z-chamferSize) chamferedRect([size.x,size.y],chamferSize);
  
  hull() for (ix=[-1,1], iy=[-1,1]){
    //determine rotation of the corner piece
    crnRot= (ix<0 && iy<0) ? 180 :
            (ix<0 && iy>0) ? 90 :
            (ix>0 && iy<0) ? -90 :
            0;
    translate([ix*(size.x/2-chamferSize),iy*(size.y/2-chamferSize),size.z-chamferSize]) 
      rotate(crnRot) corner(size=chamferSize);
  } 
}

module corner(size=[10,10,10]){
  dims = is_list(size) ? size : [size,size,size];
  points = [[0,0,0], [0,dims.y,0], [dims.x,0,0], [0,0,dims.z]];
  polyhedron(points, [[0,2,1], [0,1,3], [1,2,3], [0,3,2]]);
}

module chamferedRect(size=[10,10],chamferSize=1){
  
  //counterclockwise
  poly=[[-size.x/2+chamferSize,-size.y/2],[-size.x/2,-size.y/2+chamferSize], //bottom left
        [-size.x/2, size.y/2-chamferSize],[-size.x/2+chamferSize, size.y/2], //top left
        [ size.x/2-chamferSize, size.y/2],[ size.x/2, size.y/2-chamferSize], //top rigth
        [ size.x/2,-size.y/2+chamferSize],[ size.x/2-chamferSize,-size.y/2], //bottom rigth
       ];
  polygon(poly);
}
