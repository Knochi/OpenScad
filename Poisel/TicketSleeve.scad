/* a sleeve for event tickets */
$fn=32;

/* [Dimensions] */
ticketCompDims=[206,83,0.5];
minWallThck=2;
recessDims=[178,82,0.3];
crnrRad=2;
spcng=0.1;

/* [Reveal Window] */
wndwDims=[75,66];
wndwPos=[-(-205/2+75+75/2),2.5];
wndwRad=2;

/* [Options] */
split=true;

/* [Hidden] */
fudge=0.1;
ovDims=ticketCompDims+[minWallThck*1,minWallThck*2,minWallThck*2];


difference(){
  body();
  translate([-(ovDims.x/2+fudge)/2,0,0]) cube([ovDims.x/2+fudge,ovDims.y+fudge,ovDims.z+fudge],true);
}

module body(){
  difference(){
    //body
    translate([0,0,0]) hull() for (ix=[-1,1],iy=[-1,1],iz=[-1,1])
      translate([ix*(ovDims.x/2-crnrRad),iy*(ovDims.y/2-crnrRad),iz*(ovDims.z/2-crnrRad)]) sphere(crnrRad);
    //ticket compartment
    translate([(minWallThck+fudge)/2,0,0]) cube(ticketCompDims+[fudge,0,0],true);
    //recess
    translate([0,0,(ovDims.z-recessDims.z+fudge)/2]) cube(recessDims+[0,0,fudge],true);
    //window
    translate([wndwPos.x,wndwPos.y,-(ovDims.z-minWallThck)/2]) cube([wndwDims.x,wndwDims.y,minWallThck+fudge],true);
    //spring
    translate([ticketCompDims.x/3,0,ovDims.z/2-recessDims.z-minWallThck-fudge/2])
      spring();;
    translate([ticketCompDims.x/3,0,ticketCompDims.z/2-spcng*2]) spring(cut=false);
    //glue channel
    for (iy=[-1,1])
      translate([0,iy*(ovDims.y/2-crnrRad*2),-ovDims.z/2+1.8/2]){
        rotate([90,0,90]) cylinder(d=1.8,h=20,center=true);
        translate([0,0,-1.8/2]) cube([20,1.8,1.8],true);
      }
  }

  translate([ticketCompDims.x/3,0,ticketCompDims.z/2]) spring(cut=false);
}

*spring(cut=false);
module spring(size=[30,10],wdth=1,cut=true){
  R=size.y/cos(180/8);
  if (cut){
    linear_extrude(minWallThck+fudge) difference(){
      union(){
        rotate(360/16) offset(delta=wdth) circle(d=R,$fn=8);
        translate([-(size.x-size.y/2)/2,0]) square([size.x-size.y/2,size.y+wdth*2],true);
      }
      rotate(360/16) circle(d=R,$fn=8);
      translate([-(size.x-size.y/2+fudge)/2,0]) square([size.x-size.y/2+fudge,size.y],true);
    }
    translate([0,0,minWallThck/2]) linear_extrude(minWallThck/2+fudge) rotate(360/16) circle(d=R+fudge,$fn=8);
    translate([-size.x+size.y/2,0,minWallThck]) rotate([90,0,0]) linear_extrude(size.y+fudge,center=true) 
      polygon([[0,fudge],[size.x-size.y/2,fudge],[size.x-size.y/2,-minWallThck/2],[minWallThck/2+fudge,-minWallThck/2]]);
  }
  else
      mirror([0,0,1]) linear_extrude(ticketCompDims.z,scale=0.8) rotate(360/16) circle(d=R,$fn=8);
}


