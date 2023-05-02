import("./STLs/Gridfinity Divider Bins/Divider Box 2x1x2 5-Compartment.stl");
fudge=0.1;
labelSize=[16.9-1.2+fudge,10+1.65+fudge];
labelSize2=[33.24-18.12+fudge,10+1.65+fudge];
lablBlckHght=12.8-7.1;
binDist=34.451-18.12;
rad=1.8;
$fn=20;
echo(40.8-39.15);

blocks();

module blocks(){
  translate([1.2-fudge/2,40.8-labelSize.y+fudge,7.2-fudge]) labelBlock(labelSize);
  translate([67.08-fudge/2,40.8-labelSize.y+fudge,7.2-fudge]) labelBlock(labelSize);
  for (ix=[0:2])
    translate([ix*binDist+18.12-fudge/2,40.9-labelSize2.y+fudge,7.2-fudge]) labelBlock(labelSize2);
}
  
*labelBlock(labelSize);
module labelBlock(size){
  rad=2.00;
  translate([size.x/2,size.y/2]) difference(){
   linear_extrude(lablBlckHght) hull() for (i=[-1:1]){
    translate([i*(size.x/2-rad),(size.y/2)-rad]) circle(rad); //back
    translate([i*(size.x/2-rad),-(size.y/2)]) square(rad*2,true); //front
    }
    hull() for (ix=[-1,1],iz=[-1,1])
      translate([ix*(size.x/2-rad),-size.y/2-rad,iz*(lablBlckHght-rad)+lablBlckHght]) sphere(rad);
  }
}


/*
GF_cut();
translate([0.01,0,20.7]) GF_cut("darkGreen");

module GF_cut(col="darkred"){
  intersection(){
    import("./STLs/Gridfinity Divider Bins/Divider Box 2x1x3 5-Compartment.stl",convexity=10);
    color(col) cube([10,43.5,25]);
    }
}
*/
