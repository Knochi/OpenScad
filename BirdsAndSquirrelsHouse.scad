$fn=60;
/*[JarHolder]*/
jarDia=80;
jarHght=80;
beamDia=15;
wallThck=2;
spcng=0.3;
hingeWdth=18;
beamAng=50;
screwDia=3.6;
screwLngth=40;
jarZPos=85;

/*[BirdsHouse]*/
ovDims=[150,170,365];
pltFrmHght=155;
matThck=12;
wndwDims=[ovDims.y-4-matThck*4,110,3];



/* [Hidden] */
facePoly=[[-ovDims.x/2,0],[-ovDims.x/2,ovDims.z-90],
        [-ovDims.x/2+65,ovDims.z],
        [ovDims.x/2,ovDims.z-55],[ovDims.x/2,0]];
roofAngLft=atan2(90,65);// left calc angel from dimensions
roofAngRght=atan2(55,ovDims.x-65);
echo(roofAngLft,roofAngRght);
fudge=0.1;

translate([0,-ovDims.y/2+matThck+2,jarZPos]) rotate([90,0,0]) translate([0,0,-80])jar();
translate([0,-(ovDims.y/2-matThck),jarZPos]) rotate([-90,90,0]) holder();
#translate([0,0,ovDims.z]) roof();

//front and back
color("ivory") translate([0,-ovDims.y/2+matThck,0]) rotate([90,0,0]) face();
translate([0,-ovDims.y/2,20]) rotate([90,90,0]) barkTile();

color("ivory") translate([0,ovDims.y/2,0]) rotate([90,0,0]) face(false);
//platform and divider
color("brown") translate([-ovDims.x/2,0,pltFrmHght]) platform();
//floor
*color("ivory") translate([0,0,matThck/2]) cube([ovDims.x-matThck*2,ovDims.y,matThck],true);

//left 
*color("grey") translate([-(ovDims.x-matThck)/2,0,(pltFrmHght-matThck)/2]) 
  cube([matThck,ovDims.y-matThck*2,pltFrmHght-matThck],true);

//drawer
translate([0,0,pltFrmHght]) drawer();

translate([-ovDims.x/2,ovDims.y/2-matThck,pltFrmHght+matThck/2]) rotate([-90,0,90]) stopper();

*barkTile();
module barkTile(){
  dia=50;
  a=dia/2;
  ri=(a/2) * sqrt(3);
  
  chmf=2;
  factor=1-chmf/dia*2;
  thck=5;
  wedgeWdth=3;
  wedgeDist=2;
  aWdg= wedgeWdth * (2/sqrt(3)); //ru = a
  h = aWdg/2 * sqrt(3);
  wedgeOffset = [0,wedgeWdth/2]; //center distance of two hexagons with ri=wedgeWdth

  difference(){
    union(){
      cylinder(d=dia,h=thck-chmf,$fn=6);
      translate([0,0,thck-chmf]) linear_extrude(chmf,scale=factor) circle(d=dia,$fn=6);
    }
    translate([0,0,thck+fudge]){
      //translate([-6,0,0]) wedge([6,3,3]);
      translate([0,0,0]) wedge([aWdg,3,3]);
      translate([-h,wedgeOffset.y,0]) wedge([aWdg,3,3]);
      //translate([-aWdg,0,0]) wedge([3,3,3]);
      for (i=[0:60:360-60])
        rotate(i) translate([dia/2,0,-fudge]) screw3x16(true);
      }
  }
}



*wedge();
module wedge(size=[11,3,3]){
  
  xOffset=(size.y/2)/tan(60);
  poly=[[-size.x/2,0,size.z]                 ,[-(size.x/2-xOffset),size.y/2,size.z],
        [(size.x/2-xOffset),size.y/2,size.z] ,[size.x/2,0,size.z],
        [(size.x/2-xOffset),-size.y/2,size.z],[-(size.x/2-xOffset),-size.y/2,size.z],
        [-(size.x/2-xOffset*2),0,0]          ,[(size.x/2-xOffset*2),0,0]];
  
  translate([0,0,-size.z]) polyhedron(poly,[[0,1,2,3,4,5],[0,6,1],[0,5,6],[3,2,7],[4,3,7],[2,1,6,7],[5,4,7,6]]);
  
}
  
*spacer();
module spacer(){
  dia=15;
  baseThck=5;
  drillDia=4;
  ovHght=45;
  k=2.2;
  dk=7;
  
  difference(){
    hull(){ for(iy=[-1,1])
      translate([0,iy*(dia/2+4),0]) cylinder(d=dk+2,h=baseThck);
      cylinder(d=dia,h=baseThck);
    }
    for (iy=[-1,1]){
      translate([0,iy*(dia/2+4),-fudge/2]) cylinder(d=drillDia,h=baseThck+fudge);
      translate([0,iy*(dia/2+4),baseThck-k]) cylinder(d1=3.5-fudge,d2=7+fudge,h=k+fudge*2);
    }
  }
  translate([0,0,baseThck]) cylinder(d1=dia, d2=dia*0.8, h=ovHght-baseThck-dia*0.8/2);
  translate([0,0,ovHght-dia*0.8/2]) sphere(d=dia*0.8);
    
}

*stopper();
module stopper(){
  ovDims=[matThck*2,matThck,2];
  
  difference(){
    union(){
      hull() for(ix=[-1,1]) 
        translate([ix*(ovDims.x-ovDims.y)/2,0,0]) cylinder(d=ovDims.y,h=ovDims.z);
      hull() for(iy=[-1,1]) 
        translate([ovDims.y/2,iy*(ovDims.x-ovDims.y)/2+ovDims.y/2,0]) cylinder(d=ovDims.y,h=ovDims.z);
    }
    translate([(ovDims.x-ovDims.y)/2,0,-fudge]) cylinder(d1=3.5-fudge,d2=7+fudge,h=2.2+fudge*2);
  }
}

*drawer();
module drawer(){
  tiltAng=10;
  flrWdth=(ovDims.x-matThck)/cos(tiltAng);
  sideHght=wndwDims.y-(ovDims.x-matThck)*tan(tiltAng)+matThck;
  flrDeep=ovDims.y-matThck*4;
  sltDims=[30,flrDeep-50];
  spcng=1;
  
  //floor
  translate([-ovDims.x/2,0,0]) rotate([0,-tiltAng,0]) translate([ovDims.x/2,0,0]){
    color("ivory") linear_extrude(matThck)
      difference() {
        translate([flrWdth/2-ovDims.x/2,0,0]) square([flrWdth,flrDeep],true);
        hull() for(iy=[-1,1])
          translate([0,iy*sltDims.y/2]) circle(d=sltDims.x);
      }
      union(){
        color("Grey") linear_extrude(matThck+1) difference(){
          offset(-spcng) hull() for(iy=[-1,1])
            translate([0,iy*sltDims.y/2]) circle(d=sltDims.x);
          for (ix=[-2:2],iy=[-10:10]){
            
            translate([ix*4,iy*4]) circle(d=2);
          }
        }
        translate([0,0,matThck]) linear_extrude(1) difference(){
          offset(5+1) hull() for(iy=[-1,1])
            translate([0,iy*sltDims.y/2]) circle(d=sltDims.x);
          offset(-spcng) hull() for(iy=[-1,1])
            translate([0,iy*sltDims.y/2]) circle(d=sltDims.x);
          for(iy=[-1,1]) translate([0,iy*(sltDims.y+sltDims.x+5)/2]) circle(d=3);
          for(ix=[-1,1],iy=[-1,1]) translate([ix*(sltDims.x+5)/2,iy*20]) circle(d=3);
        }
      }
    }
  //faces
  color("ivory") for (iy=[-1,1])
    translate([0,iy*(ovDims.y/2-matThck*1.5),(wndwDims.y)/2+matThck/2]) 
      cube([ovDims.x,matThck,wndwDims.y+matThck],true);
    //side
  color("grey") translate([ovDims.x/2-matThck,0,wndwDims.y-sideHght/2+matThck]) 
    rotate([0,90,0]) linear_extrude(matThck) difference(){
      square([sideHght,ovDims.y-matThck*4],true);
    }
  //window
  translate([-ovDims.x/2+wndwDims.z/2,0,wndwDims.y/2+matThck]) 
    rotate([90,0,90]) color("grey",0.3) cube(wndwDims,true);
}

module roof(){
  //230x170x12
  translate([-ovDims.x/2+65,ovDims.y/2-230,0]) rotate([0,roofAngRght,0]) cube([170,230,12]);
}

module platform(){
  pltFrmDims=[120,ovDims.y-matThck*2,12];
  translate([(pltFrmDims.x+ovDims.x)/2-pltFrmDims.x,0,-pltFrmDims.z/2]) 
    cube(pltFrmDims+[ovDims.x,0,0],true);
  echo(pltFrmDims+[ovDims.x,0,0]);
}

module face(isFront=true){
  
  linear_extrude(matThck) difference(){
    polygon(facePoly);
    if (isFront) 
      translate([0,jarZPos]) circle(d=70);
    else //isBack
      translate([0,270]) circle(d=8);
  }
  
}

module holder(){
  difference(){
    for(ir=[-1,1])
      rotate(ir*beamAng) translate([(jarDia+beamDia)/2,0,0]){
        difference(){
          cylinder(d=beamDia,h=jarHght); //beams
          translate([0,0,-fudge]) cylinder(d=screwDia,h=screwLngth); //screwhole
        }
        translate([0,0,jarHght]) 
          cylinder(d=beamDia-wallThck*2-spcng*2,h=hingeWdth+wallThck); //hingePole
        translate([0,0,jarHght+hingeWdth]) cylinder(d=beamDia,h=wallThck); //hingeCap
        translate([0,0,jarHght+spcng]){
          difference(){ //hinge sleeves
            cylinder(d=beamDia,h=hingeWdth-spcng*2);
            translate([0,0,-spcng]) cylinder(d=beamDia-wallThck*2,h=hingeWdth);
            if (ir==1) rotate(90-beamAng){ //cut away on one side
              translate([-beamDia/2-fudge,-beamDia/2,-spcng])
                cube([beamDia/2+fudge,beamDia+fudge,hingeWdth]);
              translate([-fudge,-beamDia/2,-spcng])
                cube([beamDia/2+fudge,beamDia/2+fudge,hingeWdth]);
          }
          
          }
        }
      }//for
    }//diff
  difference(){
    hull() for(ir=[-1,1]) //latch
      rotate(ir*beamAng) translate([(jarDia+beamDia)/2,0,0])
        rotate(ir*(180-beamAng)) translate(([(beamDia-wallThck)/2,0,jarHght+spcng])) 
          cylinder(d=wallThck,h=hingeWdth-spcng*2);
  }
  
  
  difference(){
    rotate(-beamAng) rotate_extrude(angle=beamAng*2) //wallMount
      translate([(jarDia/2),0,0]) square([beamDia,wallThck]);
    for(ir=[-1,1])
      rotate(ir*beamAng) translate([(jarDia+beamDia)/2,0,0])
        translate([0,0,-fudge]) cylinder(d=screwDia,h=screwLngth);
  }
}

module jar(){
  cylinder(d=80,h=80);
  translate([0,0,80]) cylinder(d=65,h=20);
}

*screw3x16();
module screw3x16(cut=false){
  dk=1.8;
  k=6;
  if (cut){
    translate([0,0,-16-fudge])cylinder(d=3+fudge*2,h=16-dk+fudge);
    translate([0,0,-dk-fudge]) cylinder(d1=3+fudge*2,d2=k+fudge*4,h=dk+fudge*2);
  }
  else{
    translate([0,0,-16])cylinder(d=3,h=16-dk);
    translate([0,0,-dk]) cylinder(d1=3,d2=k,h=dk);
  }
}