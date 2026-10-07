/* [Grill Dimensions] */
wallThck=1.7;
frameWdth=100;
frameDpth=121.5;
frameHght=7;
frameInRad=1.8;
standOffDepth=3;
maxHght=17;
brimHght=12.4;

/* [Fins] */
finThck=2;
finHght=20;
finTilt=10; //[-60:1:60]
finRotation=0; //[-180:1:180]
finZOffset=2;
finDist=15;
finCount=7;

/* [FinBody] */
finBdyZOffset=-2;
finBdySpcng=0.5;
finBdy2FinOvLap=3;

/* [Clips] */
clipThck=1;
clipWdth=10;
clipSpcng=0.2;

/* [Hidden] */
fudge=0.1;
minFinLen=sqrt(pow(frameWdth,2)+pow(frameDpth,2)); //the minimum fin length to touch the frame (circumfence of rectangle)
$fn=48;

%ventDummy();

clipOn();

module clipOn(){
  frameHght=-finBdyZOffset+maxHght+finZOffset-brimHght+finBdy2FinOvLap;
  //frame
  difference(){
    translate([0,0,brimHght+finBdyZOffset]) linear_extrude(frameHght,convexity=3) difference(){
      square([frameWdth,frameDpth],true);
      offset(-wallThck) square([frameWdth,frameDpth],true);
      
    }
    rotate([-90,0,-90]) linear_extrude(frameWdth+fudge,center=true,convexity=3) offset(finBdySpcng) ventProfile2D();
  }
  //fins
  intersection(){
    linear_extrude(maxHght+finZOffset+finThck+finHght) square([frameWdth,frameDpth],true);
    rotate(finRotation)
      for (iy=[-(finCount-1)/2:(finCount-1)/2])
        translate([0,iy*finDist,maxHght+finZOffset+finThck/2]) rotate([finTilt,0,0]) fin();
   }
    
  //clips
  for (ix=[-1,1],iy=[-1,1]){
    r= iy>0 ? 180 : 0;
    translate([ix*((frameWdth-clipWdth)/2-wallThck-clipSpcng),iy*((frameDpth-clipThck)/2-wallThck),0]) rotate(r) clip();
  }
    
  module fin(){
    rotate([0,-90,0]) linear_extrude(minFinLen,center=true){
      for (ix=[0,1])
        translate([ix*(finHght-finThck),0]) circle(d=finThck);
      translate([(finHght-finThck)/2,0]) square([finHght-finThck,finThck],true);
    }
  }
  *clip();
  module clip(){
    clipHght=maxHght+finZOffset+finThck+finBdy2FinOvLap+finThck/2+clipSpcng;
    translate([0,0,clipHght/2-standOffDepth-clipSpcng]) cube([clipWdth,clipThck,clipHght],true);
    //hook
    translate([0,clipThck/2,-standOffDepth-clipSpcng]) rotate([0,-90,180]) 
      linear_extrude(clipWdth,center=true) polygon([[0,0],[0,clipThck+wallThck],[-(clipThck+wallThck)*2,clipThck],[-(clipThck+wallThck)*2,0]]);
  }
}

// Dummy
module ventDummy(){

  //extrude sidewalls from traced SVG
  rotate([-90,0,-90]) for (iz=[-1,1])
    translate([0,0,iz*(frameWdth-wallThck)/2]) 
      linear_extrude(wallThck,center=true) ventProfile2D();
      
  //reconstruct the rest (if needed)
  for (iy=[-1,1]){
    translate([0,iy*(frameDpth-wallThck)/2,(brimHght-standOffDepth-frameInRad)/2]) cube([frameWdth-wallThck*2,wallThck,brimHght+standOffDepth-frameInRad],true);
    translate([0,iy*(frameDpth)/2+wallThck-frameInRad,brimHght-frameInRad]) rotate([0,90,0]) cylinder(r=frameInRad,h=frameWdth,center=true);
  }
}

module ventProfile2D(){
  translate([-156.16/2,-17.2])  import("ventProfileSide.svg");
}