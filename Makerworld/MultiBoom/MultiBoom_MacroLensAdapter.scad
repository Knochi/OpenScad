ovDims=[26,27.2,0];
beamWdth=13.6;
beamThck=10.6;
beamChamfer=[0.35,0.35,0.5];
shoeDist=5;
$fn=50;

//original parts
*translate([-115.05-25.9/2,-114.4-27.2/2,-35.85]) import("MultiBOOM_Phone_A.stl",convexity=3);
*translate([-0.2-27.2/2,34.07,0]) import("MultiBOOM_Arm_Female_150mm.stl",convexity=3);
*translate([85.38+beamWdth,-33.7+beamWdth,-10.5]) import("MultiBOOM_Arm_Male_100mm.stl");
 
 coldShoeAdapter();
 
 //sleeve
 *linear_extrude(47) difference(){
  circle(d=15);
  circle(d=14);
 }

module coldShoeAdapter(){

  translate([0,0,-shoeDist]) coldShoe(height=shoeDist);
  translate([0,0,beamWdth]) rotate([90,0,0]) femaleJoint();
}

module femaleJoint(height=beamThck,doubleSided=false, horizontal=true, center=true){
  bumpCount=8;
  bumpAng=360/bumpCount;
  bumpRad=10.75;
  
  cntrOffset= center ? [0,0,0] : [0,0,height/2];
  
  translate(cntrOffset){
    hexNut(height=height,horizontal=horizontal,center=true);
    //bumps
    for (ang=[0:bumpAng:360-bumpAng],iz= doubleSided ? [1,-1] : [1])
      rotate(ang) translate([bumpRad,0,iz*height/2]) rotate([0,90,0]) pill();
  }
  
  module pill(length=4.35,dia=2.4){
   hull() for (iz=[-1,1])
      translate([0,0,iz*(length-dia)/2]) sphere(d=dia);
  } 

}
 

*hexNut();
module hexNut(ri=13.6,height=10.6, chamfer=beamChamfer, holeDia=14.6, holeChamfer=1, horizontal=false, center=false){
  r1=ri2ro(ri-chamfer.y,8);
  ro=ri2ro(ri,8);
  centerOffset= center ? -height/2 : 0;
  
  translate([0,0,centerOffset]) difference(){
    rotate(360/16){
      cylinder(r1=r1,r2=ro,h=chamfer.z,$fn=8);
      translate([0,0,chamfer.z]) linear_extrude(height-chamfer.z*2) circle($fn=8,ro);
      translate([0,0,height-chamfer.z]) cylinder(r1=ro,r2=r1,h=chamfer.z,$fn=8);
    }
    if (horizontal){
      sFact=(holeDia+holeChamfer*2)/holeDia;
      mirror([0,0,1]) 
        translate([0,0,-holeChamfer]) linear_extrude(holeChamfer+0.1,scale=sFact) horizontalHole(holeDia);
      translate([0,0,-0.1/2]) linear_extrude(height+0.1) horizontalHole(holeDia);
      translate([0,0,height-holeChamfer]) linear_extrude(holeChamfer+0.1,scale=sFact) horizontalHole(holeDia);
    }
    else{
      translate([0,0,-0.1]) cylinder(d1=holeDia+(holeChamfer+0.1)*2,d2=holeDia,h=holeChamfer+0.1);
      translate([0,0,-0.05]) cylinder(d=holeDia,h=height+0.1);
      translate([0,0,height-holeChamfer]) cylinder(d1=holeDia,d2=holeDia+(holeChamfer+0.1)*2,h=holeChamfer+0.1);
    }
    
  }
}

*coldShoe();
module coldShoe(height=5){
  //coldShoe Spec
  //https://cdn.standards.iteh.ai/samples/36330/0f7a221b5b7647cc972f7403f522191a/ISO-518-2006.pdf
  slotWdth=12.5;
  internalDims=[18.6,16,2]; //Tolerances: 0|+2; -2|+3; 0|+1.5
  teethThck=1.5; //<=
  chamfer=1.0;
  spcngLat=0.3;
  spcngZ=0.2;
  dims=[15,20,1.8];
  sprngSlotDims=[dims.x-2,2];
  sprngThck=0.8;
  
  //plate
  linear_extrude(dims.z) difference(){
    union(){
      offset(chamfer=true,delta=chamfer) 
        square([dims.x-chamfer*2,dims.y-chamfer*2],true);
      //contact points
      for (iy=[-1,1])
        hull() for (ix=[-1,1])
          translate([ix*(sprngSlotDims.x-sprngSlotDims.y)/4,iy*(dims.y/2),0]) 
            circle(d=sprngSlotDims.y);
    }
    //slots for springs
    for (iy=[-1,1])
      hull() for (ix=[-1,1])
        translate([ix*(sprngSlotDims.x-sprngSlotDims.y)/2,iy*((dims.y-sprngSlotDims.y)/2-sprngThck),0]) 
          circle(d=sprngSlotDims.y);
      
  }
  
  
  translate([0,0,dims.z]) linear_extrude(height+beamChamfer.z)
    offset(chamfer=true,delta=chamfer) square([12-chamfer*2,beamThck-chamfer*2],true);
}

*horizontalHole();
module horizontalHole(dia=10){
//https://www.hydraresearch3d.com/design-rules#holes-horizontal
a=0.3; //change to 0.6 for <0.1 layer thickness
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
  circle(d=dia,$fn=66);
}

function ri2ro(r=1,n=$fn)=r/cos(180/n);