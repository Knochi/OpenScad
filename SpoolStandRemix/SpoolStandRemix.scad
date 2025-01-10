/* [show] */
showStand=true;
showLabel=true;
showCut=true;
showSwatch=true;


ovDims=[74,150,35];

lblDims=[29.6,1.2,15];
lblSpcng=0.1;
lblPos=[ovDims.x/2,0.8,1.0];
fudge=0.1;

if (showStand)
difference(){
  union(){
    import("SpoolStand.stl",convexity=4);
    //close the angled slot
    translate([ovDims.x/2,3.94,3.00]) cube([29,3.2,4],true);
  }
  if (showCut) color("darkred") translate([ovDims.x,ovDims.y/2,ovDims.z/2]) cube(ovDims+[0.1,0.1,0.1],true);
  //add a vertical slot
  *translate([ovDims.x/2,2.6,4]) cube([28,1.2,5],true);
  //add an angled slot (but more to the back)
  *translate([ovDims.x/2,5.05,3.89]) rotate([-25,0,0]) cube([28,1.2,5],true);
  //cut out for front label
  translate([lblPos.x,(lblDims.y+lblPos.y)/2,5-(5-lblPos.z-2-fudge)/2]) 
    cube([lblDims.x+lblSpcng,lblDims.y+lblPos.y+lblSpcng*2,5-lblPos.z-2+fudge],true);
  translate(lblPos+[0,lblDims.y/2,1]) cube([24+lblSpcng*2,lblDims.y+lblSpcng*2,2+lblSpcng*2],true);
}
if (showLabel)
  color("grey") translate(lblPos+[-lblDims.x/2,0,0]) rotate([90,-90,180]) import("LabelToBeCustomized.stl");
