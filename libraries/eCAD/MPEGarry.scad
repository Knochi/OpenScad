/* Library for MPE-Garry Connectors */
fudge=0.1;

//demo
MPE_192(6);
translate([10,0,0]) MPE_196(6);
translate([20,0,0]) MPE_098(pins=6,variant=1);
translate([20,-10,0]) MPE_098(pins=6,variant=2);
translate([20,-20,0]) MPE_098(pins=12,variant=3);
translate([20,-30,0]) MPE_098(pins=6,variant=4);
translate([20,-40,0]) MPE_098(pins=6,variant=5);
translate([20,-50,0]) MPE_098(pins=12,variant=6);

module MPE_192(pins,cntrX=false,diff="none"){
  
  pinDia=0.41;
  drill=0.65;
  
  bdyWdth=pins*1.27+0.41;
  bdyHght=2.2;
  bdyDpth=2.2;
  
  cntrOffset = cntrX ? [-bdyWdth/2,0,0] : [-(1.27+0.41)/2,-3.4,0];
  
  translate(cntrOffset){
  if (diff=="none"){
   
      color("darkgrey") cube([bdyWdth,bdyDpth,bdyHght]);
      for (i=[(1.27+0.41)/2:1.27:pins*1.27]){//pins
        color("gold") union(){
          translate([i,3.4,bdyHght/2]) rotate([90,0,0]) cylinder(h=6.4,d=pinDia);//horizontal
          translate([i,3.4,bdyHght/2]) rotate([180,0,0]) cylinder(h=3+bdyHght/2,d=pinDia); //vertical
          translate([i,3.4,bdyHght/2]) rotate([90,0,0]) sphere(d=pinDia);
          translate([i,-3,bdyHght/2]) rotate([90,0,0]) sphere(d=pinDia);
          translate([i,3.4,-3]) rotate([90,0,0]) sphere(d=pinDia); 
        }
      }
    }//if
  else {
    for (i=[(1.27+0.41)/2:1.27:pins*1.27]){//drills
      translate([i,3.4,-3+fudge/2]) cylinder(h=3+fudge,d=drill); //vertical
    }
  }
  }
}

//!MPE_196(28);
module MPE_196(pins,cntrX=false,diff="none"){
  
  pinDia=0.41;
  drill=0.65;
  
  bdyWdth=pins*1.27+0.41;
  bdyHght=2.2;
  bdyDpth=2.2;
  
  cntrOffset = cntrX ? [-bdyWdth/2,0,0] : [-(1.27+0.41)/2,-3.4,0];
  
  translate(cntrOffset){
  if (diff=="none"){
   
      color("darkgrey") cube([bdyWdth,bdyDpth,bdyHght]);
      for (i=[(1.27+0.41)/2:1.27:pins*1.27]){//pins
        color("gold") union(){
          translate([i,3.4-0.7,bdyHght/2]) rotate([90,0,0]) cylinder(h=6.4-0.7,d=pinDia);//horizontal
          translate([i,2.2+4.7-3.6,pinDia/2]) rotate([-90,0,0]) cylinder(h=3.6,d=pinDia); //solderpart
          
          translate([i,-3,bdyHght/2])  sphere(d=pinDia); //front sphere
          hull(){
            translate([i,2.7,bdyHght/2])  sphere(d=pinDia); //upper sphere
            translate([i,2.2+4.7-3.6,pinDia/2])  sphere(d=pinDia); //bottom sphere
          }
          translate([i,2.2+4.7,pinDia/2]) sphere(d=pinDia); //back spehre
        }
      }
    }//if
  else {
    for (i=[(1.27+0.41)/2:1.27:pins*1.27]){//drills
      translate([i,3.4,-3+fudge/2]) cylinder(h=3+fudge,d=drill); //vertical
    }
  }
  }
}
//!MPE_094(16,cntr=false);
module MPE_094(pins, center=false, diff="none", thick=8.5){ //receptable housing
  //dual row, SMD
  holeX=0.7;
  holeY=0.7;
  drill=1.02;
  
  cntrOffset = center ? [-pins/4*2.54-0.25,-2.54,0] : [-1.27-0.25,-1.25,0];
  
  pinWdth=0.64;
  pinLen=3.1;
  
  translate(cntrOffset){
    
    if (diff=="housing"){
      translate([-fudge/2,-fudge/2,0]) cube([2.54*(pins/2)+0.5+fudge,5.08+fudge,thick]);
    }
    
    else if (diff=="drill") {
      for (i=[0:2.54:(pins/2-1)*2.54],j=[1.27,1.27+2.54]){
          translate([i+1.27+0.25-holeX/2,j-0.2,-pinLen]) cylinder(h=pinLen, d=1.1);
        }
    }
    else if (diff=="pins"){
      translate([pins/4*2.54+0.25,2.54,-matThck+fudge/2]) rndRect(2.54*pins/2,5.08,thick,1.27,0);
    }
    else {
      difference(){
        color("darkgrey") cube([2.54*(pins/2)+0.5,5.08,8.5]);
        for (i=[0:2.54:(pins/2-1)*2.54],j=[1.27,1.27+2.54]){
          translate([i+1.27+0.25-holeX/2,j-holeY/2,-fudge/2+2]) cube([holeX,holeY,6.5+fudge]);
        }
      }
    
      color("gold")
        for (i=[0:2.54:(pins/2-1)*2.54],j=[1.27,1.27+2.54]){
          translate([i+1.27+0.25-holeX/2,j-0.2,-pinLen]) cube([pinWdth,0.4,pinLen]);
        }
    }//else
  }
}




module MPE_098(pins,center=false,variant=1,diff="none"){
  //-- variations --
  //single row, low profile (3.7mm)      - 1,2 (Pin Layout 1,2)
  //dual row, low profile                - 3
  //single row, standard profile (7.5mm) - 4,5 (Pin Layout 1,2) 
  //dual row, standard profile           - 6
  
  rows = ((variant == 3)||(variant==6)) ? 2 : 1;
  bdHght = (variant>=4) && (variant<=6) ? 7.5 : 3.5;
  
  cntrOffset = center ? [-pins/(2*rows)*2.54,-1.25*rows,0] : [-1.27,-1.25,0];

  holeX=0.7;
  holeY=0.7;
  drill=1.2;
  
  pinWdth=0.64;
  pinLen=(4.5-holeX)/2;
  
  translate(cntrOffset){
    if (diff=="none"){
      color("darkgrey")
      difference(){
        translate([0,0,0.2]) cube([pins*2.54/rows,2.5*rows,bdHght]);
        
        if (rows==1){
          for (i=[0:2.54:(pins-1)*2.54]){
            translate([i+1.27,1.25,(bdHght+0.2-fudge)/2+0.2]) cube([holeX,holeY,bdHght+0.2],true);
          }
        }
        else {
          for (r=[-1.27,+1.27]){ //row
            for (c=[0:2.54:(pins-1)*2.54]){ //column
              translate([c+1.27,2.5+r,(bdHght+0.2-fudge)/2+0.2]) cube([holeX,holeY,bdHght+0.2],true);
            }
          }
        }
      
      }//difference
      
      if (rows == 1){
        color("gold")
        for (i=[0:2.54*2:(pins-1)*2.54]){
          translate([i-pinWdth/2+1.27,1.25+holeY/2,0]) cube([pinWdth,pinLen,0.2]);
        }
        color("gold")
        for (i=[2.54:2.54*2:(pins-1)*2.54]){
          translate([i-pinWdth/2+1.27,+1.25-holeY/2-pinLen,0]) cube([pinWdth,pinLen,0.2]);
        }
      }
      else{
        color("gold")
        for (r=[-pinLen+2.5-1.27-holeY/2,2.5+1.27+holeY/2]){
          for (c=[0:2.54:(pins-1)*2.54/2]){
            translate([c-pinWdth/2+1.27,r,0]) cube([pinWdth,pinLen,0.2]);
          }
        }
      }
      
    } //if none
    else if (diff=="drill"){
      for (i=[0:2.54:(pins-1)*2.54]){
          #translate([i+1.27,1.25,-thick+fudge/2]) cylinder(h=thick,d=drill);
      }
    }// if drill
  }
}
