// Sichtschutz
/* 
  
  # Garten Maße
  Terasse: 2.53m
  Vorsprung Küche: 0.57m
  Hang: 1.66m x 0.62m (Küche)
  Küche <-> Tor: 4.35m
  
  Terrasse pflastern
  https://www.obi.de/magazin/garten/terrasse/terrasse-pflastern
  
  Ziesak Steine Katalog:
  https://www.ziesak.de/publish/binarydata/2024/werbung/hagebau_kataloge/9912227_gbs_92_fs24_fl_72dpi_master.pdf
  
*/


/* [Show] */
showLounge=true;
showPallisade=true;
showPlantWall=true;


/* [Dimensions] */
fenceDims=[1800,1800];
postDims=[90,90,1900];
panelDims=[1719,1140,35];
terraceDims=[2520,7820];
ovWidth=11885;
hutDist=5700;
protrusion=560;
wallThck=200;
stairDims=[350,1000,140];
stairCnt=5;
newTerraceDims=[3025,2195,80];
gravelThck=100; //compressed
sandThck=30; //compressed

/* [Positioning] */
loungePos=[400,-2400,0];
xOffsetLeft=280;
xOffsetRight=310;
yOffset=50;

/* [Panel Positioning] */
panelPos=[0,-15,650];
panelRot=[-5,0,0];
doorYOffset=-(740+1135+1300);
terraceOffset=2310;

/*[Hidden]*/
slopeDims=[stairDims.x*stairCnt,stairDims.z*stairCnt];
newTerraceThck=newTerraceDims.z+gravelThck+sandThck;
newTerracePos=[wallThck,-terraceOffset,-newTerraceDims.z-gravelThck-sandThck];
fudge=0.1;


// --- new terrace ---
if (showLounge)
  translate(loungePos) lounge();

//palissade
if (showPallisade){
  translate([wallThck+terraceDims.x+10,-2380,-250]) pallisade();
  for (i=[0:4])
    translate([wallThck+terraceDims.x+575,-2380+i*505,-250]) rotate(90) pallisade();
}

if (showPlantWall)
  for (ix=[0:2],iz=[0:2])
  translate([wallThck+10+ix*410,-410,iz*260]) plantBrick();

//wall
color("FireBrick") 
translate([wallThck,0,0]) rotate([90,0,-90]) linear_extrude(wallThck) 
  difference(){
    square([ovWidth,2700]);
    //window
    translate([780,1100]) square([1000,1050]);
    //door
    translate([740+1135+1300,150]) square([2750,2000]);
  }

//Pipes 
translate([wallThck+140-90/2,doorYOffset+630+90/2,0]){
  cylinder(d=90,h=2700);
  translate([0,450,-500]) cylinder(d=90,h=2700+500);
}


//stairs
color("grey") for(i=[0:stairCnt-1])
  translate([terraceDims.x+wallThck+i*stairDims.x,doorYOffset-stairDims.y,-stairDims.z-i*stairDims.z]) cube(stairDims);

//floor
floorPoly=[[0,0],[terraceDims.x+wallThck,0],[terraceDims.x+wallThck+slopeDims.x,-slopeDims.y],[0,-slopeDims.y]];
color("SaddleBrown")
  difference(){
    rotate([90,0,0]) linear_extrude(ovWidth) polygon(floorPoly);
    //terrace old
    translate([wallThck,-terraceDims.y-terraceOffset,-80.5]) cube([terraceDims.x,terraceDims.y,81]);
    //terrace new
    translate(newTerracePos) cube(newTerraceDims+[1,1,1+gravelThck+sandThck]);
  }

//new terrace layers
translate(newTerracePos){
  //gravel
  color("Sienna") cube([newTerraceDims.x,newTerraceDims.y,gravelThck]);
  //sand
  color("Khaki") translate([0,0,gravelThck]) color("Sienna") cube([newTerraceDims.x,newTerraceDims.y,sandThck]);
  //bricks
  color("Brown") translate([0,0,gravelThck+sandThck]) color("Sienna") cube(newTerraceDims);
}

//old terrace
color("Maroon") translate([wallThck,-terraceDims.y-2310,-80.5]) cube([terraceDims.x,terraceDims.y,81]);

//corner
color("ivory")
translate([0,-ovWidth-protrusion,-slopeDims.y]) linear_extrude(3500) square(protrusion);

//hut
translate([hutDist+terraceDims.x+slopeDims.x,0,-slopeDims.y]) hut();




// --- Fences ---

//left
color("BurlyWood"){
  //fence1 (full)
  translate([(fenceDims.x+postDims.x)/2+xOffsetLeft,-yOffset,0]) RhombusDIY();
  //Post 1&2
  for (ix=[0,1])
    translate([ix*(fenceDims.x+postDims.x)+xOffsetLeft,-yOffset,0]) post();
  //fence2 (half)
  translate([fenceDims.x+postDims.x*1.5+xOffsetLeft+900/2,-yOffset,-110]) RhombusDIY([900,50,1800]);
  //Post 3
  translate([fenceDims.x*1.5+postDims.x*2+xOffsetLeft,-yOffset,-182.0]) post();
  //fence3 (half)
  translate([fenceDims.x*1.5+postDims.x*2.5+xOffsetLeft+900/2,-yOffset,-480]) RhombusDIY([900,50,1800]);
  //Post 4
  translate([fenceDims.x*2+postDims.x*3+xOffsetLeft,-yOffset,-530]) post();
  //fence4 (half)
  translate([fenceDims.x*2+postDims.x*3.5+xOffsetLeft+900/2,-yOffset,-670]) RhombusDIY([900,50,1800]);
  //Post 5
  translate([fenceDims.x*2.5+postDims.x*4+xOffsetLeft,-yOffset,-700]) post();
  //fence5
  translate([fenceDims.x*3+postDims.x*4.5+xOffsetLeft,-yOffset,-670]) RhombusDIY();
  //Post 6
  translate([fenceDims.x*3.5+postDims.x*5+xOffsetLeft,-yOffset,-700]) post();
  //fence6 
  translate([fenceDims.x*4+postDims.x*5.5+xOffsetLeft,-yOffset,-670]) RhombusDIY();
  //Post 6
  translate([fenceDims.x*4.5+postDims.x*6+xOffsetLeft,-yOffset,-700]) post();
  //fence7 (half)
  translate([fenceDims.x*4.5+postDims.x*6.5+xOffsetLeft+900/2,-yOffset,-670]) RhombusDIY([900,50,1800]);
  //Post 7
  translate([fenceDims.x*5+postDims.x*7+xOffsetLeft,-yOffset,-700]) post();
}

//right
color("BurlyWood") translate([0,-ovWidth+yOffset,0]){
  //fence //1
  translate([(fenceDims.x+postDims.x)/2+xOffsetRight,0,0]) rotate(180) RhombusDIY();
  //Post 1&2
  for (ix=[0,1])
    translate([ix*(fenceDims.x+postDims.x)+xOffsetRight,0,0]) post();
  //fence2
  translate([fenceDims.x+postDims.x*1.5+xOffsetRight+900/2,0,-160]) rotate(180) RhombusDIY([900,50,1800]);
  //Post 3
  translate([fenceDims.x*1.5+postDims.x*2+xOffsetRight,0,-270.0]) post();
  //fence3
  translate([fenceDims.x*1.5+postDims.x*2.5+xOffsetRight+900/2,0,-580]) rotate(180) RhombusDIY([900,50,1800]);
  //Post 4
  translate([fenceDims.x*2+postDims.x*3+xOffsetRight,0,-620.0]) post();
}

*color("DarkSlateGrey"){
  translate([fenceDims.x+postDims.x,0,panelDims.y/2]+panelPos) rotate([90,0,0]+panelRot) solarPanel();
  translate([(fenceDims.x+postDims.x)*2,0,panelDims.y/2]+panelPos) rotate([90,+0,0]+panelRot) solarPanel();
}

*RhombusDIY();
module RhombusDIY(ovDims=[1800,50,1800]){
  braceDims=[70,20];
  profileDims=[70,20];
  profileCnt=23;
  profileDist=(ovDims.z-profileCnt*profileDims.x)/(profileCnt-1);
  
  //braces
  for (ix=[-1:1])
    translate([ix*(ovDims.x-braceDims.x)/2,braceDims.y/2,ovDims.z/2]) cube([braceDims.x,braceDims.y,ovDims.z],true);
  //profiles
  for (iz=[0:profileCnt-1])
    translate([0,-profileDims.y/2,iz*(profileDims.x+profileDist)+profileDims.x/2]) 
      rotate([0,-90,0]) linear_extrude(ovDims.x,center=true) rhombusProfile(dims=profileDims);
}

module VARO(){
  braceDims=[70,25];
  profileDims=[70,25];
  ovDims=[1800,50,1800];
  profileCnt=20;
  profileDist=21;
  //braces
  for (ix=[-1:1])
    translate([ix*(ovDims.x-braceDims.x)/2,braceDims.y/2,ovDims.z/2]) cube([braceDims.x,braceDims.y,ovDims.z],true);
  //profiles
  for (iz=[0:profileCnt-1])
    translate([0,-profileDims.y/2,iz*(profileDims.x+profileDist)+profileDims.x/2]) cube([ovDims.x,profileDims.y,profileDims.x],true);
}

module post(size=[90,90,1900],rounded=true){
  if (rounded){
    translate([0,0,(size.z-size.x/2)/2]) cube(size-[0,0,size.x/2],true);
    translate([0,0,size.z-size.x/2]) rotate([90,0,0]) cylinder(d=size.x,h=size.y,center=true);
  }
  else
    translate([0,0,size.z/2]) cube(size,true);
}

*solarPanel();
module solarPanel(size=[1719,1140,35]){
  //e.g. viessmann VitoVolt 300 M400WE
  //https://www.photovoltaik4all.de/media/pdf/5e/fd/79/Vitovolt_M400WE_6135350VDP00002_1.pdf
  glassThck=3.2;
  frameThck=1.5;
  drillDist=[1031,1090];
  drillDia=9;
  //frame
  color("darkSlateGrey") difference(){
    linear_extrude(size.z,convexity=2) difference(){
      square([size.x,size.y],true);
      square([size.x-size.z*2,size.y-size.z*2],true);
    }
    //mounting holes
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*drillDist.x/2,iy*drillDist.y/2,-fudge/2]) cylinder(d=drillDia,h=size.z-frameThck+fudge);
  }  color("grey")//panel
  translate([0,0,size.z-glassThck-frameThck]) linear_extrude(glassThck) square([size.x-size.z*2,size.y-size.z*2],true);
}

module profiler(width=1800,profile=[70,25],count=10,dist=21){
  for (iz=[0:count-1])
    translate([0,-profile.y/2,iz*(profile.x+dist)+profile.x/2]) cube([width,profile.y,profile.x],true);
}

*rhombusProfile();
module rhombusProfile(dims=[77,24],radius=2,angle=45,center=true){
  edge=dims.y/tan(angle);
  $fn=20;
  poly=[[0,0],[edge,dims.y],[dims.x,dims.y],
        [dims.x-edge,0]];
  centerOffset= center ? [-dims.x/2,-dims.y/2] : [0,0];
  translate(centerOffset) offset(radius) offset(-radius) polygon(poly);
}

*hut();
module hut(size=[2200,2200,2500],roof=300){
  hutShape=[[0,0],[0,2200],[1100,2500],[2200,2200],[2200,0]];
  translate([0,size.y,0]) rotate([90,0,0]) linear_extrude(2200) polygon(hutShape);
}

module pallisade(type="paliboard"){
  color("darkGrey") cube([500,60,250]);
}

module lounge() {
  ovDims=[2570,1970,740];
  back=400;
  sides=400;
  
  color("#bcb3aa") difference(){
    cube(ovDims);
    translate([back,-1,430]) cube([ovDims.x-back+1,ovDims.y-back+1,740-430+1]);
    translate([930,-1,-0.5]) cube([ovDims.x-930+1,ovDims.y-930+1,740+1]);
    
  }
}


module plantBrick(){
  wallThck=60;
  ovDims=[400,300,250];
  linear_extrude(ovDims.z) difference(){
    square([ovDims.x,ovDims.y]);
    translate([wallThck,wallThck]) square([ovDims.x-wallThck*2,ovDims.y-wallThck*2]);
  }
}