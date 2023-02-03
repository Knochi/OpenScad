use <myShapes.scad>
//use <wallDesk.scad>

/*  Specs
    min:800
    max:1300
*/

/* -- [Dimensions] -- */
minHeight=800;  //minimum table surface Height
maxHeight=1300; //maximum table surface Height
monHeight=310; //monitor Height over table Surface
norbergDims=[740,596,433];
backPlateThck=18; //[9:3:21]
backPlateWdth=740;
backPlateExtTop=0; //Extend Backplate on Top
backPlateExtBot=200; //Extend Backplate on Bottom
beamsExtend=00; //extra rail length for Stability
beam2PlateGap=0.5;
wheelBoxDims=[24,70];

/* -- [show] -- */
heightSetting=0; //[0:0.1:1]
tableRaised=true;
showBeams=true;
showNorberg=true;
showMonitor=true;
showWheels=true;

/* -- [Options] -- */
wheelsPerSide=4;

/* [Hidden] */
actHght=(maxHeight-minHeight)*heightSetting;
backPlateDims=[backPlateWdth,backPlateThck,
               norbergDims.z+monHeight+325/2+backPlateExtTop+backPlateExtBot];

//WheelBoxes



//Profiles (if used)
//profileYOffset=-(beamDims.y-backPlateDims.y)/2; //center on backPlate
  
//backPlateHght=880;
fudge=0.1;

// --- Assembly ---

if (showBeams) for(im=[0,1])
    mirror([im,0,0]) translate([norbergDims.x/2+beam2PlateGap,0,0]) beam();

//everything that is mounted to the backplate goes here
translate([0,0,minHeight+actHght]){
  NORBERG(tableRaised);
  translate([0,0,monHeight]) rotate([90,0,0]) asusVA24D(); 
  translate([0,0,-norbergDims.z]) backPlate();
}

*beam();
module beam(VProfile=false){

  beamDims=[50,backPlateThck+3,backPlateDims.z-norbergDims.z+minHeight+beamsExtend-backPlateExtBot];
  wheelBoxZDist=(backPlateDims.z-(maxHeight-minHeight)-beamDims.y*2-wheelBoxDims.y)/(wheelsPerSide-1);
  wheelBoxZOffset=beamDims.z/2-wheelBoxZDist*(wheelsPerSide-1)/2-wheelBoxDims.y/2-beamDims.y;
  gap=0.5; 

  
  translate(beamDims/2){
      //beam
      
        difference(){
          linear_extrude(beamDims.z,center=true) square([beamDims.x,beamDims.y],true);
          if (VProfile)
            translate([(-beamDims.x/2),profileYOffset]) linear_extrude(10) VSlotProfile(cut=true);
          else //WheelBoxes
            for (iz=[-(wheelsPerSide-1)/2:(wheelsPerSide-1)/2])
              translate([-beamDims.x/2,0,iz*wheelBoxZDist+wheelBoxZOffset])
                rotate([-90,0,180]) wheelBox(beamDims.y,cutOut=true); 
        }//diff
        
        for (iz=[-(wheelsPerSide-1)/2:(wheelsPerSide-1)/2])
              translate([-beamDims.x/2,0,iz*wheelBoxZDist+wheelBoxZOffset])
                rotate([-90,0,180]) wheelBox(beamDims.y,cutOut=false); 

        //Cut Profile
        *if (VProfile)
          color("silver") linear_extrude(beamDims.z,center=true) translate([-beamDims.x/2,profileYOffset]) VSlotProfile();
        
  }
}

*backPlate();
module backPlate(VProfile=true){
  //ovDims=[740,backPlateThck,880];
  
  wheelBoxZDist=(maxHeight-minHeight-wheelBoxDims.y+beamsExtend)/(wheelsPerSide);
  wheelBoxZOffset=-backPlateDims.z/2+wheelBoxZDist*(wheelsPerSide/2)-wheelBoxDims.y;
  sheetThck=1;
  
  //plate
  translate([0,backPlateDims.y/2,backPlateDims.z/2-backPlateExtBot]) difference(){
    cube(backPlateDims,true);
    if (VProfile)
      for (ix=[-1,1])
        translate([ix*backPlateDims.x/2,0,0]) 
          linear_extrude(backPlateDims.z+fudge,center=true) VSlotProfile(cut=true);
    else 
      for (ix=[-1,1], iz=[-(wheelsPerSide-1)/2:(wheelsPerSide-1)/2])
        translate([ix*backPlateDims.x/2,0,iz*wheelBoxZDist+wheelBoxZOffset])
          rotate([90,0,0]) wheelBox(backPlateThck,cutOut=true); 
      
  }
  // wheels
    if (!VProfile)
    for (ix=[-1,1], iz=[-(wheelsPerSide-1)/2:(wheelsPerSide-1)/2])
      translate([ix*(backPlateDims.x/2),backPlateDims.y/2+0.02,iz*wheelBoxZDist+backPlateDims.z/2+wheelBoxZOffset]) 
        rotate([90,0,0]) wheelBox(backPlateThck);;
  
}


module NORBERG(isRaised=true){
  //https://www.ikea.com/de/de/p/norberg-wandklapptisch-weiss-30180504/
  ovDims=[740,595,19];
  plateDepth=450; //depth of the movable part
  rot= isRaised ? 0 : 90;
  gap=1;
  
  translate([0,-(ovDims.y-plateDepth)-gap/2,-ovDims.z]) 
    rotate([rot,0,0]) translate([0,-plateDepth/2-gap/2,ovDims.z/2]) 
      cube([ovDims.x,plateDepth,ovDims.z],true);
  translate([0,-(ovDims.y-plateDepth)/2,-ovDims.z/2]) cube([ovDims.x,(ovDims.y-plateDepth),ovDims.z],true);
  
  //angle iron
  translate([0,-7,-200-ovDims.z]) rndRect([25,14,400],2,true);
  translate([0,-67/2,-400-7-ovDims.z]) rotate([90,0,0]) rndRect([25,14,67],2,true);
}

*VSlotWheel();
module VSlotWheel(cutOut=false){
  //https://openbuildspartstore.com/solid-v-wheel/
  
  outDia=23.9; //OpenBuilds: 23.9
  inDia=16; //OpenBuilds:15.947 +-0.026
  width=10.2;
  chamfer=(10.2-6)/2;
  bearing=[5,16,5]; //625 5x16x5
  
  poly=[[inDia/2,width/2],[outDia/2-chamfer,width/2],[outDia/2,width/2-chamfer],
        [outDia/2,-(width/2-chamfer)],[outDia/2-chamfer,-width/2],[inDia/2,-width/2]];
  cutPoly=[[0,width/2],[outDia/2-chamfer,width/2],[outDia/2,width/2-chamfer],
        [outDia/2,-(width/2-chamfer)],[outDia/2-chamfer,-width/2],[0,-width/2]];
  if (cutOut)
    polygon(cutPoly);
  else{
    //wheel
    color("darkSlateGrey") rotate_extrude() polygon(poly);
    //bearing
    color("silver") for (iz=[-1,1]) 
      translate([0,0,iz*(bearing.z+1)/2]) 
        difference(){
          cylinder(d=bearing[1],h=bearing.z,center=true);
          cylinder(d=bearing[0],h=bearing.z+fudge,center=true);   
        }
      }
}

*VSlotProfile(cut=false);
module VSlotProfile(size=10,thick=1,cut=false){
  //profileThck=1;
  //profileDim=10;
  xOffset=sin(45)*10;;
  a=sin(45)*11*2;
  
  if (cut)
    circle(d=a,$fn=4);
  else
  translate([xOffset,0]) mirror([1,0]) for(ir=[-45,45])
    rotate(ir) translate([(size-thick)/2,0]) square([size,thick],true);
}

*wheelBox();
module wheelBox(thick=21,ZOffset=1.5,cutOut=false){
  $fn=20;
  sheetThck=1;
  brim=4;
  wheelXOffset=8;
  gap=1;
  cutX= cutOut ? 0.1 : 0;
  cutX3D= [cutX*2, cutX*2,cutX*2]; //extra for cutting
  dblWheelDist=40;

  if (cutOut)
    body();
  else{
    difference(){
      color("darkGrey") body();
      for (iy=[-1,1]) 
        translate([-wheelXOffset,iy*dblWheelDist/2,0]){
          //bolt
          cylinder(d=5.1,h=thick+fudge,center=true);
          //M5 Nut DIN 439 is 2.7 (DIN 934 is 4) thick, S is 8 outDia=8.9
          //M6 Nut DIN 934 is 5 thick, S is 10, outDia=11.1
          translate([0,0,-(thick+fudge)/2]) cylinder(d=8.9+fudge,h=4+fudge,$fn=6);
          //wheel compartment
          compartment();
          //locking pin
        }
        //translate([fudge/2,0,0]) rotate([0,-90,0]) cylinder(d=6,h=wheelBoxDims.x+fudge);
    }
    for (iy=[-1,1]) 
        translate([-wheelXOffset,iy*dblWheelDist/2,0]){
          translate([0,0,ZOffset]) VSlotWheel();
          color("silver") translate([0,0,-thick/2]) difference(){
            cylinder(d=8.9,h=4,$fn=6);
            translate([0,0,-(fudge)/2]) cylinder(d=5,h=4+fudge);
          }
        }
    
  }//else

  //submodule body
  module body(){
    difference(){
      //body
      union(){
        rndRect([wheelBoxDims.x*2,wheelBoxDims.y,thick]+cutX3D,3,center=true); 
        for (iz=[-1,1]) //sheet
          translate([0,0,iz*(thick-sheetThck)/2]) 
            rndRect([(wheelBoxDims.x+brim)*2,(wheelBoxDims.y+brim*2),sheetThck]+cutX3D,3+brim,center=true);
      }
      //half
      translate([(wheelBoxDims.x+brim+fudge)/2+cutX*2,0,0]) 
        cube([wheelBoxDims.x+brim+fudge,wheelBoxDims.y+brim*2+fudge,thick+fudge]+cutX3D,true);
      
    }//difference
  } //submodule body

  module compartment(){
    translate([0,0,ZOffset]){
        rotate(90) rotate_extrude(angle=180) 
          difference(){
            offset(gap) VSlotWheel(true);
            translate([-6,0]) square([12,12+gap],true);
          }
        rotate([90,0,90]) linear_extrude(wheelXOffset+fudge) offset(gap)
          union(){
            VSlotWheel(true);
            mirror([1,0]) VSlotWheel(true);
          }
        }
  }
  
}

*sleeveNut();
module sleeveNut(){
    $fn=20;//https://www.amazon.de/H%C3%BClsenmuttern-Senkkopf-Innensechskant-Edelstahl-St%C3%BCck/dp/B01H3SQGN6/
  l1=12;
  l2=7;
  dk=8;
  k=1.8;
  d2=5;
  sw=2.5;
  
  color("silver") difference(){
    union(){
      cylinder(d=dk,h=0.2);
      translate([0,0,0.2]) 
        cylinder(d1=dk,d2=d2,h=k-0.2);
      translate([0,0,k]) cylinder(d=d2,h=l1-k);
    }
    translate([0,0,l1-l2]) cylinder(d=4,h=l2+fudge);
    translate([0,0,-fudge]) cylinder(d=(2/sqrt(3))*sw,h=k+fudge,$fn=6);
  }
  
}

