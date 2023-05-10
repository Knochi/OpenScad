bottomDia=20; //largest Dia on the bottom
topDia=5; //smallest Diameter on the Tip
slices=5; //number of slices
sliceThck=5; //thickness of each slice
$fn=50;

diaTower();

module diaTower(){
  //build a tower out of slices with reducing diameter
  diaPerSlice=(bottomDia-topDia)/(slices-1);
  echo(diaPerSlice);
  for (iz=[0:slices-1])
    translate([0,0,iz*sliceThck]) cylinder(d=bottomDia-iz*diaPerSlice,h=sliceThck);
}