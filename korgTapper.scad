$fn=20;
fudge=0.1;

korgHousing();
module korgHousing(){
  wallThick=1.75;
  outerDims=[98.8,61.7,6.9];
  innerDims=[outerDims.x-wallThick*2,outerDims.y-wallThick*2,4.75];
  rad=2.85;
  hdJckRcsDims=[32.4,13.65,0.5];
  hdJckRcsPos=[(innerDims.x-hdJckRcsDims.x)/2,
               (innerDims.y-hdJckRcsDims.y)/2-6,
              -(innerDims.z+(hdJckRcsDims.z-fudge)/2)];
  hdJckLatchDims=[[7.7,3.3],[3.6,9.5]];
  shrkFinPoly=[[0,0],[0,7.5],[3.5,4.8],[3.8,4.8],[3.8,0]];
  batRipDims=[57.5,0.65,1.7];
  latchDims=[12.85,0.9,1.8];
  
  for (iy=[0,-(8.1+0.65)])
    translate([(innerDims.x-batRipDims.x)/2-12.4,
              -(innerDims.y-batRipDims.y)/2+10.6+iy,
              -innerDims.z+batRipDims.z/2]) cube(batRipDims,true);
  //Fin
  translate([innerDims.x/2-3.8,outerDims.y/2-4.5,-innerDims.z]) 
    rotate([90,0,0]) linear_extrude(1.1) polygon(shrkFinPoly);
  //latch
  translate([(outerDims.x-1.25)/2-1.25,(innerDims.y-9.6)/2-30.8,-innerDims.z+6.1/2]) 
    cube([1.25,9.6,6.1],true);
  //shell
  difference(){
    translate([0,0,-(outerDims.z-rad)]) rotate([90,0,90]) linear_extrude(outerDims.x,center=true){
      hull() for(ix=[-1,1])
        translate([ix*(outerDims.y/2-rad),0]) circle(rad);
        translate([-outerDims.y/2,0]) square([outerDims.y,outerDims.z-rad]);
    }
    translate([0,0,-(innerDims.z-fudge)/2]) cube(innerDims+[0,0,fudge],true);
    
    //headjack cutouts
    translate(hdJckRcsPos)
      cube(hdJckRcsDims+[0,0,fudge],true);
    translate([(innerDims.x-hdJckLatchDims[0].x)/2-12.5,
               (innerDims.y-hdJckLatchDims[0].y)/2-17.3,-(outerDims.z)/2-fudge]) 
      cube([hdJckLatchDims[0].x,hdJckLatchDims[0].y,outerDims.z+fudge],true);
    translate([(innerDims.x-hdJckLatchDims[1].x)/2-5.6,
               (innerDims.y-hdJckLatchDims[1].y)/2-8.75,-(outerDims.z)/2-fudge]) 
      cube([hdJckLatchDims[1].x,hdJckLatchDims[1].y,outerDims.z+fudge],true);
    
    
    translate([(innerDims.x-fudge)/2,hdJckRcsPos.y-0.5,0]) 
      rotate([0,90,0]) cylinder(d=11,h=wallThick+fudge);
    
    circRcsXPos=(innerDims.x-hdJckLatchDims[1].x)/2-5.6;
    
    translate([circRcsXPos,hdJckRcsPos.y-0.5,0]) 
      rotate([0,90,0])cylinder(d=12.5,h=innerDims.x/2-circRcsXPos);
    
    // locking
    // across
    translate([-(innerDims.x-14.5)/2+9.2,0,0]){
      translate([0,0,-(1.4-fudge)/2]) cube([14.5,outerDims.y+fudge,1.4+fudge],true);
      translate([0,0,-1.4-latchDims.z/2-1]) 
        cube([latchDims.x,innerDims.y+latchDims.y*2,latchDims.z],true);
    }
    // along
    translate([(innerDims.x+latchDims.y)/2,0,-latchDims.z/2-1]){
      translate([0,-(innerDims.y-11.3)/2+3.4,0]) 
        cube([latchDims.y+fudge,11.3,latchDims.z],true);
      translate([0,(innerDims.y-7.5)/2-20.2,0]) 
        cube([latchDims.y+fudge,7.5,latchDims.z],true);
    }
    
  }//difference
  
}
