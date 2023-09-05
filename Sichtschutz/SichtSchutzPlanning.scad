// Sichtschutz
/* 
  #Examples
  
  ## 212x55x180cm mit Pflanzkasten - 1180EUR
  Leisten 28mm
  https://www.binnen-markt.de/pflanzkasten-212-sichtschutz-lang-holz.html
  
  ## OBI DIY
  https://www.obi.de/magazin/garten/zaun/sichtschutz-aus-holz-bauen
  
  ## Hornbach "Rhombus Lärche" 180x180cm - 149EUR oder 90x180cm - 99EUR
  Leisten 22x70mm, Pfähle 22x70mm
  https://www.hornbach.de/shop/Zaunelement-Rhombus-Laerche-180x180-cm-natur/6420621/artikel.html
  
  ## Hornbach DIY
  - H-Pfostentraäger, Beton für Tor
  - Einschraub-Bodenhülsen für Zaunpfähle
  - Pfosten kesseldruckimp.
    - 7x7x185cm - 9.95EUR
    - 9x9x185cm - 15.95EUR
  - Pfosten Lärche
    - 9x9x180cm - 38.95EUR (reel 8.5x8.5x180mm)
  https://www.hornbach.de/projekte/holzzaun-bauen/
  
  ## Mega-Holz
  https://mega-holz.de/produkt-kategorie/sichtschutzzaun/
  ### VARO Lärche 
  25x70mm
  ### Rhombus 180x180cm
  Lamellen: 24 x 77mm 
    https://mega-holz.de/produkt/rhombusleiste-laerche-24x77-cm/
  Verstrebungen: 25x75mm
  
  # Garten Maße
  Terasse: 2.53m
  Vorsprung Küche: 0.57m
  Hang: 1.66m x 0.62m (Küche)
  Küche <-> Tor: 4.35m
  
  
*/
/* [Dimensions] */
fenceDims=[1800,1800];
postDims=[90,90,1900];
panelDims=[1719,1140,35];
slopeDims=[1700,700];
terraceDims=[2530,7000];
hutDist=4600;
protrusion=560;
 
/* [Positioning] */
xOffsetLeft=200;
xOffsetRight=310;
yOffset=50;
/* [Panel Positioning] */
panelPos=[0,-15,650];
panelRot=[-5,0,0];

/*[Hidden]*/
fudge=0.1;


//floor
floorPoly=[[0,0],[terraceDims.x,0],[terraceDims.x+slopeDims.x,-slopeDims.y],[0,-slopeDims.y]];
color("Sienna")
  rotate([90,0,0]) linear_extrude(terraceDims.y) polygon(floorPoly);
//corner
color("ivory")
translate([0,-terraceDims.y-protrusion,-slopeDims.y]) linear_extrude(3500) square(protrusion);

//hut
translate([hutDist+terraceDims.x+slopeDims.x,0,-slopeDims.y]) hut();

//left
color("BurlyWood"){
  //fence1 (full)
  translate([(fenceDims.x+postDims.x)/2+xOffsetLeft,-yOffset,0]) RhombusDIY();
  //Post 1&2
  for (ix=[0,1])
    translate([ix*(fenceDims.x+postDims.x)+xOffsetLeft,-yOffset,0]) post();
  //fence2 (half)
  translate([fenceDims.x+postDims.x*1.5+xOffsetLeft+900/2,-yOffset,-140]) RhombusDIY([900,50,1800]);
  //Post 3
  translate([fenceDims.x*1.5+postDims.x*2+xOffsetLeft,-yOffset,-182.0]) post();
  //fence3 (half)
  translate([fenceDims.x*1.5+postDims.x*2.5+xOffsetLeft+900/2,-yOffset,-540]) RhombusDIY([900,50,1800]);
  //Post 4
  translate([fenceDims.x*2+postDims.x*3+xOffsetLeft,-yOffset,-600]) post();
  //fence4
  translate([fenceDims.x*2.5+postDims.x*3.5+xOffsetLeft,-yOffset,-670]) RhombusDIY();
  //Post 5
  translate([fenceDims.x*3+postDims.x*4+xOffsetLeft,-yOffset,-700]) post();
  //fence5
  translate([fenceDims.x*3.5+postDims.x*4.5+xOffsetLeft,-yOffset,-670]) RhombusDIY();
  //Post 6
  translate([fenceDims.x*4+postDims.x*5+xOffsetLeft,-yOffset,-700]) post();
  //fence6
  translate([fenceDims.x*4+postDims.x*5.5+xOffsetLeft+900/2,-yOffset,-670]) RhombusDIY([900,50,1800]);
  //Post 6
  translate([fenceDims.x*4.5+postDims.x*6+xOffsetLeft,-yOffset,-700]) post();
}

//right
color("BurlyWood"){
  //fence //1
  translate([(fenceDims.x+postDims.x)/2+xOffsetRight,-terraceDims.y+yOffset,0]) rotate(180) RhombusDIY();
  //Post 1&2
  for (ix=[0,1])
    translate([ix*(fenceDims.x+postDims.x)+xOffsetRight,-terraceDims.y+yOffset,0]) post();
  //fence2
  translate([fenceDims.x+postDims.x*1.5+xOffsetRight+900/2,-terraceDims.y+yOffset,-160]) rotate(180) RhombusDIY([900,50,1800]);
  //Post 3
  translate([fenceDims.x*1.5+postDims.x*2+xOffsetRight,-terraceDims.y+yOffset,-270.0]) post();
  //fence3
  translate([fenceDims.x*1.5+postDims.x*2.5+xOffsetRight+900/2,-terraceDims.y+yOffset,-580]) rotate(180) RhombusDIY([900,50,1800]);
  //Post 4
  translate([fenceDims.x*2+postDims.x*3+xOffsetRight,-terraceDims.y+yOffset,-620.0]) post();
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

