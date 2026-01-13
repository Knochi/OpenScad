
/* [Dimensions] */
contDims=[55,6.65,20];
cvrHght=8;
cvrSpcng=0.23;

/* [Linkage] */
linkBeamWdth=2;
linkBeamHght=3.5;
linkAxisWdth=1;
linkSpcng=0.2;

/* [show] */
$fn=48;
showOContainer=true;
showOCover=true;
showOLinkages=true;

/* [hidden] */
shrtLnkPos=[[3.86,contDims.y/2,17.25],[-3.21,contDims.y/2,11.19]];
shrtLnkLen=norm(shrtLnkPos[0]-shrtLnkPos[1]);
lngLnkPos=[[11.01,contDims.y/2,15.16],[-3.21,contDims.y/2,30.08]];
lngLnkLen=norm(lngLnkPos[0]-lngLnkPos[1]);
echo(shrtLnkLen,lngLnkLen);

rotate([90,0,0]) translate([-178.4,19.96,43.25]){
  if (showOContainer)
    %import("Container.stl");
  if (showOCover)
    %import("Cover.stl");
  if (showOLinkages){
    %import("LinkageLong.stl");
    %import("LinkageShort.stl");
  }
}
//short linkage
translate(shrtLnkPos[0]) rotate([0,139.4,0]) linkage(length=shrtLnkLen);
//long linkage
translate(lngLnkPos[0]) rotate([0, 226.4,0]) linkage(length=lngLnkLen);
*container();
module container(){
  cube(contDims);
}
*cover();
module cover(){
  rotate([0,-90,0]) translate([0,0,cvrSpcng]) cube([contDims.x,contDims.y,cvrHght]);
}

*linkage();
module linkage(length=50){
  for (ix=[0,1])
    translate([ix*length,0,0]) rotate([90,0,0]) cylinder(d=linkBeamHght,h=linkAxisWdth*2+linkBeamWdth, center=true);
  translate([length/2,0,0]) cube([length,linkBeamWdth,linkBeamHght],true);
}