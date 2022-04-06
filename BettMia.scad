
matrDims=[1400,2000,300];
topBeamDims=[140,0,60];
frmBeamDims=[120,0,60];
frameTopHght=240; 
frameDims=[1600,2200,240];
footDia=80;

color("ivory") translate([0,0,matrDims.z/2+frameDims.z-topBeamDims.z]) cube(matrDims,true);

  color("burlyWood") for(ix=[-1,1]){
    translate([ix*(matrDims.x+topBeamDims.x)/2,0,frameTopHght-topBeamDims.z/2]) 
      cube([topBeamDims.x,matrDims.y,topBeamDims.z],true);
    translate([ix*(matrDims.x+frmBeamDims.z)/2,0,frameTopHght-topBeamDims.z-frmBeamDims.x/2]) 
      cube([frmBeamDims.z,matrDims.y+frmBeamDims.z*2,frmBeamDims.x],true);
  }
    
  color("tan") for(iy=[-1,1])
    translate([0,iy*(matrDims.y+topBeamDims.x)/2,frameTopHght-topBeamDims.z/2]) 
      cube([matrDims.x+topBeamDims.x*2,topBeamDims.x,topBeamDims.z],true);
    
  //feet
  *color("burlywood") for (ix=[-1,1],iy=[-1,1])
    translate([ix*(matrDims.x+topBeamDims.x)/2,iy*(matrDims.y+topBeamDims.x)/2,0]) cylinder(d=footDia,h=frameTopHght-topBeamDims.z);



//calculate volume
sidesVol=(topBeamDims.x*topBeamDims.z*matrDims.y)/(1000*1000*1000);
facesVol=(topBeamDims.x*topBeamDims.z*matrDims.x)/(1000*1000*1000);
ovVol=sidesVol+facesVol;
cubicPrice=1415; //€/m³
echo(str("Volume: ",sidesVol,"m³"));
echo(str("Cost: ",ovVol*cubicPrice,"€"));
