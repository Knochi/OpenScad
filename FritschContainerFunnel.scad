// Fritsch Container Funnel

minWallThck=1.2;
channelDims=[16.2,24,6];

squareFunnel();

module squareFunnel(){
  linear_extrude(channelDims.z) difference(){
    square([channelDims.x,channelDims.y],true);
    offset(-minWallThck) square([channelDims.x,channelDims.y],true);
  }
  translate([0,0,channelDims.z]) linear_extrude(channelDims.z*2,scale=[2,2]) difference(){
    square([channelDims.x,channelDims.y],true);
    offset(-minWallThck) square([channelDims.x,channelDims.y],true);
  }
}  
  