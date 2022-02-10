use <rndrect2.scad>
use <connectors.scad>



matThck=3;
fudge=0.1;
ovDims=[72.5,36,matThck];
PCBDims=[62.5,26,1.6];
crnRad=2.5;
layThck=[matThck,matThck,5,3];
blckThck=layThck[1]+layThck[2];


/* [show] */
showLayer3=true;
showLayer2=true;
showLayer1=true;
showLayer0=true;
showPCB=true;
showBlock=true;
export="none"; //["none","layer0","layer1","layer2","layer3","block"]


/* [Hidden] */
$fn= (export=="none") ? 20 : 200;

if (showPCB)
  translate([0,0,1.6]) PCB();

//layers

if (showLayer0) color("darkslateGrey") translate([0,0,-layThck[1]-layThck[0]/2]) layer0();
if (showLayer1) translate([0,0,-layThck[1]/2]) layer1();
if (showLayer2) color("violet") translate([0,0,layThck[2]/2]) layer2(layThck[2]);
if (showLayer3) color("orange") translate([0,0,layThck[2]+layThck[3]/2]) layer3(layThck[3]);
  
if (showBlock)  color("grey")
translate([-(ovDims.x-5)/2,0,-blckThck/2+layThck[2]]) block();

//export

if (export=="layer0") !projection() layer0();
if (export=="layer1") !projection() layer1();
if (export=="layer2") !projection() layer2(layThck[2]);
if (export=="layer3") !projection() layer3(layThck[3]);
if (export=="block"){ 
  block("top");
  translate([6,0,0]) rotate([180,0,0]) block("bottom");
}


module layer0(){
  difference(){
    rndRect(ovDims,radius=crnRad,drill=2,center=true);
    translate([-(ovDims.x-5)/2,0,0]) cube(matThck+fudge,true);
  }
}

module layer1(){
  
  difference(){
   rndRect(ovDims,radius=crnRad,drill=2.5,center=true);
   rndRect([35,21,matThck+fudge],radius=crnRad,drill=0,center=true);
   translate([-(ovDims.x-12)/2-crnRad,0,0]) rndRect([12,27,matThck+fudge],radius=crnRad,drill=0,center=true);
  }
}

*layer2();
module layer2(thick=matThck){
  difference(){
    rndRect(ovDims+ + [0,0,-matThck+thick],radius=crnRad,drill=2.5,center=true);
    cube(PCBDims+ [0,0,-PCBDims.z+thick+fudge],true); //PCB
    translate([-(ovDims.x-12)/2-crnRad,0,0]) rndRect([12,27,thick+fudge],radius=crnRad,drill=0,center=true); //Test connectors
    translate([(ovDims.x)/2,0,0]) cube([12,8.5,thick+fudge],true); //duraclik
  }
}

module layer3(thick=matThck){
  
  brimX=(ovDims.x-PCBDims.x)/2;
  dClikDims=[7.5+brimX,8.5,thick+fudge];
  difference(){
    rndRect(ovDims + [0,0,-matThck+thick],radius=crnRad,drill=2.5,center=true);
    translate([(PCBDims.x-dClikDims.x)/2+brimX+fudge,0,0]) cube(dClikDims,true);
    translate([-((PCBDims.x-dClikDims.x)/2+brimX+fudge),0,0]) cube(dClikDims,true);
    rndRect([10.2,10.2,thick+fudge],radius=1,drill=0,center=true);
    cube([30,8,thick+fudge],true);
    for (i=[-1,1])
      translate([-(ovDims.x-5)/2,i*9,0]) cube(thick+fudge,true);
  }
}

*block("none");
module block(split="none"){
spltOffset= (split=="top") ? -blckThck/4 : (split=="bottom") ? +blckThck/4 : 0;
  
  difference(){
    cube([5-fudge,27,blckThck],true);
    translate([0,20.3/2,0]) rotate([0,90,0]) cylinder(d=6+fudge,h=5+fudge,center=true);
    translate([0,-20.3/2,0]) rotate([0,90,0]) cylinder(d=6+fudge,h=5+fudge,center=true);
    translate([0,0,(blckThck-4)/2]) cube([5+fudge,8.5,4+fudge],true);
    if (spltOffset) translate([0,0,spltOffset]) cube([5,27+fudge,blckThck/2+fudge],true);  
  }
  if (split!="bottom"){ 
    translate([0,9,(blckThck+matThck)/2]) cube([matThck,matThck,matThck-fudge],true);
    translate([0,-9,(blckThck+matThck)/2]) cube([matThck,matThck,matThck-fudge],true);
  }
  if (split!="top")
    translate([0,0,-(blckThck+matThck)/2]) cube([matThck,matThck,matThck-fudge],true);
}
*PCB();
module PCB(){
  dims=PCBDims;
  color("green")  translate([0,0,-dims.z/2]) cube(dims,true);
  
  //duraClik horizontal
  color("ivory"){
    translate([-(dims.x-7)/2,0,6.5/2]) cube([7,8,6.5],true); 
    translate([(dims.x-7)/2,0,6.5/2]) cube([7,8,6.5],true); 
  
  //duraClik vertical
    translate([-(dims.x-8)/2+16.5,0,8/2]) cube([8,8,8],true); 
    translate([(dims.x-8)/2-16.5,0,8/2]) cube([8,8,8],true); 
  }
  
  //pinHeaders
   pinHeader(16,4,true);
  
  //TestJacks4mm
  translate([-dims.x/2+1.8,20.3/2,-dims.z/2]) rotate([0,-90,0]) testJack4mm();
  translate([-dims.x/2+1.8,-20.3/2,-dims.z/2]) rotate([0,-90,0]) testJack4mm("black");
  
  //Wires
  color("blue") 
    translate([-PCBDims.x/2+4,-18.3/2,1.6/2]) rotate([0,90,0]) cylinder(d=1.6,h=20);
  color("red") 
    translate([-PCBDims.x/2+4,18.3/2,1.6/2]) rotate([0,90,0]) cylinder(d=1.6,h=33);
}