use <eCad\packages.scad>

PCBThck=0.8;

linear_extrude(PCBThck) import("TrinketM0PCB.svg");
translate([8.7,17,PCBThck]) QFN28();
translate([6.1,12.4,PCBThck]) APA102();