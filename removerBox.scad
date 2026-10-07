ovDims=[120,60,20];
floorThck=3;
colRows=[3,2];
wallThck=2.1;

cutOutDims=[(ovDims.x-(colRows.x+1)*wallThck)/colRows.x,(ovDims.y-(colRows.y+1)*wallThck)/colRows.y];

difference(){
  linear_extrude(ovDims.z) square([ovDims.x,ovDims.y],true);
  #for (ix=[-(colRows.x-1)/2:(colRows.x-1)/2],iy=[-(colRows.y-1)/2,(colRows.y-1)/2]){
    translate([ix*(cutOutDims.x+wallThck),iy*(cutOutDims.y+wallThck),floorThck]) 
      linear_extrude(ovDims.z) square(cutOutDims,true);
    echo(ix,iy);
    }
}