sdCardOvDims=[24,32,2.1];
sdCardBrmWdth=0.6;
sdCardCrnrRad=1;
sdCardNotchDims=[sdCardBrmWdth,1.5];
sdCardNotchYOffset=sdCardOvDims.y/2-11.5+sdCardNotchDims.y/2;
cntctSurHght=1.4;
cntcCavDist=2.5;
cntcCavDims=[(15-6*0.6)/6,6,sdCardOvDims.z-cntctSurHght];
cntcCav1XOffset=-8.125+cntcCavDist/2;
cntcCav9Dims=[sdCardOvDims.x/2-0.7-sdCardBrmWdth-(8.125+0.3),8,sdCardOvDims.z-cntctSurHght];
echo(cntcCav9Dims.x);
cntcCav9XOffset=-8.125-0.3-cntcCav9Dims.x/2;
cntcCav78Dims=[sdCardOvDims.x/2-0.7-sdCardBrmWdth-(-8.125+6*cntcCavDist+0.3),6,sdCardOvDims.z-cntctSurHght];
cntcCav78XOffset=sdCardOvDims.x/2-0.7-sdCardBrmWdth-cntcCav78Dims.x/2;


fudge=0.1;
$fn=48;

//bottom
difference(){
  union(){
    linear_extrude(1.4) offset(sdCardCrnrRad) square([sdCardOvDims.x-sdCardCrnrRad*2,sdCardOvDims.y-sdCardCrnrRad*2],true);
    linear_extrude(sdCardOvDims.z) offset(sdCardCrnrRad/2) 
      square([sdCardOvDims.x-sdCardCrnrRad-sdCardBrmWdth*2,sdCardOvDims.y-sdCardCrnrRad],true);
  }
  translate([-sdCardOvDims.x/2,sdCardOvDims.y/2,-fudge/2]) linear_extrude(sdCardOvDims.z+fudge) circle(d=8,$fn=4);
  //contact cavities 1-6
  for (i=[0:5])
    translate([i*cntcCavDist+cntcCav1XOffset,(sdCardOvDims.y-cntcCavDims.y+fudge)/2,cntctSurHght]) 
      linear_extrude(cntcCavDims.z+fudge) square([cntcCavDims.x,cntcCavDims.y+fudge],true);
  //contact cavitiy 9
  translate([cntcCav9XOffset,(sdCardOvDims.y-cntcCav9Dims.y+fudge)/2,cntctSurHght]) 
    linear_extrude(cntcCavDims.z+fudge)square([cntcCav9Dims.x,cntcCav9Dims.y+fudge],true);
  //contact cavity pins 7&8
  translate([cntcCav78XOffset,(sdCardOvDims.y-cntcCav78Dims.y+fudge)/2,cntctSurHght]) 
    linear_extrude(cntcCavDims.z+fudge)square([cntcCav78Dims.x,cntcCav78Dims.y+fudge],true);
  //notch
  translate([-(sdCardOvDims.x-sdCardNotchDims.x+fudge)/2,sdCardNotchYOffset,-fudge/2]) 
    linear_extrude(sdCardOvDims.z+fudge) square([sdCardNotchDims.x+fudge,sdCardNotchDims.y+fudge],true);
}
  