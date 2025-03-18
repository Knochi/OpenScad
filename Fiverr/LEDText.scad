
boxDims=[23,6,7];

color("darkSlateGrey") rotate([90,0,90]) import("../Makerworld/MakersSupply/3030 5V Board LED - KB001.stl");

module textString(cut=false){
  fudge= cut ? 0.1 : 0;
  translate([0,0,4]) 
    rotate([90,0,0]) 
      linear_extrude(6+fudge,center=true,convexity=3) 
        offset(0.1) text("love",size=12,font="Brush Script MT",halign="center");
      }


color("darkred") difference(){
  translate([0,0,(boxDims.z-2)/2])
    cube(boxDims,true);
  translate([0,0,(boxDims.z-2)/2])
    translate([0,0,2]) cube(boxDims+[-2,-1,2.1],true);
    
  textString(true);
  }
color("ivory") textString();      