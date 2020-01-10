use <bezier.scad>
use <Aperture_Parametric_4PGun.scad>


$fn=150;
fudge=0.1;

/*-- [Burner-Dimensions] --*/
pipStrLngth=700; //length of the straight part
pipHndlLngth=80; //length of the straight handle part 
pipBendAng=133;
pipBendRad=90;
pipDia=16;
wThck=0.5;
canDia=80;
canHght=400;

/*-- [Tube-Dimensions] --*/
tubBendRad=80;
tubOutDia=31;
tubInDia=25;
//exhaust
exOutDia=80;
exInDia=70;
exLngth=200;

/* [Adapter Settings] */
adaLngth=100;
adaBrim=20;
adaFlange=40;
adaScrwDia=4.2;
adaNumScrws=6;
adaZOffset=8;
adaPos=[-40,0,tubOutDia+adaZOffset];
adaOvLngth=adaLngth+adaBrim+adaFlange;
//noozle to boost with HHO
boostNozzle=true;
//doveTails to mount to gun
doveTails=true;
//opening Size in Reducer
redOpng=50;
//mesh thicknee to keep gas
meshThck=3;

/* -- [3DP] -- */
minWallThck=2;
//innerSpacing
inSpc=0.2;


/* -- [show] -- */
export="none";//["none","diaTest", "adapter", "irisMain", "irisLid", "irisPlanet", "irisDisk", "exConn", "coupler", "reducer", "mesh"]
muzzle="reducer"; //["none","reducer","iris"]
showCut=false;
showEx=true;
showBurner=true;
showIris=false;
showTubing=true;
showConnectors=true;


//adapter dia test
if (export=="diaTest")
  !translate([0,0,0]) intersection(){
      cylinder(d=exOutDia+minWallThck*2+inSpc*2+fudge,h=20);
      mirror([0,0,1]) union(){
        translate([0,0,-160]) adapter();
        translate([0,0,-20+minWallThck/2]) adapter();
      }
    }
 

if (export=="adapter" && showCut)
  !difference(convexity=4){
    union(){
      if (showEx) translate([0,0,adaLngth+adaFlange]) exhaust();
      adapter();
      if (muzzle=="iris") translate([0,0,adaLngth+adaFlange+exLngth+fudge]) irisAssy();
      if (muzzle=="reducer") translate([0,0,adaLngth+adaFlange+exLngth+fudge]) reducer();
    }
    translate([0,0,-fudge/2]) 
      color("red") 
        cube([exOutDia,
              exOutDia,
              adaOvLngth+exLngth]);
  }

else if (export=="adapter")
  !translate([0,0,adaOvLngth]) mirror([0,0,1]) adapter();

if (export=="irisMain")
  !difference(){
    main_shell();
    for (ir=[0:360/adaNumScrws:360-360/adaNumScrws])
      rotate(ir) translate([exOutDia/2,0,-adaBrim/2]) rotate([0,90,0])
        cylinder(d=adaScrwDia,h=minWallThck*1.2);
  }
if (export=="irisLid")
  !make_lid();	
if (export=="irisDisk")
  !make_planet_disk();
if (export=="irisPlanet")
  !make_planet();
if (export=="exConn")
  !fixation();

if (export=="coupler")
  !coupler();

if (export=="reducer")
  !translate([0,0,adaBrim]) reducer();

if (export=="mesh")
  !mesh();

//no Export
if (showBurner) rotate([0,90,0]) burner(); 
if (showTubing) tube();
if (showEx) translate(adaPos) rotate([0,-90,0]) adapter();
if (showEx) translate([adaPos.x-160,0,adaPos.z]) rotate([0,-90,0]) exhaust();
if (showIris) 
  translate([-adaLngth-adaFlange-exLngth-50,0,tubOutDia]) 
    rotate([0,-90,0]){
      irisAssy();
}

if (showConnectors){
  fixation();
  translate([150,0,0]) rotate([90,0,90]) coupler();
}


module mesh(){
  cylinder(d=exOutDia,h=meshThck);
}
module reducer(){
  ovDia=exOutDia+2*minWallThck;
  translate([0,0,meshThck]) difference(){
    sphere(d=exOutDia+2*minWallThck);
    sphere(d=exInDia);
    translate([0,0,-(ovDia+fudge)/2]) cube(ovDia+fudge,true);
    cylinder(d=redOpng,h=ovDia+fudge);
  }
  translate([0,0,-adaBrim]) difference(){
    cylinder(d=ovDia,h=adaBrim+meshThck);
    translate([0,0,-fudge/2]) cylinder(d=exOutDia+inSpc,h=adaBrim+meshThck+fudge);
    for (ir=[0:360/adaNumScrws:360-360/adaNumScrws])
      rotate(ir) translate([(exOutDia+minWallThck)/2,0,adaBrim/2]) rotate([0,90,0])
        cylinder(d=adaScrwDia,h=minWallThck*1.2,center=true);
  }
}

module coupler(){
  cpWdth=40;
  cpWallThck=3;
  cpThck=cpWallThck*2+pipDia;
  //dist=adaPos.z*2-tubOutDia-cpWallThck*2;
  dist=150-tubOutDia*2-cpWallThck*4;
  echo("dist",dist);
  s=7;
  ru=(s/2)*(2/sqrt(3));
  ovHght=tubOutDia*2+cpWallThck*4+dist;
  scrwLngth=18;
  yOffset=dist/2+cpWallThck+tubOutDia/2-adaPos.z;
  
  difference(){
    translate([0,-yOffset,0]) linear_extrude(cpWdth,center=true,convexity=2) 
      tubConPar(d1=tubOutDia,d=dist,wallThck=cpWallThck,thck=cpThck);
    for (iz=[-1,1],iy=[-1,1])
      translate([0,iy*pipDia,iz*cpWdth/4]) rotate([0,90,0]){
        cylinder(d=4.5,h=tubOutDia,center=true);
        translate([0,0,scrwLngth/2-1]) cylinder(r=ru+fudge,h=8,$fn=6);
        translate([0,0,-scrwLngth/2+1-8]) cylinder(r=4,h=8);
      }
    cube([1,ovHght+fudge,cpWdth+fudge],true);
    cylinder(d=pipDia,h=cpWdth+fudge,center=true);
  }
}

!fixation(true);
module fixation(stab=false){
  fixWallThck=3;
  fixWdth=40;
  //M4
  s=7;
  ru=(s/2)*(2/sqrt(3));
  //tubConPar(d1=20,d=8,wallThck=2,thck=2){
  dist=adaPos.z-tubOutDia-fixWallThck*2;
  ovHght=tubOutDia*2+fixWallThck*4+dist;
  yOffset=(tubOutDia+dist)/2+fixWallThck;
  fixThck= stab ? pipDia+fixWallThck*2 : tubOutDia/2;
  screwLngth=18;
  
  //translate([-fixWdth/2,0,adaPos.z/2]) rotate([90,0,-90])
  difference(){
    union(){
      difference(){
        linear_extrude(fixWdth,center=true,convexity=2) 
          tubConPar(d1=tubOutDia,d=dist,wallThck=fixWallThck,thck=fixThck);
        if (stab) translate([0,-ovHght/4-fudge/2,0])
          cube([ovHght/2+fudge,ovHght/2+fudge,fixWdth+fudge],true);
      }
      if (stab){ 
        translate([0,-yOffset,0]) 
          cylinder(d=pipDia+fixWallThck*2,h=fixWdth,center=true);
        translate([0,-yOffset/2,0]) cube([pipDia+2*fixWallThck,yOffset,fixWdth],true);
      }
    }    
    for (iz=[-1,1])
      translate([0,0,iz*fixWdth/4]) rotate([0,90,0]){
        cylinder(d=4.5,h=tubOutDia,center=true);
        translate([0,0,screwLngth/2-1]) cylinder(r=ru+fudge,h=6,$fn=6);
        translate([0,0,-screwLngth/2+1-6]) cylinder(r=4,h=6);
      }
    cube([1,ovHght+fudge,fixWdth+fudge],true);
      translate([0,-yOffset,0]) cylinder(d=pipDia,h=fixWdth+fudge,center=true);
  }
  
}



module irisAssy(){
  rotate(90) difference(){
    main_shell();
    for (ir=[0:360/adaNumScrws:360-360/adaNumScrws])
      rotate(ir) translate([exOutDia/2,0,-adaBrim/2]) rotate([0,90,0])
        cylinder(d=adaScrwDia,h=minWallThck*1.2);
  }
  place_planets(angle_blade = 30);
  make_planet_disk();
  make_lid();	
}

module tube(){
  dIn=tubInDia;
  dOut=tubOutDia;
  mRad=tubBendRad;
  
  color("grey",0.5){
    rotate([0,-90,0]) linear_extrude(40) shape();
    translate([-40,0,-mRad]) rotate([90,-90,0]) 
      rotate_extrude(angle=180) translate([mRad,0,0]) shape();
    translate([-40,0,-mRad*2]) rotate([0,90,0]) linear_extrude(pipStrLngth) shape();
    translate([pipStrLngth-40,0,-mRad]) rotate([90,90,0]) 
      rotate_extrude(angle=120) translate([mRad,0,0]) shape();
    translate([adaPos.x-adaFlange,0,adaPos.z]) rotate([0,90,0]) linear_extrude(300) shape();
  }
  
  module shape(){
    difference(){
      circle(d=dOut);
      circle(d=dIn);
    }
  }
}


*adapter();
module adapter(){

  exWallThck=(exOutDia-exInDia)/2;
  
  //tube connector
  conPos=14; //point number
  conOffset=[0,0,5];
  conDia=[3,5]; //inner/outer Dia
  
  P0=[tubInDia/2-minWallThck+inSpc,0];
  P1=[tubInDia/2+inSpc,0];
  P2=[tubInDia/2+inSpc,adaFlange-minWallThck*2];
  P3=[tubOutDia/2+inSpc,adaFlange];
  P4=[exOutDia/2+minWallThck+inSpc,adaLngth+adaFlange];
  P5=[exOutDia/2+minWallThck+inSpc,adaLngth+adaBrim+adaFlange];
  P6=[exOutDia/2+inSpc,adaLngth+adaBrim+adaFlange];
  P7=[exOutDia/2+inSpc,adaLngth+adaFlange-inSpc];
  P8=[exOutDia/2-exWallThck,adaLngth+adaFlange-inSpc];
  P9=[tubOutDia/2-minWallThck+inSpc,adaFlange];
  PE=[tubInDia/2-minWallThck+inSpc,adaFlange-minWallThck*2];
  
  bdyPnts=Bezier([                P0,SHARP(),
                                SHARP(),P1,SHARP(),
                                SHARP(),P2,SHARP(),
      
                                SHARP(),P3,OFFSET([0,50]), 
                        OFFSET([0,-50]),P4,SHARP(), //top right
      
                                SHARP(),P5,SHARP(),
                                SHARP(),P6,SHARP(),
                                SHARP(),P7,SHARP(),
                                SHARP(),P8,OFFSET([0,-50+minWallThck/2]),
                                       
           OFFSET([0,50+minWallThck/2]),P9,SHARP(),
                                SHARP(),PE ]);
  
  
  
  //debug
  conAng=angle2D(bdyPnts[conPos-1],bdyPnts[conPos+1]);
  echo(conAng);
  
  if (boostNozzle) color("ivory") translate([bdyPnts[conPos].x,0,bdyPnts[conPos].y]) 
    rotate([0,90+conAng,0]) 
      nozzle(hght=8,ang=90-conAng);

  
  color("ivory") difference(){
      body();
  
  //screw holes
    for (ir=[0:360/adaNumScrws:360-360/adaNumScrws])
      rotate(ir) translate([exOutDia/2,0,adaOvLngth-adaBrim/2]) rotate([0,90,0])
        cylinder(d=adaScrwDia,h=minWallThck*1.2);
    //4/6 tube connector
    if (boostNozzle) translate([bdyPnts[conPos].x,0,bdyPnts[conPos].y]) 
      rotate([0,-90+conAng,0]) translate([0,0,-fudge])  
        cylinder(d=4,h=exWallThck+minWallThck+fudge); 
    if (doveTails)
      for(ir=[0,180]) rotate(ir)
        translate([exOutDia/2+minWallThck+fudge*2,0,adaLngth+adaFlange-minWallThck]) 
          rotate([0,90,180]) doveTail([40,20,4.5+fudge]);
  }//diff
  
  module body(){
      rotate_extrude(convexity=3){ 
        polygon(bdyPnts);
        //rounding
      translate([(tubInDia-minWallThck)/2+inSpc,0,0]) circle(d=minWallThck);
      *translate([(exOutDia+minWallThck)/2+inSpc,adaLngth+adaBrim+adaFlange]) circle(d=minWallThck);
      }//rot_ex
    }
}

module exhaust(){
  color("grey",0.3)
  linear_extrude(exLngth) difference(){
    circle(d=exOutDia);
    circle(d=exInDia);
  }
}

*burner();
module burner(){
  //muzzle
  color("salmon") translate([0,0,-36]) rotate([0,0,0]) muzzle();
  
  color("silver"){
    //long straight part
    linear_extrude(pipStrLngth) shape();
    
    //radius
    translate([pipBendRad,0,pipStrLngth]) rotate([-90,0,180]) 
      rotate_extrude(angle=-pipBendAng) 
        translate([pipBendRad,0,0]) shape();
  }  
    //handle
    translate([pipBendRad,0,pipStrLngth]) rotate([0,-(180-pipBendAng),0]) 
      translate([pipBendRad,0,-pipHndlLngth]){
        color("silver") linear_extrude(pipHndlLngth) shape();
        translate([0,0,-canHght]) can();
      }
    
  
  module shape(){
    difference(){
      circle(d=pipDia);
      circle(d=pipDia-wThck*2);
    }
  }
  
  module can(){
    color("green") cylinder(d=canDia,h=canHght*0.75);
    color("yellow") translate([0,0,canHght*0.75]) cylinder(d=canDia,h=canHght*0.25);
  }
}
*muzzle();
module muzzle(){
  wThck=1;
  
  difference(){
    union(){
      cylinder(d=16+2*wThck,h=53);
      cylinder(d=25,h=35);
      translate([0,0,35]) cylinder(d1=25,d2=18,h=5);
    }
    translate([0,0,-fudge/2]){
      cylinder(d=16,h=53+fudge);
      cylinder(d=25-wThck*2,h=35+fudge);
      translate([0,0,35]) cylinder(d1=25-wThck*2,d2=18-wThck*2,h=5+fudge);
    }
  }
}

//nozzle for 4/6 tube

module nozzle(hght=10,lngth=15,ang=90){
  inDia=3;
  outDia=5;
  bdyDia=8;

  difference(){
    body();
    body(2);
  }

  
  module body(oz=0){
    nfudge= oz ? 0.1 : 0;
    translate([0,0,-nfudge/2-fudge]) cylinder(d=bdyDia-oz*2,h=hght-bdyDia/2+nfudge+fudge);
    translate([0,0,hght-bdyDia/2]){
      sphere(d=bdyDia-oz*2);
      rotate([0,ang,0]){
        translate([0,0,-nfudge]) cylinder(d=bdyDia-oz*2,h=hght-bdyDia/2+nfudge-oz);
        translate([0,0,hght-bdyDia/2-oz-nfudge/2]) cylinder(d=outDia-oz,h=lngth+nfudge+oz);
      }
    }
  }
}
*doveTail();
module doveTail(size=[40,8,2]){
  rotate([90,0,90]) linear_extrude(size.x)
  polygon([[-(size.y/2-size.z),0],[size.y/2-size.z,0],
           [size.y/2,size.z],[-size.y/2,size.z]]);
}

*pDisc20();
module pDisc20(){
  T=0.43;
  t=0.2;
  D=20;
  d=13.5;
  L=25;
  color("gold") cylinder(d=D,h=t);
  color("ivory") translate([0,0,0.2]) cylinder(d=d,h=T-t);
  color("darkSlateGrey") translate([d/2+(D-d)/4,1,0.5/2+t]) rotate([0,90,0]) cylinder(d=0.5,h=L+(D-d)/4);
  color("red") translate([d/2-(D-d)/4,-1,0.5/2+t]) rotate([0,90,0]) cylinder(d=0.5,h=L+(D-d)*0.75);
}


*tubConPar(20,10,2,8);
module tubConPar(d1=20,d=8,wallThck=2,thck=2){
  if (d1==thck) echo("error");
    debug=true;
  r1=d1/2;
  R1=d1/2+wallThck;
  
    //r2 = (d^2 + 4 d r1 + t^2)/(8 r1 - 4 t) and 2 r1!=t
  r2 = (pow(d,2) + 4*d*R1 + pow(thck,2))/(8*R1 - 4*thck);
  echo("r2",r2);
  yOffset=R1+d/2;
  xOffset=r2+thck/2;
  alpha=asin(xOffset/(R1+r2))*2; //OK
  echo("a",alpha);
  s=2*R1*sin(alpha/2); //?
  h=R1*(1-cos(alpha/2));
  
  difference(){
    union(){
      for (iy=[-1,1])
        translate([0,iy*(yOffset)]) circle(r=R1);
      square([s,d+2*h],true);
    }
    for (ix=[-1,1])
      translate([ix*xOffset,0,0]) circle(r2);
    for (iy=[-1,1])
      translate([0,iy*(yOffset)]) circle(r1);
  }
 
}
*dualTube();
module dualTube(r1=15,r2=10,dist=40,width=8){
// w=width, D=dist
//  I: (r1+r3)²=d1²+(r3+w/2)²
// II: (r2+r3)²=d2²+(r3+w/2)²
//III: d2=D-d1
  
/* thanks to Wolfram alpha
I for r3: r3 = (4 d1^2 - 4 r1^2 + w^2)/(8 r1 - 4 w) and 2 r1!=w
alt. I:   r3 = (4 d1^2 - 4 r1^2 + w^2)/(4 (2 r1 - w))
  
II for r3: r3 = (4 D^2 - 8 D d1 + 4 d1^2 - 4 r2^2 + w^2)/(8 r2 - 4 w) and 2 r2!=w
alt. II:   r3 = (4 (d1 - D)^2 - 4 r2^2 + w^2)/(4 (2 r2 - w))
  
//alt. I=II: (2 d1^2)/(w - 2 r1) + r1 = (2 (d1 - D)^2)/(w - 2 r2) + r2
  
  d1 = 1/4*(width - 2*r2)*((2*sqrt(2)*sqrt(r2))/sqrt(2*r2 - width) - (4*dist)/(2*r2 - width));
*/  
  d1 = 1/4*(width - 2*r2)*((2*sqrt(2)*sqrt(r2))/sqrt(2*r2 - width) - (4*dist)/(2*r2 - width));
  echo("d1",d1);
  d2 = dist-d1;
  r3 = (4*pow(d1,2) - 4*pow(r1,2) + pow(width,2))/(8*r1 - 4*width);
  translate([0,d1]) circle(r1);
  translate([0,-d1]) circle(r2);
  #translate([-r3-width/2,0]) circle(r3);
}

//angle between two vectors
function angle2Vec(a,b)=atan2(norm(cross(a,b)),a*b);
function angle2D(a,b)=atan((b.x-a.x)/(b.y-a.y));

module screw(l=6){
  s=2.5;//key width
  D=9.4;//head Diameter flat part
  dk=7.6; //head Diameter
  d=4; //screw diameter
  
  k=2.2; //head height
  
  cylinder(d=dk,h=k);
  translate([0,0,-l]) cylinder(d=d,h=l);
}
