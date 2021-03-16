$fn=20;
fudge=0.1;
heatsink([9,9,5],5,3.5);
translate([12,0,0]) pushButton(col="red");
translate([12,15,0]) pushButton(col="green");
translate([12,30,0]) pushButton(col="white");
translate([-15,0,0]) rotEncoder();
translate([-15,30,0]) microStepper();
translate([30,0,0]) SMDSwitch();
translate([-40,0,0]) AirValve();
translate([-80,0,0]) AirPump();
translate([-140,0,0]) SSR();


*PT15();
module PT15(rotor="R",center=true){
  cntrOffset= center ? [[0,0,0],[0,0,0]] : [[0,0,10],[90,0,0]];
  //body
  translate(cntrOffset[0]) rotate(cntrOffset[1]){
     linear_extrude(6) difference(){
      circle(d=15);
      circle(d=5);
    }
    difference(){
      color("ivory") translate([0,0,0.5]) cylinder(d=5,h=5);
      linear_extrude(6) rotorR();
    }
  }

  module rotorR(){
    difference(){
            circle(d=4);
            translate([-(4.02+fudge)/2,4.02/2-(4.02-3.52),0]) square(4.02+fudge);
          }
  }
}

module microStepper(angle=0){
  //Machifit GA12BY15
  color("gold") translate([0,0,-9/2]) cube([12,10,9],true); //gearbox
  
  color("silver"){
    //shaft
    rotate(angle){
      difference(){
        cylinder(d=3,h=10);
        translate([3-0.5,0,1+9/2]) cube([3,3,9+fudge],true);
      }
      cylinder(d=4,h=0.8);
    }
    //motor body
    translate([0,0,-19.8]) cylinder(d=12,h=10.8);
  }
}


module SSR(){
  //Solid State Relay
  //e.g. Fotek SSR-40 DA

  bdDims=[60,45.4,22.1];
  pltDims=[62.5,44.4,2.65];
  color("whiteSmoke") translate([0,0,1.1]) body();
  color("silver") plate();

  module body(){
    sltWdth=(bdDims.x-37-10)/2;
    difference(){
      translate([0,0,bdDims.z/2])  cube(bdDims,true);
      //mounting holes
      for (ix=[-1,1]){
        translate([ix*(37+10)/2,0,-fudge/2]) cylinder(d=10,h=bdDims.z+fudge);
        translate([ix*((bdDims.x-sltWdth)/2+fudge),0,bdDims.z/2]) cube([sltWdth+fudge,10,bdDims.z+fudge],true);
      }
      //screw terminals
      for (ix=[-1,1],iy=[-1,1]){
        translate([ix*((bdDims.x-11.6)/2+fudge),iy*(16.75+10.8)/2,bdDims.z-8/2]) cube([11.6+fudge,10.8,8+fudge],true);
      translate([0,0,bdDims.z-0.8/2]) cube([30.25,43.3,0.8+fudge],true);
        
      }
    }
  }

  module plate(){
    linear_extrude(pltDims.z) difference(){
      square([pltDims.x,pltDims.y],true);
      translate([(pltDims.x-4.8)/2-4.6,0]) circle(d=4.8);
      translate([-((pltDims.x-7.3)/2-3.75),0])
        hull() for (ix=[-1,1])
            translate([ix*(7.3-4.4)/2,0]) circle(d=4.4);
    }
  }


}

*MEN1281();
module MEN1281(){
  for (ix=[-1,1]){
    translate([ix*(10-2.5)/2,0,1.2])
      cube([2.5,5,2.4],true);
    translate([ix*(10-2.5)/2,0,-3.1]) cylinder(d=2.5,h=3.1);
    }
    translate([0,0,5.4]) cylinder(d=3,h=7-5.4);
    translate([0,1.5,2.4]) rotate([90,0,0]) 
      linear_extrude(3) 
        polygon([[-5,0],[-5,1],[-5+1.6,1],[-1.5,3],
                 [1.5,3],[5-1.6,1],[5,1],[5,0]]);
    
}
*AirPump();
module AirPump(){
  //CJP37-C12A2
  mtrDia=24.1;
  mtrLngth=31;
  bdyDia=27.1;
  bdyLngth=27.3;
  rad=1;
  flngDims=[36.6,10];
  
  color("grey") cylinder(d=mtrDia,h=mtrLngth);
  color("ivory") translate([0,0,mtrLngth+0.6]) cylinder(d=bdyDia,h=bdyLngth);
  color("silver"){
    hull(){
      translate([0,0,mtrLngth]) cylinder(d=bdyDia+0.6,h=0.6);
      translate([29.8-rad-(bdyDia+0.6)/2,-(bdyDia+0.6)/2+36.6/2,mtrLngth+0.3]) 
        cube([0.1,36.6,0.6],true);
    }
  //flange
    translate([29.8-rad-(bdyDia+0.6)/2,flngDims.x-(bdyDia+0.6)/2,mtrLngth]) rotate(-90)
      bend([flngDims.x,0,0.6],90,rad) 
        linear_extrude(0.6) difference(){
          union(){
            hull() for (ix=[0,1]) 
              translate([ix*(flngDims.x-rad*2)+rad,flngDims.y-rad*2]) circle(rad);
            translate([0,0]) square([flngDims.x,flngDims.y-2*rad]);
          }
        translate([4.3/2+2.5,flngDims.y-rad-4.3/2-2.5]) circle(d=4.3);
      }
    }
  //pipe
    color("ivory") translate([0,0,mtrLngth+bdyLngth]){ 
      cylinder(d=4,h=5.3);
      translate([0,0,5.3]){
        cylinder(d=4.8,h=1);
        translate([0,0,1]) cylinder(d1=4.8,d2=3,h=3);
      }}
}

*AirValve();
module AirValve(clamp=false){
  // CEME 5000EN1,5P; SH-V08298C-R(C1)4
  
  bdyDia=23.5;
  bdyLngth=30;
  pipDia=4.9;
  
  clmpDims=[38,15,30];
  clmpSpcng=1;
  clmpDrill=4.2;
  
  clmpOffset= (clamp) ? [0,-bdyLngth/2,bdyDia/2+(clmpDims.z-bdyDia)/2] : [0,0,0];
  
  translate(clmpOffset) rotate([-90,0,0]){
    //body
    color("teal") cylinder(d=bdyDia,h=bdyLngth);
    
    //contacts
    for (ix=[-1,1]){
      color("teal") translate([ix*16.8/2,0,-1.2]) cube([4,7.5,2.4],true);
      color("silver") translate([ix*16/2,0,-13.4/2]) cube([0.6,6.5,13.4],true);
    }
    //pipes
    color("ivory"){
      translate([0,0,bdyLngth]) cylinder(d=12,h=7.2);
      translate([0,0,bdyLngth+7-pipDia/2]) rotate([90,0,0]) pipe(31.7-6);
      translate([0,0,bdyLngth+7]) pipe(11.3);
    }
  }
  //clamp
  if (clamp)
    color("darkSlateGrey") clamp();
  
  module pipe(length=30){
    tipLngth=5.5;
    tipDia=4.5;
    pipDia=5.0;
    //tip
    translate([0,0,length-tipLngth]){
      cylinder(d=tipDia,h=tipLngth);
      cylinder(d1=5.5,d2=tipDia,h=1.5);
    }
    cylinder(d=pipDia,h=length-tipLngth);
  }
  
  module clamp(){
    hlfClmpDims=[clmpDims.x,clmpDims.y,(clmpDims.z-clmpSpcng)/2];
    drillDist=bdyDia+fudge+(clmpDims.x-bdyDia)/2-fudge; //is in middle of remaining space
    minWallThck=(clmpDims.z-bdyDia-fudge*2)/2;
    
    difference(){
      union(){
        difference(){
          translate([0,0,clmpDims.z/2]){
            rotate([90,0,0]) cylinder(d=bdyDia+fudge*2+minWallThck*2,h=clmpDims.y,center=true);
            translate([0,0,(clmpSpcng+minWallThck)/2]) 
              cube([clmpDims.x,clmpDims.y,minWallThck],true);
          }
          translate([0,0,(hlfClmpDims.z+clmpSpcng-fudge)/2])
            cube(hlfClmpDims+[fudge,fudge,clmpSpcng+fudge],true);
        }
        translate([0,0,hlfClmpDims.z/2]) cube(hlfClmpDims,true);
      }
        
      translate([0,0,clmpDims.z/2]) rotate([90,0,0]) 
        cylinder(d=bdyDia+fudge*2,h=clmpDims.y+fudge,center=true);
      for (ix=[-1,1])
        translate([ix*drillDist/2,0,-fudge/2]) cylinder(d=clmpDrill,h=clmpDims.z+fudge);
    }//diff
  }
}

*AlphaPot();
module AlphaPot(size=9, shaft="T18", vertical=true){
  ovDim=[9.5,6.5+4.85,10];
  yOffset=ovDim.y/2-6.5;
  
  
  translate([0,yOffset,ovDim.z/2]) cube(ovDim,true);
  translate([0,0,ovDim.z]) cylinder(d=7,h=5);
  translate([0,0,ovDim.z]) shaft();
  
  module shaft(){
    L=15;
    F=7;
    T=6;
    M=1;
    C1=0.5; //chamfer at Tip
    C2=0.25; //chamfer at middle
    dia=6;
    difference(){
      union(){
        translate([0,0,L-C1]) cylinder(d1=dia,d2=dia-C1*2,h=C1);
        translate([0,0,L-T+C2]) cylinder(d=dia,h=T-C1-C2);
        translate([0,0,L-T]) cylinder(d1=dia-C2*2,d2=dia,h=C2);
        translate([0,0,L-F]) cylinder(d=dia-C2*2,h=M);
        translate([0,0,L-F-C2]) cylinder(d1=dia,d2=dia-C2*2,h=C2);
        translate([0,0,5]) cylinder(d=dia,h=L-F-C2-5);
      }
      translate([0,0,L-F+(F+fudge)/2]) cube([dia+fudge,1,F+fudge],true);
    }
  }
}


*SMDSwitch();
module SMDSwitch(){
  translate([0,0,1.4/2]) cube([6.7,2.6,1.4],true);
  //pins
  for (ix=[-1,1],iy=[-1,1])
    color("silver") translate([ix*(6.7+0.5)/2,iy*(2.6-0.4)/2,0.15/2]) cube([0.5,0.4,0.15],true);
  for (ix=[-1,1]){
  color("silver") translate([ix*4.5/2,-(1.25+2.6)/2,0.15/2]) cube([0.4,1.25,0.15],true);
  color("white") translate([ix*1.5/2,0,1.4+1.5/2]) cube([1.3,0.65,1.5],true);
  }
  
  color("silver") translate([4.5/2-3,-(1.25+2.6)/2,0.15/2]) cube([0.4,1.25,0.15],true);
  //stem
  
  //studs
  for (ix=[-1,1])
    translate([ix*3/2,0,0]){
      translate([0,0,-0.3]) cylinder(d=0.75,h=0.3);
      translate([0,0,-0.5]) cylinder(d1=0.4,d2=0.75,h=0.2);
    }
}

*Button_1188E();
module Button_1188E(){
  shtThck=0.2;
  bdDims=[7,2.5-shtThck,3.5];
  btDims=[3,1,1.4];
  //body
  color("ivory") translate([0,shtThck/2,bdDims.z/2]) cube(bdDims,true);
  translate([0,-bdDims.y/2,0]) sheet();
  //button
  color("darkSlateGrey") translate([0,-(bdDims.y+btDims.y)/2,bdDims.z/2]) cube(btDims,true);
  //stems & pins
  for (ix=[-1,1]){
    color("ivory") translate([ix*2.3/2,-0.4,-0.75]) 
      cylinder(d=0.7,h=0.75);
    color("silver") translate([ix*4.2/2,(bdDims.y+0.6)/2,shtThck/2]) cube([0.6,0.6,shtThck],true);
  }
  
  module sheet(){
    difference(){
      union(){
        color("silver") translate([0,0,bdDims.z/2]) cube([bdDims.x,shtThck,bdDims.z],true);
        color("silver") translate([0,0,0.7/2]) cube([7.8-shtThck*2,shtThck,0.7],true);
        color("silver") translate([7.8/2-shtThck,0,0.7/2]) rotate([0,-90,-90]) 
          bend([0.7,0.4,shtThck],90,0.2,true) cube([0.7,0.4,shtThck],true);
        color("silver") translate([-(7.8/2-shtThck),0,0.7/2]) rotate([0,90,90]) 
          bend([0.7,0.4,shtThck],90,0.2,true) cube([0.7,0.4,shtThck],true);
      }
      translate([0,0,bdDims.z/2]) cube([4,shtThck+fudge,2.2],true);
    }
  }
}

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

!KMR2();
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

module rotEncoder(diff="none",thick=3,knob=false){
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
          translate([ix*(12-1)/2,iy*(13.2-1)/2,0]) 
            cylinder(d=1,h=7.5);//rndRect(12,13.2,7.5,1,0); //base
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
        if (knob) color("white",0.5) translate([0,0,7.5+7+10.5-10.3]) cylinder(d1=15,d2=14.5,h=12.5);
    }//union
  }
}

*leverSwitch();
module leverSwitch(){
  //https://cdn-reichelt.de/documents/datenblatt/C200/KS-C3900.pdf
  
  bodyDims=[29.5,14,17];
  screwDia=12;
  screwLngth=10.5;
  lvrLngth=17.5;
  lvrDia=[3.6,5.8]; //tip Dia
  
  translate([0,0,-bodyDims.z/2]) cube(bodyDims,true);
  difference(){
    cylinder(d=screwDia,h=screwLngth);
    rotate(90) translate([0,screwDia/2,(screwLngth+fudge)/2]) 
      cube([2,1.4*2,screwLngth+fudge],true);
  }
  
  translate([0,0,screwLngth]) rotate([0,15,0]) hull(){
    sphere(d=lvrDia[0]);
    translate([0,0,lvrLngth-lvrDia[1]]) sphere(d=lvrDia[1]);
  }
}



module arcadeButton(){
  
}

module bend(size=[50,20,2],angle=45,radius=10,center=false, flatten=false){
  alpha=angle*PI/180; //convert in RAD
  strLngth=abs(radius*alpha);
  i = (angle<0) ? -1 : 1;


  bendOffset1= (center) ? [-size.z/2,0,0] : [-size.z,0,0];
  bendOffset2= (center) ? [0,0,-size.x/2] : [size.z/2,0,-size.x/2];
  bendOffset3= (center) ? [0,0,0] : [size.x/2,0,size.z/2];

  childOffset1= (center) ? [0,size.y/2,0] : [0,0,size.z/2*i-size.z/2];
  childOffset2= (angle<0 && !center) ? [0,0,size.z] : [0,0,0]; //check

  flatOffsetChld= (center) ? [0,size.y/2+strLngth,0] : [0,strLngth,0];
  flatOffsetCb= (center) ? [0,strLngth/2,0] : [0,0,0];

  angle=abs(angle);

  if (flatten){
    translate(flatOffsetChld) children();
    translate(flatOffsetCb) cube([size.x,strLngth,size.z],center);
  }
  else{
    //move child objects
    translate([0,0,i*radius]+childOffset2) //checked for cntr+/-, cntrN+
      rotate([i*angle,0,0])
      translate([0,0,i*-radius]+childOffset1) //check
        children(0);
    //create bend object

    translate(bendOffset3) //checked for cntr+/-, cntrN+/-
      rotate([0,i*90,0]) //re-orientate bend
       translate([-radius,0,0]+bendOffset2)
        rotate_extrude(angle=angle)
          translate([radius,0,0]+bendOffset1) square([size.z,size.x]);
  }
}