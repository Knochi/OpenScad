
/*[Dimensions]*/
plateDims=[237.2,224.1,4.5];//dimensions of big plates, thickness of structure incl. ribs
wallThck=2;//thickness of the wallsection
spcng=0.11; //spacing between walls
prssFit=0.03; //press Fit spacing on connectors

/* [Tongue&Groove] */
tgDist=[31.5,48];

/* [Customizer] */
variant="slots"; //["none","slots","studs"]

/* [slots] */
//slotter(sltDims=[5,15],sltDist=[40,20],sltCnt=[5,10],sltStagger=[20,0],rndSlt=true,center=false){
sltsOffset=[0,1.2];
sltsCount=[9,20];
sltsDims=[5,15];
sltsSpacing=[40,20];
sltsStagger=[20,0];
sltN=20;

/* [Studs] */
stdsOffset=[0,0];
stdsCount=[50,50];
stdsHeight=1.8;
/* [screwDomes] */

mntHoleDia=2.6;

/* [show] */
showA=true;
showB=false;
showCustom=true; //show the customizations
isolate="none"; //["none","a1","a3","a4"]

/* [Hidden] */
flankAng=atan(2.5/1); //tan(alpha)=GK/AK
fudge=0.1;
$fn=40;
 
 
 if (isolate!="none")
   !difference(){
     union(){
      if (isolate=="a1") a1(showCustom);
      if (isolate=="a3") a3(showCustom);
      if (isolate=="a4") a4(showCustom);
        
      if (showCustom && (variant=="studs")){
        intersection(){
          translate([0,0,-1.8]) linear_extrude(1.8+fudge){
            if (isolate=="a1") a1(place=true,getFootprint=true);
            if (isolate=="a3") a3(place=true,getFootprint=true);
            if (isolate=="a4") a4(place=true,getFootprint=true);
            }
          translate([stdsOffset.x,stdsOffset.y,-1.8]) linear_extrude(stdsHeight) studder(count=stdsCount,center=true);
        }
      }
     }
     if (showCustom && (variant=="slots")) 
       translate([sltsOffset.x,sltsOffset.y,-fudge/2]) linear_extrude(2.3+fudge) 
        //slotter(sltCnt=sltsCount,center=true);
       slotter(sltDims=sltsDims,sltCnt=sltsCount,sltDist=sltsSpacing,sltStagger=sltsStagger,center=true,$fn=sltN);
   }
   
if (showA)
  Asite();



//Asite (right side)
module Asite(){
  
  difference(convexity=5){
    union(){
      a1(true);
      a3(true);
      a4(true);
    }
   if (showCustom)
    translate([sltsOffset.x,sltsOffset.y,-fudge/2]) linear_extrude(2.3+fudge) 
      slotter(sltDims=sltsDims,sltCnt=sltsCount,sltDist=sltsSpacing,sltStagger=sltsStagger,center=true,$fn=sltN);
  }
}



// --- A-Site parts ---
*a1();
module a1(place=false,getFootprint=false){
  ovDims=[74.7,224.1,60.5];
  wallDims=[ovDims.x,ovDims.y,wallThck];
  crnRad=2;
  cntrOffset= place ? [-spcng-plateDims.x/2, spcng/2,0] : [0,0,0];
  
  translate(cntrOffset){    
    if (getFootprint) translate([-ovDims.x,0])#square([ovDims.x,ovDims.y]);
    else{
      //right side of P1P
      translate([-wallDims.x+crnRad,0,-2+wallThck]) cube(wallDims+[-crnRad,0,0]);
      //corner
      translate([-wallDims.x+crnRad,0,crnRad]) rotate([-90,0,0]) linear_extrude(ovDims.y) difference(){
        circle(crnRad);
        translate([0,-crnRad-fudge]) square(crnRad+fudge);
      }
      //corner stiffener
      stifDims=[1.43,4.50];
      translate([-ovDims.x+wallThck,0,wallThck+stifDims.y]) rotate([-90,0,0]) linear_extrude(ovDims.y) difference(){ 
        square(stifDims);
        translate([stifDims.x,0]) circle(stifDims.x);
      }
      //back of P1P 
      cutout=[43.34,179.1];
      rad=179.1-164.3;
      translate([-ovDims.x+wallThck,0,crnRad]) 
        difference(){
          rotate([0,-90,0]) linear_extrude(wallThck) difference(){
            square([ovDims.z-crnRad,ovDims.y]);
            translate([cutout.x-crnRad,0]){
              translate([0,-fudge]) square([cutout.x+fudge,cutout.y+fudge-rad]);
              translate([rad,cutout.y-rad]) circle(rad);
              translate([rad,0]) square([ovDims.z-cutout.x-rad+fudge,cutout.y]);
            }
          }
        translate([-1.2,cutout.y-fudge,58.5-crnRad]) cube([1.21,ovDims.y-cutout.y+fudge-wallThck/2,2.01]);
        }
      //top
      tpCutOut=[55.5,ovDims.z-21.7];
      tpRad=7;
      translate([0,ovDims.y,ovDims.z]) rotate([-90,0,180]) linear_extrude(wallThck) 
        difference(){ 
          square([ovDims.x,ovDims.z-crnRad]);
          square(tpCutOut+[-tpRad,0]);
          translate([tpCutOut.x-tpRad,tpCutOut.y-tpRad]) circle(tpRad);
          translate([tpCutOut.x-tpRad,0]) square([tpRad,tpCutOut.y-tpRad]);
      }
      //block
      blockDims=[30.1,28.8,32.4];
      translate([-ovDims.x+2,0,2]) cube(blockDims);

      //ribs
      translate([-45.1,182,2]) rotate(90) rib(size=[ovDims.y-182,5,2.5],chamfer=[1,1],tip=0);
      translate([-30.37,0,2]) rotate(90) rib(size=[ovDims.y,5,2.5],chamfer=[1,1],tip=0);
      translate([-13.5,182,2]) rotate(90) rib(size=[ovDims.y-182,5,2.5],chamfer=[1,1],tip=0);
      translate([0,0,2]) rotate(90) rib(size=[ovDims.y-5,4.5,2.5],chamfer=[0,1],tip=45);
      //tongues
      linear_extrude(plateDims.z) for(iy=[0:3])
        translate([0,iy*tgDist.y+17]) rotate(-90) tongGroove(isTongue=true);
      
    }    
  }
}



*a3();
module a3(place=false,getFootprint=false){
  domePos=[[118.18,61.2,wallThck],[117.86,198.46,wallThck]]; //center pos
  domeDims=[[14.4,10.23,6.9],[10.81,14.4,6.9]];
  domeFlanks=[[4.4,4.4,1,2.6],[0,0,4.4,4.4]];
  domeOffset=[[0,0.41],[0,0.64]];
  
  edgRibDims=[plateDims.y-5,4.5,plateDims.z-wallThck]; //length,width,height
  topRibDims=[plateDims.y-182.1,5,plateDims.z-wallThck]; //rib to the site
  topRibXPos=[33.52,63.3,97.83,145.69,178.91,209.8];

  //cutouts
  topFieldWidths=[52.8,54.8,54.8,52.8];
  topFieldPos=[6.5,
               topFieldWidths[0]+6.5+3,
               topFieldWidths[0]+topFieldWidths[1]+6.5+3*2,
               topFieldWidths[0]+topFieldWidths[1]+topFieldWidths[2]+6.5+3*3];
  cntrOffset= place ? [-plateDims.x/2      , spcng/2,0] : [0,0,0];
  
  if (getFootprint)
    translate(cntrOffset) square([plateDims.x,plateDims.y]);
  else translate(cntrOffset){  
    
    //plate
    linear_extrude(wallThck) difference(){
      square([plateDims.x,plateDims.y]);
      //grooves bottom
      for(i=[0:6])
        translate([i*tgDist.x+31.85,0]) tongGroove();
      //grooves left&right
      for(ix=[0,1],iy=[0:3]){
        rot= ix ? 90 : -90;
        translate([ix*plateDims.x,iy*tgDist.y+17]) rotate(rot) tongGroove();
      }
    }
    //top Wall
    translate([0,plateDims.y-5,0]) difference(){
      {
        cube([plateDims.x,5,21.7]);
        translate([-fudge/2,-fudge,20.2]) cube([plateDims.x+fudge,3+fudge,1.5+fudge]);
        //fields
        for (i=[0:3])
          translate([topFieldPos[i],-fudge,17.2]) 
            rotate([-90,0,0]) 
              sqFrustum([topFieldWidths[i],17.2,3+fudge],flanks=[0,0,0,6.5]);
        //corners
        translate([0,0,wallThck]) cylinder(d=4*2,h=17.2-wallThck,$fn=4);
        translate([plateDims.x,0,wallThck]) cylinder(d=4*2,h=17.2-wallThck,$fn=4);
      } 
      
    }
    
    //rib to the left
    translate([edgRibDims.y,0,wallThck]) rotate(90) rib(size=edgRibDims);
    //ribs to the top
    for (xPos=topRibXPos)
      translate([xPos,182.06,wallThck]) rotate(90) rib(size=topRibDims,chamfer=[1,1],tip=0);
    //screw Domes
    for (i=[0:len(domePos)-1])
      translate(domePos[i]) screwDome(domeDims[i],domeFlanks[i],domeOffset[i]);
    //rib in lower section
    translate([0,60.65,wallThck]) 
      rib(size=[230.57,8.5,plateDims.z-wallThck],chamfer=[0,0], tip=68);
    //block in top section
    translate([113.9,plateDims.y-5,9.8])
      cube([7.9,3,7.4]);
    //label
    translate([13.4,13.3,plateDims.z]) linear_extrude(1.4) text("A3",size=6.4,font="Arial:style=Bold");
  }
}

*a4();
module a4(place=false, getFootprint=false){
  plateDims=[237.2,224.10,1.6];//plate with minimum thickness
  cntrOffset= place ? [-plateDims.x/2      ,-spcng/2,0] : [0,0,0];
  drillPos=[[12.74,8.29],[222.66,8.29]];
  lwrBrim=[plateDims.x,18.4]; //size of the brim at the bottom
  tongOffset=31.9;
  
  if (getFootprint)
    translate(cntrOffset+[0,-plateDims.y,0]) square([plateDims.x,plateDims.y]);
  else translate(cntrOffset){
    
      
    translate([0,-plateDims.y,2-wallThck]) linear_extrude(wallThck-0.4) difference(){
      square([plateDims.x,plateDims.y]);
      for (pos=drillPos) translate(pos) circle(d=7.5);
      //left&right grooves
      for(ix=[0,1],iy=[0:3]){
        rot= ix ? 90 : -90;
        translate([ix*plateDims.x,iy*tgDist.y+16.6+tgDist.y]) rotate(rot) tongGroove();
      }
    }
    //tongues
      linear_extrude(plateDims.z) for(ix=[0:6])
        translate([ix*tgDist.x+tongOffset,0]) rotate(0) tongGroove(isTongue=true);
      
    translate([0,-plateDims.y+lwrBrim.y,plateDims.z])
      sqFrustum(size=[plateDims.x,plateDims.y-lwrBrim.y,2-plateDims.z],flanks=[0,0,0.4,0]);
    
    //ribs
    translate([0,-plateDims.y+lwrBrim.y+0.4,2]) sqFrustum(size=[4.5,plateDims.y-lwrBrim.y-0.4,4.36],flanks=[0,0.85,0,0]);
    translate([0,-plateDims.y,1.6]) sqFrustum(size=[4.52,lwrBrim.y+0.4,2.77],flanks=[0,0.54,0,0]);
    translate([30.85,-plateDims.y,plateDims.z]) cube([3,41.2,2.77]); //not sure why this has no flanks
    for (i=[0:2]) translate([i*48.3+92.83,-plateDims.y,plateDims.z])
      sqFrustum(size=[4.70,41.2,2.77],flanks=[0.85,0.85,0,0]);
    translate([221.79,-205.3,2]) cube([3.4,129.2,3.13]);
    //ramp
    rmpPoly=[[0,0],[0,-129.2],[14.07,-129.2],[3.13,0]];
    translate([62.31+3.4,-76.11,2]) rotate([0,-90,0]) linear_extrude(3.4) polygon(rmpPoly);
    for (pos=drillPos) translate([pos.x,pos.y-plateDims.y,plateDims.z]) screwDome();
      
    //label
    translate([19.1,-217.1,1.6]) linear_extrude(1.4) text("A4",size=6.4,font="Arial:style=Bold");
  }
  
  *screwDome();  
  module screwDome(){
   
    difference(){
      cylinder(d=12.2,h=2.5);
      translate([0,0,-fudge/2]) cylinder(d=3.5,h=2.5+fudge);
      translate([0,0,-fudge]) cylinder(d=7.5,h=0.9+fudge);
      translate([0,0,0.89]) cylinder(d1=7.5,d2=3.5,h=0.81);
    }
  }
}

*a5();
module a5(){
 //translate([plateDims.x/2,plateDims.y,0]) 
 //"pegboard a5a6.stl" was slightly rotated, need to compensate that with odd angle
   color("grey") rotate(89.46) translate([-942.63,-124.79,0])  import("pegboard a5.stl");
}

*a6();
module a6(){
  //"pegboard a5a6.stl" was slightly rotated, need to compensate that with odd angle
   color("grey") rotate(89.46) translate([-1163.15,-210.09,0]) import("pegboard a6.stl");
}

// --- B-Site parts ---
module b1(){
  translate([-123.89,292.85,0]) import("pegboard b1.stl");
}

*b2();
module b2(){
  translate([-209.33,69.79,0]) import("pegboard b2.stl");
}

*
*studder(center=true);
module studder(dia=4.85,count=[10,10],spacing=8,center=false){
  //a module to create studs on a surface
  //defaults to danish brick
  stdOffset=[0,0];
  cntrOffset= center ? [-(spacing*(count.x-1))/2-stdOffset.x,-(spacing*(count.y-1)-stdOffset.y)/2] :  [0,0,0];
  
  translate(cntrOffset) for (ix=[0:count.x-1],iy=[0:count.y-1]){
   //xOffset= (iy % 2) ? stdOffset.x : 0;
   //yOffset= (ix % 2) ? stdOffset.y : 0;
   *translate([ix*spacing+xOffset,iy*spacing+yOffset]) circle(d=dia);
   translate([ix*spacing,iy*spacing]) circle(d=dia);
  }
}

*slotter(sltDims=sltsDims,sltDist=sltsSpacing,sltStagger=sltsStagger,sltCnt=sltsCount,center=true);
module slotter(sltDims=[5,15],sltDist=[40,20],sltCnt=[5,10],sltStagger=[20,0],rndSlt=true,center=false){
  //a module to generate slots in custom form and arrangement
  //defaults to IKEA SKADIS
  
  cntrOffset= center ? [-(sltDist.x*(sltCnt.x-1)+sltStagger.x)/2,-(sltDist.y*(sltCnt.y-1)-sltStagger.y)/2] :  [0,0,0];
  
  translate(cntrOffset) for (ix=[0:sltCnt.x-1],iy=[0:sltCnt.y-1]){
   xOffset= (iy % 2) ? sltStagger.x : 0;
   yOffset= (ix % 2) ? sltStagger.y : 0;
   translate([ix*sltDist.x+xOffset,iy*sltDist.y+yOffset]) slot();
  }
  
  module slot(){
    if (rndSlt){
      if (sltDims.x<sltDims.y) //vertical slot
        hull() for (iy=[-1,1])
          translate([0,iy*(sltDims.y-sltDims.x)/2]) circle(d=sltDims.x);
      
      if (sltDims.x>sltDims.y) //horizontal slot
        hull() for (ix=[-1,1])
          translate([ix*(sltDims.x-sltDims.y)/2,0]) circle(d=sltDims.y);
      else //round hole
        circle(d=sltDims.x);
    }
    else
      square(sltDims,center=true);
  }
}


module tongGroove(size=[4.24,2.85],angle=14.2,isTongue=false){
  
  //tongue and groove connectors
  spcng = isTongue ? [prssFit,prssFit]:[0,0];
  constrict=tan(angle)*size.y; //tan()=AK/GK
  poly=[[-size.x/2+constrict+spcng.x,0],[size.x/2-constrict-spcng.x,0],
        [size.x/2-spcng.x,size.y-spcng.y],[-size.x/2+spcng.x,size.y-spcng.y]];
  polygon(poly);
}

*rib();
module rib(size=[100,4.5,plateDims.z-wallThck], chamfer=[1,0],tip=46.16){
  tipAng= tip ? tip : 90; //atan(2.5/(219.1-216.7))=46.16;
  tipLngth=size.z/tan(tipAng);
  length = (tip) ? size.x-tipLngth : size.x;
  poly=[[0,0],[size.y,0],[size.y-chamfer[1],size.z],[chamfer[0],size.z]];
  
  tipVerts=[[0,0,0],[0,size.y,0],[0,size.y-chamfer[1],size.z],[0,chamfer[0],size.z],[tipLngth,0,0],[tipLngth,size.y,0]];
  tipFaces=[[0,1,2,3],[0,4,3],[2,1,5],[3,2,5,4],[0,1,5,4]];
  
  rotate([90,0,90]) linear_extrude(length) polygon(poly);
  translate([length,0,0]) 
    polyhedron(tipVerts,tipFaces);
}


module screwDome(size,flanks,baseOffset){
  //screw Dome centered on the hole
  //A3 center dome
  
  frstmHght=size.z-(plateDims.z-wallThck);
  cntrOffset=[-size.x/2,-size.y/2,0]+baseOffset;

  translate(cntrOffset){
    cube([size.x,size.y,plateDims.z-wallThck]);
    translate([0,0,plateDims.z-wallThck]) difference(){
      sqFrustum([size.x,size.y,frstmHght],flanks);
      translate([size.x/2,size.y/2,-fudge/2]-baseOffset) cylinder(d=mntHoleDia,h=frstmHght+fudge);
    }
  }

}

*sqFrustum();
module sqFrustum(size=[1,1,1], flanks=[0.1,0.1,0.1,0.1], center=false, method="poly"){
  //a square frustum --> cube with a trapezoid crosssection
  //https://en.wikipedia.org/wiki/Frustum
  
  //size = base dimensions x height
  //https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
  cntrOffset= (center) ? [0,0,-size.z/2] : [size.x/2,size.y/2,size.z/2];
  //flanks= (len(flanks)==undef) ? [flanks,flanks,flanks,flanks] : flanks;
  
  //flankRed=[tan(flankAng.x)*size.z,tan(flankAng.x)*size.z]; //reduction in width by angle
  faceScale=[(size.x-(flanks[0]+flanks[1]))/size.x,(size.y-(flanks[2]+flanks[3]))/size.y]; //scale factor for linExt
  faceOffset=0; //TODO calculate faceOffset for linear_extrusion method, when flanks are different
  if (method=="linExt")
    translate(cntrOffset)
      linear_extrude(size.z,scale=faceScale)
        square([size.x,size.y],true);
  else{ //for export to FreeCAD/StepUp
    verts= [[-size.x/2,-size.y/2,-size.z/2], //0
            [ size.x/2,-size.y/2,-size.z/2], //1
            [ size.x/2, size.y/2,-size.z/2], //2
            [-size.x/2, size.y/2,-size.z/2],//3
            [-(size.x/2-flanks[0]),-(size.y/2-flanks[2]),size.z/2],  //4
            [  size.x/2-flanks[1] ,-(size.y/2-flanks[2]),size.z/2],  //5
            [  size.x/2-flanks[1] , (size.y/2-flanks[3]),size.z/2],  //5
            [-(size.x/2-flanks[0]), (size.y/2-flanks[3]),size.z/2]]; //5
    faces= [[0,1,2,3],  // bottom
            [4,5,1,0],  // front
            [7,6,5,4],  // top
            [5,6,2,1],  // right
            [6,7,3,2],  // back
            [7,4,0,3]]; // left
  translate(cntrOffset) polyhedron(verts,faces,convexity=2);
  }
}

