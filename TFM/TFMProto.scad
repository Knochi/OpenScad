$fn=50;

/* -- [Dimensions] -- */
teeth=6;
magDims=[4,5,2]; //e.g. Supermagnete.de Q-05-2.5-02-HN
rotorDia=40;
sheetThck=1.2;
discThck=1.2;
gap=0.2;
magSpc=2;
spcng=0.2; //spacing for core insert
coreLngth=4;
coreThck=1;
coilThck=2.5;


/* -- [show] -- */
TFMType="rotary"; //["rotary","linear"]
TFMStyle="uShape"; //["uShape","disc","doubleE"]
showRotor=true;
showStator=true;
showBody=true;
showCoil=true;
showIron=true;

/* -- [Hidden] -- */
segmAng=360/teeth;
coilDia=magDims.y+coreLngth*2-discThck-gap/2;
fudge=0.1;


if (TFMType=="rotary")
  rotTFM();

if (TFMType=="linear"){
  linTFM();
}

module linTFM(){
  if (showRotor) linMover();
  if (showStator) linStator(TFMStyle);
  
   

  
  if (TFMStyle=="doubleE"){
    for (p=[0:2],ir=[0:segmAng:360-segmAng])
      rotate(ir+p*segmAng/3) translate([magDims.y+gap,0,magDims.z+sheetThck*2]) rotate([90,0,0]) 
        color("silver") doubleE([coreLngth,(magDims.z+sheetThck*2)*3,sheetThck],coreThck=sheetThck,phaseSel=p+1,center=true);
  }
}

//assembly of 3Phase rotary TFM
module rotTFM(){
  for (i=[0:2])
    translate([0,0,i*(magDims.x+magSpc)]){
      rotor();
      rotate(i*segmAng/6) stator();
    }
}

*linStator(TFMStyle);
module linStator(style="uShape",cut=true){
  
  ovDia=magDims.y+(coreLngth+gap)*2;
  ovHght=magDims.z+discThck*2;
  
  
  if (style=="uShape"){//uShapes
    
    if (showBody) difference(){
      union(){
        for (iz=[-ovHght/2-discThck,ovHght*2.5]) translate([0,0,iz]) 
          difference(){
            cylinder(d=ovDia,h=discThck);
            translate([0,0,-fudge/2]) cylinder(d=magDims.y+spcng,h=discThck+fudge);
          }
        bodyStack();
      }
      for (ir=[0:segmAng/2:360-segmAng/2],tb=[-1,1],iz=[0:2])
        rotate(ir+iz*segmAng/3)
          translate([magDims.y/2+(coilDia/2-coilThck)/2,0,tb*(magDims.z+discThck)/2+iz*(magDims.z+discThck*2)]) 
            cube([coilDia/2-coilThck,sheetThck+spcng,discThck+spcng],true);
    }//diff
      
      //iron
      if (showIron) 
        for (iz=[0:2])
          translate([0,0,iz*(magDims.z+discThck*2)])
            rotate(iz*segmAng/3)
          for (ir=[0:segmAng/2:360-segmAng/2])
            rotate(ir)
              translate([(coreLngth+magDims.y)/2+gap,0,0]) rotate([90,0,0]) 
                color("silver") uShape([coreLngth,magDims.z+discThck*2,sheetThck],coreThck=discThck,material="wire",center=true);
      
    }//if uShape
    
  else if (style=="disc")
      difference(){
        color("darkGray") cylinder(d=ovDia,h=magDims.z+sheetThck*2,center=true);
        color("Gray") cylinder(d=coilDia,h=magDims.z+fudge,center=true);
        color("darkGray") cylinder(d=magDims.y+gap,h=magDims.z+sheetThck*2+fudge/2,center=true);
        if (cut) color("darkGray") 
          translate([0,ovDia/4,0]) cube([ovDia+fudge,ovDia/2+fudge,magDims.z+sheetThck*2+fudge],true);
      }
  
      
  //coil
  if (showCoil) color("chocolate") difference(){
    cylinder(d=coilDia,h=magDims.z,center=true);
    cylinder(d=coilDia-coilThck*2,h=magDims.z+fudge/2,center=true);
    if (cut) rotate(45) translate([0,0,-(magDims.z+fudge)/2]) cube([coilDia/2+fudge,coilDia/2+fudge,magDims.z+fudge]);
  }
  
  module bodyStack(){
    for (iz=[0:2])
      translate([0,0,iz*(magDims.z+discThck*2)])
        rotate(iz*segmAng/3)
          body();
  }
  
  module body(){
    difference(){ //single body diffs
            cylinder(d=ovDia,h=ovHght,center=true);
            
            //uShape 
            for (ir=[0:segmAng/2:360-segmAng/2]){
              rotate(ir) translate([(ovDia/2-coilThck)/2+coilDia/2-coilThck-fudge,0,0]) 
                cube([ovDia/2-coilThck,sheetThck+spcng,magDims.z+discThck*2+fudge],true);
              for (iz=[-1,1])
              rotate(ir) translate([magDims.y/2+(coilDia/2-coilThck)/2,0,iz*(magDims.z+discThck)/2]) 
                  cube([coilDia/2-coilThck,sheetThck+spcng,discThck+spcng],true);
            }
            
            cylinder(d=magDims.y+spcng,h=ovHght+fudge,center=true);
            difference(){
              cylinder(d=ovDia+fudge,h=magDims.z+spcng,center=true);
              cylinder(d=coilDia-coilThck*2,h=magDims.z+spcng*2,center=true);
            }
          }
  }
}


module linMover(){
  
  for (p=[0,1],iz=[0:(teeth-1)]){
    discCol= p ? "red" : "blue";
    translate([0,0,iz*(magDims.z*2+discThck*2)+p*(discThck+magDims.z)]){ 
      mirror([0,0,p]) magnet(magDims,shape="disc",center=true);
      color(discCol) translate([0,0,(magDims.z+discThck)/2]) cylinder(d=magDims.y,h=discThck,center=true);
    }
  }
  color("red") translate([0,0,-(magDims.z+discThck)/2]) cylinder(d=magDims.y,h=discThck,center=true);
}

module stator(){
  //teeth
  for (r=[0:segmAng:360-segmAng])
    rotate(r) 
      translate([(rotorDia-magDims.z-coreLngth)/2-gap,0,0])
        rotate([90,0,180]) 
          color("silver") uShape([coreLngth,magDims.x,magDims.y],coreThck,true);
}

module rotor(){
  //magnets
  for (pol=[0,1],r=[0:segmAng:360-segmAng])
    rotate(r+pol*segmAng/2) translate([rotorDia/2,0,0]) mirror([pol,0,0]) rotate([0,90,0]) magnet(magDims,true); 
}

*magnet(magDims,true,"disc");
module magnet(size=[1,1,1],center=false,shape="cube"){
  cntrOffset= center ? [0,0,0] : [size.x/2,size.y/2,size.z/2];
  if (shape=="cube")
    translate(cntrOffset){
      color("darkred") translate([0,0,-size.z/4]) cube([size.x,size.y,size.z/2],true);
      color("darkblue") translate([0,0,size.z/4]) cube([size.x,size.y,size.z/2],true);
    }
  else if (shape=="disc")
    translate([0,0,cntrOffset.z]){
      color("darkred") translate([0,0,-size.z/2]) cylinder(d=size.x,h=size.z/2);
      color("darkblue") cylinder(d=size.x,h=size.z/2);
    }
}

*uShape(size=[8,5,1],coreThck=1.4, material="wire", center=true);
module uShape(size=[1,1,1],coreThck=0.5,material="sheet",center=false){
  /*    /     /|  ^
       +-----+ |  |
       +---+ | |  y
  coreThck | | |   z
       +---+ | /  /
       +-----+/  v
        x--> */
  cntrOffset= center ? -[size.x/2,size.y/2,size.z/2] : [0,0,0];
  wireDia=size.z;//(size.y-coreThck)/2;
  coreThck=size.y-wireDia*2;
  bendRad=wireDia/2+coreThck/2;
  echo(wireDia,bendRad,coreThck);
  translate(cntrOffset)
    if (material=="sheet") difference(){
      cube(size);
      translate([-coreThck/2-fudge/2,coreThck,-fudge/2]) 
        cube([size.x-coreThck+fudge,size.y-coreThck*2,size.z+fudge]);
    }
    else {
      translate([0,wireDia/2,wireDia/2]) rotate([0,90,0]) cylinder(d=wireDia,h=size.x-(coreThck/2+wireDia));
      translate([0,size.y-wireDia/2,wireDia/2]) rotate([0,90,0]) cylinder(d=wireDia,h=size.x-(coreThck/2+wireDia));
      translate([size.x-wireDia/2-bendRad,bendRad+wireDia/2,wireDia/2]) 
        rotate([0,0,90]) rotate_extrude(angle=-180) translate([bendRad,0]) circle(d=wireDia);
    }
}

*doubleE([5,10,0.5],coreThck=0.5,phaseSel=1,center=true);
module doubleE(size=[1,1,1],coreThck=0.5,phaseSel=0,center=false){
  cntrOffset= center ? [0,0,0] : [size.x/2,size.y/2,size.z/2];
  cutOutDim=[size.x-coreThck+fudge,(size.y-coreThck*6)/3,size.z+fudge];
  phaseYPos=[                 -(size.y-coreThck)/2,
             -(cutOutDim.y/2+1.5*coreThck)-fudge/2,
             -(cutOutDim.y/2+0.5*coreThck)+fudge/2,
              (cutOutDim.y/2+0.5*coreThck)-fudge/2,
              (cutOutDim.y/2+1.5*coreThck)+fudge/2,
              (size.y-coreThck)/2];
  
  phaseXPos=-(size.x-coreThck+fudge)/2;
  
  translate(cntrOffset)
    difference(){
      cube(size,true);
      for (iy=[-1:1])
        translate([-(coreThck+fudge)/2,iy*(cutOutDim.y+coreThck*2),0])  cube(cutOutDim,true);
      if (phaseSel== 1) for (i=[2,3,4,5])
        translate([phaseXPos,phaseYPos[i],0]) cube(coreThck+fudge,true);
      if (phaseSel== 2) for (i=[0,1,4,5])
        translate([phaseXPos,phaseYPos[i],0]) cube(coreThck+fudge,true);
      if (phaseSel== 3) for (i=[0,1,2,3])
        translate([phaseXPos,phaseYPos[i],0]) cube(coreThck+fudge,true);
    }
}