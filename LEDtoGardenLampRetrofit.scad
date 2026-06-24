$fn=100;

fudge=0.1;

power();

module power(){
  zOffset=-3.1;
  shellThck=1.6;
  *translate([0,0,zOffset]) usbCBreakOut();
  spcng=0.2;
  usbCSize=[8.74,2.96];
  tongueDims=[8,12+spcng*2,1.5];
  hookSize=3;
  
  
  intersection(){
    difference(){
      union(){
        //body
        linear_extrude(11.6,center=true,convexity=3) 
          translate([0,6/2]) square([21.5,6],true);
        //tongue
        translate([0,tongueDims.y/2,zOffset-tongueDims.z-spcng]) linear_extrude(tongueDims.z) square([tongueDims.x,tongueDims.y],true);
        //hook
        translate([0,tongueDims.y+1.5,zOffset-tongueDims.z-spcng]) 
          linear_extrude(hookSize) square([tongueDims.x,hookSize],true);
        //front
        rotate([90,0,0]) linear_extrude(shellThck,convexity=3) 
          intersection(){
            circle(d=11.6);
            square([10.3,12],true);
          }
     }
     translate([0,0,-11.6/2-fudge]) linear_extrude(3) usbCBreakOut(true) circle(d=3.1);
     translate([0,6+fudge/2,-1]) rotate([90,0]) linear_extrude(6+fudge) usbCBreakOut(true) circle(d=3.1);
     
     translate([0,-shellThck-0.16,0]) rotate([-90,0,0]) linear_extrude(12) usbCShape();
     translate([0,3+fudge,-usbCSize.y/4-spcng]) cube([usbCSize.x+spcng*2,6+fudge,usbCSize.y/2+spcng*2],true);  
    
     
     translate([0,12/2,zOffset-spcng]) linear_extrude(1.6+spcng*2,convexity=3) square([21.5,12],true);
     
    }
  translate([0,hookSize,-11.6/2-fudge])
    rotate([0,-90,0]) linear_extrude(22,center=true) polygon([[+0,-hookSize-shellThck],[12,-hookSize-shellThck],[12,0],[0,tongueDims.y+hookSize]]);
  }
  
  module usbCShape(){
     offset(spcng) hull() for (ix=[-1,1])
      translate([ix*(usbCSize.x-usbCSize.y)/2,0]) circle(d=usbCSize.y);
  }
}

module bottom(){
  difference(){
    union(){
      //inner
      linear_extrude(5,convexity=3) difference(){
        circle(d=40);
        circle(d=30);
      }
      
      linear_extrude(2,convexity=3) difference(){
        circle(d=30);
        circle(d=14);
        }

      linear_extrude(3.5,convexity=3) difference(){
        circle(d=55);
        circle(d=40);
        for (i=[0:3])
          rotate(i*90+45) translate([40,0]) square([40,5],true);
        
      }
    }
    translate([0,29-5-13/2+0.5,-0.1]) cylinder(d=12,h=6);
  }
}

module shim(){
  translate([0,0,5.5]) linear_extrude(2) difference(){
    circle(d=55);
    circle(d=29);
  }

  translate([0,0,2.5]) linear_extrude(2) difference(){
    circle(d=29);
    circle(d=14);
  }

  translate([0,0,2.5]) linear_extrude(5) difference(){
    circle(d=29);
    circle(d=25);
  }
}

*usbC(plug=false);
module usbC(center=false, pins=24, plug=false){
  //https://usb.org/document-library/usb-type-cr-cable-and-connector-specification-revision-21
  //rev 2.1 may 2021
  //receptacle dims
  shellOpng=[8.34,2.56];
  shellLngth=6.2; //reference Length of shell to datum A
  shellThck=0.2;
  centerOffset = center ? [0,0,-(shellOpng.y+shellThck*2)/2] : [0,0,0] ;
  //tongue
  tngDims=[6.69,4.45,0.6];

  //body
  bdyLngth=3;
  
  //colors
  metalSilverCol="silver";
  blackBodyCol="#222222";
  metalGoldPinCol="gold";
  
  //contacts
  //          pinA1          ...                        pinA12
  cntcLngths= (pins>16) ? [4,3.5,3.5,4,3.5,3.5,3.5,3.5,4,3.5,3.5,4] : //8x short, 4x long per side
                          [4,0,0,4,3.5,3.5,3.5,3.5,4,0,0,4]; //16pin
  cntcDims=[0.25,0.05]; //width, thickness
  
  pitch=0.5;
  
  //assembly
  translate([0,0,shellOpng.y/2+shellThck]+centerOffset) rotate([90,0,0]){
    //shell
    color(metalSilverCol) translate([0,0,-bdyLngth]) rcptShell(shellLngth+bdyLngth);
    tongue();
    color(blackBodyCol) translate([0,0,-bdyLngth]) linear_extrude(bdyLngth) shellShape();
  }

  //plug
  if (plug)
    translate([0,0,shellOpng.y/2+shellThck]+centerOffset) rotate([-90,0,0]) plug();
  
  module tongue(){
    tngPoly=[[0,0.6],[1.37,0.6],[1.62,tngDims.z/2],[tngDims.y-0.1,tngDims.z/2],[tngDims.y,tngDims.z/2-0.1],
    [tngDims.y,-(tngDims.z/2-0.1)],[tngDims.y-0.1,-tngDims.z/2],[1.62,-tngDims.z/2],[1.37,-0.6],[0,-0.6]];

    color(blackBodyCol) rotate([0,-90,0]) linear_extrude(tngDims.x,center=true) polygon(tngPoly);
    for (ix=[0:11],iy=[-1,1])
      color(metalGoldPinCol) translate([ix*pitch-11/2*pitch,iy*(tngDims.z+cntcDims.y)/2,cntcLngths[ix]/2]) 
        cube([cntcDims.x,cntcDims.y,cntcLngths[ix]],true);
  }

  module rcptShell(length=shellLngth){
    linear_extrude(length) difference(){
      offset(shellThck) shellShape();
      shellShape();
    }
  }
  module shellShape(size=[shellOpng.x,shellOpng.y]){
    hull() for (ix=[-1,1])
        translate([ix*(size.x-size.y)/2,0]) circle(d=size.y);
  }
  
  module plug(){
    //minimal Plug length from USB.org
    translate([0,0,-6.65]){
      color(metalSilverCol) linear_extrude(6.65)
        shellShape(size=[8.25,2.4]);
      //body max width,height
      color(blackBodyCol) translate([0,0,-35]) 
        linear_extrude(35) shellShape(size=[12.35,6.5]);
    }
  }
}

*usbCBreakOut();
module usbCBreakOut(cut=false){
  dims=[21.5,12];
  pcbThck=1.6;
  holeDia=3;
  holeDist=16;
  holeYOffset=2.6;
  if (cut)
    for (ix=[-1,1])
      translate([ix*holeDist/2,holeYOffset]) children();
  else{    
    color("darkRed") linear_extrude(pcbThck) difference(){
      translate([0,dims.y/2]) square(dims,true);
      for (ix=[-1,1])
        translate([ix*holeDist/2,holeYOffset]) circle(d=holeDia);
      for (ix=[-2.5:2.5])
        translate([ix*2.54,dims.y-1]) circle(d=1);
    }
    translate([0,4.6,pcbThck]) usbC(plug=false);
  }
}