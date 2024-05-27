use <eCad/Displays.scad>

$fn=50;

/* -- [show] -- */
showSTL=true;
showBody=true;
showEars=true;
showSensor=true;
showDisplay=true;
showCamera=true;
showPlug=true;
chainHull=true;
mode="remix"; //["remix","model"]
showSection="none"; //["none","Y-Z","X-Y"]
sectionOffset=0.5; //[0:0.05:1]
/* -- [Remix-Dimension] -- */
bdyDiaRmx=15.48;
/* -- [Model-Dimensions] -- */
bdyDiaMdl=80;
wallThck=2;
displayOffset=[0,-30,0];
glueSpcng=0.1;


/* -- [Hidden] -- */
bdyDia= (mode=="remix") ? bdyDiaRmx : bdyDiaMdl;
bdyInDia=bdyDia*0.87;
frntHoleDia=bdyDia*0.42;
bdyZOffset=bdyDia*0.72;
bdyBtmHght=bdyDia*0.4;
bdyBtmInHght=bdyDia*0.53;
bdyBtmInDia=bdyDia*0.65;
sensorOffset=scaleList2BdyDia([2.7,-7.2,4.5]) + [0,0,bdyZOffset];


if (showCamera && mode=="model")
 translate([0,+3.5,bdyZOffset+46]) rotate([-12,0,0]) rotate([90,90,0]) OV2640(length=75);

if (showSTL && mode!="model")
  %difference(){
    translate([-1.47,+2.414,0]) rotate([9.7,-11.1,-11.6+90]) 
      scale(100) import("C3_BB_PrintModel_redox.stl",convexity=3);
    if (showSection=="Y-Z")
      translate([bdyDia,0,bdyZOffset]) cube(bdyDia*2,true);
    if (showSection=="X-Y")
      translate([0,0,bdyZOffset+bdyDia*sectionOffset*2]) cube(bdyDia*2,true);
  }
  

//outer sphere
if (showBody){
  difference(){
    body();
    if (showSection=="Y-Z")
      color("darkred") translate([bdyDia*sectionOffset*2,0,bdyZOffset]) cube(bdyDia*2,true);
    if (showSection=="X-Y")
      color("darkRed") translate([0,0,bdyZOffset+bdyDia*sectionOffset*2]) cube(bdyDia*2,true);
  }
}

if (showDisplay && mode!="remix")
  translate(displayOffset+[0,0,bdyZOffset]) rotate([90,0,180]) roundDisplayWS(showPlug=showPlug);

if (showEars)
  difference(){
    for (ix=[-1,1])
      translate([0,0,bdyZOffset]) rotate([0,ix*90,0]) sideDisc();
    if (showSection=="Y-Z")
        color("darkred") translate([bdyDia*sectionOffset*2,0,bdyZOffset]) cube(bdyDia*2,true);
  }
  
if (showSensor)
  translate(sensorOffset) 
    rotate([-90,0,0]) sensor();


module body(){
  difference(){
    union(){
      translate([0,0,bdyZOffset]) sphere(d=bdyDia); 
      translate([0,0,scale2BdyDia(20)]) rotate([0,-78,90]) topHood();   
    }
    translate([0,0,bdyZOffset]){
      //front hole
      rotate([90,0,0]) cylinder(d=frntHoleDia,h=bdyDia/2);
      //hollow Out main
      difference(){
        sphere(d=bdyDia-2*wallThck);
        translate([0,0,-(bdyDia-2*wallThck)/2]) 
          cylinder(d=bdyDia-2*wallThck,h=((bdyDia-2*wallThck)-frntHoleDia)/2);
      }
      //hollow Out bottom
        sphere(d=bdyInDia);
      
    }
    //bottom
    cylinder(d=bdyDia,h=bdyBtmHght);
    cylinder(d=bdyBtmInDia,h=bdyBtmInHght);
    //cutouts for ears
    for (ix=[-1,1])
      translate([0,0,bdyZOffset]) rotate([0,ix*90,0]) sideDisc(true);
    
  } //diff
  
  //bottom sphere
  difference(){
    translate([0,0,bdyZOffset]) sphere(d=bdyInDia);    
    translate([0,0,bdyZOffset]) sphere(d=bdyInDia-wallThck*2);    
    translate([0,0,bdyZOffset-frntHoleDia/2]) cylinder(d=bdyInDia,h=bdyInDia);
  }
  
  //front ring
  translate([0,scale2BdyDia(-7.21),bdyZOffset]) rotate([-90,0,0]) frntRing();
  
  
  module baseMount(){
    //attach legs or other mounts
  }
  
  
  module topHood(){
    
    //upper Diameter
    dia1=scaleList2BdyDia(
              [3.08,        3.36,         3.40,         3.6,            3.4]);
    //lower Diameter
    dia2=scaleList2BdyDia(
              [6.0,         6.4,          6.90,          7.0,            7]);
    //distance of those
    dist=scaleList2BdyDia(
              [4,           4,            4,            3.8,              4]);
    
    //translation of each profile
    transRmx= [[0,0.0,-0.1],[-0.17,0,-1], [-0.41,0,-2.5], [-1.0,0,-3.9],  [-1.45,0,-5.41]];
    
    //rotation of each profile
    rotRmx=   [[0,0,0],     [0,1,0],      [0,0,0],      [0,-5,0],       [180,-18,0]];
    //chamfers [width,heightOfProfile]
    chmfRmx=  [[0.35,0.30], [2.0,0.1],    [2.0,0.1],    [2.0,0.1],      [0.84,0.21]];
    
    rotMdl=rotRmx;
    transMdl= [ for (i=[0:len(transRmx)-1]) scaleList2BdyDia(transRmx[i]) ];
    chmfMdl=[ for (i=[0:len(chmfRmx)-1]) scaleList2BdyDia(chmfRmx[i]) ];
    
    if (chainHull)
      for (i = [0: len(dia1)-2])
        hull(){
            translate(transMdl[i]) rotate(rotMdl[i]) hoodShape(dia1[i],dia2[i],dist[i],chmfMdl[i]);
            translate(transMdl[i+1]) rotate(rotMdl[i+1]) hoodShape(dia1[i+1],dia2[i+1],dist[i+1],chmfMdl[i+1]);
        }
    else
      for (i = [0: len(dia1)-1])
        translate(transMdl[i]) rotate(rotMdl[i]) hoodShape(dia1[i],dia2[i],dist[i],chmfMdl[i]);
   
    
    module hoodShape(dia1,dia2,dist,chamfer){
      hull(){
          cylinder(d1=dia1, 
                  d2=dia1-chamfer[0], 
                  h=chamfer[1]);
        translate([-dist,0,0])
        cylinder(d1=dia2, 
                d2=dia2-chamfer[0], 
                h=chamfer[1]);
      }
    }
    
  } //topHood
  
}

//"ears"
*sideDisc(false);
module sideDisc(cut=false){
  
  crnrRad=scale2BdyDia(0.36);
  spcng= cut ? glueSpcng : 0;
  sectionDims=[scale2BdyDia(2),bdyDia/2-scale2BdyDia(3.8)];
  
  rotate_extrude() 
    difference(){
      offset(spcng){
        mirror([0,1]) rotate(-90) hull(){
          translate([scale2BdyDia(0.36),0]) intersection(){
            circle(d=bdyDia);
            translate([scale2BdyDia(6),0]) square(sectionDims);
          }
          translate([scale2BdyDia(6.36)+crnrRad,sectionDims.y-0.2]) circle(crnrRad);
          translate([scale2BdyDia(6.36+0.1),sectionDims.y+scale2BdyDia(0.05)]) circle(scale2BdyDia(0.1));
          
        }//hull
      translate([0,scale2BdyDia(6)]) square([scale2BdyDia(4.00),wallThck]);
      }
      translate([-glueSpcng-0.1,0]) square([glueSpcng+0.1,scale2BdyDia(8.2)]);
    }//diff
  
}

*frntRing();
module frntRing(){
  //main ring
  rotate_extrude() hull(){
    translate(scaleList2BdyDia([4.45,0.61])) circle(d=scale2BdyDia(0.2));
    translate(scaleList2BdyDia([3.52,0   ])) circle(d=scale2BdyDia(0.3));
    translate(scaleList2BdyDia([3.23,-0.1])) circle(d=scale2BdyDia(0.1));
    translate(scaleList2BdyDia([3.23,+0.2])) circle(d=scale2BdyDia(0.1));
    translate(scaleList2BdyDia([4.52,0.93])) circle(d=scale2BdyDia(0.1));
  }  
  //-- handle --
  //body
  polyRmx=[[3.98,0.74],[3.98,-0.03],[4.1,-0.14],[4.85,0.36],[5,0.62],[5,1.3]];
  poly=[ for (i=[0:len(polyRmx)-1]) scaleList2BdyDia(polyRmx[i]) ];
    rotate_extrude(angle=48) polygon(poly);
  
}
*sensor();
module sensor(){
  //poly=[[1.4,-7.2],[1.77,-7.5],[2,-7.5],[2.15,-7.4],[3.25,-7.4]]; //-3.25,+7.2
  polyRmx=[[0,0],[1.31,0],[0.93,-0.34],[0.7,-0.34],[0.54,-0.18],[0,-0.18]];
  poly=[ for (i=[0:len(polyRmx)-1]) scaleList2BdyDia(polyRmx[i]) ];
  
difference(){  
  union(){
    rotate_extrude() polygon(poly);
      hull(){
        cylinder(r1=scale2BdyDia(1.31),r2=0.1,h=0.1);
        translate([0,0,scale2BdyDia(4)]) sphere(scale2BdyDia(1.9));
      }
  }
  translate([-sensorOffset.x,-bdyZOffset+sensorOffset.z,-sensorOffset.y]) sphere(d=bdyDia);
}
}

module antenna(){
  //socket
  //antenna
}

module hips(){
  
}

*OV2640();
module OV2640(fov=66,length=40){
  //https://www.aliexpress.com/i/1005004962071810.html
  //connector: e.g. https://www.digikey.de/en/products/detail/te-connectivity-amp-connectors/2-1734839-4/1860480
  // 24pins, 0.5mm pitch, 0.3mm FCC thickness
  //camera module
  camModDims=[9,9,2];
  lensDia=8.5;
  lensHght=5.5;
  color("darkslateGrey"){
  if (fov==66){
    cylinder(d=lensDia,h=lensHght);
    translate([0,0,camModDims.z/2]) cube(camModDims,true);
  }
  if (fov==160)
    cylinder(d=10,h=10.5);
}
  //flex + connector
  color("orange") 
    linear_extrude(0.3){
    translate([0,-6/2]) square([length-camModDims.x/2,6]);
    translate([length-camModDims.x/2-4.5,-12.5/2]) square([4.5,12.5]);
  }
}

*echo(scaleList2BdyDia([1,2,3,4]));
function scale2BdyDia(input)=(input/bdyDiaRmx)*bdyDia;

function scaleList2BdyDia(input,output=[], index=0)= (index<len(input)) ? 
  scaleList2BdyDia(input,concat(output, (input[index]/bdyDiaRmx)*bdyDia),index+1) : output;
  
function scale2BdyDia2D(input)=[(input[0]/bdyDiaRmx)*bdyDia,(input[1]/bdyDiaRmx)*bdyDia];
function scale2BdyDia3D(input)=[(input[0]/bdyDiaRmx)*bdyDia,(input[1]/bdyDiaRmx)*bdyDia,(input[2]/bdyDiaRmx)*bdyDia];
