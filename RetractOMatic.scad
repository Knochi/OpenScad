/* [Dimensions] */
filament=1.75; //[1.75,2.85]
//The maximum rectract Distance
maxRetrDist=20;
//minimum Wall Thickness
minWallThck=2;
//spacing
spcng=0.2;
fitDia=10;
retract=0; //[0:20]
/* [show] */
showASY=true;
showClutch=true; 

/* [Hidden] */
$fn=50;
bwdnDia= (filament==1.75) ? [4,2] : [6.35,3];
slotCnt=3;
segAng=360/(slotCnt*2);
conHght=5;
fudge=0.1;

if (showASY) ASY();
if (showClutch) !hookThing();

module ASY(){
  color("green") translate([0,0,-retract/2]) hookThing();
  color("red") translate([0,0,retract/2]) rotate([180,0,0]) hookThing();
}



module hookThing(){
  
  ovLngth=maxRetrDist+conHght+minWallThck*2;
  slotLen=ovLngth-conHght+spcng;
  baseDia= max(fitDia,bwdnDia[0]+minWallThck*4+spcng*2);
  
  translate([0,0,-conHght/2]) difference(){
    union(){
      cylinder(d=bwdnDia[0]+minWallThck*2,h=ovLngth,center=true);
      translate([0,0,-ovLngth/2]) cylinder(d=baseDia,h=conHght-spcng);
      translate([0,0,ovLngth/2-minWallThck]) cylinder(d=baseDia,h=minWallThck);
    }
    cylinder(d=bwdnDia[0]+spcng,h=ovLngth+fudge,center=true);
    for (ir=[0:segAng*2:360-segAng])
      rotate(ir) translate([0,0,(conHght-spcng)/2]) 
        linear_extrude(height=slotLen+fudge,center=true) offset(spcng) arc(bwdnDia[0],segAng);
  }
  
}


module arc(r=1,angle=45,poly=[],iter=0){
  facets= fragFromR(r,angle);
  iter = iter ? iter-1 : facets;
  aSeg=angle/facets;
  x= r * cos(aSeg*iter);
  y= r * sin(aSeg*iter);
  poly = concat(poly,[[x,y]]);
  if (iter>0){
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