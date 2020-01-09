$fn=50;
fudge=0.1;
spc=0.1;

/* [show] */
showCut=true;
export="handle"; //["handle","hook"]

if (export=="handle")
  !handle();

if (export=="hook")
  !hook();

difference(){
  union(){
    hook();
    translate([0,0,5.8]) rotate([180,0,0]) handle();
  }
  color("darkred") translate([0,0,-10]) cube([8,8,20]);
}

module handle(){
  hndlDia=7;
  hndlOffset=(14)/2;
  fltOffset=4.7;
  ovHght=12;
  
  difference(){
    body();
    translate([0,0,-fudge]){
      cylinder(d=2.8,h=ovHght+fudge*2);
      cylinder(d=5+spc*2,h=1.1+fudge); 
      translate([(12+fltOffset)/2,0,(8.5+fudge*2)/2]) cube([12-fltOffset,12,8.5+fudge*2],true);
      intersection(){
        cylinder(d=5+spc*2,h=6);
        translate([0,0,6/2]) cube([5+spc*2+fudge,4.3+spc*2,6],true);
      }
    }
    translate([0,0,ovHght-1.8]) cylinder(d1=2.8,d2=6,h=1.8);
  } 
  
  module body(){
    
    cylinder(d1=12,d2=8.5,h=ovHght);
    translate([-(14-4.7)/2,0,0]) hull() for (ix=[-1,1])
      translate([ix*(14-4.7)/2,0,0]) cylinder(d1=4.7,d2=2.5,h=ovHght);
    translate([-hndlOffset,0,ovHght]) rotate([90,0,0]) rotate_extrude(){
      translate([(hndlDia-2.5)/2,0]) circle(d=2.5);
      translate([0,-2.5/2]) square([(hndlDia-2.5)/2,2.5]);
    }
  }
}

module hook(){
  rad=1;
  slice=(5-4.25)/2;
  
  difference(){
    body();
    translate([0,0,-fudge]) cylinder(d=2.8,h=8);
    for (iy=[-1,1])
      translate([0,iy*(5-slice+fudge)/2,(4.8-fudge)/2]) cube([6.5,slice+fudge,4.8+fudge],true);
  }
  module body(){
    
    cylinder(d=5,h=6.5);
     
    translate([0,0,6.5]) cylinder(d=8,h=2);
    translate([1,0,6.5+2])
      hull() for (ix=[-1,1])
        translate([ix*(6-4)/2,0,0]) cylinder(d=4,h=2.6+rad);
    translate([-2,0,6.5+2+2.6+5/2]) minkowski(){
      cube([12,7,5]+[-2*rad,-2*rad,-2*rad],true);
      sphere(rad);
    }
    translate([-10+4+rad,0,6.5+2+2.6+5+0.9/2]) frustum([4,7-rad*2,0.9],flankAng=45,center=true);
  }
}

*frustum([3,2,0.9],method="poly",center=true);
module frustum(size=[1,1,1], flankAng=5, center=false, method="poly"){
  //cube with a trapezoid crosssection
  //https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
  cntrOffset= (center) ? [0,0,0] : [size.x/2,size.y/2,size.z/2];
  
  flankRed=tan(flankAng)*size.z; //reduction in width by angle
  faceScale=[(size.x-flankRed*2)/size.x,(size.y-flankRed*2)/size.y]; //scale factor for linExt
  
  if (method=="linExt")
    translate(cntrOffset)
      linear_extrude(size.z,scale=faceScale,center=true) 
        square([size.x,size.y],true);
  else{ //for export to FreeCAD/StepUp
    polys= [[-size.x/2,-size.y/2,-size.z/2], //0
            [ size.x/2,-size.y/2,-size.z/2], //1
            [ size.x/2, size.y/2,-size.z/2], //2
            [-size.x/2, size.y/2,-size.z/2],//3
            [-(size.x/2-flankRed),-(size.y/2-flankRed),size.z/2], //4
            [  size.x/2-flankRed ,-(size.y/2-flankRed),size.z/2], //5
            [  size.x/2-flankRed , (size.y/2-flankRed),size.z/2], //5
            [-(size.x/2-flankRed), (size.y/2-flankRed),size.z/2]]; //5
    faces= [[0,1,2,3],  // bottom
            [4,5,1,0],  // front
            [7,6,5,4],  // top
            [5,6,2,1],  // right
            [6,7,3,2],  // back
            [7,4,0,3]]; // left
    translate(cntrOffset) polyhedron(polys,faces);
  }
}