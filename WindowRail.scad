$fn=50;

baseLngth=62+6;
baseHght=2;
matThck=3;
spcng=0.2;
drill=3;
minWallThck=1.6; //lineWdth=0.4
fudge=0.1;
baseWdth=matThck+spcng*2+minWallThck*2;
guideLngth=baseLngth/2-baseWdth*1.5;
guideHght=2;

/* [dowels] */
dwlDia=6;
dwlLngth=7;
dwlDist=62;

windowRail(false,true);
*translate([0,0,0.2]) uniScrew();

module windowRail(drills=true,dowels=false){
  //base
  translate([0,0,baseHght/2]){
    difference(){
      hull() for (ix=[-1,1]) translate([ix*(baseLngth-baseWdth)/2,0,0]) 
        cylinder(d=baseWdth,h=baseHght,center=true);
      if (drills) for (ix=[-1,0,1]) translate([ix*(baseLngth-baseWdth)/2,0]){
        cylinder(d=drill+fudge,h=baseHght+fudge,center=true);
        translate([0,0,-baseHght/2+0.2]) cylinder(d1=drill+fudge,d2=6+fudge*2,h=1.8+fudge);
      }
    }
    //guide
    for (ix=[-1,1],iy=[-1,1]) 
      translate([ix*(baseLngth-baseWdth)/4,iy*(baseWdth-minWallThck)/2,(baseHght+guideHght)/2])
        cube([guideLngth,minWallThck,guideHght],true);
  }
  //dowels
  if (dowels) for (ix=[-1,1])
    translate([ix*(dwlDist)/2,0,0]){
      translate([0,0,-dwlLngth+1]) cylinder(d=dwlDia,h=dwlLngth-1);
      translate([0,0,-dwlLngth]) cylinder(d1=dwlDia-2,d2=dwlDia,h=1);
    }
}


module uniScrew(d=3,l=20,head="star"){
  dk=6;
  k=1.8;
  cylinder(d1=d,d2=dk,h=k);
  translate([0,0,-l]) cylinder(d=d,h=l);
}