trgt=[109.67,91.55];
trgt_r=[-2.52,4.37];


translate([125,80]){
  circle(23.1);
  color("lightgrey") rotate(30) circle(23.094,$fn=3); // a=40
}
color("blue") translate([125,80]) circle(1);
color("red") translate(trgt) circle(1);
trgt_M=[trgt.x+trgt_r.x,trgt.y-trgt_r.y];
echo(trgt_M);
color("darkred") translate(trgt_M) circle(1);
color("grey") translate([105,91.55]) circle(1);
trgt1=trgt+[30.655,0];

color("darkred") translate(trgt1) cylinder(1);
trgt_r1=trgt1+[2.5244,-4.37];
color("darkred") translate(trgt_r1) cylinder(1);

trgt2=trgt_r1+[-15.328,-26.548];
color("darkred") translate(trgt2) cylinder(1);