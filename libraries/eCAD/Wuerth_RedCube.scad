$fn=50;
metalSilverCol=[0.50754, 0.50754, 0.50754]; //KiCAD Color

redCube_THT();
module redCube_THT(size=[7,7,12],threatDia=5,threatLen=8,pins=9){
  //example 7461001
  bdyDims=[size.x,size.y,size.z-threatLen];
  segmentHght=1.1; //height of the rounding above the body
  cornerRad=sphereSegment(size.x/2,segmentHght);
  threatChamfer=0.58;
  pinDims=[1.13,1.13,3.5];
  pinCnt=sqrt(pins);
  pitch=2.54;
  
  //body
  color(metalSilverCol) intersection(){
    translate([0,0,bdyDims.z/2]) cube(bdyDims,true);
    translate([0,0,-cornerRad+bdyDims.z+segmentHght]) sphere(r=cornerRad,$fn=100);
  }
  //threat
  color(metalSilverCol) translate([0,0,bdyDims.z]) 
    cylinder(d=threatDia,h=threatLen-threatChamfer);
  color(metalSilverCol) translate([0,0,size.z-threatChamfer]) 
    cylinder(d1=threatDia,d2=threatDia-threatChamfer*2,h=threatChamfer);
  
  //pins
  for (ix=[-(pinCnt-1)/2:(pinCnt-1)/2],iy=[-(pinCnt-1)/2:(pinCnt-1)/2])
    color(metalSilverCol) translate([ix*pitch,iy*pitch,0]) pin();
  
  module pin(){
    chamfer=0.3;
    translate([0,0,-(pinDims.z-chamfer)/2]) cube([pinDims.x,pinDims.y,pinDims.z-chamfer],true);
    translate([0,0,-pinDims.z+chamfer/2]) rotate([180,0,0]) frustum([pinDims.x,pinDims.y,chamfer],45,center=true);
  }
}

//2rh=a²+h² (a=segment radius, h=segment height, r=sphere radius)
function sphereSegment(a, h)=(pow(a,2)+pow(h,2))/(2*h);

*frustum(center=false);
module frustum(size=[1,1,1], flankAng=5, center=false, method="poly"){
  //cube with a trapezoid crosssection
  //https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
  
  
  flankRed=tan(flankAng)*size.z; //reduction in width by angle
  faceScale=[(size.x-flankRed*2)/size.x,(size.y-flankRed*2)/size.y]; //scale factor for linExt
  
  if (method=="linExt"){
    cntrOffset= (center) ? [0,0,-size.z/2] : [size.x/2,size.y/2,0];
    translate(cntrOffset)
      linear_extrude(size.z,scale=faceScale) 
        square([size.x,size.y],true);
  }
  else{ //for export to FreeCAD/StepUp
    cntrOffset= (center) ? [0,0,0] : [size.x/2,size.y/2,size.z/2];
    polys= [[-size.x/2,-size.y/2,-size.z/2], //0
            [ size.x/2,-size.y/2,-size.z/2], //1
            [ size.x/2, size.y/2,-size.z/2], //2
            [-size.x/2, size.y/2,-size.z/2],//3
            [-(size.x/2-flankRed),-(size.y/2-flankRed),size.z/2], //4
            [  size.x/2-flankRed ,-(size.y/2-flankRed),size.z/2], //5
            [  size.x/2-flankRed , (size.y/2-flankRed),size.z/2], //5
            [-(size.x/2-flankRed), (size.y/2-flankRed),size.z/2]]; //5
    faces= [[0,1,2,3],  // bottom
            [4,5,1,0],  // front
            [7,6,5,4],  // top
            [5,6,2,1],  // right
            [6,7,3,2],  // back
            [7,4,0,3]]; // left
    translate(cntrOffset) polyhedron(polys,faces);
  }
}