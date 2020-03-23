fudge=0.1;

M3Rivet();

module M3Rivet(){
  //RS Expansion insert 
  color("gold")
  
  difference(){
    union(){
      cylinder(h=4.78,d=4);
      cylinder(h=3.78,d=4.22);
    }
    translate([0,0,-fudge/2]) cylinder(h=4.78+fudge,d=2.5);
    translate([0,0,4/2]) cube([0.5,4.5,4+fudge],true);
  }
}