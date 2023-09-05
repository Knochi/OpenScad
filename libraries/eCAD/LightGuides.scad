use <bezier.scad>

$fn=20;
fudge=0.1;


*translate([20.36+1,0,0]) import("sources/1271_2001.stl");  

Mentor_1271_2001();
module Mentor_1271_2001(){
  crnRad=0.1;
  translate([0,-1.2,2.54]) rotate([90,0,0]) cylinder(d=2,h=7.68-1.2);
  translate([0,-7.1,2.54]) rotate([90,0,0]) sphere(1.00);
  //post
  translate([0,0,-2.1]) linear_extrude(2.1) rotate(30) offset(crnRad) circle(d=1.1-crnRad,$fn=3);
  //foot
  translate([0,2.1/2-1.2,1.56/2]) cube([2,2.1,1.56],true);
  translate([0,1.76/2-1.2,1.56+1.98/2]) cube([2,1.76,1.98],true);
  //ramp
  poly=[[0,0],[0,1.98],[2.9,2.1-1.56],[2.9,0]];
  translate([0,0.56,1.56]) rotate([90,0,90]) linear_extrude(2,center=true) polygon(poly);
}

Mentor_1276_2004();
module Mentor_1276_2004(){
  //https://www.mentor.de.com/bauelemente/product/1276-2004/
  crv4=7.5; //curvature
  crv3=5.5;
  crv2=3.5;
  crv1=1.5;

  LEDPos4=[5.6,2.1];
  LEDPos3=[1.8,2.1];
  LEDPos2=[-2,2.1];
  LEDPos1=[-5.8,2.1];

  tipPos4=[-10.7,16.7];
  tipPos3=[-10.7,12.9];
  tipPos2=[-10.7,9.1];
  tipPos1=[-10.7,5.3];

  tipPositions=[tipPos4,tipPos3, tipPos2, tipPos1];
  LEDPositions=[LEDPos4,LEDPos3,LEDPos2,LEDPos1];

  color("white",0.5) lightGuide();
  color("darkSlateGrey")diaphragm();

  module diaphragm(){
    ovDims=[16.3,4.5,3.8];
    translate([0,0,1.2]) difference(){
      translate([0,0,3.8/2]) cube(ovDims,true);
      translate([0,0,3.8-(2.5-fudge)/2]) cube([16.3+fudge,3.15,2.5+fudge],true);
      for (i=LEDPositions)
        translate([i.x,0,2/2]) cube([3.3,4,2+fudge],true);
      
      translate([0,0,ovDims.z-2.5/2]) cube([6.7,ovDims.y+fudge,2.5+fudge],true);
    }
  }
                     
  module lightGuide(){
    
    curvatures=[crv4,crv3,crv2,crv1];

    
    basPoly=[[0,11.3/2],[3.1,11.3/2],[3.1,-11.3/2],[0,-11.3/2],[0,-(11.3/2-3)],
             [2.5,-(11.3/2-3-0.45)],[2.5,11.3/2-3-0.45],[0,(11.3/2-3)]];
    //base
    translate([(20.5-13.9)/2,0,0]) rotate([0,-90,0]) linear_extrude(20.5-13.9) polygon(basPoly);
    //stiffeners
    for (i=[0,1]){
      mirror([0,i,0]) translate([-1.5/2+1.5,-4.1-1.5,3.1]) rotate([90,0,90]) 
        linear_extrude(1.5) polygon([[0,0],[4.1,0],[4.1,2.5]]);
      mirror([0,i,0]) translate([-1.5/2-2.55,-4.1-1.5,3.1]) rotate([90,0,90]) 
        linear_extrude(1.5) polygon([[0,0],[4.1,0],[4.1,2.5]]);
    }
    
    //tips
    for (i=[5.3,9.1,12.9,16.7]){
      translate([-17.2,0,i]) rotate([0,90,0]) cylinder(d=3,h=4.5);
      translate([-17.2+4.5,0,i]) rotate([0,90,0]) 
      hull(){
        translate([0,0,2-fudge/2]) cube([3,3,fudge],true);
        cylinder(d=3,h=1);
      }
    }
    
    //pegs
    for (i=[-1,1])
      translate([0,i*8.3/2,-2.9]) 
        union(){
          cylinder($fn=3,d=2.5,h=2.9);
          rotate(180) cylinder($fn=3,d=2.5,h=2.9);
        }
        
    //Lightguides with Bezier
    for (i=[[tipPositions[0],curvatures[0],LEDPositions[0]],
            [tipPositions[1],curvatures[1],LEDPositions[1]],
            [tipPositions[2],curvatures[2],LEDPositions[2]],
            [tipPositions[3],curvatures[3],LEDPositions[3]]])
    
    rotate([90,0,0]) translate([0,0,-1.5]) linear_extrude(3) 
      polygon(Bezier([[i[0].x,i[0].y+1.5],/*C*/OFFSET([i[1]+1.5,0]), //node 0 tip
                     OFFSET([0,i[1]+1.5]),[i[2].x+1.5,i[2].y],LINE(), //node1 led
                     LINE(),[i[2].x-1.5,i[2].y],OFFSET([0,i[1]]), //node2 led
                     OFFSET([i[1],0]),[i[0].x,i[0].y-1.5]])); //node3 tip
  }
}
