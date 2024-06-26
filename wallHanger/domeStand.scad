use <eCad/devBoards.scad>
use <threads.scad>

/* [show] */
showThreads=false;
showPico=false;
showBaseTop=true;
showBaseBottom=true;
showDome=false;
showCut=false;
topOffset=0; //[0:40]

/* [DomeDimensions] */
domeOuterDia=90;
domeHeight=170;
domeWallThck=2.5;

/* [ModelDimensions] */
minWallThck=2;
domeSpacing=0.5;
topHght=15;
botHght=15;
baseHght=topHght+botHght;

/* [Config] */
magDia=10;
magThck=1;
magSpcng=0.2;

/* [Hidden] */
baseDia=domeOuterDia+minWallThck*2+domeSpacing*2;
fudge=0.1;
$fn=100;

difference(){
  base();
  if (showCut) color("darkRed") translate([0,-baseDia/4,baseHght/2]) cube([baseDia+fudge,baseDia/2,baseHght+fudge],true);
}

if (showDome)
  translate([0,0,baseHght-minWallThck+topOffset]) glassDome();



*smartBase();
//base with pi Pico and connector for LEDs
module smartBase(){
  if (showPico)
    translate([0,0,0]) piPico(false);
}

//base with drainslots and reservoir for condensing water 
module base(){
  
  slotCount=12;
  threadLen=5;
  angInc=360/slotCount;
  threadSpcng=0.2;
  rodDia=2.2;
  rodDistDia=30; 
  chamfer=1;

  fabricSlotDims=[2,10];
  
  innerDia=domeOuterDia-domeWallThck*2-domeSpacing*2;
  slotDims=[4,2,topHght+fudge];
  if (showBaseTop)
    translate([0,0,botHght+topOffset]) top();
  
  if (showBaseBottom)
    bottom();
  
  module top(){  
    difference(){
      cylinder(d=baseDia,h=topHght);
        rotate_extrude() translate([(domeOuterDia-domeWallThck)/2,topHght-minWallThck]) circle(d=domeWallThck+domeSpacing*2);
 
        translate([0,0,topHght-minWallThck]) 
          linear_extrude(minWallThck+fudge) difference(){
          circle(d=domeOuterDia+domeSpacing*2);
          circle(d=innerDia);
          }
        
        //drain slots
        for (ir=[0:angInc:360-angInc])
          rotate(ir) translate([(innerDia-slotDims.x)/2+domeSpacing+domeWallThck/2,0,topHght/2]) cube(slotDims,true);
        //holes for metal rods
        for (ir=[0,120,240])
          rotate(ir) translate([rodDistDia/2,0,0]){
            cylinder(d=rodDia,h=topHght+fudge-chamfer);
            translate([0,0,topHght-chamfer]) cylinder(d1=rodDia,d2=rodDia+(chamfer+fudge)*2,h=chamfer+fudge);
          }
        //slots for fabric
        for (ir=[60,180,300],d=[rodDistDia/4,rodDistDia*0.6])
          rotate(ir) translate([d,0,topHght/2]){
            cube([fabricSlotDims.x,fabricSlotDims.y,topHght+fudge],true);
          }
        //thread
        if (showThreads)
          translate([0,0,-fudge]) metric_thread(diameter=baseDia-minWallThck+threadSpcng, 
                                                pitch=2, 
                                                length=topHght-minWallThck*3-domeSpacing+fudge, 
                                                internal=true, leadin=0);
        else
          color("cyan") translate([0,0,-fudge]) cylinder(d=baseDia-minWallThck*2,h=topHght-minWallThck*3-domeSpacing+fudge);
      }
      //sockets for metal rods
      for (ir=[0:120:240])
        rotate(ir) translate([rodDistDia/2,0,0]) difference(){
          cylinder(d=rodDia+2*minWallThck,h=topHght-chamfer);
          translate([0,0,minWallThck]) cylinder(d=rodDia,h=topHght);
        }
      
    }
      
  module bottom(){
    //attachment for watering
    atWidth=10;
    atAng=20;
    filetRad=10;
    
    difference(){
      //body
      union(){
        cylinder(d=baseDia,h=botHght);
        attachment(atWidth, atAng, baseDia, height=botHght);
        //thread on top
        if (showThreads)
          translate([0,0,botHght]) metric_thread(diameter=baseDia-minWallThck-threadSpcng, 
                                                 pitch=2, 
                                                 length=threadLen, 
                                                 internal=false, leadin=0);
        //threadDummy
        else
          color("cyan") translate([0,0,botHght]) cylinder(d=baseDia-minWallThck,h=threadLen);
      } //union
      //results in minWallTchk*1.5 walls
      translate([0,0,minWallThck]) cylinder(d=baseDia-3*minWallThck,h=botHght+threadLen);
      //recesses for magnets (or feet, or whatever)
      for (ir=[0:120:240])
        rotate(ir) translate([baseDia/3,0,-fudge]) cylinder(d=magDia+magSpcng*2,h=magThck+magSpcng+fudge);
      //watering opening
      for (ir=[-1,1])
        rotate(ir*atAng/2) translate([(baseDia+atWidth)/2,0,minWallThck]) 
          cylinder(d=atWidth-minWallThck*2,h=botHght-minWallThck+fudge);
      rotate(-atAng/2) rotate_extrude(angle=atAng) 
        translate([(baseDia)/2+minWallThck,minWallThck]) square([atWidth-minWallThck*2,botHght-minWallThck+fudge]);
      //open attachment
      attachment(atWidth, atAng, baseDia, height=botHght, cut=true);
    } //diff
    //add material above recesses to ensure watertightness
    for (ir=[0:120:240])
      rotate(ir) translate([baseDia/3,0,magThck+magSpcng]) cylinder(d=magDia+magSpcng*2+minWallThck*2,h=minWallThck);
  }//bottom
}

*attachment(wallThck=minWallThck*1.5);
 module attachment(width=10, angle=20, baseDia=baseDia, height=botHght, filetRad=10, hollow=true, wallThck=undef, cut=false){
  minWallThck = (minWallThck == undef) ? 1 : minWallThck;//only for floor and top
  wallThck = (wallThck == undef) ? minWallThck : wallThck;
  //calculate fillets, see filletBetween2Circles.png
  //filletRad=r3, width/2 = r2, baseDia/2=r1, atFilAng=alpha
  a=filetRad+width/2; 
  b=baseDia/2+filetRad; 
  c=baseDia/2+width/2; 
  atFilDist=b;
  atFilAng=acos((b^2+c^2-a^2)/(2*b*c)); //angle for fillet circle
  
  beta=acos((a^2+c^2-b^2)/(2*a*c)); //angle for tangent 
  atTangRad=sqrt((width/2)^2+c^2-2*(width/2)*c*cos(beta)); //radius at which the tangents meet (d)

  if (cut)
    difference(){
      rotate(-(angle/2+atFilAng)) 
        rotate_extrude(angle=angle+atFilAng*2) 
          translate([(baseDia)/2-minWallThck*3-fudge/2,minWallThck]) square([minWallThck*3+fudge,height-minWallThck*2]);
      for (ir=[-1,1])
        rotate(ir*(angle/2+atFilAng)) translate([atFilDist,0,-fudge/2]) cylinder(r=filetRad+minWallThck,h=height+fudge);
    }
  else 
    difference(){
      union(){
        rotate(-angle/2) rotate_extrude(angle=angle) translate([(baseDia)/2,0,0]) square([width,height]);
        rotate(-(angle/2+atFilAng)) 
          rotate_extrude(angle=angle+atFilAng*2) 
            translate([(baseDia)/2-fudge,0,0]) square([atTangRad-baseDia/2+fudge,height]);
          for (ir=[-1,1])
            rotate(ir*angle/2) translate([(baseDia+width)/2,0,0]) cylinder(d=width,h=height);
      }
      if (hollow){
        //core
        rotate(-angle/2) rotate_extrude(angle=angle) 
          translate([(baseDia)/2+wallThck,minWallThck]) square([width-wallThck*2,height-minWallThck*2]);
        //radii
        for (ir=[-1,1])
            rotate(ir*angle/2) translate([(baseDia+width)/2,0,minWallThck]) 
              cylinder(d=width-wallThck*2,h=height-minWallThck*2);
        
        //into the fillets
        difference(){
          rotate(-(angle/2+atFilAng)) 
            rotate_extrude(angle=angle+atFilAng*2) 
              translate([(baseDia)/2-1,minWallThck]) square([atTangRad-baseDia/2+1,height-minWallThck*2]);
          for (ir=[-1,1])
            rotate(ir*(angle/2+atFilAng)) translate([atFilDist,0,minWallThck-fudge/2]) 
              cylinder(r=filetRad+wallThck+fudge,h=height-minWallThck*2+fudge);
        }
        
      }
      //fillets
      for (ir=[-1,1])
        rotate(ir*(angle/2+atFilAng)) translate([atFilDist,0,-fudge/2]) cylinder(r=filetRad,h=height+fudge);
    }
  
}//attachment
    
//glass dome
*glassDome();
module glassDome(dia=90, height=170, wallThck=2.5){
  fudge=0.1;
  color("white",0.4) difference(){
    union(){
      translate([0,0,height-dia/2]) 
        //half sphere
        difference(){ 
          sphere(d=dia);
          translate([0,0,-(dia+fudge)/2]) cylinder(d=dia+fudge,h=dia+fudge,center=true);
        }
      cylinder(d=dia,h=height-dia/2);
    }
    union(){
      translate([0,0,height-dia/2-wallThck]) sphere(d=dia-wallThck*2);
      translate([0,0,-fudge]) cylinder(d=dia-wallThck*2,h=height-dia/2-wallThck+fudge);
    }
  }
}

function filletAng(r1, r2, r3)= let(
  a=r2+r3,
  b=r1+r3,
  c=r1+r2,
  alpha=acos((b^2+c^2-a^2)/(2*b*c)),
  beta=acos((a^2+c^2-b^2)/(2*a*c)),
  gamma=180-alpha-beta
) [alpha,beta,gamma];