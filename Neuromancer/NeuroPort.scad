$fn=50;

cntrDia=14;
bWdth=3;
bLen=34;

pWdth=7.4;
pLen=26;
pThck=0.82;

%translate([-18.6,-7.1]) import("NeuroPort.svg");
!plate();

module plate(){
  pWngWdth=(pWdth-bWdth)/2;
  poly=[[-pLen/2,bWdth/2],[-pLen/2+pWngWdth,pWngWdth+bWdth/2],[pLen/2-pWngWdth,pWngWdth+bWdth/2],[pLen/2,bWdth/2],
        [pLen/2,-bWdth/2],[pLen/2-pWngWdth,-(pWngWdth+bWdth/2)],[-(pLen/2-pWngWdth),-(pWngWdth+bWdth/2)],[-pLen/2,-bWdth/2]];
  linear_extrude(pThck) polygon(poly);  
}

module buckle(){
  
}

difference(){
  union(){
    circle(d=cntrDia);
    translate([-1.6,0,0]) square([bLen,bWdth],true);
  }
  circle(r=1.6);
}
