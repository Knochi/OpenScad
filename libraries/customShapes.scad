echo (tan(0));
skewedCube([30,30,20],[45,0],center=true);

module skewedCube(size=[1,1,1],skew=[45,45],center=false){
  skwDstX= tan(skew.x) ? size.z/tan(skew.x) : 0;
  skwDstY= tan(skew.y) ? size.z/tan(skew.y) : 0;
  skewDist= [skwDstX,skwDstY];
  centerOffset= center ? [-(size.x+skewDist.x)/2,-(size.x+skewDist.y)/2,-size.z/2]: [0,0,0];
  
  polys= // -- bottom --
         [[0,0,0],          //0
         [size.x,0,0],      //1
         [size.x,size.y,0], //2
         [0,size.y,0],      //3
         // -- top --
         [skewDist.x,skewDist.y,size.z],             //4
         [size.x+skewDist.x,skewDist.y,size.z],      //5
         [size.x+skewDist.x,size.y+skewDist.y,size.z], //6
         [skewDist.x,size.y+skewDist.y,size.z]];       //7
  
  faces=[[0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
  
  translate(centerOffset) polyhedron(polys,faces);
}