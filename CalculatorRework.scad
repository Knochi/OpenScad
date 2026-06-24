use <eCAD/Displays.scad>


// TRIUMPH 80 C Calculator conversion
minWallThck=0.8;

/* [Hidden] */
fudge=0.1;

$fn=16;

translate([0,42,10]) Futaba_9ST12();
translate([0,38,2]) OLED2_42inch_RA(center=true);

%topShell();
module topShell(){
  //original topShell
  ovDims=[71.9,120.5,18.4];
  edgeRad=2;
  bdyUprWdth=71.2;
  bdyLwrWdth=71.9;
  topDims=[65.5,ovDims.y,0.9];
  chamfLen=52;
  chamfCntrOffset=-117.4/2+17.8+chamfLen/2;
  keysCutoutDims=[61.85,74.3];
  keysCutoutOffset=-ovDims.y/2+5.6+keysCutoutDims.y/2;
  
  
  difference(){
    body();
    //chamfers for shell
    for (ix=[-1,1])
      translate([ix*bdyUprWdth/2,chamfCntrOffset,ovDims.z-topDims.z]) 
        rotate([-90,0,0]) cylinder(r=edgeRad,h=chamfLen,center=true,$fn=4);
    //keyboard cutout
    translate([0,keysCutoutOffset,-fudge/2]) linear_extrude(ovDims.z+fudge) square(keysCutoutDims,true);
  }
  *body();
  module body(){
    translate([0,0,ovDims.z/2])
      rotate([90,0,0]) difference(){
        linear_extrude(ovDims.y,center=true) bdyShape();
        linear_extrude(ovDims.y-minWallThck*2,center=true) offset(-minWallThck) bdyShape();
        }
    translate([0,0,ovDims.z-topDims.z/2]) cube(topDims,true);
  }
  
  module bdyShape(){
    hull(){
      for (ix=[-1,1]){
        translate([ix*(bdyUprWdth/2-edgeRad),ovDims.z/2-edgeRad-topDims.z]) circle(edgeRad);
        translate([ix*(bdyLwrWdth/2-edgeRad),-ovDims.z/2+edgeRad]) circle(edgeRad);
      }
    }
  }
}