use <eCAD/elMech.scad>
$fn=24; //multiple of four


/* [show] */
showSpheres=true;
showFrames=true;
export="none"; //["none","cornerSphere","edgeBar","frame"]

/* [Dimensions] */
ovDims=[100,100,100];
crnRad=4;
rad=6;
matThck=3;

/* [Hidden] */
fudge=0.1; 
spcng=0.1;
kerf= (export!="none") ? 0 : 0.1; //show kerf at lasercut pieces, will be removed for export
crnrSphereRad=12;


translate([0,0,ovDims.z/2]) arcadeButton(size=30,panelThck=3,col="yellow");


//export

if (export=="cornerSphere")
  !crnrSphere();
if (export=="edgeBar")
  !edgeBar(outer=true);
if (export=="frame")
  !frame();

//place plates
for (rot=[[0,90,0],[90,0,0],[0,0,0]],iz=[-1,1])
  rotate(rot) translate([0,0,iz*(ovDims.z-matThck)/2]) 
    rndRect([ovDims.x-matThck*2-kerf*2,ovDims.y-matThck*2-kerf*2,matThck],crnRad,3);

//place spheres
if (showSpheres)for (rot=[0:90:270],iz=[0,1])
        mirror([0,0,iz]) rotate(rot) 
          translate([(ovDims.x/2)-matThck,(ovDims.y/2)-matThck,(ovDims.z/2)-matThck]) 
            crnrSphere();

color("green") translate([0,(ovDims.y-matThck)/2,(ovDims.z-matThck)/2])
  edgeBar();
  
    

if (showFrames) color("lightblue") 
    translate([0,0,ovDims.z/2-matThck]) frame();

*edgeBar(outer=false);
module edgeBar(length=ovDims.x,outer=true){  
  difSphereRad= outer ? crnrSphereRad+spcng : crnrSphereRad-fudge;
  if (outer)
    cube([ovDims.x-crnrSphereRad*2+matThck*2,matThck,matThck],true);
  
  difference(){
    translate([0,matThck/2,matThck/2]) rotate([0,90,0])
      cylinder(r=crnrSphereRad/2,h=ovDims.x,center=true,$fn=50);
    if (outer){
      translate([0,-(crnrSphereRad+matThck)/2,matThck/2]) cube([ovDims.x,crnrSphereRad,crnrSphereRad],true);
      translate([0,matThck/2,-(crnrSphereRad+matThck)/2]) cube([ovDims.x,crnrSphereRad,crnrSphereRad],true);
    }
    else{
      translate([0,(crnrSphereRad-matThck)/2,matThck/2])
        cube([ovDims.x,crnrSphereRad+spcng,crnrSphereRad+fudge],true);
      translate([0,0,-(crnrSphereRad-matThck)/2])
        cube([ovDims.x,crnrSphereRad+fudge,crnrSphereRad+spcng],true);
    }
    for (ix=[-1,1])
      translate([ix*(ovDims.x/2-matThck),-matThck/2,-matThck/2]) sphere(difSphereRad,$fn=50);
  }
}

module frame(){
  for (rot=[0:90:270]){
    rotate(rot){ 
      translate([-(ovDims.x)/2+matThck,-ovDims.y/2+matThck,0]) 
        cornerInlay();
      translate([0,(ovDims.y-matThck)/2,matThck/2]) edgeBar(outer=false);
    }
  }
}

*cornerInlay();
module cornerInlay(){
  rectSize= (crnrSphereRad > crnRad) ? crnrSphereRad*2 : crnRad*2;
  difference(){
    intersection(){
      sphere(crnrSphereRad,$fn=50);
      union(){
        translate([0,0,matThck*2]) cylinder(d=crnrSphereRad-spcng,h=crnrSphereRad-matThck*2);
        translate([rectSize/2,rectSize/2,crnrSphereRad/2+matThck+spcng])
           rndRect([rectSize-spcng,rectSize-spcng,crnrSphereRad+spcng],crnRad,0);
      }
    }
    translate([crnRad,crnRad,0]) cylinder(d=3.1,h=crnrSphereRad);
    translate([crnRad,crnRad,matThck*2]) cylinder(d=6.1,h=crnrSphereRad);
  }
}

*crnrSphere();
module crnrSphere(){
  rectSize= (crnrSphereRad > crnRad) ? crnrSphereRad*2 : crnRad*2;
  rotate([180,0,-90]) 
    difference(){
      sphere(crnrSphereRad,$fn=50);
      cube(crnrSphereRad);
      
      for (rot=[[0,0,0],[90,0,90],[-90,-90,0]]){
        rotate(rot){
          translate([rectSize/2,rectSize/2,-crnrSphereRad/2])
            rndRect([rectSize,rectSize,crnrSphereRad+fudge],crnRad,0);
          translate([0,0,-crnrSphereRad]) cylinder(d=crnrSphereRad,h=crnrSphereRad-matThck*2);
          translate([crnrSphereRad-matThck/2,0,0]) cube(matThck*2,true);
        }
      }
    }
}

batDims=[53,45,8];

*cage();
module cage(size=[100,100,100], dia=12){
    
    for (ix=[-1,1],iy=[-1,1],iz=[-1,1]){
        //z-beams
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]) cylinder(d=dia,h=size.x-dia,center=true);
        //x-beams
        translate([0,iy*(size.y/2-rad),iz*(size.z/2-rad)]) rotate([0,90,0]) cylinder(d=dia,h=size.x-dia,center=true);
        //y-beams
        translate([ix*(size.x/2-rad),0,iz*(size.z/2-rad)]) rotate([90,0,0]) cylinder(d=dia,h=size.x-dia,center=true);
    }
    for (rot=[0,90,180,270],iz=[0,1])
        mirror([0,0,iz]) rotate(rot) translate([(size.x/2-rad),(size.y/2-rad),(size.z/2-rad)]) crnrCap();
    //vertical beams
    //for (ix=[-1,1],iy=[-1,1])
    *crnrCap();
    module crnrCap(){
        rotate_extrude(angle=90) intersection(){
            square([rad,rad]);
            circle(d=12);
        }
    }    
    
}

*rndCube(ovDims,6);
module rndCube(size=[10,10,10],rad=3){
    //very slow rendering --> 46s @ fn=50
    hull() for (ix=[-1,1],iy=[-1,1],iz=[-1,1]){
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad),iz*(size.z/2-rad)]) sphere(r=rad);
    }
}



module rndRect(size, rad, drill=0, center=true){  
  if (len(size)==2) //2D shape
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(d=drill);
    }
  else
    
    linear_extrude(size.z,center=center) 
    difference(){
      hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(d=drill);
    }
}