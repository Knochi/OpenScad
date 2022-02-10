$fn=32;
baseThck=3;
saleaDims=[46.82*2,46.82*2]; //height=15
saleaRad=(93.72-52.85)/2;
bigRad=52.5-34.5;  
smallRad=25.4-19.4;
drillDist=60;

clampWdth=20;
clampThck=2; //thick of the actual clamping plane
clampHght=15;
clampYOffset=10;
fudge=0.1;

//screwparameters M4
d=4;
dk=7.6;
k=2.6;

difference(){
  union(){
    rotate([0,180,180]) translate([-105/2,-111.25/2+(55.63-46.82),-13.6]) import("Saleae_holderV2.stl",convexity=3);
    translate([0,0,-baseThck+2]) linear_extrude(baseThck-2+fudge){ 
      //backplate
      offset(saleaRad) square(saleaDims+[-saleaRad*2,-saleaRad*2],true);
      hull(){ //lower part
        for (ix=[-1,1]) 
          translate([ix*(52.5-bigRad),-64.38+bigRad]) circle(bigRad);
        for (ix=[-1,1]) 
          translate([ix*(52.5-smallRad),-25.43]) circle(smallRad);
      }
    }
    //base for clamps
    translate([0,0,-baseThck+2]) linear_extrude(baseThck) hull() 
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(saleaDims.x+baseThck)/2,iy*(clampWdth-baseThck)/2+clampYOffset]) 
          circle(d=baseThck);
  }//union
  for (ix=[-1,1]){
    translate([ix*drillDist/2,0,-baseThck+2-fudge/2]){
      translate([0,0,baseThck-k]) 
        cylinder(d1=d-fudge,d2=dk+fudge*2,h=k+fudge);
      cylinder(d=d,h=baseThck-k+fudge);
    }
    translate([0,ix*drillDist/2,-baseThck+2-fudge/2]){
      translate([0,0,baseThck-k]) 
        cylinder(d1=d-fudge,d2=dk+fudge*2,h=k+fudge);
      cylinder(d=d,h=baseThck-k+fudge);
    }
  }
}

for (ix=[-1,1]) translate([ix*(saleaDims.x+baseThck)/2,clampYOffset,0]) rotate(ix*90) clamp();
  
*clamp();
module clamp(){
  linear_extrude(clampHght+clampThck/2) hull() for(ix=[-1,1]) 
    translate([ix*(clampWdth-baseThck)/2,0]) circle(d=baseThck);
   translate([0,1,clampHght+clampThck/2]) hull() for (my=[0,1]) mirror([0,my,0]) for (mx=[0,1]) mirror([mx,0,0]) 
     translate([(clampWdth-baseThck)/2,1/2,0]) rotate_extrude(angle=90){
      //translate([0,-clampThck/2,0]) square([baseThck/2,clampThck]);
      translate([(baseThck)/2-0.5,0]) circle(d=clampThck);
     }
}

//salea dummy
*translate([0,0,2]) color("darkred") linear_extrude(15) offset(saleaRad) square(saleaDims+[-saleaRad*2,-saleaRad*2],true);