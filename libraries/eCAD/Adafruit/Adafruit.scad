use <eCad\packages.scad>
use <eCad\Connectors.scad>
include <eCad\KiCADColors.scad>


module TrinketM0(){
  PCBThck=0.8;

  color("#222222") linear_extrude(PCBThck) import("TrinketM0PCB.svg");
  translate([8.7,17,PCBThck]) QFN(28);
  translate([6.1,12.4,PCBThck]) APA102();
}

featherM0basic();
module featherM0basic(cut=false){
  PCBThck=1.6;
  PCBDims=[50.8,22.86,PCBThck];
  mUSBPos=[2.5,PCBDims.y/2,PCBThck];
  QFNPos=[24.1,9.65,PCBThck];
  drillDist=[1.8*25.4,0.7*25.4];
  drillDia=2.0;
  
  if (cut)
    for(ix=[-1,1],iy=[-1,1])
      translate([ix*drillDist.x/2,iy*drillDist.y/2])
      circle(d=drillDia);
  else{
    translate([-PCBDims.x/2,-PCBDims.y/2,0]){
      color(pcbBlackCol)  linear_extrude(PCBThck) import("FeatherM0basicPCBedge.svg");
      translate(mUSBPos) rotate(-90) mUSB();
      translate(QFNPos) QFN(48);
    }
  }
}