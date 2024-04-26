//assembly of the Marble Clock from Instructables
//https://www.instructables.com/Marble-Clock/
//reverse engineering project


//TODOs
//turn around the whole thing, the "fall tower" belongs to the right

*translate([0,-44,0]) rotate([90,0,0]) translate([83,99,-8])  import("1a.stl");

//left back pillar
translate([0,8,0]){
  rotate([90,0,180]) translate([-179.5,-70,0]) import("1b.stl");
  color("grey") for (iz=[46.7,90.7,134.7]){
    translate([13,-5,iz]) rotate([0,-4,0]) import("hold_piece.stl");
    translate([56,-5,iz+3]) rotate([0,-4,0]) import("hold_piece.stl");
    if (iz>50) translate([56,-25,iz-9]) rotate([0,6,0]) import("hold_piece.stl");
  }
}

translate([-50,0,0]) rotate([90,0,90]) import("1c.stl");

//left rails
translate([111,0,150.5]) rotate([90,4,180]) import("1d.stl");
translate([76,0,104.1]) rotate([90,4,180]) import("1e.stl");
translate([76,-14,60.1]) rotate([90,-4,0]) import("1f.stl");

//small rails
translate([52,-14,134.6]) rotate([90,6,0]) import("1g1.stl");
translate([52,-14,90.6]) rotate([90,6,0]) import("1g2.stl");

translate([195,16,0]) rotate([90,0,180]) translate([83,99,-8]) import("2a.stl");
translate([200,0,0]) rotate([90,0,-90]) import("2b.stl");
translate([230,0,170]) rotate([90,0,180]) import("2d.stl");

