include <KiCADColors.scad>

/* Library for MPE-Garry Connectors */
fudge=0.1;

$fn=20;
col=[10,20,40];

//demo

MPE_192(6);
translate([col[0],0,0]) MPE_196(6);

translate([col[1],5,0]) text("MPE_098",size=2);
translate([col[1],0,0]) MPE_098(pins=4,variant=4);
translate([col[1],-10,0]) MPE_098(pins=6,variant=2);
translate([col[1],-20,0]) MPE_098(pins=12,variant=3);
translate([col[1],-30,0]) MPE_098(pins=6,variant=4);
translate([col[1],-40,0]) MPE_098(pins=6,variant=5);
translate([col[1],-50,0]) MPE_098(pins=12,variant=6);

translate([col[2],0,0]) MPE_087();



*MPE_006(1,10,11);
module MPE_006(rows=1, pins=10, AH=11){
  //     AH, L  
  LDict=[[ 6,5.9],
         [ 8,8],
         [ 9,9],
         [10,10.1],
         [11,11.2],    
         [12,11.9],
         [15,15],
         [22,22]];
  dTip=0.52;
  lTip=3;
  dSpcr=0.625;
  dTop=0.9;
  lTop=4.2;
  dFlng=1.6;//the part that is visible from above
  lFlng=0.7;
  dDrill=0.7;
  lDrill=3.7;
  lCntc=2.4;
  bdyHght=2.8;
  
  pick = search(AH,LDict);
  L=LDict[pick[0]][1];
  echo(pick);
  for (ix=[0:pins-1])
    translate([ix*2.54,0,0]){
      pin();
      translate([0,0,L-bdyHght]) body();
    }
  
  module body(ri=2.54/2){
    ro=2/sqrt(3)*ri;
    color(blackBodyCol) linear_extrude(2.8) difference(){
      circle(r=ro,$fn=6);
      circle(d=dFlng);
    }
  }
  module pin(){
    difference(){
      union(){
        color(metalGoldPinCol) translate([0,0,-(lTip-dTip/2)]){
          cylinder(d=dTip,h=lTip-dTip/2);
          sphere(d=dTip);
        }
        color(metalGoldPinCol) cylinder(d1=dTip,d2=dSpcr,h=(dSpcr-dTip)/2);
        color(metalGoldPinCol) translate([0,0,(dSpcr-dTip)/2]) cylinder(d=dSpcr,h=L-(dSpcr-dTip)/2);
        color(metalGoldPinCol) translate([0,0,L-lTop]) cylinder(d1=dSpcr,d2=dTop,h=(dTop-dSpcr)/2);
        color(metalGoldPinCol) translate([0,0,L-lTop+(dTop-dSpcr)/2]) cylinder(d=dTop,h=lTop-(dTop-dSpcr)/2);
        color(metalGoldPinCol) translate([0,0,L-lFlng]) cylinder(d=dFlng,h=lFlng);
      }
      color(metalGoldPinCol) translate([0,0,L-lDrill]) cylinder(d=dDrill,h=lDrill+fudge);
    }
  }
  
  
};


*MPE_087(rows=1,pins=4,A=11.3,center=true);
module MPE_087(rows=2, pins=6, A=19.8,markPin1=true, center=false){
  //       A   ,  B  ,   C , L // overall Length, above body, below body, body
  Ldict=[[10.20, 5.20, 2.50, 2.50],
        [11.30, 5.50, 3.30, 2.50],
        [10.80, 5.80, 2.50, 2.50],
        [12.60, 6.80, 3.30, 2.50],
        [13.90, 8.20, 3.30, 2.50],
        [14.70, 9.00, 3.30, 2.50],
        [16.50, 10.70, 3.30, 2.50],
        [17.70, 12.10, 3.30, 2.50],
        [19.80, 14.00, 3.30, 2.50],
        [21.60, 15.80, 3.30, 2.50],
        [22.80, 17.00, 3.30, 2.50],
        [24.90, 19.10, 3.30, 2.50],
        [10.00, 6.00, 2.50, 1.50],
        [10.60, 6.60, 2.50, 1.50],
        [11.10, 6.30, 3.30, 1.50],
        [13.80, 9.00, 3.30, 1.50],
        [14.30, 9.50, 3.30, 1.50],
        [14.60, 9.80, 3.30, 1.50],
        [16.80, 12.00, 3.30, 1.50],
        [19.60, 14.80, 3.30, 1.50],
        [21.40, 16.60, 3.30, 1.50],
        [22.60, 17.80, 3.30, 1.50],
        [24.70, 19.90, 3.30, 1.50]];
        
  pick=search(A,Ldict);
  
  L= (pick) ? Ldict[pick[0]][3] : 2.5;
  B= (pick) ? Ldict[pick[0]][1] : 5.2;
  C= (pick) ? Ldict[pick[0]][2] : 2.5;
  
  pitch=2.54;
  cntrOffset= center ? [-(pins/rows-1)/2*pitch,(rows-1)*-pitch/2,0] : [0,0,0];  
  //pins
  for (ix=[0:pins/rows-1],iy=[0:rows-1]){
    pinNo=(ix*rows+1)+iy;
    pinCol= ((pinNo==1)&&markPin1) ? redBodyCol : metalGoldPinCol;
    translate([ix*pitch,iy*pitch,-C]+cntrOffset) 
      color(pinCol) squarePin(size=0.64, length=A,center=false);
    //squarePin(size=0.64,length=10,center=false){
  }
  color(blackBodyCol) 
    linear_extrude(L){ 
      for (ix=[0:pins/rows-1],iy=[0:rows-1])
        translate([ix*pitch,iy*pitch,0]+cntrOffset) octagon();
      if (rows>1)//fill the gaps
        square([(pins/rows-1)*pitch,(rows-1)*pitch],center);
    }
}

*MPE_204();
module MPE_204(pins=6,variant=1,center=false){
  //MPW Garry 1.27mm pitch horizontal female header Series 204
  bdDims=[4.1,pins*1.27+0.41,2.2];
  cntrOffset = 1;
  pinDia=0.44;
  holeDia=0.51;
  pinLngth=3; //Lngth under PCB
  rad=0.5;
  bdOffset=[-4.1+5.3,-bdDims.y+(0.41+1.27)/2,0];
  //body
  difference(){
    color(blackBodyCol) translate(bdOffset) cube(bdDims);
    color(blackBodyCol) translate(bdOffset+[-fudge,-fudge/2,(bdDims.z-1.7)/2]) 
      cube([0.3+fudge,bdDims.y+fudge,1.7]);
    for (iy=[0:pins-1])
      color(blackBodyCol) translate([bdOffset.x,iy*-1.27,bdDims.z/2])
        rotate([0,90,0]){ 
          cylinder(d=holeDia,h=bdDims.x+fudge);
          translate([0,0,bdDims.x-(1-holeDia)/2+fudge]) cylinder(d2=1+fudge*2,d1=holeDia,h=(1-holeDia+fudge)/2);
      }
  }
  
  for (iy=[0:pins-1])
    translate([0,iy*-1.27,0]) pin();
  
  module pin(){
    color(metalGoldPinCol) translate([0,0,-pinLngth+pinDia/2]){
      sphere(d=pinDia);
      cylinder(d=pinDia,h=pinLngth+bdDims.z/2-rad-pinDia/2);
    }
    color(metalGoldPinCol) translate([rad,0,bdDims.z/2-rad]) 
      rotate([90,0,180]) rotate_extrude(angle=90) translate([rad,0,0]) circle(d=pinDia);
    color(metalGoldPinCol) translate([rad,0,bdDims.z/2]) rotate([0,90,0]) cylinder(d=pinDia,h=bdOffset.x+0.3-rad);
    color(metalGoldPinCol) translate([bdOffset.x+0.3,0,bdDims.z/2]) rotate([0,-90,0]) cylinder(d2=pinDia,d1=1,h=(1-pinDia)/2);
  }
  
}

module MPE_192(pins,cntrX=false,diff="none"){
  
  pinDia=0.41;
  drill=0.65;
  
  bdyWdth=pins*1.27+0.41;
  bdyHght=2.2;
  bdyDpth=2.2;
  
  cntrOffset = cntrX ? [-bdyWdth/2,0,0] : [-(1.27+0.41)/2,-3.4,0];
  
  translate(cntrOffset){
  if (diff=="none"){
   
      color(blackBodyCol) cube([bdyWdth,bdyDpth,bdyHght]);
      for (i=[(1.27+0.41)/2:1.27:pins*1.27]){//pins
        color(metalGoldPinCol) union(){
          translate([i,3.4,bdyHght/2]) rotate([90,0,0]) cylinder(h=6.4,d=pinDia);//horizontal
          translate([i,3.4,bdyHght/2]) rotate([180,0,0]) cylinder(h=3+bdyHght/2,d=pinDia); //vertical
          translate([i,3.4,bdyHght/2]) rotate([90,0,0]) sphere(d=pinDia);
          translate([i,-3,bdyHght/2]) rotate([90,0,0]) sphere(d=pinDia);
          translate([i,3.4,-3]) rotate([90,0,0]) sphere(d=pinDia); 
        }
      }
    }//if
  else {
    for (i=[(1.27+0.41)/2:1.27:pins*1.27]){//drills
      translate([i,3.4,-3+fudge/2]) cylinder(h=3+fudge,d=drill); //vertical
    }
  }
  }
}

//!MPE_196(28);
module MPE_196(pins,cntrX=false,diff="none"){
  
  pinDia=0.41;
  drill=0.65;
  
  bdyWdth=pins*1.27+0.41;
  bdyHght=2.2;
  bdyDpth=2.2;
  
  cntrOffset = cntrX ? [-bdyWdth/2,0,0] : [-(1.27+0.41)/2,-3.4,0];
  
  translate(cntrOffset){
  if (diff=="none"){
   
      color(blackBodyCol) cube([bdyWdth,bdyDpth,bdyHght]);
      for (i=[(1.27+0.41)/2:1.27:pins*1.27]){//pins
        color(metalGoldPinCol) union(){
          translate([i,3.4-0.7,bdyHght/2]) rotate([90,0,0]) cylinder(h=6.4-0.7,d=pinDia);//horizontal
          translate([i,2.2+4.7-3.6,pinDia/2]) rotate([-90,0,0]) cylinder(h=3.6,d=pinDia); //solderpart
          
          translate([i,-3,bdyHght/2])  sphere(d=pinDia); //front sphere
          hull(){
            translate([i,2.7,bdyHght/2])  sphere(d=pinDia); //upper sphere
            translate([i,2.2+4.7-3.6,pinDia/2])  sphere(d=pinDia); //bottom sphere
          }
          translate([i,2.2+4.7,pinDia/2]) sphere(d=pinDia); //back spehre
        }
      }
    }//if
  else {
    for (i=[(1.27+0.41)/2:1.27:pins*1.27]){//drills
      translate([i,3.4,-3+fudge/2]) cylinder(h=3+fudge,d=drill); //vertical
    }
  }
  }
}

*MPE_094(16,1,center=false);
module MPE_094(pins, rows=2, center=false, diff="none", thick=8.5){ //receptable housing
  //dual row, SMD
  holeX=0.7;
  holeY=0.7;
  drill=1.02;
  
  cntrOffset = center ? [-pins/rows/2*2.54,-rows*1.25,0] : [-1.27,-1.25,0];
  //cntrOffset=[0,0,0];
  pinWdth=0.64;
  pinLen=3.1;
  
  translate(cntrOffset){
    
    if (diff=="housing"){
      translate([-fudge/2,-fudge/2,0]) cube([2.54*(pins/2)+0.5+fudge,5.08+fudge,thick]);
    }
    
    else if (diff=="drill") {
      for (i=[0:2.54:(pins/2-1)*2.54],j=[1.27,1.27+2.54]){
          translate([i+1.27+0.25-holeX/2,j-0.2,-pinLen]) cylinder(h=pinLen, d=1.1);
        }
    }
    else if (diff=="pins"){
      translate([pins/4*2.54+0.25,2.54,-matThck+fudge/2]) rndRect(2.54*pins/2,5.08,thick,1.27,0);
    }
    else {
      //body     
      difference(){
        color(blackBodyCol) cube([2.54*((pins/rows-1)+1),rows*2.5,8.5]);
        for (i=[0:2.54:(pins/rows-1)*2.54],j=[0:2.54:(rows-1)*2.54]){
          translate([i+1.27-holeX/2,1.25+j-holeY/2,-fudge/2+2]) cube([holeX,holeY,6.5+fudge]);
        }
      }
      //pins
      color(metalGoldPinCol)
        for (i=[0:2.54:(pins/rows-1)*2.54],j=[0:2.54:(rows-1)*2.54]){
          translate([i+1.27-holeX/2,1.25+j,-pinLen]) cube([pinWdth,0.4,pinLen]);
        }
    }//else
  }
}



*rotate(-90) MPE_098(20,3,true,center=true);

module MPE_098(pins,variant=1,peg=false,diff="none",center=false){
  //-- variations --
  //single row, low profile (3.7mm)      - 1,2 (Pin Layout 1,2)
  //dual row, low profile                - 3
  //single row, standard profile (7.5mm) - 4,5 (Pin Layout 1,2) 
  //dual row, standard profile           - 6
  
  rows = ((variant == 3)||(variant==6)) ? 2 : 1;
  bdHght = (variant>=4) && (variant<=6) ? 7.5 : 3.5;
  
  
  cntrOffset = center ? [-pins/(2*rows)*2.54,-1.25*rows,0] : [-1.27,-1.25,0];

  holeX=0.9;
  holeY=0.9;
  drill=1.2;
  frstm=1.7;
  gap= (rows>1) ? 4.4 : 1.7;
  pegDist=(pins/2-2)*2.54;
  
  pinWdth=0.64;
  pinLen= (rows>1) ? (4.65-holeX)/2 : (4.5-holeX)/2;
  
  translate(cntrOffset){
    if (diff=="none"){
      difference(){
        color(blackBodyCol) translate([0,0,0.2]) cube([pins*2.54/rows,2.5*rows,bdHght]);
        color(blackBodyCol) translate([-fudge/2,((2.5*rows)-gap)/2,0]) cube([pins*2.54/rows+fudge,gap,0.5]);
        
        if (rows==1){
          for (i=[0:2.54:(pins-1)*2.54]){
            color(blackBodyCol) translate([i+1.27,1.25,(bdHght+0.2-fudge)/2+0.2]) cube([holeX,holeY,bdHght+0.2],true);
            translate([i+1.27,1.25,bdHght]) mirror([0,0,1]) frustum([frstm+fudge,frstm+fudge,0.6],45);
            }
        }
        else {
          for (r=[-1.27,+1.27]){ //row
            for (c=[0:2.54:(pins-1)/2*2.54]){ //column
              color(blackBodyCol) translate([c+1.27,2.5+r,(bdHght+0.2-fudge)/2+0.2]) cube([holeX,holeY,bdHght+0.2],true);
              translate([c+1.27,2.5+r,bdHght]) mirror([0,0,1]) frustum([frstm+fudge,frstm+fudge,0.6],45);
            }
          }
        }
      
      }//difference
      
      //pins
      if (rows == 1){
        
        for (i=[0:2.54*2:(pins-1)*2.54]){
          translate([i-pinWdth/2+1.27,1.25+holeY/2,0]) pin();
        }
        color(metalGoldPinCol)
        for (i=[2.54:2.54*2:(pins-1)*2.54]){
          translate([i-pinWdth/2+1.27,+1.25-holeY/2,0]) mirror([0,1,0]) pin();
        }
      }
      else{ //two rows
        color(metalGoldPinCol)
        for (ix=[0:2.54:(pins-1)*2.54/2],iy=[-1,1]){
            translate([ix-pinWdth/2+1.27,2.5+iy*(+1.27+holeY/2),0]) mirror([0,1-iy,0]) pin(); //cube([pinWdth,pinLen,0.2]);
          }
        
      }
      //pegs
      if ((peg)&&(rows>1))
        for (ix=[2.54,2.54+pegDist]){
          color(blackBodyCol) translate([ix,2.54,-0.8]) cylinder(d=1.6,h=1.3);
        color(blackBodyCol) translate([ix,2.54,-1.1]) cylinder(d1=1.6-0.3,d2=1.6,h=0.3);
        }
    } // none
    
    else if (diff=="drill"){
      for (i=[0:2.54:(pins-1)*2.54]){
          #translate([i+1.27,1.25,-thick+fudge/2]) cylinder(h=thick,d=drill);
      }
    }// if drill
  }
  
  module pin(){
    rad=0.5;
    //cube([pinWdth,pinLen,0.2]);
    color(metalGoldPinCol) translate([0,0,rad]) rotate([-90,0,0]) bend([pinWdth,pinLen,0.2],90,rad) cube([pinWdth,pinLen-rad,0.2]);
  }
}


// ---- helpers ---

// bend modifier
// bends an child object along the x-axis
// size: size of the child object to be bend
// angle: angle to bend the object, negative angles bend down
// radius: bend radius, if center= false is measured on the outer if center=true is measured on the mid
// center=true: bend relative to the childrens center
// center=false: bend relative to the childrens lower left edge
// flatten: calculates only the stretched length of the bend and adds a cube accordingly


module bend(size=[50,20,2],angle=45,radius=10,center=false, flatten=false){
  alpha=angle*PI/180; //convert in RAD
  strLngth=abs(radius*alpha);
  i = (angle<0) ? -1 : 1;


  bendOffset1= (center) ? [-size.z/2,0,0] : [-size.z,0,0];
  bendOffset2= (center) ? [0,0,-size.x/2] : [size.z/2,0,-size.x/2];
  bendOffset3= (center) ? [0,0,0] : [size.x/2,0,size.z/2];

  childOffset1= (center) ? [0,size.y/2,0] : [0,0,size.z/2*i-size.z/2];
  childOffset2= (angle<0 && !center) ? [0,0,size.z] : [0,0,0]; //check

  flatOffsetChld= (center) ? [0,size.y/2+strLngth,0] : [0,strLngth,0];
  flatOffsetCb= (center) ? [0,strLngth/2,0] : [0,0,0];

  angle=abs(angle);

  if (flatten){
    translate(flatOffsetChld) children();
    translate(flatOffsetCb) cube([size.x,strLngth,size.z],center);
  }
  else{
    //move child objects
    translate([0,0,i*radius]+childOffset2) //checked for cntr+/-, cntrN+
      rotate([i*angle,0,0])
      translate([0,0,i*-radius]+childOffset1) //check
        children(0);
    //create bend object

    translate(bendOffset3) //checked for cntr+/-, cntrN+/-
      rotate([0,i*90,0]) //re-orientate bend
       translate([-radius,0,0]+bendOffset2)
        rotate_extrude(angle=angle)
          translate([radius,0,0]+bendOffset1) square([size.z,size.x]);
  }
}

*frustum([3,2,0.9],method="poly");
module frustum(size=[1,1,1], flankAng=5, center=false, method="poly", col=blackBodyCol){
  //cube with a trapezoid crosssection
  //https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
  cntrOffset= (center) ? [0,0,-size.z/2] : [size.x/2,size.y/2,0];

  flankRed=tan(flankAng)*size.z; //reduction in width by angle
  faceScale=[(size.x-flankRed*2)/size.x,(size.y-flankRed*2)/size.y]; //scale factor for linExt method only

  if (method=="linExt")
    translate(cntrOffset)
      linear_extrude(size.z,scale=faceScale)
        square([size.x,size.y],true);
  else{ //for export to FreeCAD/StepUp
    polys= [[-size.x/2,-size.y/2,-size.z/2], //0
            [ size.x/2,-size.y/2,-size.z/2], //1
            [ size.x/2, size.y/2,-size.z/2], //2
            [-size.x/2, size.y/2,-size.z/2],//3
            [-(size.x/2-flankRed),-(size.y/2-flankRed),size.z/2], //4
            [  size.x/2-flankRed ,-(size.y/2-flankRed),size.z/2], //5
            [  size.x/2-flankRed , (size.y/2-flankRed),size.z/2], //5
            [-(size.x/2-flankRed), (size.y/2-flankRed),size.z/2]]; //5
    faces= [[0,1,2,3],  // bottom
            [4,5,1,0],  // front
            [7,6,5,4],  // top
            [5,6,2,1],  // right
            [6,7,3,2],  // back
            [7,4,0,3]]; // left
   color(col) polyhedron(polys,faces,convexity=2);
  }
}

*octagon();
module octagon(size=2.54){
  //isolator octagon 2D shape
  poly=[[-size/2,size/4],[-size/3,size/2],
        [size/3,size/2],[size/2,size/4],
        [size/2,-0.635],[size/3,-size/2],
        [-size/3,-size/2],[-size/2,-size/4]];
  polygon(poly);
}

*squarePin(center=true);
module squarePin(size=0.64,length=10,center=false){
  cntrOffset= center ? 0 : length/2;
  
  translate([0,0,cntrOffset]){
    translate([0,0,-(length-size)/2]) mirror([0,0,1]) pyramid();
    translate([0,0,0]) cube([size,size,length-size],true);
    translate([0,0,(length-size)/2]) pyramid();
  }
  
  module pyramid(){
    polyhedron([[size/2,size/2,0], //0
                      [size/2,-size/2,0], //1
                      [-size/2,-size/2,0], //2
                      [-size/2,size/2,0], //3
                      [0,0,size/2]], //4
                     [[0,1,2,3],[0,1,4],[1,2,4],[2,3,4],[3,0,4]]);
  }
}
