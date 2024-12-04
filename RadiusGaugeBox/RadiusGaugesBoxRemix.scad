/* [show] */
showTip=true;
showSmallGauges=true;
showLargeGauges=false;
showFace=false;
export="none"; //["none","buildLarge","buildSmall"]

/* [Hidden] */
sepWallThck=1.6;
compWdth=3.2;
tipThck=6.75-sepWallThck;
ovDims=[215.9,64.1,60];
offsetLarge=101;
offsetFace=198.4;
offsetSmall=102.55;

if (showTip)
  tip();
if (showSmallGauges)
  smallGauges();
if (showLargeGauges)
  largeGauges();
if (showFace)
  face();

if (export=="buildLarge")
  !difference(){
    translate([-offsetLarge+tipThck,0,0]){
      translate([offsetLarge-tipThck,0,0]) tip();
      largeGauges();
      face();
    }
  magnetComps();
  }
if (export=="buildSmall")
  !union(){
    tip();
    smallGauges();
    translate([-offsetFace+offsetSmall,0,0]) face();
  }


module smallGauges(){
  intersection(){
    import("RadiusGauges.stl",convexity=5);
    translate([tipThck,0,0]) cube([102.55-tipThck,ovDims.y,ovDims.z]);
  }
}

module largeGauges(){
  intersection(){
    import("RadiusGauges.stl",convexity=5);
    translate([101,0,0]) cube([102.55-tipThck,ovDims.y,ovDims.z]);
  }
}

*tip();
module tip(){
  intersection(){
    import("RadiusGauges.stl",convexity=5);
    cube([tipThck,ovDims.y,ovDims.z]);
  }
}

module face(){
  difference(){
    intersection(){
      import("RadiusGauges.stl",convexity=5);
      translate([176,0,0]) cube([215.9-176,ovDims.y,ovDims.z]);
    }
    translate([176,3.2,0]) 
      cube([200.9-176-(200.9-198.4),60.7-3.2,ovDims.z]);
  }
}

*magnetComps();
module magnetComps(){
  compDims=[5.6-3.8,16.1-7.9,17.1];
  compRad=3;
  compSpcng=0;
  compDist=36.1-16.1;
  compStart=[3.8,7.9,0];
  
  for (iy=[0:2])
    translate([compStart.x,compStart.y+iy*compDist,0]){
      cube([compDims.x,compDims.y,compDims.z-compRad]);
      hull() for (i=[0,1])
        translate([0,compRad+i*(compDims.y-compRad*2),compDims.z-compRad]) 
          rotate([0,90,0]) cylinder(r=compRad,h=compDims.x,$fn=50);
    }
}