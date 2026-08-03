/* Watch dummy to test the feel */

/* [body] */
watchDia=42;
watchThck=11;
watchSensThck=2;
watchWght=70;
watchChmf=2;
watchRad=1;
watchKnobDia=5;
watchKnobHght=2;
watchKnobPos=0.5; //[0:0.05:1]

/* [strap holder] */
strapWdth=20;
strapHldWdth=2;
strapHldLen=6;
strapHldRad=2;
strapHoleDia=2;

$fn=64;

body();
strapHolder();

module body(){
  poly=[[0,0],[0,watchThck],[watchDia/2-watchChmf,watchThck],[watchDia/2,watchThck-watchChmf],[watchDia/2,0]];
  //calculate radius for sensor bulge
  s = watchDia-watchRad*2;
  h = watchSensThck;
  r = (4*pow(h,2)+pow(s,2))/(8*h);
  
  //body
  rotate_extrude(){
    square([watchRad,watchThck]);
    offset(watchRad) offset(-watchRad) polygon(poly);
    intersection(){
      translate([0,r-watchSensThck]) circle(r=r,$fn=254);
      translate([0,-watchSensThck]) square([watchDia/2-watchRad,watchSensThck]);
    }
  }
  //knob
  translate([watchDia/2+watchKnobHght,0,watchThck*watchKnobPos]) 
    rotate([0,-90,0]) cylinder(d=watchKnobDia,h=watchDia/2+watchKnobHght);
  
}


module strapHolder(){
  //simple strap holder using hull operation
  
  //calculate the width of the watch at the connection points
  s=strapWdth+strapHldWdth*2;
  r=watchDia/2;
  h=r-0.5*sqrt(4*pow(r,2)-pow(s,2));
  for (ix=[-1,1],my=[0,1])
    mirror([0,my,0]) translate([ix*(strapWdth+strapHldWdth)/2,0,0])
      rotate([90,0,-90]) linear_extrude(strapHldWdth,center=true) difference(){
        hull(){
          translate([watchDia/2-h-strapHldWdth,0]) square([strapHldWdth,watchThck-watchChmf-watchRad/2]);
          translate([watchDia/2-h+strapHldLen,strapHldRad]) circle(strapHldRad);
        }
        translate([watchDia/2-h+strapHldLen,strapHldRad]) circle(d=strapHoleDia);
        }
}

