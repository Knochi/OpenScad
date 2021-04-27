import("BoneProductionsLogo.svg");

$fn=20;

/* [Dimensions] */
cptlHght=12;
xHght=8;
ascenders=cptlHght-xHght;
descenders=ascenders; //not needed
width=xHght;
ltrSpc=1.5;
stroke=1.5;
inDia=xHght-stroke*2;
fudge=0.1;

/* [Options] */
tiltB=true;
bridgeUN=true;

/* [Colors] */
lineColor="darkgrey";
boneColor="grey";
fillColor="gold";

/* [Hidden] */
fillOffset=-0.05;
prodOffset=[-xHght*1.5-ltrSpc*2,-cptlHght-ltrSpc]; //Offset between 1st and 2nd line
ltrPHght=0; //letter P top center needs to be in line (45) with letter B top center


if (tiltB) translate([xHght/2,xHght/2]) rotate(45) translate([0,-xHght/2]) ltrB();
else translate([xHght/2,0]) ltrB();
translate([xHght/2+(xHght+ltrSpc),0]) ltrO();
translate([xHght/2+(xHght+ltrSpc)*2,0]) ltrN();
translate([xHght/2+(xHght+ltrSpc)*3,0]) ltrE();
translate(prodOffset){
  translate([xHght/2                                   ,0]) ltrP();
  translate([xHght/2                  +(xHght+ltrSpc)  ,0]) ltrR(); //R
  translate([                          (xHght+ltrSpc)*2,0]) ltrO();
  translate([                          (xHght+ltrSpc)*3,0]) ltrD(); //D
  translate([                          (xHght+ltrSpc)*4,0]) ltrU();
  translate([                          (xHght+ltrSpc)*5,0]) ltrC();
  translate([                          (xHght+ltrSpc)*6,0]) ltrT(); //T
  translate([stroke/2        +ltrSpc  +(xHght+ltrSpc)*6,0]) ltrI(); //I
  translate([stroke  +xHght/2+ltrSpc*2+(xHght+ltrSpc)*6,0]) ltrO(); 
  translate([stroke  +xHght/2+ltrSpc*2+(xHght+ltrSpc)*7,0]) ltrN(); 
  translate([stroke  +xHght/2+ltrSpc*2+(xHght+ltrSpc)*8,0]) ltrS(); //S
}

module ltrI(){
  color(lineColor) {
    difference(){
      intersection(){
        hull(){
          translate([0,xHght/2]) circle(d=xHght);
          translate([0,cptlHght-xHght/2]) circle(d=xHght);
        }
        translate([-stroke/2,0]) square([stroke,cptlHght]);
      }
      translate([-(stroke+fudge)/2,cptlHght-stroke*2]) square([stroke+fudge,stroke]);
    }
  }
  color(fillColor) translate([-(stroke)/2,cptlHght-stroke*2-fillOffset]) square([stroke,stroke+fillOffset*2]);
}

module ltrT(){
  color(lineColor) translate([0,xHght/2]){
    translate([-xHght/2,0]) square([stroke,cptlHght-xHght/2]);
    translate([-xHght/2-stroke,cptlHght-xHght/2-stroke*2]) square([stroke+xHght/2,stroke]);
    difference(){
      intersection(){
        circle(d=xHght);
        translate([-xHght/2,-xHght/2]) square(xHght/2);
      }
    circle(d=inDia);
    }
  }
  color(fillColor) offset(fillOffset) translate([0,xHght/2]){
    intersection(){
      circle(d=inDia);
      translate([-inDia/2,-inDia/2]) square(inDia/2);
    }
    translate([-inDia/2,0]) square([inDia/2,cptlHght-xHght/2-stroke*2]);
  }
}
module ltrD(){
  ltrO();
  color(lineColor) translate([xHght/2-stroke,xHght/2]) square([stroke,cptlHght-xHght/2]);
}

module ltrR(){
  difference(){
    ltrN();
    square([xHght/2,xHght]);
  }
  color(lineColor) translate([-xHght/2,xHght/2]) square([stroke,xHght/2]);
}

module ltrC(){
  translate([xHght/2,xHght/2]) rotate(90) ltrN();
}
module ltrU(){
  translate([0,xHght]) mirror([0,1]) ltrN();
}

module ltrE(){
  color(lineColor) translate([0,xHght/2]) {
    difference(){
      circle(d=xHght);
      circle(d=inDia);
      translate([0,-xHght/2+stroke]) square([xHght/2,(inDia-stroke)/2]);
    }
  square([inDia,stroke],true);
  }

  color(fillColor) translate([0,xHght/2]) offset(fillOffset) {
    difference(){
      circle(d=inDia);
      translate([0,0]) square([inDia,stroke],true);
    }
    intersection(){
      translate([0,-xHght/2+stroke]) square([xHght/2,(inDia-stroke)/2]);
      circle(d=xHght);
    }
  }
}

module ltrS(){
  color(lineColor) translate([0,xHght/2]) {
    difference(){
      circle(d=xHght);
      circle(d=inDia);
      translate([-xHght/2,-xHght/2+stroke]) square([xHght/2,(inDia-stroke)/2]);
      translate([0,stroke/2]) square([xHght/2,(inDia-stroke)/2]);
    }
  square([inDia,stroke],true);
  }

  color(fillColor) translate([0,xHght/2]) offset(fillOffset) {
    difference(){
      circle(d=inDia);
      translate([0,0]) square([inDia,stroke],true);
    }
    intersection(){
      circle(d=xHght);
      union(){
        translate([-xHght/2,-xHght/2+stroke]) square([xHght/2,(inDia-stroke)/2]);
        translate([0,stroke/2]) square([xHght/2,(inDia-stroke)/2]);
      }
      
    }
  }
}

module ltrN(){
  translate([0,xHght/2]){
    color(lineColor) difference(){
      circle(d=xHght);
      circle(d=inDia);
      translate([0,-xHght/4]) square([inDia,xHght/2],true);
      
    }
    color(fillColor) offset(fillOffset) {
      circle(d=inDia);
      intersection(){
        translate([0,-xHght/4]) square([inDia,xHght/2],true);
        circle(d=xHght);
      }
    }
  }
}

module ltrB(){  
    difference(){      
      translate([0,cptlHght-xHght]) ltrO();
      translate([0,xHght/2]) circle(d=xHght);
    }
    ltrO();
    color(lineColor) translate([-xHght/2,xHght/2]) square([stroke,ascenders]);
}

module ltrP(){
  translate([0,cptlHght-xHght]) ltrO();
  color(lineColor) translate([-xHght/2,0]) square([stroke,cptlHght-xHght/2]);
}

module ltrO(){
  // O
  translate([0,xHght/2]){
    color(lineColor) difference(){
    circle(d=xHght);
    circle(d=inDia);
    }
    color(fillColor) offset(fillOffset) circle(d=inDia);
  }
}
  