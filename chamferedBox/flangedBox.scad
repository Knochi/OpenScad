/* [show] */
showBox=true;
showCover=true;
sectionCut="none"; //["none","Y-Z"]

/* [Dimensions] */
boxDims=[100,100,100];
flangeDims=[130,100,3];
drillDia=3.1;
drillDist=[115,80];
chamfer=10; 
wallThck=1;
//spacing between cover and box
cvrSpcng=0.1;

/* [Hidden] */
fudge=0.1;
$fn=20;

difference(){
  union(){
    if (showBox)
      color("lightGrey") translate([0,0,flangeDims.z/2]) chamfBox();
    if (showCover)
      color("palegreen") cover();
  }
  if (sectionCut=="Y-Z")
    color("darkRed") translate([0,-max(boxDims.y,flangeDims.y)/2-fudge/2,-fudge/2]) 
      cube([max(boxDims.x,flangeDims.x)/2+fudge,
            max(boxDims.y,flangeDims.y)+fudge,
            boxDims.z+fudge]);
}

module cover(){
  edgeDims=[boxDims.x-(wallThck+cvrSpcng)*2,
            boxDims.y-(wallThck+cvrSpcng)*2]; //outer dims of the interlocking edge
  //bottom cover for the box
  linear_extrude(flangeDims.z/2,convexity=3) difference(){
    chamferedRect([flangeDims.x,flangeDims.y],chamfer);
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*drillDist.x/2,iy*drillDist.y/2]) circle(d=drillDia);
  }
  linear_extrude(flangeDims.z/2+wallThck,convexity=3) difference(){
    chamferedRect(edgeDims,chamfer-wallThck-cvrSpcng);
    offset(-wallThck) chamferedRect(edgeDims,chamfer-wallThck-cvrSpcng);;
  }
}
  

module chamfBox(){
  //inner chamfer from wallthck
  
  a1=tan(45/2)*wallThck; //[a1,a1] offset between inner and outer chamfer origin
  c1=sqrt(2)*a1; //offset distance 45°
  hchmf=sqrt(2)*chamfer/2; //diagonal of outer offset
  
  chmfIn=2*(hchmf+c1-wallThck)/sqrt(2);
  
  difference(){
    union(){
      chamfCube(boxDims+[0,0,-flangeDims.z/2],chamfer);
      linear_extrude(flangeDims.z/2,convexity=3) difference(){
        chamferedRect([flangeDims.x,flangeDims.y],chamfer);
        for (ix=[-1,1],iy=[-1,1])
          translate([ix*drillDist.x/2,iy*drillDist.y/2]) circle(d=drillDia);
      }
    }
    translate([0,0,-fudge]) 
      chamfCube([boxDims.x-wallThck*2,boxDims.y-wallThck*2,boxDims.z-wallThck-flangeDims.z/2],chmfIn);
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
