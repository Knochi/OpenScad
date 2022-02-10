$fn=20;

width=23;
thick=2;
slice1=9;
slice2=20;
slice3=12.5;
angle1=20;
angle2=79;


//cubes
translate([slice1/2,0,0]) cube([slice1,width,thick],true);
translate([slice1,0,0]){
  #rotate([90,0,0]) cylinder(d=thick,h=width,center=true);
  rotate([0,angle1,0]){
    translate([slice2/2,0,0]) cube([slice2,width,thick],true);
    //slice3
    translate([slice2,0,0]){
      rotate([0,angle2-angle1,0]) translate([slice3/2,0,0]) cube([slice3,width,thick],true);
      #rotate([90,0,0]) cylinder(d=thick,h=width,center=true);
    }
  }
}