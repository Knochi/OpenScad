$fn=50;

/*[Dimensions] */
carrierDia=14;
carrierHght=70;
minWallThck=2;

/* [Hidden] */
fudge=0.1;
inDia=carrierDia-minWallThck*2;
inHght=carrierHght-minWallThck*2;

carrier();

module carrier(){
  difference(){
    cylinder(d=carrierDia,h=carrierHght,center=true);
    cylinder(d=inDia,h=inHght,center=true);
    cube([inDia*0.8,carrierDia+fudge,inHght*0.8],center=true);
  }
  //repell magnets
  translate([0,0,-inHght/2]) cylMagnet(height=8);
  translate([0,0,inHght/2-8]) cylMagnet(height=8);
  //working magnet
  mirror([0,0,1]) cylMagnet(height=16,center=true);
}

module cylMagnet(dia=10,height=5,center=false){
  cntrOffset= center ? [0,0,-height/2] : [0,0,0];
  
  translate(cntrOffset){
    color("green") cylinder(d=dia,h=height/2);
    color("red") translate([0,0,height/2]) cylinder(d=dia,h=height/2);
  }
}

color("coral") translate([0,0,-10]) coil();
module coil(dia=20,wire=1,length=20){
$step=10;
$h=0.1;

// cr : cylinder radisu for wrapping
// r : radius of actual pipe
// vr : radius of "virtual" pipe, used to place the real pipe

//place();
//loop();
manyLoops(cr=10,r=1,vr=2);
//manyEmptyLoops(cr=20,r=wire,vr=dia);
  
  module place(cr=20,r=5,vr=5,t=0) {
    rotate(t,[0,0,1])
    translate([cr+vr,0,t/360*2*vr])
    rotate(90,[1,0,0]) linear_extrude(height=$h,center=true) circle(r=r);
  }

  module loop(cr=20,r=5,vr=5) {
      for( t=[0:$step:360-$step/2] ) {
          hull() {
              place(cr=cr,r=r,vr=vr,t=t);
              place(cr=cr,r=r,vr=vr,t=t+$step);
          }
      }
  }

  module emptyLoop(cr=20,rin=5,rout=7) {
      difference() {
          /*render(convexity=2)*/ loop(cr=cr,r=rout,vr=rout,$h=0.1);
          /*render(convexity=2)*/ loop(cr=cr,r=rin,vr=rout,$h=0.5);
      }
  }

  module manyLoops(cr=20,n=5,r=5,vr=5,h=0.1) {
      for(i=[0:n-1]) {
          translate([0,0,i*vr*2]) loop(cr=cr,r=r,vr=vr);
      }
}

  module manyEmptyLoops(cr=20,n=5,rout=7,rin=5) {
      for(i=[0:n-1]) {
          translate([0,0,i*rout*2]) emptyLoop(cr=cr,rin=rin,rout=rout);
      }
  }
}