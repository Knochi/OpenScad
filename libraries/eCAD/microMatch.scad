
/* [Config] */
positions = 10; //[4,6,8,10,12,14,16,18,20,22,24,26]
sideEntry = true;
export = "none"; //["none","body","layer.prod"]

/* [Hidden] */
$fn=50;
fudge=0.1;

// -- Kicad diffuse colors --
ledAlpha=0.1;
glassAlpha=0.39;
metalGreyPinCol=    [0.824, 0.820,  0.781];
metalGreyCol=       [0.298, 0.298,  0.298]; //metal Grey
metalCopperCol=     [0.7038,0.27048,0.0828]; //metal Copper
metalAluminiumCol=  [0.372322, 0.371574, 0.373173];
metalBronzeCol=     [0.714, 0.4284, 0.18144];
metalSilverCol=     [0.50754, 0.50754, 0.50754];
resblackBodyCol=    [0.082, 0.086,  0.094]; //resistor black body
darkGreyBodyCol=    [0.273, 0.273,  0.273]; //dark grey body
brownBodyCol=       [0.379, 0.270,  0.215]; //brown Body
lightBrownBodyCol=  [0.883, 0.711,  0.492]; //light brown body
pinkBodyCol=        [0.578, 0.336,  0.352]; //pink body
blueBodyCol=        [0.137, 0.402,  0.727]; //blue body
greenBodyCol=       [0.340, 0.680,  0.445]; //green body
orangeBodyCol=      [0.809, 0.426,  0.148]; //orange body
redBodyCol=         [0.700, 0.100,  0.050]; 
yellowBodyCol=      [0.832, 0.680,  0.066];
whiteBodyCol=       [0.895, 0.891,  0.813];
metalGoldPinCol=    [0.859, 0.738,  0.496];
blackBodyCol=       [0.148, 0.145,  0.145];
greyBodyCol=        [0.250, 0.262,  0.281];
lightBrownLabelCol= [0.691, 0.664,  0.598];
ledBlueCol=         [0.700, 0.100,  0.050, ledAlpha];
ledYellowCol=       [0.100, 0.250,  0.700, ledAlpha];
ledGreyCol=         [0.98,  0.840,  0.066, ledAlpha];
ledWhiteCol=        [0.895, 0.891, 0.813, ledAlpha];
ledgreyCol=         [0.27, 0.25, 0.27, ledAlpha];
ledBlackCol=        [0.1, 0.05, 0.1];
ledGreenCol=        [0.400, 0.700,  0.150, ledAlpha];
glassGreyCol=       [0.400769, 0.441922, 0.459091, glassAlpha];
glassGoldCol=       [0.566681, 0.580872, 0.580874, glassAlpha];
glassBlueCol=       [0.000000, 0.631244, 0.748016, glassAlpha];
glassGreenCol=      [0.000000, 0.75, 0.44, glassAlpha];
glassOrangeCol=     [0.75, 0.44, 0.000000, glassAlpha];
pcbGreenCol=        [0.07,  0.3,    0.12]; //pcb green
pcbBlackCol=        [0.16,  0.16,   0.16]; //pcb black
pcbBlue=            [0.07,  0.12,   0.3];
FR4darkCol=         [0.2,   0.17,   0.087]; //?
FR4Col=             [0.43,  0.46,   0.295]; //?


microMatch(positions, sideEntry);
module microMatch(pos=10, sideEntry=true, THT=true){
  // TE Micro-Match connector line (also available from other manufacturers)
  // https://www.te.com/usa-en/products/connectors/pcb-connectors/wire-to-board-connectors/ffc-fpc-ribbon-connectors/intersection/micro-match.html
  pitch=1.27;
  bdOffset = sideEntry ? [0,-2.63,5.8-2.5] : [0,0,5.25];
  bdRot = sideEntry ? [90,0,0] : [0,0,0];
  pin1Offset = (sideEntry || THT) ? [-(pos-1)/2*pitch,-pitch,0] : [0,0,0];
  pin1Rot = (sideEntry || THT) ? [0,0,90] : [0,0,0];
  // KLC footprint Layer specification https://klc.kicad.org/footprint/f5/
  silkLineWdth=0.12;
  prodLineWdth=0.1;
  courtLineWdth=0.05;
  courtClearance=0.5;
  //pins
  pinThck=0.25;

  //the flanked part for female
  tpFace=[pos*pitch+0.53,3.85]; 
  tpFlankAngle=2.5; 

  //collar
  collarDims=[pos*pitch+1.93,5,1.6];
  keying=[0.7,2.5];
  cutOutDims=[1.7,(collarDims.y-tpFace.y)/2+fudge,0.9];


  if (export=="layer.prod")
    !rotate(pin1Rot) translate(pin1Offset) prdLayer();
  if (export=="layer.silk")
    !rotate(pin1Rot) translate(pin1Offset) offset(delta=(prodLineWdth+silkLineWdth)/2) prdLayer();
  if (export=="layer.courtyard")
    !rotate(pin1Rot) translate(pin1Offset) offset(delta=courtClearance) prdLayer(false);

  rotate(pin1Rot) translate(pin1Offset){
    //exports for layers, if "none" show them all
    if (export=="none"){
      color("grey") linear_extrude(0.1) 
        strokeOffset(prodLineWdth) prdLayer();
      color("cyan") linear_extrude(0.1) 
        strokeOffset(silkLineWdth,(prodLineWdth+silkLineWdth)/2) prdLayer();
      color("pink") linear_extrude(0.1)
        strokeOffset(courtLineWdth,courtClearance) prdLayer(false);
    }

    translate(bdOffset) rotate(bdRot) body();
    
    //pins
    if (sideEntry) for (ix=[0:(pos-1)]){
      if (ix%2) color(metalSilverCol) //back row
        translate([ix*pitch-(pos-1)/2*pitch,0,0]){
          rotate([90,0,90]){
            translate([0,0,-pinThck/2]) pinTHTlow();
            if ((ix+1)%4) //sequential contacts have opposite kink directions
              translate([pitch,-0.15,0]) pinKink();
            else
              translate([pitch,-0.15,0]) rotate([0,180,0]) pinKink();
          }
        }
      else color(metalSilverCol) //fron row
        translate([ix*pitch-(pos-1)/2*pitch,0,0]) 
          rotate([90,0,90]){
            translate([0,0,-pinThck/2]) pinTHThigh();
          if ((ix)%4) //sequential contacts have opposite kink directions
              translate([-pitch,-0.15,0]) pinKink();
            else
              translate([-pitch,-0.15,0]) rotate([0,180,0]) pinKink();
          }
    }
      
    else for (ix=[0:(pos-1)]){
      pinRot= (ix%2) ? -1 : 1 ;
      color(metalSilverCol) translate([ix*pitch-(pos-1)/2*pitch,0,0]) rotate([90,0,pinRot*90]) translate([0,0,-pinThck/2]) pinSMD();
    }
  }
  

  module body(){
    bdyHght=5;
    tpHght=3.5; //top Part Height incl. collar
    btFace=[tpFace.x,tan(tpFlankAngle)*tpHght*2+tpFace.y];
    //body with flank angle and contact holes
    //translate([0,0,-tpHght/2+ovHght]) difference(){
    translate([0,0,-tpHght/2]) difference(){
      frustum(size=[btFace.x,btFace.y,tpHght], flankAng=[0,tpFlankAngle], center=true, method="poly", col=redBodyCol);
      stagger(pos=pos,pitch=[2.54,-1.5]) color(redBodyCol) translate([0,0,tpHght/2-0.5]) linear_extrude(0.5+fudge) cross2D();
    }

    //collar
    collar();

    //base with V-Slot
    baseDims=[tpFace.x+(collarDims.x-tpFace.x)/2,3,1.5];
    basePoly=[[baseDims.y/2,baseDims.z],[baseDims.y/2,0],[baseDims.y/2-0.43,0],[baseDims.y/2-0.43,0.1],[baseDims.y/2-0.95,1],
              [-(baseDims.y/2-0.95),1],[-(baseDims.y/2-0.43),0.1],[-(baseDims.y/2-0.43),0],[-baseDims.y/2,0],[-baseDims.y/2,baseDims.z]];
    
    translate([-collarDims.x/2,0,-baseDims.z-tpHght]) 
      rotate([90,0,90]) color(redBodyCol) linear_extrude(baseDims.x) polygon(basePoly);

    module collar(){
      //translate([0,0,collarDims.z/2+ovHght-tpHght]) difference(){
        translate([0,0,+collarDims.z/2-tpHght]) difference(){
        color(redBodyCol) cube(collarDims,true);
        color(redBodyCol) translate([(collarDims.x-keying.x+fudge)/2,0,0]) cube([keying.x+fudge,keying.y,collarDims.z+fudge],true);
        //staggered cutouts in collar
        //TODO: add fillets (r~0.25mm)
      translate([0,0,(collarDims.z-cutOutDims.z+fudge)/2]) 
        stagger(pos=pos,pitch=[pitch*2,collarDims.y-cutOutDims.y],stagger=(pitch+0.1)) color(redBodyCol)  cube(cutOutDims+[0,fudge,fudge],true);
      } 
    }

    module cross2D(){
      ovDims=[0.85,1.5,0.5];
      barWdth=[0.4,0.6];
      square([ovDims.x,barWdth.y],true);
      square([barWdth.x,ovDims.y],true);
    }
  }

  // -- SMD pin traced from datasheet --
  *pinSMD();
  module pinSMD(){
    poly=concat(push_arc([3.26,0],[3.53,0.28],0.3,0),
                push_arc([3.51,0.62],[3.36,0.76],0.15,0),
                push_arc([2.88,0.76],[2.73,0.91],0.15,1),
                push_arc([-0.63,0.95],[-0.64,1.25],0.15,1),
                push_arc([-1.82,1.92],[-1.96,1.56],0.5,1),
                push_arc([-2.63,0.9],[-2.69,0.76],0.15,0),
                [[-2.69,0.34],[-2.08,0.34]],
                push_arc([-2.08,0.39],[-1.79,0.39],0.15,1),
                push_arc([-1.77,0.31],[-1.62,0.2],0.15,0),
                push_arc([-1.17,0.2],[-1.03,0.31],0.15,0),
                push_arc([-1.0,0.39],[-0.72,0.4],0.15,1),
                push_arc([-0.68,0.31],[-0.53,0.21],0.15,0),
                push_arc([0.93,0.32],[1.04,0.29],0.15,1),
                push_arc([1.3,0.06],[1.4,0.02],0.15,0)
                );
    linear_extrude(pinThck) polygon(poly);
  }
  
  module pinTHThigh(){
    poly=concat([[-2.32,0]],
                push_arc([-pitch-0.5/2-0.15,0],[-pitch-0.5/2,-0.15],0.15,1),
                push_arc([-pitch+0.5/2,-0.15],[-pitch+0.5/2+0.15,0],0.15,1),
                push_arc([2.12,0],[2.33,0.2],0.2,0),
                push_arc([2.33,0.46],[2.53,0.66],0.2,1),
                push_arc([2.53,1.3],[2.33,1.5],0.2,1),
                push_arc([2.33,3.01],[2.53,3.22],0.2,1),
                push_arc([2.53,3.8],[2.33,4],0.2,0),
                push_arc([1.97,4],[1.72,3.75],0.25,0),
                push_arc([1.72,2.6],[1.42,2.59],0.15,1),
                [[1.32,3.46],[0.92,1.19]],
                push_arc([0.92,0.77],[0.72,0.56],0.2,1),
                [[-2.06,0.56]],
                push_arc([-2.22,0.47],[-2.32,0.29],0.2,0)
                );
    linear_extrude(pinThck) polygon(poly);
  }

  *pinTHThigh();
  module pinTHTlow(){
    poly=concat([[pitch-0.5/2,0.51],[pitch-0.5/2,-0.15]], 
                push_arc([pitch+0.5/2,-0.15],[pitch+0.5/2+0.15,0],0.15,1),
                push_arc([2.12,0],[2.33,0.2],0.2,0),
                push_arc([2.33,0.46],[2.53,0.66],0.2,1),
                push_arc([2.53,1.3],[2.33,1.5],0.2,1),
                push_arc([2.33,3.01],[2.53,3.22],0.2,1),
                push_arc([2.53,4],[2.33,4.2],0.2,1),
                push_arc([2.33,5.03],[2.13,5.24],0.2,0),
                push_arc([1.28,5.24],[1.18,5.21],0.2,0),
                push_arc([1.02,5.11],[0.92,5.08],0.2,1),
                [[0.82,5.08],[1.32,3.02]],
                push_arc([1.42,3.92],[1.72,3.92],0.15,1),
                push_arc([1.72,1.35],[1.63,1.14],0.3,1)
                );
    linear_extrude(pinThck) polygon(poly);
  }

  *pinKink();
  module pinKink(){
    kinkRad=0.525;
    kinkAng=60;
    rotate([180,0,0]){
      translate([0,0.31/2,0]) color(metalSilverCol) cube([0.5,0.31,pinThck],true);
      translate([0,0.31,0]) color(metalSilverCol)
        bend(size=[0.5,0.24,pinThck],angle=-35.8,radius=kinkRad,center=true){
          cube([0.5,0.24,pinThck],true);
          bend(size=[0.5,0.38,pinThck],angle=66.51,radius=kinkRad,center=true){
            cube([0.5,0.38,pinThck],true);
            bend(size=[0.5,0.68,pinThck],angle=-30.66,radius=kinkRad,center=true){
              cube([0.5,0.68,pinThck],true);
              translate([0,0.39/2,0]) cube([0.5,0.39,pinThck],true);
              translate([0,0.39+0.11/2,0]) rotate([-90,0,0]) 
                frustum(size=[0.5,pinThck,0.11], flankAng=[40,40], center=false, method="poly", col=metalSilverCol);
            }
          }
        }
    }
  }

  //submodule for layers
  module prdLayer(marker=true){
    projection() translate(bdOffset) rotate(bdRot) body();
    if (marker) translate(-pin1Offset+[0,pitch+0.8]) rotate(-90) circle(d=1.27,$fn=3);
  }
}

// --- Helpers ---

//create offset stroke from shapt
module strokeOffset(strkWdth=0.1, offset=0){
   difference(){
          offset(strkWdth/2) offset(delta=offset) children();
          offset(-strkWdth/2) offset(delta=offset) children();
        }
}

//arc function simlar to svg path command "a/A" (https://www.w3.org/TR/SVG11/paths.html#PathData)
function push_arc(start, end, r, sweep=1, poly=[], iter=0)=let(
  chord = norm(start-end),
  r = (r<chord/2) ? chord/2 : r, //limit the radius to half the chord length, doesn't work
  cc = c_centers(start,end,r),
  center=cc[sweep],
  dir = sweep ? -1 : 1,
  //calulate start and end angle with atan2 to address all quadrants
  sa = atan2(start.y-center.y,start.x-center.x), //atan2(y/x) 
  ea = atan2(end.y-center.y,end.x-center.x), //atan2(y/x) 
  u= center-start,
  v= center-end,
  angle = acos(u * v / (norm(u)*norm(v))),
  facets= arcFragments(r,abs(angle)), //total facets
  angInc=(dir*angle)/(facets-1),
  x = center.x+r*cos(sa+angInc*iter),
  y = center.y+r*sin(sa+angInc*iter)
  ) (iter<facets) ? push_arc(start,end,r, sweep, poly=concat(poly,[[x,y]]),iter=iter+1) : 
    poly;


//Calculate fragments from r, angle and $fn, $fr or $fa 
//from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features
function arcFragments(r,angle)=
  let(
    cirFrac=360/angle, //fraction of angle
    frgFrmFn= floor($fn/cirFrac), //fragments for arc calculated from fn
    minFrag=3 //minimum Fragments
  ) ($fn>minFrag) ? ceil(max(frgFrmFn,minFrag)+1) : ceil(max(min(angle/$fa,r*(2*PI/cirFrac)/$fs),minFrag));

//calculate two centers from two points and a radius
//from https://lydxlx1.github.io/blog/2020/05/16/circle-passing-2-pts-with-fixed-r/
function c_centers(P1, P2, r)= let(
  q = sqrt(pow((P2.x-P1.x),2) + pow((P2.y-P1.y),2)),
  x3 = (P1.x + P2.x) /2,
  y3 = (P1.y + P2.y) /2,
  xx = sqrt(pow(r,2) - pow(q/2,2))*(P1.y-P2.y)/q,
  yy = sqrt(pow(r,2) - pow(q/2,2))*(P2.x-P1.x)/q
) [[x3 + xx, y3+yy], [x3-xx,y3-yy]];

function roundVec(Vec,digits)= let(
  x = round(Vec.x*pow(10,digits))/pow(10,digits),
  y = round(Vec.y*pow(10,digits))/pow(10,digits),
  z = (len(Vec) > 2) ? round(Vec.z*pow(10,digits))/pow(10,digits) : 0
) (len(Vec) > 2) ? [x,y,z] : [x,y];

*frustum([3,2,0.9],method="poly");
module frustum(size=[1,1,1], flankAng=[5,5], center=false, method="poly", col="darkSlateGrey"){
  //cube with a trapezoid crosssection
  //size = base dimensions x height
  //https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
  cntrOffset= (center) ? [0,0,-size.z/2] : [size.x/2,size.y/2,0];

  flankRed=[tan(flankAng.x)*size.z,tan(flankAng.x)*size.z]; //reduction in width by angle
  faceScale=[(size.x-flankRed.x*2)/size.x,(size.y-flankRed.y*2)/size.y]; //scale factor for linExt

  if (method=="linExt")
    translate(cntrOffset)
      linear_extrude(size.z,scale=faceScale)
        square([size.x,size.y],true);
  else{ //for export to FreeCAD/StepUp
    polys= [[-size.x/2,-size.y/2,-size.z/2], //0
            [ size.x/2,-size.y/2,-size.z/2], //1
            [ size.x/2, size.y/2,-size.z/2], //2
            [-size.x/2, size.y/2,-size.z/2],//3
            [-(size.x/2-flankRed.x),-(size.y/2-flankRed.y),size.z/2],  //4
            [  size.x/2-flankRed.x ,-(size.y/2-flankRed.y),size.z/2],  //5
            [  size.x/2-flankRed.x , (size.y/2-flankRed.y),size.z/2],  //5
            [-(size.x/2-flankRed.x), (size.y/2-flankRed.y),size.z/2]]; //5
    faces= [[0,1,2,3],  // bottom
            [4,5,1,0],  // front
            [7,6,5,4],  // top
            [5,6,2,1],  // right
            [6,7,3,2],  // back
            [7,4,0,3]]; // left
   color(col) polyhedron(polys,faces,convexity=2);
  }
}

module stagger(pos=10, pitch=[1.27,1.27], stagger){
  stagger = (stagger==undef) ? pitch.x/2 : stagger;
 
  for (ix=[-(pos-1)/4:(pos-1)/4],iy=[-1,1])
      translate([ix*pitch.x+iy*stagger/2+pitch.x/4,iy*pitch.y/2,0]) children();
}

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
      translate([0,0,i*-radius]+childOffset1){ //check
        children(0);
        if ($children){ //if there are more children translate them to the end of the block
          translate(childOffset1) children([1:$children-1]);
        }
        
      }

    //create bend object
    translate(bendOffset3) //checked for cntr+/-, cntrN+/-
      rotate([0,i*90,0]) //re-orientate bend
       translate([-radius,0,0]+bendOffset2)
        rotate_extrude(angle=angle)
          translate([radius,0,0]+bendOffset1) square([size.z,size.x]);
  }
}