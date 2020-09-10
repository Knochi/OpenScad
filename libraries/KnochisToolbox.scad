module twoByTwo(size=[5,5]){
  for (ix=[-1,1],iy=[-1,1])
    translate([ix*size.x/2,iy*size.y/2,0]) children();
}

// circle segment height from radius and chord length
function segmentHght(s,r)=r-0.5*sqrt(4*pow(r,2)-pow(s,2));