module twoByTwo(size=[5,5]){
  for (ix=[-1,1],iy=[-1,1])
    translate([ix*size.x/2,iy*size.y/2,0]) children();
}