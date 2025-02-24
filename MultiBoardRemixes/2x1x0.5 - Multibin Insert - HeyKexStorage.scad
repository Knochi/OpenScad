// Hex Key / Allen Key 
$fn=50;

/* [Bin dimensions] */
ovDims=[93,43,17.6];
maxDeep=13.2;
wallThck=1;
chamfer=9.00;
axisOffset=[-2,0,11];
keyPos=[[9,-16],[3,-10],[2,-4],[4,2]];
keyDias=[4.4,3.26,2.7,1.69];
keyHghts=[56.8,56.8,53.2,46.8];
keyWdths=[21.3,21.3,18.9,15.7];

/* [show] */
showMagnets=true;

translate(axisOffset) rotate([90,0,0]) cylinder(d=3,h=ovDims.y-wallThck*2,center=true);

difference(){
  import("2x1x0.5 - Multibin Insert - STL Remixing File.stl",convexity=4);
  translate([(ovDims.x-ovDims.y)/2,0,ovDims.z-maxDeep])
    linear_extrude(maxDeep) 
      offset(delta=chamfer-wallThck,chamfer=true) 
        square([ovDims.x-chamfer*2,ovDims.y-chamfer*2],true);
}


  for (i=[0:len(keyPos)-1])
    translate([keyPos[i].x,keyPos[i].y,axisOffset.z]) rotate([90,0,90]){ 
      color("darkSlateGrey") hexKey(dia=keyDias[i],height=keyHghts[i],width=keyWdths[i]);
      //magnet d5 x 1 CA002
      if(showMagnets) translate([0,+0,-1-wallThck]) cylinder(d=5,h=1);
    }


module hexKey(dia=4,height=50,width=14,spcng=0.2,radius,cut=false){
  //length are overall dimensions including radius and thickness
  radius = is_num(radius) ? radius : dia;
  l1=height-radius-dia/2;
  l2=width-radius-dia/2;
  
  if (cut)
    offset(spcng) circle(d=dia,$fn=6);
  else {
    rotate(180/6) linear_extrude(l1) circle(d=dia,$fn=6);
    translate([radius,0,l1]) rotate([90,-90,0]) rotate_extrude(angle=90) 
      translate([radius,0,0]) rotate(180/6) circle(d=dia,$fn=6);
    translate([radius,0,l1+radius]) rotate([0,90,0]) linear_extrude(l2) rotate(180/6) circle(d=dia,$fn=6);
  }
}


