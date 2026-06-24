$fn=48;
pcb22W_TFT();

translate([0,39,0]) rotate([0,90,0]) cylinder(d=18,h=65,center=true);

module pcb22W_TFT(){
// 22.5W charger module with color TFT display
// https://de.aliexpress.com/item/1005009524999358.html
  pcbDims=[61.5,25.5,1];
  pcbSitesHght=22.9;
  pcbCntrWidth=18.5;
  crnrRad=4.6;
  usbADist=32.5;
  usbADims=[13.5,9.84,6];
  usbAZOffset=1.2;
  displayDims=[29.6,15.5,5.4];
  btnDims=[2.45,7,3.5];
  btnPos=[-(pcbDims.x-btnDims.x)/2,pcbDims.y-8.1,-btnDims.z/2];
  
  sitesYOffset=pcbDims.y-pcbSitesHght+crnrRad;
  color("darkGreen") 
    linear_extrude(pcbDims.z) translate([-pcbDims.x/2,0]) difference(){
      union(){
        translate([0,sitesYOffset]) square([pcbDims.x,pcbSitesHght-crnrRad]);
        translate([crnrRad,sitesYOffset]) circle(crnrRad);
        translate([crnrRad,sitesYOffset-crnrRad]) square([pcbDims.x-crnrRad*2,crnrRad]);
        translate([pcbDims.x-crnrRad,sitesYOffset]) circle(crnrRad,$fn=4);
        translate([(pcbDims.x-pcbCntrWidth)/2,0]) square([pcbCntrWidth,pcbDims.y]);
      }
      for (ix=[-1,1])
        translate([pcbDims.x/2+ix*(pcbCntrWidth+usbADims.x+0.4)/2,usbADims.y/2]) offset(0.2) 
          square([usbADims.x,usbADims.y],true);
    }
  //USB-A sockets
  for (ix=[-1,1])
    translate([ix*usbADist/2,usbADims.y/2,-usbADims.z/2+pcbDims.z+usbAZOffset]) cube(usbADims,true);
  //display
  translate([0,pcbDims.y-displayDims.y/2,pcbDims.z+displayDims.z/2]) cube(displayDims,true);
  //button
  translate(btnPos) cube(btnDims,true);
}
