$fn=30;
ovDims=[80,40,20];
lockCnt=[4,2,1];
lockDist=[20,20,10];
lockDia=10;
fudge=0.1;

/* [show] */

showCut=true;


/*[Hidden]*/
edgeOffset=(ovDims.x-((lockCnt.x-1)*lockDist.x))/2;
difference(){
  block();
  if (showCut) color("darkRed")
    translate([ovDims.x-edgeOffset,-lockDia-fudge/2,-fudge/2])
      cube([edgeOffset+lockDia+fudge,ovDims.y+lockDia+fudge,ovDims.z+lockDia+fudge]);
}

module block(center=false){
  
  cntrOffset= center ? [0,0,0] : [ovDims.x/2,ovDims.y/2,ovDims.z/2];
  translate(cntrOffset){
    cube(ovDims,true);
    
    //top surface
    translate([0,0,ovDims.z/2]) 
      grid([lockCnt.x,lockCnt.y],[lockDist.x,lockDist.y],true)
        sphere(d=lockDia);
    
    //front
    translate([0,-ovDims.y/2,0]) 
      grid([lockCnt.x,1,lockCnt.z],[lockDist.x,0,lockDist.y],true)
        sphere(d=lockDia);
    
    //side
    translate([ovDims.x/2,0,0]) 
      grid([1,lockCnt.y,lockCnt.z],[0,lockDist.y,lockDist.z],true)
        sphere(d=lockDia);
         sphere(d=lockDia);
    
    //right
    for (iy=[-(lockCnt.y-1)/2:(lockCnt.y-1)/2],iz=[-(lockCnt.z-1)/2:(lockCnt.z-1)/2])
      translate([ovDims.x/2,
        iy*lockDist.y,
        iz*lockDist.z
        ]) sphere(d=lockDia);
  }
}

*grid([1,4],[5,5],true) sphere(2);
*grid(3,2);
module grid(cnt=[],dist=[],center=false){
  
  
  if (len(cnt)==2){ //2D 
    cntrOffset= center ? [0,0,0] : [dist.x/2*(cnt.x-1),dist.y/2*(cnt.y-1),0];
  
    for (ix=[-(cnt.x-1)/2:(cnt.x-1)/2], 
         iy=[-(cnt.y-1)/2:(cnt.y-1)/2])
       
      translate(cntrOffset+[ix*dist.x,iy*dist.y,0]) children();
  }
  else{ //3D
    cntrOffset= center ? [0,0,0] : [dist.x/2*(cnt.x-1),
                                    dist.y/2*(cnt.y-1),
                                    dist.z/2*(cnt.z-1)];
  
    for (ix=[-(cnt.x-1)/2:(cnt.x-1)/2], 
         iy=[-(cnt.y-1)/2:(cnt.y-1)/2],
         iz=[-(cnt.z-1)/2:(cnt.z-1)/2])
      translate(cntrOffset+[ix*dist.x,iy*dist.y,iz*dist.z]) children();
  }
}