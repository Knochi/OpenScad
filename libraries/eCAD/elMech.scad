$fn=20;
fudge=0.1;
heatsink([9,9,5],5,3.5);
translate([12,0,0]) pushButton(col="red");
translate([12,15,0]) pushButton(col="green");
translate([12,30,0]) pushButton(col="white");

module heatsink(dimensions, fins, sltDpth){
  finWdth=dimensions.x / (fins*2-1);
  bdyHght=dimensions.z - sltDpth;
  echo(bdyHght);
  
  difference(){
    translate([0,0,(dimensions.z-finWdth/2)/2]) cube(dimensions - [0,0,finWdth/2],true);
    for (i=[0:fins-2])
      translate([i*finWdth*2-(dimensions.x-finWdth)/2+finWdth,0,dimensions.z/2+bdyHght]) 
        cube([finWdth,dimensions.y+fudge,dimensions.z],true);
  }
  for (i=[0:fins-1])
      translate([i*finWdth*2-(dimensions.x-finWdth)/2,0,dimensions.z-finWdth/2]) rotate([90,0,0]) cylinder(d=finWdth,h=dimensions.y,center=true);
}
  
*pushButton(col="red");
module pushButton(panelThck=2,col="darkSlateGrey"){
  //RAFI 1.10.107, 9.1mm, 24V/0.1A
  
  translate([0,0,-20]){
    color("darkSlateGrey"){
      difference(){
        union(){
          cylinder(d=9,h=20);
          translate([0,0,20]) cylinder(d1=11,d2=10.2,h=2);
        }
        for (i=[-1,1]) translate([i*9/2,0,20-6.5-9/2]) cube([4,9,9],true);
      }
    translate([0,0,20-5.5-panelThck]) cylinder(d=11.5,h=5.5); //fixation ring
    }
    
    color(col) translate([0,0,22]) cylinder(d=7,h=2.5);
    color("silver") for (i=[-1,1]){
      difference(){
        union(){
          translate([i*2.5,0,-(5.5-2.5/2)/2]) cube([0.2,2.5,5.5-2.5/2],true);
          translate([i*2.5,0,-5.5+2.5/2]) rotate([0,90,0]) cylinder(d=2.5,h=0.2,center=true);
        }
        translate([i*2.5,0,-5.5+2.5/2]) rotate([0,90,0]) cylinder(d=0.8,h=0.3,center=true);
      }
    }
  }
}

*KMR2();
module KMR2(){
  // C and K Switches Series KMR 2
  // https://www.ckswitches.com/media/1479/kmr2.pdf
  mfudge=0.01;
  btnRad=0.6;
  btnDim=[2.1,1.6,0.5];
  //body
  color("silver") translate([0,0,0.7+mfudge]) cube([4.2,2.8,1.4-mfudge],true);
  //button (simplified)
  color("darkSlateGrey")
  hull() for (i=([-1,1]),j=[-1,1])
    translate([i*(btnDim.x/2-btnRad),j*(btnDim.y/2-btnRad),1.4]) cylinder(r=btnRad,h=btnDim.z);
    
  //pads
  color("grey") for (i=([-1,1]),j=[-1,1]){
    translate([i*(4.6-0.5)/2,j*(2.2-0.6)/2,0.1/2]) cube([0.5,0.6,0.1],true);
  }
}