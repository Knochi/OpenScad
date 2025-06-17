/* [Dimensions] */
brickOvDims=[68.6,25.6,150];
brickCrnrRad=1;
slotWdth=35;

screwDia=4;
screwHeadDia=7.5;
screwHeadThck=2.2;

mountRelHeight=0.6;
wallThck=2;

spcng=0.3;

/* [show] */
showDummy=true;
showHolder=true;

/* [Hidden] */
fudge=0.1;
$fn=100;

powerBrickWallMount();

module powerBrickWallMount(){  
  
  outerCrnrRad=brickCrnrRad+spcng+wallThck;
  bdyHght=(brickOvDims.z+wallThck+spcng)*mountRelHeight;
  slotDims=[slotWdth,brickOvDims.y+wallThck+spcng*2+fudge,bdyHght+fudge];
  wallYOffset=brickOvDims.y/2+spcng+wallThck/2;
  backThck= (screwHeadThck+spcng) > wallThck ? screwHeadThck+spcng: wallThck;  
  
  if (showDummy) translate([0,0,0.01]) color("ivory") dummy();
    
  if (showHolder){
    color("grey") difference(){
      body();
      //front and bottom slot
      translate([0,-(wallThck+fudge)/2,-wallThck-spcng+(bdyHght)/2]) 
        cube(slotDims,true);
      translate([0,-wallYOffset,bdyHght-wallThck-spcng-outerCrnrRad/2]) 
        cube([outerCrnrRad*2+slotDims.x,wallThck+fudge,outerCrnrRad+fudge],true);
      //screw holes
      for (iz=[-1,1])
        translate([0,brickOvDims.y/2+spcng-fudge/2,bdyHght/2+iz*bdyHght/3]){
          rotate([-90,0,0]) cylinder(d=screwDia+spcng,h=backThck+fudge);
          translate([0,0,0]) rotate([-90,0,0]) screwHd();
        }
    }
    color("grey") for (ix=[-1,1])
      translate([ix*(slotDims.x/2+outerCrnrRad),-wallYOffset,bdyHght-wallThck-spcng-outerCrnrRad]) 
        rotate([90,0,0]) cylinder(r=outerCrnrRad,h=wallThck,center=true);
  }
  *body();
 module body(){
   
  translate([0,0,-wallThck-spcng])  
    difference(){
      //outer shell
      linear_extrude(bdyHght) offset(wallThck+spcng) shape(true);
      //inner shell
      translate([0,0,wallThck]) linear_extrude(bdyHght+fudge) 
        offset(spcng) shape();
    }
  }
  
  module dummy(){
    difference(){
      linear_extrude(brickOvDims.z) shape();
      translate([0,0,(11-fudge)/2]) cube([22,11.9,11+fudge],true);
    }
  }
  
  module shape(backOffset=false){
    yOffset= backOffset ? backThck-wallThck : 0;
    hull() for (ix=[-1,1],iy=[-1,1])
        translate([ix*(brickOvDims.x/2-brickCrnrRad),iy*(brickOvDims.y/2+yOffset/2-brickCrnrRad)+yOffset/2,0]) 
          circle(r=brickCrnrRad);
  }
}

!linear_extrude(27.2) horizontalHole(dia=15.4);
module horizontalHole(dia=1){
//https://www.hydraresearch3d.com/design-rules#holes-horizontal
a=0.3; //change to 0.6 for >0.1 layer thickness
ang=40;
r=dia/2;

//roof
px1=sin(40)*r;
py1=cos(40)*r;
px2=sin(40)*(r+a-px1);
py2=r+a;
roofPoly=[[-px1,py1],[-px2,py2],[px2,py2],[px1,py1]];

//bottom
x=sqrt(pow(r+a,2)-pow(r,2));
px3=x*r/(r+a);
py3=-(r+a)+sqrt(pow(x,2)-pow(px3,2));
botPoly=[[-px3,py3],[0,-r-a],[px3,py3]];

  polygon(roofPoly);  
  polygon(botPoly);  
  
  circle(d=dia,$fn=36);

}

*screwHd();
module screwHd(offset=spcng){
  cylinder(d1=screwHeadDia+offset,d2=screwDia+offset,h=screwHeadThck+offset);
}