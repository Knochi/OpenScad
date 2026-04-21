$fn=50;

pinDia=4.5;
pinLen=30;

difference(){
  translate([0,0,pinDia*0.33]) rotate([90,0,0]){
    cylinder(d=pinDia,h=pinLen-pinDia*0.4,center=true);
    cylinder(d=pinDia*1.2,h=2,center=true);
    translate([0,0,pinLen/2-pinDia*0.2]) cylinder(d1=pinDia,d2=pinDia*0.8,h=pinDia*0.2);
    mirror([0,0,1]) translate([0,0,pinLen/2-pinDia*0.2]) cylinder(d1=pinDia,d2=pinDia*0.8,h=pinDia*0.2);
  }
  
  translate([0,0,-pinDia/2]) cube([pinDia*1.2,pinLen+0.1,pinDia],true); 
}