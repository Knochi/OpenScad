chamfer=0.7;
holesDist=[12,13];
holesZOffset=8.9+holesDist.y/2;
screwLength=8;
solderIronDia=16.5;
screwMaxDepth=1.5;
leverAng=atan((14.6-8.5)/(35-4));

narrowing=tan(leverAng)*(screwLength-4);
widthAtBase=14.6*2-narrowing*2;
baseScale=widthAtBase/(14.6*2);

leverLength=81;
fudge=0.1;
$fn=26;
//modify the base for other screw Length
difference(){
  union(){
    translate([-(116.4+133.6)/2,-61.75,0]) import("HolderArm_20mm_v1.3.stl",convexity=4);
    translate([0,0,30.8/2]) rotate([-90,0,0]) linear_extrude(4)  
      offset(delta=chamfer,chamfer=true) square([29.2-chamfer*2,30.8-chamfer*2],true);
    translate([0,4,30.8/2]) rotate([-90,0,0]) linear_extrude(screwLength-4, scale=[baseScale,1])  
      offset(delta=chamfer,chamfer=true) square([29.2-chamfer*2,30.8-chamfer*2],true);
    //fill the hole for the iron
    translate([0,leverLength,0]) cylinder(d=21,h=30.8);
  }
  translate([0,-0.1,30.8]) rotate([-90,0,0]) linear_extrude(screwLength,convexity=6) for (ix=[-1,1],iy=[-1,1])
      translate([ix*holesDist.x/2,holesZOffset+iy*holesDist.y/2]){
        circle(d=2.2);
        translate([0,-1.1]) circle(d=0.5);
    }
  translate([0,screwLength-screwMaxDepth,30.8]) rotate([-90,0,0]) 
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*holesDist.x/2,holesZOffset+iy*holesDist.y/2]){
        cylinder(d=4,h=4);
        translate([0,0,4]) sphere(d=4);
    }
  translate([0,leverLength,-fudge/2]) cylinder(d=solderIronDia,h=30.8+fudge);
  translate([-2,81,-fudge/2]) cube([4,103-81,30.8+fudge]);
}

//modify the diameter

*translate([-2,81,0]) cube([4,103-81,30.8]);
