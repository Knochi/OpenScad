/* [Parameters] */
$fn=50;
barDims=[20.5,1000,2.1]; //Dimensions of the raw bar to engrave
subStrokeDims=[10,0.3];
mainStrokeDims=[18,0.6];
firstStrokeOffset=7; //2 litres at39mm
textOffset=[-4,1];
textSize=8;
kettleDia=280;
kettleRim=30;
litresPerDiv=2; //litres per division
litresPerSubdiv=1; //litres per sub-division
maxLitres=30; //maximum litres
wallThck=3;
hldrHght=15;
spcng=0.5;
fudge=0.1;

/* [Hidden] */
mmPerDiv=litres2height(litresPerDiv,kettleDia);
mmPerSubdiv=litres2height(litresPerSubdiv,kettleDia);

holder();
module holder(){
  screwOffset=(hldrHght-wallThck)/2;
  hldrOvDims=[barDims.x+wallThck*2,kettleRim+wallThck*3+barDims.z+spcng*2+3];
  difference(){
    linear_extrude(screwOffset*2,convexity=3) difference(){
      union(){
        square([barDims.x+wallThck*2,barDims.z+wallThck*2],true);
        translate([0,barDims.z/2+(4+wallThck*2)/2+spcng]) square([7+wallThck*2,3+wallThck*2],true);
      }
      square([barDims.x+spcng*2,barDims.z+spcng*2],true);
    }
    translate([0,(barDims.z)/2+wallThck,screwOffset]) rotate([-90,0,0]){
      M4Nut();
      }
      translate([0,0,screwOffset]) rotate([-90,0,0]) cylinder(d=4.3,h=15);
    
    }
  translate([0,0,hldrHght-wallThck]) linear_extrude(wallThck) difference(){
    translate([0,-11.5]) square([hldrOvDims.x,hldrOvDims.y],true);
    square([barDims.x+spcng*2,barDims.z+spcng*2],true);
  }
    
  translate([0,-35.50,hldrHght/2]) cube([hldrOvDims.x,wallThck,hldrHght],true);
}

module marking(){
  color("lightgrey") translate([0,0,barDims.z])
    for (i=[1:(maxLitres/litresPerSubdiv)]){
      //if (mmPerDiv/i*mmPerSubDiv)
      if (i*litresPerSubdiv%(litresPerDiv)) //subDiv
        translate([0,i*mmPerSubdiv-subStrokeDims.y/2+firstStrokeOffset]) square(subStrokeDims);
      else //mainDiv
        translate([0,i*mmPerSubdiv+firstStrokeOffset]){
          translate([0,-mainStrokeDims.y/2]) square(mainStrokeDims);
          translate([subStrokeDims.x,0]+textOffset) text(str(i*litresPerSubdiv),size=textSize);
        }
    }
  echo(mm2Litres(470,280));
  echo(litres2height(28.9,280));
}

*M4Nut();
module M4Nut(spcng=0.2){
  s=7;
  dia=ri2ro(s,6);
  linear_extrude(3+spcng*2) offset(spcng) {
    rotate(180/6) circle(d=dia,$fn=6);
    translate([0,hldrHght/4]) square([s,dia/2+fudge],true);
    }
}

function mm2Litres(height,dia)=pow(dia/200,2)*PI*height/100;

function litres2height(litres,dia)=litres/(pow(dia/200,2)*PI/100);

// -- helper Functions -- 
function ri2ro(ri,N)=ri/cos(180/N);
function ri2a(ri,N)=2*ri*tan(180/N);