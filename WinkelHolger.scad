$fn=50;
poly=[[0,3],[0,65],[20,65],[20,20],[65,20],[65,0],[3,0]];

linear_extrude(50) difference(){
  polygon(poly);
  translate([20,20]) circle(3);
}
  