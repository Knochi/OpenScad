//PlantPostLightningFix
$fn=50;
rodDia=7.1;
innerPostDia=43;
outerPostDia=50;
lowerDia=25;
matThck=3;
ovHght= 50;
fudge=0.1;

poly=[[0,0],[ovHght,0],[ovHght,innerPostDia/2],[ovHght/2,innerPostDia/2],[0,lowerDia/2]];

showCut=false;

difference(){
  union(){
    cylinder(d=20,h=ovHght);
    for (i=[0,120,240])
      rotate([0,-90,i]) linear_extrude(matThck,center=true) polygon(poly);
    translate([0,0,ovHght]) cylinder(d=outerPostDia,h=matThck);
    rotate_extrude() translate([outerPostDia/2,ovHght+matThck/2]) circle(d=matThck);
  }
  translate([0,0,matThck]) cylinder(d1=0.1,d2=rodDia+fudge,h=matThck);
  translate([0,0,matThck*2]) cylinder(d=rodDia+fudge,h=ovHght+fudge);
  
  if (showCut) translate([0,0,-fudge/2]) color("darkRed") cube([outerPostDia/2+matThck,outerPostDia/2+matThck,ovHght+matThck+fudge]);
}

//rips



  