//debris chute
//https://de.m.wikipedia.org/wiki/Bauschutt#/media/Datei%3AStecksystem_zum_Abtransport_von_Bauschutt.JPG

/* [Dimensions] */
wallThck=0.8;
ovHght=40;
brimHght=5;
brimThck=1.0;
minDia=15;
flankAng=5;
stckHght=10;
spcng=0.2;

/* [show] */
showAsy=false;
sectionCut="none"; //["none","X-Z"]

/* [Hidden] */
fudge=0.1;

upperDia=tan(flankAng)*ovHght*2+minDia; //upper Diameter from height and angle
brimLowerDia=upperDia+brimThck*2-tan(flankAng)*brimHght*2;
ovDia=upperDia+(brimThck+wallThck)*2;
sectCubeDims=[ovDia+fudge,ovDia/2+fudge,ovHght+fudge];

if (showAsy)
  for (iz=[0:3])
    translate([0,0,iz*(stckHght+spcng)]) cone();
else    
  cone();

module cone(cut=false){
  difference(){
    union(){
    cylinder(d1=minDia+wallThck*2,d2=upperDia+wallThck*2,h=ovHght);
    translate([0,0,ovHght-brimHght]) cylinder(d1=brimLowerDia+wallThck*2,d2=upperDia+brimThck*2+wallThck*2,brimHght);
    }
    cylinder(d1=minDia,d2=upperDia,h=ovHght);
    translate([0,0,ovHght-brimHght+wallThck]) cylinder(d1=brimLowerDia,d2=upperDia+brimThck*2,brimHght);
    translate([0,0,-fudge]) cylinder(d=minDia,h=fudge*2);
    if (sectionCut=="X-Z") 
      color("darkRed") translate([0,-sectCubeDims.y/2,ovHght/2]) 
        cube(sectCubeDims,true);
  }
}
