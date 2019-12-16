$fn=20;
fudge=0.1;
heatsink([9,9,5],5,3.5);
translate([12,0,0]) pushButton(col="red");
translate([12,15,0]) pushButton(col="green");
translate([12,30,0]) pushButton(col="white");
translate([-15,0,0]) rotEncoder();

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

module rotEncoder(diff="none",thick=3){
  //SparkFun Rotary Encoder COM-10982 - https://www.sparkfun.com/products/10982
  if (diff=="body"){
    union(){
      translate([0,0,-thick/2-fudge/2]){
        rndRect(12.4+1,13.2+1,thick+fudge,1,0);
        translate([0,0,0]) rndRect(11,15+1,thick+fudge,1,0);
      }
    }
  }
  else if (diff=="dome"){
    translate([0,0,-thick/2-fudge/2]) cylinder(h=thick+fudge,d=9+1);
  }
  else{
    union(){
      color("darkgrey") translate([0,0,0])
        hull() for (ix=[-1,1],iy=[-1,1])
          translate([ix*(12-1)/2,iy*(13.2-1)/2,0]) cylinder(d=1,h=7.5);//rndRect(12,13.2,7.5,1,0); //base
      color("grey") translate([-12.4/2,-11/2,fudge]) cube([12.4,11,7.5]);//base sheet
      color("lightgrey") translate([0,0,7.5-fudge]) cylinder(h=7+fudge,d=9,$fn=100); //screw dome
      color("white",0.5) translate([0,0,7.5+7.0-fudge]) cylinder(h=10.5, d=6); //handle
      color("grey") //5pins on top
        for (i=[-4.1:8.2/4:4.1]){
          translate([i-0.8/2,7,-2.9]) cube([0.8,0.3,4.3]);
        }
      color("grey") //3 pins front
        for (i=[-2.5:2.5:2.5]){
          translate([i-0.9/2,-7.5,-2.8]) cube([0.9,0.3,7]);
        }
    }//union
  }
}
