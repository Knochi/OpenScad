 $fn=20;





module RYB080I(){
  //Reyax Bluetooth Module BLE 4.2 & 5.0
  //https://reyax.com/products/ryb080i/

  poly=[[-5.5,-5.5],[5.5,-5.5],[5.5,2.4],[5.5-2.8,2.4],
        [5.5-2.8,5.5],[-3.3,5.5],[-3.3,3.2],[-5.5,3.2]];
  padDims=[0.7,0.7,0.87];

  difference(){
    union(){
      color("darkSlateGrey") linear_extrude(0.8) polygon(poly);
      color("silver") translate([-4.6,-4.6,0.8]) cube([11-1.8,6.6,1.4]);
      color("ivory") translate([-1,2+1.8,0.8]) cube([3,1.6,0.8]);
      for (ix=[-1,1], iy=[0:6])
        color("gold") translate([ix*(5.535-padDims.x/2),-4.5+iy,0.4]) 
          cube(padDims,true);
      for (ix=[-3.5:3.5])
        color("gold") translate([ix,-5.5+padDims.x/2,0.4]) 
          rotate(90) cube(padDims,true);
    }
    for (ix=[-1,1], iy=[0:6])
        color("gold") translate([ix*(5.5),-4.5+iy,0.4]) 
          cylinder(d=0.5,h=0.9,center=true);
    for (ix=[-3.5:3.5])
        color("gold") translate([ix,-5.5,0.4]) 
          rotate(90) cylinder(d=0.5,h=0.9,center=true);
    color("darkgrey") translate([0,0,0.8+1.4-0.1]) linear_extrude(0.2) text("REYAX",size=1.2,valign="center",halign="center");
    color("darkgrey") translate([0,-2,0.8+1.4-0.1]) linear_extrude(0.2) text("RYB080I",size=1.2,valign="center",halign="center");
  }
}