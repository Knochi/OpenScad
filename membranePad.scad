
pad();
rotate(180) pad();

module pad(){
  ovDims=[7.7,7.7];
  gap=4;
  padDims=[(ovDims.x-gap)/2,ovDims.y];
  //xOffset=-(ovDims.x-gap)/4-gap/2;
  
  fngrCnt=3;
  fngrDims=[ovDims.x/2+1,ovDims.y/((fngrCnt*2)+(fngrCnt*2-1))];
  pitch=ovDims.y/((fngrCnt*2)+(fngrCnt*2-1));
  echo(pitch);
  echo(str("xOffset:",-(padDims.x+gap)/2));
  echo(str("padDims:",padDims));
  
  translate([-(padDims.x+gap)/2,0]) square(padDims,true);
  
  for (iy=[0:(fngrCnt-1)]){
    echo(str("yOffset ",iy,": ",-(ovDims.y-fngrDims.y)/2+pitch*4*iy));
    #translate([-(ovDims.x-fngrDims.x)/2,-(ovDims.y-fngrDims.y)/2+pitch*4*iy]) square(fngrDims,true);
  }
}