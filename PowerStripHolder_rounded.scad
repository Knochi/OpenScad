use <bezier.scad>


/* [Dimensions] */
wdth=62;
hght=43;
lngth=320; //needed only for example
minWallThck=3;
cap="round"; //["round","cubic"]
screws="slim"; //["slim","sturdy"]
drillDia=3.6;
cblDia=7.5;
cblHght=10;

/* [show] */
showSection=false;
cableSide=false;

/* [Hidden] */
fudge=0.1;
$fn=50;


powerStripWthSwitch();

module powerStripWthSwitch(){
  btmWdth=44;//width at the bottom
  topWdth=44;
  btmHght=14;//height of bottom segment
  midHght=27.5; //from bottom to top of mid segment
  bezOffset=5;

  rad=2;
  spcng=0.2;
  
  bezPolyStrip=[[0,0],LINE(),
           LINE(),[btmWdth/2,0],OFFSET([bezOffset/2,0]),
           OFFSET([0,-bezOffset]),[wdth/2,btmHght],LINE(),
           LINE(),[wdth/2,midHght],OFFSET([0,bezOffset]),
           OFFSET([bezOffset/2,0]),[topWdth/2,hght],LINE(),
           LINE(),[0,hght]];
  
  bezPolyCap=[[0,0],LINE(),
           LINE(),[wdth/2+minWallThck,0],LINE(),
           //OFFSET([0,-bezOffset]),[wdth/2,btmHght],LINE(),
           LINE(),[wdth/2+minWallThck,midHght],OFFSET([0,bezOffset]),
           OFFSET([bezOffset/2,0]),[topWdth/2+minWallThck,hght],LINE(),
           LINE(),[0,hght]];
    
  bezPolyCapInner=[[0,0],LINE(),
           LINE(),[btmWdth/2+spcng,0],OFFSET([bezOffset/2,0]),
           OFFSET([0,-bezOffset]),[wdth/2+spcng,btmHght],LINE(),
           LINE(),[wdth/2+spcng,midHght+spcng],OFFSET([0,bezOffset]),
           OFFSET([bezOffset/2,0]),[topWdth/2+spcng,hght],LINE(),
           LINE(),[0,hght]];
           
  // for sturdy screws
  drillPos=[[wdth/2+minWallThck*1.5+drillDia/2, drillDia/2+minWallThck], //outer
             [drillDia/2+minWallThck+(cblDia+fudge)/2,wdth/2+minWallThck*1.5+drillDia/2], //back
             [drillDia/2+minWallThck+cblDia/2,drillDia/2+minWallThck]]; //center just for shape
  
  difference(){
    union(){ //body
      rotate_extrude(angle=180) difference(){ 
        polygon(Bezier(bezPolyCap));
        polygon(Bezier(bezPolyCapInner));
      }
    }//union
    //cutout
    translate([0,0,-fudge/2]) cylinder(d=topWdth+minWallThck,h=hght+fudge);
    
    //cable
    if (cableSide){
      translate([0,0,cblHght]) rotate([-90,0,0]) cylinder(d=cblDia+fudge,h=wdth);
      translate([0,wdth/2,cblHght/2-fudge]) cube([cblDia+fudge,wdth,cblHght+fudge],true);
    }
  }//diff
  
  //base with screw domes
  base();
  
  if (showSection)
    color("darkred")
      rotate_extrude(angle=180)
        polygon(Bezier(bezPolyStrip));
  
  module base(){
    
    if (screws=="slim")
      difference(){
        union(){
          hull() for(ix=[-1,1])
            //translate([ix*(wdth/2-rad+minWallThck),wdth/4+minWallThck/2+(wdth/4-rad+minWallThck/2),0]) 
            translate([ix*(wdth/2-rad+minWallThck),wdth/2+minWallThck-rad,0]) 
              cylinder(r=rad,h=minWallThck);
          translate([-(wdth/2+minWallThck),0,0]) cube([wdth+minWallThck*2,wdth/2+minWallThck-rad,minWallThck]);
      }
      translate([0,0,-fudge/2]) cylinder(d=wdth,h=minWallThck+fudge);
      //cable
      translate([0,wdth/2,cblHght/2-fudge]) cube([cblDia+fudge,wdth,cblHght+fudge],true);
    for(ix=[-1,1])
      translate([ix*(wdth/2-drillDia),wdth/2-drillDia,-fudge/2]) cylinder(d=drillDia,h=minWallThck+fudge);
    }
  else { //sturdy
   
    
    for (im=[0,1])
      mirror([im,0,0]){
        difference(){
          union(){
            linear_extrude(minWallThck) hull() for (pos=drillPos) 
              translate(pos) circle(d=drillDia+minWallThck*2);
            for (i=[0,1]) hull(){
              translate(drillPos[2]) counterSunk();
              translate(drillPos[i]) counterSunk();
              }
          }
        for (pos=drillPos) 
          translate(pos) counterSunk(true);
       //center hole
        translate([0,0,-fudge/2]) cylinder(d=wdth,h=hght+fudge);
    }
  }
}
  

  
  module stripDummy(){
    rotate_extrude(angle=180) polygon(Bezier(bezPolyStrip));
    rotate([90,0,0]) linear_extrude(lngth-wdth){
      polygon(Bezier(bezPolyStrip));
      mirror([1,0]) polygon(Bezier(bezPolyStrip));
    }
    translate([0,-lngth+wdth,0]) rotate(180) rotate_extrude(angle=180) polygon(Bezier(bezPolyStrip));
    
    *hull() for (ix=[-1,1]) translate([ix*(lngth-wdth)/2,0,0]){
      cylinder(d1=44,d2=wdth,h=14);
      translate([0,0,14]) cylinder(d=wdth,h=27.5-14);
      translate([0,0,27.5]) cylinder(d1=wdth,d2=44,h=hght-27.5);
  }
  }
  }
}

*counterSunk(true);
module counterSunk(cut=false){
  dk=7;
  k=2.1;
  d=3.5;
  if (cut){
    translate([0,0,minWallThck])
      cylinder(d1=d,d2=dk+fudge,h=k+fudge/2);
    translate([0,0,-fudge/2])
      cylinder(d=drillDia,h=k+minWallThck+fudge);
    translate([0,0,minWallThck+k+fudge/2])
      cylinder(d=dk+fudge,h=hght);
  }
  else
    cylinder(d=drillDia+minWallThck*2,h=k+minWallThck);
}

