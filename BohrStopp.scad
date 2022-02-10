//remixed from https://www.thingiverse.com/thing:4877588

%translate([0,0,23]) import("Collet_13mm.stl");
*translate([0,0,14]) import("Collet_04mm.stl");

$fn=100;
fudge=0.1;

/* [Dimensions] */
brimDia=12.56; //13mm: 23.44, 4mm: 12.56
brimHght=1.65; //1.2 base+ radius
boreDia=4;

ovHght=14; //13mm: 23, 4mm:14
flankAng=6; //check
cutFlankAng=2; 
cutCnt=4;//has to be even
minWallThck=1.8;

cutRotAng=360/(cutCnt);

//width of the cuts from flank angle
cutWdth=tan(cutFlankAng)*(ovHght-brimHght+fudge)*2; 

//lowerDia of the main cone from flank Angle and overall height
lowerDia=boreDia+minWallThck*2+tan(flankAng)*ovHght*2; 

cutPoly=[[-fudge,cutWdth/2],[ovHght-brimHght,0],[-fudge,-cutWdth/2]];

echo(norm([ 4.46, 4.42, 0.00 ]));

difference(){
  union(){
    cylinder(d1=brimDia,d2=brimDia-fudge*2,h=brimHght);
    cylinder(d1=lowerDia,d2=boreDia+2*minWallThck,h=ovHght);
  }
  translate([0,0,-fudge/2]) cylinder(d=boreDia,h=ovHght+fudge);
  for (ir=[0:cutRotAng:360-cutRotAng]){
    rotate([0,-90,180+ir]) 
      linear_extrude(brimDia/2+fudge) polygon(cutPoly);
    translate([0,0,ovHght]) mirror([0,0,1])  
      rotate([0,-90,180+ir+cutRotAng/2]) 
        linear_extrude(brimDia/2+fudge) polygon(cutPoly);
  }
}