/* A customizable battery replacement for the Epson LW-C410 label writer
  This may be a base for battery replacments for other devices as well
  */

/* [Config] */
quality=50; // [20:100]
batRowCount=3;
batsPerRow=2;
// X Offset for each row
rowOffsets=[0,4,0];
batSize="AA"; //["A", "AA", "AAA"]

/* [show] */
showBatteries=true;

/* [Dimensions] */

/* [Hidden] */
fudge=0.1;
$fn= quality;
batDia= batSize=="A"   ? 16.5 :
        batSize=="AA"  ? 14.5 :
        batSize=="AAA" ? 10.5 : 15;
batLen= batSize=="A"   ? 50.0 :
        batSize=="AA"  ? 50.5 :
        batSize=="AAA" ? 44.5 : 50;

if (showBatteries)        
  color("silver") batteries();
   
batCompartment();

module batteries(spcng=0,cut=false){
  for (ix=[0:(batsPerRow-1)],iy=[0:batRowCount-1]){
    batRot=iy%2 ? [0,90,0] : [0,-90,0];
    translate([ix*batLen-batLen*(batsPerRow-1)/2+rowOffsets[iy],iy*batDia-batDia*(batRowCount-1)/2]) 
      rotate(batRot)  battery(spcng,cut);
  }
}

module batCompartment(){
  bdyDims=[121.6,54,25];
  lidOpngDims=[108.7,46.5,2];
  lidOpngRad=6;
  batCmpDims=[103,43.3,15.4];
  brimDia=0.5;
  latchDims=[8.3,11.5,1.6];
  webHght=2.7;
  zOffset=-2.5;
  
  //dummy body and LW-C410 battery compartment
  translate([0,0,zOffset]){
    difference(){
      cube(bdyDims,true);
      //lid opening
      translate([0,0,bdyDims.z/2-lidOpngDims.z])
        linear_extrude(lidOpngDims.z+fudge) offset(lidOpngRad) 
          square([lidOpngDims.x-lidOpngRad*2,lidOpngDims.y-lidOpngRad*2],true);
      //battery compartment
      translate([0,0,bdyDims.z/2-batCmpDims.z/2-brimDia-lidOpngDims.z+webHght/2]) 
        cube(batCmpDims+[0,0,lidOpngDims.z-webHght],true);
      //batteries
      translate([0,0,-zOffset]) batteries(spcng=+0.3,cut=true);
    }
    //brim
    translate([0,0,bdyDims.z/2-lidOpngDims.z]) 
      linear_extrude(brimDia) difference(){
        offset(lidOpngRad-brimDia) 
          square([lidOpngDims.x-(lidOpngRad-brimDia)*2,lidOpngDims.y-(lidOpngRad-brimDia)*2],true);
        offset(lidOpngRad-brimDia*2) 
          square([lidOpngDims.x-(lidOpngRad-brimDia)*2,lidOpngDims.y-(lidOpngRad-brimDia)*2],true);
      }
    //latches
    latchPlus=batCmpDims.y-batDia*2-latchDims.y;
    translate([0,0,bdyDims.z/2-lidOpngDims.z-latchDims.z/2]){
      translate([-batCmpDims.x/2+latchDims.x/2,0,0]) cube(latchDims,true);
      for (iy=[-1,1])
        translate([+batCmpDims.x/2-latchDims.x/2,iy*(batDia+latchPlus/4),0]) cube(latchDims+[0,latchPlus/2,0],true);
    }
  }
}


*battery(cut=true);
module battery(spcng=0,cut=false){
  cntctPosLen=2.2;
  cntctNegLen=0.5;
  cntctPosDia=5.5;
  cntctNegDia=9.4;
  crnrRad=0.5;
  bodyLen=batLen-cntctPosLen-cntctNegLen*2;
  if (cut)
    cylinder(d=batDia+spcng,h=batLen+fudge,center=true);
  else
    rotate_extrude() 
      difference(){
        union(){
          //body
          translate([0,-(cntctPosLen-cntctNegLen)/2]){
            offset(crnrRad) square([batDia-crnrRad*2+spcng*2,bodyLen-crnrRad*2],true);
            //upper and lower face
            square([cntctNegDia,bodyLen+2*cntctNegLen],true);
          }
          //pos knop
          translate([0,(batLen-cntctPosLen)/2]) square([cntctPosDia,cntctPosLen],true);
        }
        //delete everything -X
        translate([-batDia/4-fudge/2-spcng/2,0]) square([batDia/2+fudge+spcng,batLen+fudge],true);
      }
}