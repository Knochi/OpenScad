module twoByTwo(size=[5,5]){
  for (ix=[-1,1],iy=[-1,1])
    translate([ix*size.x/2,iy*size.y/2,0]) children();
}

arc(r=10);
module arc(r=1,angle=45,poly=[],iter=0){
  facets= fragFromR(r,angle);
  iter = iter ? iter-1 : facets;
  aSeg=angle/facets;
  x= r * cos(aSeg*iter);
  y= r * sin(aSeg*iter);
  poly = concat(poly,[[x,y]]);
  if (iter>0){
    echo(iter);
    arc(r,angle,poly,iter);
  }
  else {
    poly=concat(poly, [[0,0]]);
    polygon(poly);
  }
}

// a lathe tool that accepts diameters and offsets
module lathe(dimensions=[],zOffset=0,iter=0){
 
  d1= dimensions[iter][1];
  d2= dimensions[iter][2];
  h= dimensions[iter][0];

  // if one diameter make cylinder else make cone
  if (dimensions[iter][2]==undef)
    translate([0,0,zOffset]) cylinder(d=d1,h=h);
  else
    translate([0,0,zOffset]) cylinder(d1=d1,d2=d2,h=h);
  
  //cumulate offset and process next section
  if (iter<len(dimensions)-1) lathe(dimensions,zOffset+h,iter+1);
  else echo(str("[Lathe] Total Length: ",zOffset+h));
}

//from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features
function fragFromR(r,ang=360)=$fn>0 ? ($fn>=3 ? $fn : 3) : ceil(max(min(360/$fa,r*2*PI*ang/(360*$fs)),5));
function framFromA()=360/$fa;
function fragFromS()=r*2*PI/$fs;

//arc function simlar to svg path command "A" (https://www.w3.org/TR/SVG11/paths.html#PathData)
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

//rounded 2D or 3D rectangle with optional drill holes 
module rndRect(size=[10,10,2],radius=3,drillDia=1,center=false){
  //set to cube if size.y not defined
  dims = (size.y==undef) ? [size.x,size.x,size.x] : size;
  comp = (size.x>size.y) ? size.y : size.x; //which value to compare to
  radius = (radius>(comp/2)) ?  comp/2 : radius; //set and limit radius
  cntrOffset = center ? len(size)<3 ? [0,0] : // center && len(size)<3
                                      [0,0,-size.z/2] : //else if center
                                      [size.x/2,size.y/2,0]; //else
  echo(cntrOffset);
  if (len(size)<3)
    translate(cntrOffset) shape();
  else
    translate(cntrOffset) linear_extrude(size.z)  shape();

  module shape(){
    difference(){
      hull() for (ix=[-1,1], iy=[-1,1])
        translate([ix*(dims.x/2-radius),iy*(dims.y/2-radius)])
          circle(r=radius);//cube

      if (drillDia) for (ix=[-1,1],iy=[-1,1]) //drill holes
          translate([ix*(dims.x/2-radius),iy*(dims.y/2-radius)]) 
            circle(d=drillDia);
    }
  }
}


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