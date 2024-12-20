/* [show] */
showTip=true;
showSmallGauges=true;
showLargeGauges=false;
showFace=false;
export="none"; //["none","buildLarge","buildSmall","lidSmall","lidLarge"]

/* [Hidden] */
sepWallThck=1.6;
compWdth=3.2;
tipThck=6.75-sepWallThck;
ovDims=[215.9,64.1,60];
offsetLarge=101;
offsetFace=198.4;
offsetSmall=102.55;

$fn=50;

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

if (export=="lidSmall")
  !difference(){
    lid();
    translate([110/2,37,ovDims.z-0.1]) linear_extrude(0.2) text("Radius Gauges",halign="center",size=8,font="DejaVu Sans:style=Bold");
    translate([110/2,27,ovDims.z-0.1]) linear_extrude(0.2){
      translate([-21,0]) difference(){
        square(6);
        circle(5);
      }
      translate([-12,0]) text("1-20mm",size=6,font="DejaVu Sans:style=Bold");
    }
    translate([110/2,19,ovDims.z-0.1]) linear_extrude(0.2){
      translate([-21,0]){
        square([1,6]);
        square([6,1]);
        intersection(){
          translate([1,1]) circle(5);
          square(6);
          }
      }
      translate([-12,0]) text("21-40mm",size=6,font="DejaVu Sans:style=Bold");
    }
  }
  
if (export=="lidLarge")
  !difference(){
    lid();
    translate([110/2,37,ovDims.z-0.1]) linear_extrude(0.2) text("Radius Gauges",halign="center",size=8,font="DejaVu Sans:style=Bold");
    translate([110/2,27,ovDims.z-0.1]) linear_extrude(0.2){
      translate([-21,0]) difference(){
        square(6);
        circle(5);
      }
      translate([-12,0]) text("21-40mm",size=6,font="DejaVu Sans:style=Bold");
    }
    translate([110/2,19,ovDims.z-0.1]) linear_extrude(0.2){
      translate([-21,0]){
        square([1,6]);
        square([6,1]);
        intersection(){
          translate([1,1]) circle(5);
          square(6);
          }
      }
      translate([-12,0]) text("1-20mm",size=6,font="DejaVu Sans:style=Bold");
    }
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


module lid(){
  faceThck=3;
  lidWdth=110;
  roofThck=2.8;
  chamfer=2.85;
  
  //cut one part out of the lit 
  intersection(){
    translate([lidWdth,0,ovDims.z]) rotate([180,0,180]) import("RadiusGauge-Lid-40.stl",convexity=5);
    translate([faceThck,0,0]) cube([lidWdth-faceThck,ovDims.y,ovDims.z]);
    }
  
  //add face
  intersection(){
    translate([205.9,0,ovDims.z]) rotate([180,0,180]) import("RadiusGauge-Lid-40.stl",convexity=5);
    cube([faceThck,ovDims.y,ovDims.z]);
  }
  //remove text
  translate([chamfer,chamfer,ovDims.z-roofThck]) cube([lidWdth-chamfer,ovDims.y-chamfer*2,roofThck]);
  
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


