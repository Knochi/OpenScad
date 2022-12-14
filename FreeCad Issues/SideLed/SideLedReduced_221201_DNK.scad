bodyDims=[3.2,1.0,0.48]; //including pads
capWidth=0.45;
filRad=0.25;

translate([-capWidth/2,0,bodyDims.z/2]) difference(){
  cube([capWidth,bodyDims.y,bodyDims.z],true);
  circle(filRad);
}

  