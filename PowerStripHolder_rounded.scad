use <bezier.scad>


// [Dimensions]
wdth=62;
hght=43;
lngth=320; //needed only for example
minWallThck=2;
cap="round"; //["round","cubic"]

cblDia=7.5;
cblHght=10;

//[Hidden]
fudge=0.1;

// [show]
showSection=false;
cableSide=false;

powerStripWthSwitch();




$fn=50;
module powerStripWthSwitch(){
  btmWdth=44;//width at the bottom
  topWdth=44;
  btmHght=14;//height of bottom segment
  midHght=27.5; //from bottom to top of mid segment
  bezOffset=5;
  drillDia=3.1;
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
  
  difference(){
    union(){
      rotate_extrude(angle=180) difference(){ 
        polygon(Bezier(bezPolyCap));
        polygon(Bezier(bezPolyCapInner));
      }
      
    }//union
    translate([0,0,-fudge/2]) cylinder(d=topWdth+minWallThck,h=hght+fudge);
    //cable
    if (cableSide){
      translate([0,0,cblHght]) rotate([-90,0,0]) cylinder(d=cblDia+fudge,h=wdth);
      translate([0,wdth/2,cblHght/2-fudge]) cube([cblDia+fudge,wdth,cblHght+fudge],true);
    }
  }//diff
  
  base();
  
  if (showSection)
    color("darkred")
      rotate_extrude(angle=180)
        polygon(Bezier(bezPolyStrip));
  
  module base(){
    difference(){
      union(){
        hull() for(ix=[-1,1])
          translate([ix*(wdth/2-rad+minWallThck),wdth/4+minWallThck/2+(wdth/4-rad+minWallThck/2),0]) cylinder(r=rad,h=minWallThck);
        translate([-(wdth/2+minWallThck),0,0]) cube([wdth+minWallThck*2,wdth/2+minWallThck-rad,minWallThck]);
      }
    translate([0,0,-fudge/2]) cylinder(d=wdth,h=minWallThck+fudge);
    //cable
    translate([0,wdth/2,cblHght/2-fudge]) cube([cblDia+fudge,wdth,cblHght+fudge],true);
    for(ix=[-1,1])
      translate([ix*(wdth/2-drillDia),wdth/2-drillDia,-fudge/2]) cylinder(d=drillDia,h=minWallThck+fudge);
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

