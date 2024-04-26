/*  -- IKEA Samla Generator --
  Designed based on Measurements from Samla 5l 

  https://www.ikea.com/de/de/cat/samla-serie-12553/
  5 l: 28x19x14cm (lit 28x20)
  11 l: 39x28x14cm
  22 l: 39x28x28cm
  
  
  TODO:
  - create LIT
  - integrate Loft function (can be simplified to one Layer), maybe call it "bridge" then
*/


/* [Show] */
quality=40; //[12:4:100]
showBox=true;
showLit=true;
sectionPlane="none"; // ["none","Y-Z","X-Z","X-Y"]
sectionPos=0.5; // [0:0.1:1]

/* [Box Dimensions] */
//overall height of the box
boxHght=138;
//outer radius of the brim
boxBrmRad=8;
boxBrmOvHng=4;
boxCrnrRad=20; //corner radius
//outer Dimensions at the feet
boxLwrDims=[241,156]; //lower X-Y Dims
//outer Dimensions without the brim
boxTopDims=[260,175]; //top X-Y dims
footDims=[34,34,7]; 
wallThck=1.6;

//recesses at the long sites
rcsSiteDepth=2.5;
rcsSiteTopWdth=160;
rcsSiteHght=100;

//recesses with grips
rcsGripDepth=16.5;
rcsGripTopWdth=75;
rcsGripHght=100;
rcsGripRad=15;

/* [Lit Dimensions] */
//Spacing between lit and box
litSpcng=0.5;
//Spacing around feet for stacking boxes
litStckSpcng=2;
//Overhang of lit above box brim
litOvHng=4;

/* [Hidden] */
fudge=0.1;
$fn=quality;

boxDims=[boxTopDims.x+boxBrmRad*2,boxTopDims.y+boxBrmRad*2,boxHght];

rcsSiteLwrWdth=boxLwrDims.x-footDims.x*2;
rcsSiteFlankAng=atan2((rcsSiteTopWdth-rcsSiteLwrWdth)/2,rcsSiteHght);

rcsGripLwrWdth=boxLwrDims.y-footDims.y*2;
rcsGripFlankAng=atan2((rcsGripTopWdth-rcsGripLwrWdth)/2,rcsGripHght);

//calculate flank angles from top and lower dims
bdyFlankAng=[atan2((boxTopDims.x-boxLwrDims.x)/2,boxDims.z),
          atan2((boxTopDims.y-boxLwrDims.y)/2,boxDims.z)];


//calculate the inner dimension at floor level
flrDims=boxLwrDims+[tan(bdyFlankAng.x)*(footDims.z+wallThck)-wallThck*2,
                 tan(bdyFlankAng.y)*(footDims.z+wallThck)-wallThck*2];

// --- lit dimensions from box dimensions
litBrmRad=boxBrmRad+wallThck+litSpcng;
litDims=[boxDims.x+wallThck*2+litSpcng*2,boxDims.y+wallThck*2+litSpcng*2,litBrmRad+litOvHng];
//outer radius of brim
litCrnrRad=boxCrnrRad;

// Dimensions of the cutting box
sctBoxDims=[litDims.x+fudge,litDims.y+fudge,boxDims.z+wallThck+litSpcng+fudge];

difference(){
  union(){
    if (showBox) SAMLAbox();
    if (showLit) SAMLAlit();
  }
  if (sectionPlane=="Y-Z") 
    translate([sctBoxDims.x*sectionPos,0,(sctBoxDims.z-fudge)/2]) 
      color("darkRed") cube(sctBoxDims,true);
  if (sectionPlane=="X-Z") 
    translate([0,-sctBoxDims.y*sectionPos,(sctBoxDims.z-fudge)/2]) 
      color("darkRed") cube(sctBoxDims,true);
  if (sectionPlane=="X-Y") 
    translate([0,0,(sctBoxDims.z-fudge)/2+sctBoxDims.z*sectionPos]) 
      color("darkRed") cube(sctBoxDims,true);
}

module SAMLAbox(){
  //polygon for cutout in y
  yPoly=[[-rcsSiteLwrWdth/2,0],
         [-rcsSiteLwrWdth/2-tan(rcsSiteFlankAng)*footDims.z,footDims.z+fudge],
         [rcsSiteLwrWdth/2+tan(rcsSiteFlankAng)*footDims.z,footDims.z+fudge],
         [rcsSiteLwrWdth/2,0]];
  xPoly=[[-rcsGripLwrWdth/2,0],
         [-rcsGripLwrWdth/2-tan(rcsGripFlankAng)*footDims.z,footDims.z+fudge],
         [rcsGripLwrWdth/2+tan(rcsGripFlankAng)*footDims.z,footDims.z+fudge],
         [rcsGripLwrWdth/2,0]];
  
      
  *polygon(gripRcsShpPts());
  
  difference(){
    body();
    //feet (needs to be improved)
    translate([0,0,-fudge]) rotate([90,0,0]) linear_extrude(boxTopDims.y,center=true) polygon(yPoly);
    translate([0,0,-fudge]) rotate([90,0,90]) linear_extrude(boxTopDims.x,center=true) polygon(xPoly);
    *translate([0,0,(footDims.z-fudge)/2]){
      cube([boxTopDims.x,boxLwrDims.y-footDims.y*2,footDims.z+fudge],true);
    }
    //inner
    difference(){
      translate([0,0,footDims.z+wallThck]) 
        body(topDims=[boxTopDims.x-wallThck*2,boxTopDims.y-wallThck*2],
            lwrDims=flrDims,
            height=boxDims.z-footDims.z-wallThck+fudge,
            crnrRad=boxCrnrRad-wallThck);
      for (im=[0,1]){
        mirror([0,im,0]) translate([0,-boxLwrDims.y/2+rcsSiteDepth,0]) siteRecess();
        mirror([im,0,0]) translate([boxLwrDims.x/2+fudge,0,0]) rotate(90) 
          easyLoft(gripRcsShpPts(width=boxLwrDims.y-2*footDims.y,wallOffset=wallThck),
                   gripRcsShpPts(width=rcsGripTopWdth,yOffset=-tan(bdyFlankAng.y)*rcsGripHght,wallOffset=wallThck),
                   rcsGripHght+wallThck);
        }
    }
    //recesses
    for (im=[0,1]){
      mirror([0,im,0]) translate([0,-boxLwrDims.y/2+rcsSiteDepth,0]) siteRecess(true);
      mirror([im,0,0]) translate([boxLwrDims.x/2+fudge,0,0]) rotate(90) 
        easyLoft(gripRcsShpPts(width=boxLwrDims.y-2*footDims.y),
                 gripRcsShpPts(width=rcsGripTopWdth,yOffset=-tan(bdyFlankAng.y)*rcsGripHght),
                 rcsGripHght);
    }
  }
  
  translate([0,0,boxDims.z]) brim();

  module body(topDims=boxTopDims,lwrDims=boxLwrDims, height=boxDims.z,crnrRad=boxCrnrRad,useLoft=true){
    
    //point arrays
    lwrPnts=rndRectPoly(lwrDims,crnrRad);
    topPnts=rndRectPoly(topDims,crnrRad);
    
    if (useLoft){
      easyLoft(lwrPnts,topPnts,boxDims.z);
    }
    else
      linear_extrude(height,scale=[topDims.x/lwrDims.x,topDims.y/lwrDims.y],convexity=3)
        hull() for (ix=[-1,1],iy=[-1,1])
          translate([ix*(lwrDims.x/2-crnrRad),iy*(lwrDims.y/2-crnrRad)]) 
            circle(crnrRad);
  }
  
  module siteRecess(cut=false){
    poly=[[-rcsSiteLwrWdth/2,0],[-rcsSiteTopWdth/2,rcsSiteHght],
           [rcsSiteTopWdth/2,rcsSiteHght],[rcsSiteLwrWdth/2,0]];
    if (cut)
      rotate([90+bdyFlankAng.x,0,0]) linear_extrude(rcsSiteDepth+fudge) polygon(poly);
    else
      rotate([90+bdyFlankAng.x,0,0]) translate([0,0,-wallThck]) linear_extrude(rcsSiteDepth+wallThck) offset(wallThck) polygon(poly);
  }
  
  function gripRcsShpPts(width=rcsGripTopWdth,rad=rcsGripRad,yOffset=0,wallOffset=0)=let(
    leftArc=push_arc(start=[-width/2-wallOffset,rcsGripDepth-rad+yOffset],
                     end=[-width/2+rad,rcsGripDepth+yOffset+wallOffset],
                     r=rad+wallOffset),
    rightArc=push_arc(end=[width/2+wallOffset,rcsGripDepth-rad+yOffset],
                     start=[width/2-rad,rcsGripDepth+yOffset+wallOffset],
                     r=rad+wallOffset))
    
    concat([[-width/2-wallOffset,yOffset]],leftArc,rightArc,[[width/2+wallOffset,yOffset]]);

}


module SAMLAlit(){
  //body
  translate([0,0,boxDims.z+litSpcng])
    difference(){
      body();    
    }
  module body(){
    translate([0,0,wallThck]) brim([boxTopDims.x,boxTopDims.y],litBrmRad,litCrnrRad,litOvHng);
    linear_extrude(wallThck) polygon(rndRectPoly(size=[boxTopDims.x,boxTopDims.y],crnrRad=litCrnrRad));
  }
}


*brim();
module brim(outerDims=boxTopDims,brmRad=boxBrmRad, inCrnrRad=boxCrnrRad, ovHng=boxBrmOvHng){
  for (ix=[-1,1],iy=[-1,1]){
    rot = ((ix > 0) && (iy > 0)) ? 0 :
          ((ix > 0) && (iy < 0)) ? -90 :
          ((ix < 0) && (iy > 0)) ? 90 :
          180;
    translate([ix*(outerDims.x/2-inCrnrRad),iy*(outerDims.y/2-inCrnrRad)]){
      rotate(rot)
        rotate_extrude(angle=90)
          translate([inCrnrRad,-brmRad]) 
            brimXShape();
    }
  } //for
  for (ir=[0:90:270]){
    l= (ir/90%2) ? outerDims.x-inCrnrRad*2 : outerDims.y-inCrnrRad*2;
    t= (ir/90%2) ? outerDims.y/2 : outerDims.x/2;
    rotate(ir) translate([t,0,-brmRad]) rotate([90,0,0]) 
      linear_extrude(l,center=true,convexity=3) brimXShape();
  }
  *brimXShape();
  //cross section of brim
  module brimXShape(){
    intersection(){
      square(brmRad);
      difference(){
        circle(brmRad);
        circle(brmRad-wallThck);
      }
    }
    //connector
    translate([-wallThck,brmRad-wallThck]) square(wallThck);
    //overhang
    translate([brmRad-wallThck,-ovHng]) square([wallThck,ovHng]);
  }
}


  
module easyLoft(lowerPoints,upperPoints,height=10){
    lwrPnts3D=[
      for (pt=[0:len(lowerPoints)-1]) 
        [lowerPoints[pt].x,lowerPoints[pt].y,0]];
    upPnts3D=[
      for (pt=[0:len(upperPoints)-1]) 
        [upperPoints[pt].x,upperPoints[pt].y,height]];
    loft(upPnts3D,lwrPnts3D,1);
}

// --- Helper Functions ---

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
  angle = round(acos(u * v / (norm(u)*norm(v)))),
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

//calculate two centers from two points and a radius (when 3rd Point is missing there are two solutions)
//from https://lydxlx1.github.io/blog/2020/05/16/circle-passing-2-pts-with-fixed-r/
function c_centers(P1, P2, r)= let(
  q = sqrt(pow((P2.x-P1.x),2) + pow((P2.y-P1.y),2)),
  x3 = (P1.x + P2.x) /2,
  y3 = (P1.y + P2.y) /2,
  xx = sqrt(pow(r,2) - pow(q/2,2))*(P1.y-P2.y)/q,
  yy = sqrt(pow(r,2) - pow(q/2,2))*(P2.x-P1.x)/q
) [[x3 + xx, y3+yy], [x3-xx,y3-yy]];

//create 2D points for a round rectangle
function rndRectPoly(size=boxLwrDims, crnrRad=boxCrnrRad)=let(
  lLeftArc=push_arc(start=[-(size.x/2-crnrRad),-size.y/2],
                    end=[-size.x/2,-(size.y/2-crnrRad)],
                    r=crnrRad),
  tLeftArc=push_arc(end=[-(size.x/2-crnrRad),size.y/2],
                    start=[-size.x/2,(size.y/2-crnrRad)],
                    r=crnrRad),
  tRightArc=push_arc(start=[(size.x/2-crnrRad),size.y/2],
                    end=[size.x/2,(size.y/2-crnrRad)],
                    r=crnrRad),
  lRightArc=push_arc(end=[(size.x/2-crnrRad),-size.y/2],
                    start=[size.x/2,-(size.y/2-crnrRad)],
                    r=crnrRad))
  concat(lLeftArc,tLeftArc,tRightArc,lRightArc);
  
  
// OpenSCAD loft module, with n layers.

module loft(upper_points, lower_points, number_of_layers){

  assert(len(upper_points)==len(lower_points),"[loft] upper and lower must be equal in length");
  
  polyhedron( 
      points = [
          for (i = [0 : number_of_layers])
              for (j = [0 : len(upper_points) - 1])
                  [((upper_points[j][0] * (number_of_layers - i) / number_of_layers)
                  + (lower_points[j][0] * i / number_of_layers)), //X
                  ((upper_points[j][1] * (number_of_layers - i) / number_of_layers)
                  + (lower_points[j][1] * i / number_of_layers)), //Y
                  ((upper_points[j][2] * (number_of_layers - i) / number_of_layers)
                  + (lower_points[j][2] * i / number_of_layers))] //Z
      ],
      faces = [
          [for (i= [0 : len(upper_points)-1]) i], // Upper plane.
          for (i = [0 : number_of_layers -1])
              for (j = [0 : len(upper_points) - 1]) // Towards lower points.
                  [len(upper_points) * i + (j+1)%len(upper_points), 
                  len(upper_points) * i + j, 
                  len(upper_points) * (i+1) + j],
          for (i = [1 : number_of_layers])
              for (j = [0 : len(upper_points) - 1]) // Towards upper points.
                  [len(upper_points) * i + j, 
                  len(upper_points) * i + (j+1) % len(upper_points), 
                  len(upper_points) * (i-1) + (j+1) % len(upper_points)],
          [for (i= [len(upper_points) * (number_of_layers+1) -1  : -1 : len(upper_points) * number_of_layers ]) i], // Lower plane.
      ]
  );
}