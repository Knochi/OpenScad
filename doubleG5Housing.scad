$fn=50;
fudge=0.1;
lampDist=20;
lampDia=15.6;
spcng=0.1;
socketHght=13.75+2.5;
wireDia=1.5;
boreDia=7.6;

/* [show] */
showLamps=true;
showSockets=true;
showHousing=true;
showScrew=true;
export="none"; //["none","Housing","Lit"]

for (ix=[-1,1])
  translate([ix*lampDist/2,0,0]){
    if (showSockets) translate([0,0,-2.5]) socketG4();
    if (showLamps) translate([0,0,0]) lampG4();
}

if (export=="none") housing();
else !housing();



module housing(){
  ovDims=[lampDist+lampDia,lampDia,40];
  strHght=socketHght;
  litDims=[ovDims.x,ovDims.y/2,ovDims.z-strHght];
  
  if (showScrew && (export=="none"))
    translate([0,-ovDims.y/2+3,-ovDims.z/2]) rotate([90,0,0]) color("silver")  hexScrew(l=12);
  
  intersection(){
    difference(){
      hull(){
        translate([0,0,-strHght]) linear_extrude(strHght) for (ix=[-1,1])
          translate([ix*lampDist/2,0]) circle(d=lampDia);
        translate([0,0,-ovDims.z+lampDia/2]) sphere(d=lampDia);
      }
      for(ix=[-1,1]){
        translate([-ix*lampDist/2,0,-socketHght]) cylinder(d=boreDia+spcng*2,h=socketHght+fudge);
        translate([-ix*lampDist/2,0,-2.5-spcng]) cylinder(d=8.9+spcng*2,h=2.5+spcng+fudge);
      }
      //remove lit
      if (export=="Housing")
        translate([0,-litDims.y/2,-ovDims.z+litDims.z/2]) cube(litDims,true);      
        
      //interior carving
      difference(){
        hull(){
          for (ix=[-1,1])
            translate([ix*lampDist/2,0,-socketHght]) sphere(d=boreDia);
          translate([0,0,-ovDims.z+lampDia/2]) sphere(d=boreDia);
        }
        translate([0,0,-ovDims.z/2]) rotate([-90,0,0]) cylinder(d=6,h=ovDims.y,center=true);
        
      }
      hull() for (ix=[-1,1]) 
      translate([ix*wireDia/2,0,-ovDims.z-fudge]) cylinder(d=wireDia,h=lampDia-boreDia+fudge);
      //drill
      translate([0,0,-ovDims.z/2]) rotate([-90,0,0]) 
        cylinder(d=3.1,h=ovDims.y+fudge,center=true);
          
      //recess for nut
      translate([0,ovDims.y/2-3,-ovDims.z/2]) rotate([-90,0,0]) 
        linear_extrude(3+fudge) 
          circle(d=2*6/sqrt(3)+spcng*2,$fn=6);
      //recess for head
      translate([0,-ovDims.y/2-fudge,-ovDims.z/2]) rotate([-90,0,0]) 
        linear_extrude(3+fudge) 
          circle(d=6+spcng*2);
    }
  if (export=="Lit")
     translate([0,-litDims.y/2,-ovDims.z+litDims.z/2-spcng]) cube(litDims+[0,0,-spcng],true);      
  }
    
}

module socketG4(){
  baseDia=boreDia;
  baseHght=13.75;
  color("darkSlateGrey") translate([0,0,-baseHght]) difference(){
    cylinder(d=baseDia,h=baseHght);
    for (ix=[-1,1])
      translate([ix*6.1,0,(baseHght-2.25)/2]) cube([6.1,baseDia,baseHght-2.25+fudge],true);
  }
  color("darkSlateGrey") cylinder(d=8.9,h=2.5);
  
}

module lampG4(){
  color("white") cylinder(d=lampDia,h=7.5);
  color("white",0.5) translate([0,0,7.5]) cylinder(d=lampDia,h=33.2-7.5);
}

module hexScrew(dia=3,l=10){
  //threat
  cylinder(d=5.5,h=3);
  translate([0,0,-l]) cylinder(d=dia,h=l);
}