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