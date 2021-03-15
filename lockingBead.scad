$fn=50;
innerDia=5.2;
outerDia=10;
length=15;
fudge=0.1;
spcng=0.3;
minWallThck=2;

difference(){
  slottedBead(outerDia,innerDia,length);
  slottedBead(outerDia-minWallThck+spcng,innerDia-spcng,length/2+spcng);
  translate([outerDia/2,0,0]){
    cube([outerDia+(minWallThck+spcng)*2,outerDia+fudge,minWallThck+spcng],true);
    cube([minWallThck*2,outerDia,length+fudge],true);
  }
}

rotate(0){
  slottedBead(outerDia-minWallThck-spcng,innerDia,length/2-spcng);
  translate([0,-outerDia/2,0])
    cylinder(d=minWallThck,h=minWallThck,center=true);
  translate([0,-outerDia/2+minWallThck/2,0])
    cube(minWallThck,center=true);
}



module slottedBead(outerDia,innerDia,length){
  difference(){
    cylinder(d=outerDia,h=length,center=true);
    cylinder(d=innerDia,h=length+fudge,center=true);
    translate([outerDia/2,0,0]) cube([outerDia,innerDia,length+fudge],center=true);
  }
}