fudge=0.1;

boxHeader(10,shape="lockings");
*boxHeaderFix(10);

module boxHeader(pins,zOffset="top",shape="none"){
  fudge=0.1;
  RM=2.54;
  
  
  //Dimensions from WE PartNo: 612 0xx 216 21
  height=8.85;
  pinHght=11.5;
  ovDpth=8.85;
  inDepth=6.35;
  yWallThck=(ovDpth-inDepth)/2;
  A=RM*(pins/2-1);//pin to pin distance
  B=RM*(pins/2)+7.66; //overall Width
  C=RM*(pins/2-1)+7.88; //inner Width
  
  
  zOffset= (zOffset=="bottom") ? 0 : ( (zOffset=="top") ? -height : 0);
  if (shape == "outline") {
    square([B,ovDpth],true);
  }
  else if (shape == "cover") {
    square([C,ovDpth],true);
  }
  else if (shape == "lockings"){
    difference(){
      square([B,ovDpth],true);
      translate([(B-1.05-fudge)/2,0]) square([(B-C)/2+fudge,3.3],true);
      translate([-(B-1.05-fudge)/2,0]) square([(B-C)/2+fudge,3.3],true);
    }
  }
  else
  translate([0,0,zOffset]){
    color("darkgrey")
       difference(){
        translate([0,0,height/2]) cube([B,ovDpth,height],true);
        translate([0,0,(2.35+height)/2]) cube([C,6.35,height-2.35+fudge],true);
        translate([-(B-1.05-fudge)/2,0,6.4/2]) cube([(B-C)/2+fudge,3.3,6.4+fudge],true);//side nudges
        translate([(B-1.05-fudge)/2,0,6.4/2]) cube([(B-C)/2+fudge,3.3,6.4+fudge],true);
        translate([0,-(ovDpth-yWallThck)/2,(height-2.35)/2+2.35]) cube([4.5,yWallThck+fudge,height-2.35+fudge],true);
      }
      for (i=[0:pins/2-1],j=[-1,1]){
        color("gold") translate([-A/2+i*RM,RM/2*j,pinHght/2-3]) cube([0.64,0.64,pinHght],true);
      }
    }
}

module boxHeaderFix(pins,matThck=3,layer=0,cutOut=false){
  $fn=50;
  //Dimensions from WE PartNo: 612 0xx 216 21
  RM=2.54;
  height=8.85;
  pinHght=11.5;
  ovDpth=8.85;
  inDpth=6.35;
  yWallThck=(ovDpth-inDpth)/2;
  A=RM*(pins/2-1);//pin to pin distance
  B=RM*(pins/2)+7.66; //overall Width
  C=RM*(pins/2-1)+7.88; //inner Width
  
  //cutout box Header
  
  
  //cutout lockers + header
  if (layer==0){
    if (cutOut)
      hull(){
        translate([-B/2,0,-(matThck+fudge)/2]) cylinder(d=ovDpth,h=matThck+fudge);
        translate([B/2,0,-(matThck+fudge)/2]) cylinder(d=ovDpth,h=matThck+fudge);
      }
    else
    difference(){
      union(){
        translate([-B/2,0,-(matThck+fudge)/2]) cylinder(d=ovDpth,h=matThck);
        translate([B/2,0,-(matThck+fudge)/2]) cylinder(d=ovDpth,h=matThck);
      }
      cube([B,ovDpth,matThck],true);
      
    }
    translate([C/2+(B-C)/4,0,-fudge/2]) cube([(B-C)/2+fudge,3.3,matThck+fudge],true);
      translate([-(C/2+(B-C)/4),0,-fudge/2]) cube([(B-C)/2+fudge,3.3,matThck+fudge],true);
  }
}

module bHeaderCutOut(pins, matThck=3){
  difference(){
    cube([B,ovDpth,matThck],true);
    translate([C/2+(B-C)/4,0,0]) cube([(B-C)/2+fudge,3.3,matThck+fudge],true);
  }
}