use <eCad/Displays.scad>

$fn=50;

/* -- [show] -- */
showSTL=true;
showBody=true;
showSection=true;
showDisplay=true;
showCamera=true;
mode="remix"; //["remix","model"]

/* -- [Remix-Dimension] -- */
bdyDiaRmx=15.48;
/* -- [Model-Dimensions] -- */
bdyDiaMdl=80;
wallThck=2;
displayOffset=[0,-27,0];


/* -- [Hidden] -- */
bdyDia= (mode=="remix") ? bdyDiaRmx : bdyDiaMdl;
bdyInDia=bdyDia*0.87;
frntHoleDia=bdyDia*0.4;
bdyZOffset=bdyDia*0.72;
bdyBtmHght=bdyDia*0.4;
bdyBtmInHght=bdyDia*0.53;
bdyBtmInDia=bdyDia*0.7;


if (showCamera && mode=="model")
 translate([0,+3.5,bdyZOffset+46]) rotate([-12,0,0]) rotate([90,90,0]) OV2640(length=75);

if (showSTL && mode!="model")
  %difference(){
    translate([-1.47,+2.414,0]) rotate([9.7,-11.1,-11.6+90]) 
      scale(100) import("C3_BB_PrintModel_redox.stl",convexity=3);
    if (showSection)
      translate([bdyDia,0,bdyZOffset]) cube(bdyDia*2,true);
  }

//outer sphere
if (showBody){
  difference(){
    body();
    if (showSection)
      color("darkred") translate([bdyDia,0,bdyZOffset]) cube(bdyDia*2,true);
  }
}

if (showDisplay && mode!="remix")
  translate(displayOffset+[0,0,bdyZOffset]) rotate([90,0,180]) roundDisplayWS();


module body(){
  difference(){
    union(){
      translate([0,0,bdyZOffset]) sphere(d=bdyDia); 
      translate([0,-0.0465*bdyDia,1.04*bdyDia]) rotate([0,-78,90]) topHood();   
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
  } //diff
  //bottom sphere
  difference(){
    translate([0,0,bdyZOffset]) sphere(d=bdyInDia);    
    translate([0,0,bdyZOffset]) sphere(d=bdyInDia-wallThck*2);    
    translate([0,0,bdyZOffset-frntHoleDia/2]) cylinder(d=bdyInDia,h=bdyInDia);
  }
  
  module baseMount(){
    //attach legs or other mounts
    
  }
  
  module topHood(){
    chamfer=[scaleList2BdyDia([0.35,0.30]),scaleList2BdyDia([0.84,0.21])];
    dia1=scaleList2BdyDia([3.08,3.4]);
    dia2=scaleList2BdyDia([6.0,7]);
    dist=scaleList2BdyDia([4,4]);
    backOffset=scaleList2BdyDia([-1.3,0,-6.53]);
    
    //front
    hull(){
      translate([dist[0],0,0]) 
        cylinder(d1=(dia1[0]), 
                 d2=(dia1[0]-chamfer[0][0]), 
                 h=(chamfer[0][1]));
      cylinder(d1=(dia2[0]), 
               d2=(dia2[0]-chamfer[0][0]), 
               h=(chamfer[0][1]));
    }
    //back
    translate(backOffset) rotate([180,-18,0]) hull(){
      translate([dist[len(dist)-1],0,0]) 
        cylinder(d1=dia1[len(dia1)-1], d2=dia1[len(dia1)-1]-chamfer[1][0], h=chamfer[1][1]);
      cylinder(d1=dia2[len(dia2)-1], d2=dia2[len(dia2)-1]-chamfer[1][0], h=chamfer[1][1]);
    }
  }
  
}

module stand(){
  
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
