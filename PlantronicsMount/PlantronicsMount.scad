use <threads.scad>
use <thumbScrew.scad>

/* [Dimensions] */
$fn=50;
rmtDims=[21,74,10.5];
ratio=[12/21,64/74];
tblThck=25;
cblRad=10;
cblDia=3;
cblStrgthLngth=rmtDims.y+4.5+1.5;
cblOffset=[-cblRad,rmtDims.y/2+4.5,-4.5/2+rmtDims.z-1.7];
plgDia=7.8;
minWallThck=2;
screwDia=3;
thmbScrewDia=10;
cmplxHookWdth=thmbScrewDia+5;

/* [show] */
showRemote=true;
showHook=true;
showClamp=true;
export="none"; //["none","hook","body"]

/* [Hidden] */
fudge=0.1;


if (showRemote && (export=="none")) plantronicsRemote();
if (showClamp) clamp();

module plantronicsRemote(cut=false){
  if (cut){
    translate([0,0,-fudge/2]) linear_extrude(rmtDims.z+fudge)
        translate([-21/2,-74/2,0])
          offset(fudge)
            import("PlanTronicsRemoteShape.svg");
    translate([0,-rmtDims.y/2-minWallThck-fudge,7.8/2]) rotate([-90,0,0]) cylinder(d=plgDia+fudge,h=7+fudge);
    translate([0,rmtDims.y/2+4.5+fudge,-4.5/2+rmtDims.z-1.7]){
      rotate([90,0,0]) cylinder(d=4.5+fudge,h=9+fudge);
      translate([0,-(4.5+fudge)/2,(4.5/2+1.7)/2]) cube([4.5+fudge,4.5+fudge,4.5/2+1.7+fudge],true);
    }
    //cable channel
    translate(cblOffset)
      rotate_extrude(angle=180) translate([cblRad,0]){
        circle(d=cblDia+fudge);
        translate([0,(rmtDims.z-cblOffset.z)/2]) 
            square([cblDia+fudge,rmtDims.z-cblOffset.z+fudge],true);
          }
      translate(cblOffset+[-cblRad,0,0]){
          rotate([90,0,0]) cylinder(d=cblDia+fudge,h=rmtDims.y+4.5+minWallThck+fudge);
          translate([0,-(rmtDims.y+4.5+minWallThck+fudge)/2,(rmtDims.z-cblOffset.z)/2]) 
            cube([cblDia+fudge,rmtDims.y+4.5+minWallThck+fudge,rmtDims.z-cblOffset.z+fudge],true);
        }
       //front radius
      
        translate([cblOffset.x-cblRad,-rmtDims.y/2-minWallThck,cblOffset.z-cblRad]) rotate([90,0,-90])
        rotate_extrude(angle=90) translate([cblRad,0]){
          circle(d=cblDia+fudge);
          translate([(rmtDims.z-cblOffset.z)/2,0]) 
            square([rmtDims.z-cblOffset.z+fudge,cblDia+fudge],true);
        }
        //straight down
       translate([cblOffset.x-cblRad,-rmtDims.y/2-minWallThck-cblRad,cblOffset.z-cblRad*2-tblThck]){
        cylinder(d=cblDia+fudge,h=tblThck+cblRad+fudge);
        translate([0,-(rmtDims.z-cblOffset.z)/2,(tblThck+cblRad+fudge)/2])
          cube([cblDia+fudge,rmtDims.z-cblOffset.z+fudge,tblThck+cblRad+fudge],true);
     }
  }
  //else {
    //body
    color("darkSlateGrey"){
      translate([0,0,rmtDims.z+fudge])
        rotate([0,180,0]) linear_extrude(rmtDims.z,scale=ratio)
          translate([-21/2,-74/2,0])
            import("PlanTronicsRemoteShape.svg");
      //headphone plug
      translate([0,-rmtDims.y/2-1.5,7.8/2]) 
        rotate([-90,0,0]) cylinder(d=plgDia,h=7);
      
      //cable
      translate(cblOffset)
        rotate_extrude(angle=180) translate([cblRad,0]) circle(d=3);
      translate(cblOffset+[-cblRad,0,0])  
        rotate([90,0,0]) cylinder(d=cblDia,h=cblStrgthLngth);
      //translate(cblOffset+[-cblRad,-cblStrgthLngth,-cblRad]) rotate([90,0,-90])
      translate([cblOffset.x-cblRad,-rmtDims.y/2-minWallThck,cblOffset.z-cblRad]) rotate([90,0,-90])
        rotate_extrude(angle=90) translate([cblRad,0]) circle(d=3);
      //translate(cblOffset+[-cblRad,-cblStrgthLngth-cblRad,-cblRad-tblThck])
      translate([cblOffset.x-cblRad,-rmtDims.y/2-minWallThck-cblRad,cblOffset.z-cblRad-tblThck])
        cylinder(d=cblDia,h=tblThck);
      
    }//color
    //cable protection
    color("darkRed") translate([0,rmtDims.y/2+4.5,-4.5/2+rmtDims.z-1.7]) rotate([90,0,0]) cylinder(d=4.5,h=9);
  //}
  
}

module clamp(){
  crnRad=2;
  mainRad=cblRad+cblDia/2+minWallThck;
  clmpDims=[rmtDims.x/2+cblRad+cblDia+minWallThck*2,rmtDims.y/2+cblOffset.y+cblDia+1.5,rmtDims.z];
  hookWdth=rmtDims.x/2+minWallThck-cblOffset.x;
  hookOffset=[cblOffset.x-mainRad/2+hookWdth/2,-rmtDims.y/2-minWallThck/2,-tblThck/2];
  cmplxHkOffset=[cblOffset.x-mainRad,hookOffset.y-minWallThck/2,cblOffset.z-cblRad];
  
  difference(){
    union(){
      if (export=="none") difference(){
          body();
          cmplxHook(true);
        }
      if (showHook) cmplxHook();
    }
    plantronicsRemote(true);
    if (export=="hook") //render thread with hook only
      render(convexity=2) 
        translate(cmplxHkOffset+[cmplxHookWdth/2,cmplxHookWdth/2,-tblThck+cmplxHkOffset.z*2-fudge*2]) 
          metric_thread(diameter=thmbScrewDia,pitch=1,length=clmpDims.z+fudge*4,internal=true);
    else 
      translate(cmplxHkOffset+[cmplxHookWdth/2,cmplxHookWdth/2,-tblThck+cmplxHkOffset.z*2-fudge*2]) 
        cylinder(d=thmbScrewDia,h=clmpDims.z+fudge*4); 
  }
  //simple table clamp
  
  
  
  module body(){
    hull(){
      translate([cblOffset.x,cblOffset.y,0]) 
        chmfCylinder(r=mainRad,h=clmpDims.z,chmf=2);
      translate([cblOffset.x-mainRad/2,-rmtDims.y/2+mainRad/2-minWallThck,0]) 
        chmfCylinder(r=mainRad/2,h=clmpDims.z,chmf=2);
      translate([-mainRad+rmtDims.x/2+minWallThck,cblOffset.y,0]) 
        chmfCylinder(r=mainRad,h=clmpDims.z,chmf=2);
      translate([-mainRad/2+rmtDims.x/2+minWallThck,-rmtDims.y/2+mainRad/2-minWallThck,0]) 
        chmfCylinder(r=mainRad/2,h=clmpDims.z,chmf=2);
    }
    
  }//body
  module smplHook(){
    cube([hookWdth,minWallThck,tblThck+minWallThck],true);
    translate([0,rmtDims.y/4,-(tblThck+minWallThck)/2]) 
      cube([hookWdth,rmtDims.y/2,minWallThck],true);
      
    //tip
    translate([0,rmtDims.y/2,-tblThck/2-minWallThck]){
      rotate([-10,00,0]) rotate_extrude(angle=180) 
         square([hookWdth/2,minWallThck]);
      rotate([0,-90,0]) rotate_extrude(angle=10)
        translate([minWallThck/2,0,0]) square([minWallThck,hookWdth],center=true);
    }
    //chamfer
    translate([0,0,-(tblThck+minWallThck)/2]) rotate([0,90,0]) 
      cylinder(d=minWallThck,h=hookWdth,center=true);
  }
  
  module cmplxHook(cut=false){
    if (cut)
      translate(cmplxHkOffset+[cmplxHookWdth-screwDia-crnRad,-fudge,-cmplxHkOffset.z+clmpDims.z/2])
       rotate([-90,0,0])
         cylinder(d=screwDia*0.75,h=20+fudge);
       
    else {
    //upper part
     difference(){
      union(){
        translate(cmplxHkOffset+[0,0,0]) rotate([-90,-90,0]) 
          linear_extrude(cmplxHookWdth) cmplxShape();
         translate(cmplxHkOffset) rotate([180,-90,0])
        rotate_extrude(angle=90) cmplxShape();
      }
      hull(){
        translate([cblOffset.x-mainRad/2,-rmtDims.y/2+mainRad/2-minWallThck,0]) 
          chmfCylinder(r=mainRad/2+fudge,h=clmpDims.z+fudge,chmf=2+fudge);
        translate([-mainRad/2+rmtDims.x/2+minWallThck,-rmtDims.y/2+mainRad/2-minWallThck,0]) 
          chmfCylinder(r=mainRad/2+fudge,h=clmpDims.z+fudge,chmf=2+fudge);
      }
     translate(cmplxHkOffset+[cmplxHookWdth-screwDia-crnRad,fudge,-cmplxHkOffset.z+clmpDims.z/2])
       rotate([90,0,0]){
         cylinder(d=screwDia+fudge,h=20+fudge);
         translate([0,0,5]) cylinder(d=screwDia*2,h=15);
       }
    
   
    }
    //lower part
    translate(cmplxHkOffset+[0,0,-cmplxHkOffset.z*2-tblThck]){
      rotate([-90,0,-90]) rotate_extrude(angle=90) cmplxShape();
      rotate([0,0,-90]) linear_extrude(tblThck+cmplxHkOffset.z*2) cmplxShape();
      translate([0,cmplxHookWdth,0]) rotate([90,90,0]) linear_extrude(cmplxHookWdth) cmplxShape();
      translate([0,cmplxHookWdth,0]) rotate([90,90,0]) cmplxShape(true);
    }
  }//else
      
      
    module cmplxShape(cap=false){
      translate([-cblOffset.z+cblRad+clmpDims.z/2,+cmplxHookWdth/2]){
        hull() for (ix=[-1,1],iy=[-1,1])
          if (cap) translate([ix*(clmpDims.z/2-crnRad),iy*(cmplxHookWdth/2-crnRad),0])
            sphere(crnRad);
          else translate([ix*(clmpDims.z/2-crnRad),iy*(cmplxHookWdth/2-crnRad)])
            circle(crnRad);
      }
    }//cmplxShape
  
  }//cmplxHook
  
}

*chmfCylinder();
module chmfCylinder(r=1,h=1,chmf=0.2){
  rotate_extrude(){
    square([r,h-chmf]);
    square([r-chmf,h]);
    translate([r-chmf,h-chmf]) circle(chmf);
  }
}