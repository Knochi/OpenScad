
/*[Dimensions]*/
plateDims=[237.2,224.1,4.5];//dimensions of plate, thickness of structure
wallThck=2;//thickness of the wallsection
spcng=0.11; //spacing between walls
prssFit=0.03; //press Fit spacing on connectors

/* [Tongue&Groove] */
tgDist=[31.5,48];

/* [Ribs] */

/* [slots] */
sltsOffset=[0,1.2];


/* [screwDomes] */
mntHoleDia=2.6;

/* [show] */
showCustom=false; //show the customizations


/* [Hidden] */
flankAng=atan(2.5/1); //tan(alpha)=GK/AK
fudge=0.1;
$fn=20;
 

difference(){
 a3();
 if (showCustom) 
  translate([sltsOffset.x,sltsOffset.y,-fudge/2]) 
    linear_extrude(2.3+fudge) slotter(sltCnt=[9,20],center=true);
}

module a3(){
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

  translate([-plateDims.x/2      , spcng/2,0]){
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
  }
  
}

*slotter();
module slotter(sltDims=[5,15],sltDist=[40,20],sltCnt=[5,10],sltOffset=[20,0],rndSlt=true,center=false){
  //a module to generate slots in custom form and arrangement
  //defaults to IKEA SKADIS
  
  cntrOffset= center ? [-(sltDist.x*(sltCnt.x-1)+sltOffset.x)/2,-(sltDist.y*(sltCnt.y-1)-sltOffset.y)/2] :  [0,0,0];
  
  translate(cntrOffset) for (ix=[0:sltCnt.x-1],iy=[0:sltCnt.y-1]){
   xOffset= (iy % 2) ? sltOffset.x : 0;
   yOffset= (ix % 2) ? sltOffset.y : 0;
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


