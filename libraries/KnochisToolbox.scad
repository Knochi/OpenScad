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

//from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features
function fragFromR(r,ang=360)=$fn>0 ? ($fn>=3 ? $fn : 3) : ceil(max(min(360/$fa,r*2*PI*ang/(360*$fs)),5));
function framFromA()=360/$fa;
function fragFromS()=r*2*PI/$fs;
