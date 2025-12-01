// adapt Nail to a candle

/* [Nail] */
nailDia=3.7; //shaft dia
nailLen=82.5; //Length (just for display)
nailHdDia=7.5; //Diameater of the Head
nailHdThck=3; //Thickness of the head
nailHdCntSnk=true; //Countersunk?

/* [candle] */
cndlDia=26; //Diameter of the Candle
cndlLen=150; //Lenght of the candle (just for Display)

/* [Properties] */
minWallThck=1.2; //minimum Wall Thickness
slvHght=20; //Length of the sleeve
ripsCnt=3; //How many rips in the sleeve
ripsHght=20;
ripsWdth=8;
cndlSpcng=-0.5; //spacing between candle and sleeve
nailSpcng=0.1; //spacing between nail and adapter


/* [show] */
showNail=false;
showAdapter=true;
showSection=false;

/* [Hidden] */
slvOutDia=cndlDia+(cndlSpcng+minWallThck)*2;
slvInDia=cndlDia+cndlSpcng*2;
botDia=nailDia+minWallThck*2;
botHght=(slvOutDia-botDia)/2;
$fn=ripsCnt*15; //facets (influences also rips)
fudge=0.1;


if (showAdapter)
  difference(){
    color("olive") adapter();
    if (showSection) 
      translate([slvOutDia/4+fudge/2,0,(slvHght-botHght-minWallThck)/2]) 
        cube([slvOutDia/2+fudge,slvOutDia+fudge,slvHght+botHght+minWallThck+fudge],true);
}

if (showNail)
 translate([0,0,-nailHdThck]) color("silver") nail();
  
module nail(){
  
  translate([0,0,-nailLen+nailDia]) cylinder(d=nailDia,h=nailLen-nailDia);
  translate([0,0,-nailLen]) cylinder(d1=0.1,d2=nailDia,h=nailDia);
  nailHead();
  
}

*nailHead(true);
module nailHead(cut=false){
  if (cut)
    translate([0,0,-nailSpcng]) rotate_extrude() 
      intersection(){
        translate([0,nailSpcng]) offset(nailSpcng) projection() rotate([-90,0,0]) nailHead(false);
        square([nailHdDia/2+fudge+nailSpcng,nailHdThck+fudge+nailSpcng*2]);
      }
  else{
    if (nailHdCntSnk){
      coneHght=(nailHdDia-nailDia)/2;
      cylinder(d1=nailDia,d2=nailHdDia,h=coneHght);
      translate([0,0,coneHght]) cylinder(d=nailHdDia,h=nailHdThck-coneHght);
    }
    else
      cylinder(d=nailHdDia,h=nailHdThck);
  }
}

*adapter();
module adapter(){
  ripAng=360/$fn;
  ripBaseLen=2*slvInDia/2*sin(ripAng/2);
  ripAlt=1/2*sqrt(4*pow(slvInDia/2,2)-pow(ripBaseLen,2));//altitude of the isosceles triangle
  echo(ripAng,ripBaseLen,ripAlt,slvInDia/2);
  
  //sleeve
  rotate(ripAng/2) linear_extrude(slvHght) difference(){
    circle(d=slvOutDia);
    circle(d=slvInDia);
  }
  //rounded corner
  translate([0,0,slvHght]) rotate_extrude() translate([slvInDia/2+(slvOutDia-slvInDia)/4,0]) circle(d=(slvOutDia-slvInDia)/2);
  
  //bottom
  rotate(ripAng/2) difference(){
    translate([0,0,-minWallThck]){
      cylinder(d=slvOutDia,h=minWallThck);
      translate([0,0,-botHght]) cylinder(d1=botDia,d2=slvOutDia,h=botHght);
    }
    //drill
    translate([0,0,-botHght-minWallThck-fudge/2]) cylinder(d=nailDia+nailSpcng*2,h=botHght+minWallThck+fudge);
    //nail head
    if (nailHdCntSnk)
      translate([0,0,-nailHdThck]) nailHead(true);
    else
      cylinder(d=nailHdDia,h=nailHdThck);
  }
  
  //rips
  polyVerts=[[slvInDia/2-ripsWdth,0,0],[ripAlt,-ripBaseLen/2,0],[ripAlt,ripBaseLen/2,0],[ripAlt,0,ripsHght]];
  polyFaces=[[0,1,2],[1,3,2],[0,3,1],[0,2,3]];
  
  for (i=[0:ripsCnt-1])
    rotate(i*(360/ripsCnt)) polyhedron(polyVerts,polyFaces);
}