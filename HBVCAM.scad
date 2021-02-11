use <eCad\elMech.scad>

fudge=0.1;
$fs=0.5;

/* [Dimensions] */
bdyDia=18;
minWallThck=1.2;
brngBore=10;
brngDia=15;
brngThck=4;
spcng=0.2; //spacing between 3DP parts

/* [show] */
showHBV=true; //show cam module
showBodyMain=true; //show main Body
showBodyCap=true;
showStepper=false;
showBearings=true;
showMonitor=true;



if (showMonitor) rotate([90,0,0]) translate([0,-160,-66]) asusVA24D();

if (showStepper)
  translate([40+minWallThck,0,0]) rotate([0,-90,0]) microStepper();

rotate([90,0,0]) camASY();



module camASY(){
  //https://www.banggood.com/HBV-5640-FF-Fixed-Focus-5MP-USB-OV5640-Laptop-Camera-Module-5-Million-Pixels-Camera-2592+1944-p-1709224.html
  
  camDims=[8.2,8.2,5.3];
  PCBThick=1.2;
  hbvDims=[60,8.5,camDims.z+PCBThick];
  drillPos=[[-22.5,-2.2],[28.1,2.2],[28.1,-2.2]]; //from board center
  hbvPos=[0,0,-minWallThck];
  bdyWdth=hbvDims.x+minWallThck*2+5;
  capDia=bdyDia-minWallThck*2-spcng*2;
  scrwDia=1.5;
  scrwPosDia=brngBore+minWallThck+(capDia-brngBore-minWallThck)/2;
  %body();
  translate(hbvPos) HBVCAM();
  
  if (showBearings) for(ix=[-1,1])
    translate([ix*(bdyWdth/2+brngThck/2+minWallThck),0,0]) rotate([0,90,0]) bearing(brngBore,brngDia,brngThck);
  
  module body(){
    nudgeThck=(bdyDia/2-hbvDims.z);
    
    if (showBodyMain)  difference(){
      union(){
        rotate([0,90,0]) cylinder(d=bdyDia,h=bdyWdth,center=true);
        translate([bdyWdth/2,0,0]) 
            rotate([0,90,0]){
              cylinder(d=brngBore+minWallThck,h=minWallThck);
              cylinder(d=brngBore,h=minWallThck+brngThck);
            }
      }
      //cutout for left flange
      translate([-bdyWdth/2-fudge,0,0])
        rotate([0,90,0]){
          cylinder(d=bdyDia-minWallThck*2,h=minWallThck+fudge);
        for (ir=[0:120:240])
          rotate(ir) translate([scrwPosDia/2,0,0]) cylinder(d=scrwDia-spcng,h=minWallThck+20+fudge);
      }
      //compartment for HBVCAM
      translate([-minWallThck*2-fudge,0,hbvDims.z/2]+hbvPos) cube(hbvDims+[minWallThck*2+fudge,0,0],true);
      
      //window cutout
      for(ix=[-1,1])
        translate([ix*(camDims.x)/2,0,bdyDia/2+nudgeThck/2]) rotate([90,0,0]) cylinder(d=nudgeThck*3,h=bdyDia,center=true);
      translate([0,0,bdyDia/2]) cube([camDims.x,bdyDia,nudgeThck*2],true);
      translate([0,0,hbvDims.z-fudge/2]+hbvPos) cylinder(d=camDims.y,h=minWallThck+fudge);
    }//body main
    
    if (showBodyCap) color("grey")
      translate([-bdyWdth/2+minWallThck-spcng,0,0]) rotate([0,-90,0]) cap();
    
    module cap(){
      difference(){
        union(){
            cylinder(d=capDia,h=minWallThck-spcng);
            cylinder(d=brngBore+minWallThck,h=minWallThck*2);
            cylinder(d=brngBore,h=minWallThck*2+brngThck);
        }
        translate([0,0,-fudge/2]) cylinder(d=brngBore-minWallThck*2,h=minWallThck*2+brngThck+fudge);
        for (ir=[0:120:240])
          rotate(ir) translate([scrwPosDia/2,0,-fudge/2]) cylinder(d=scrwDia,h=minWallThck+fudge);
       }
    }
       
  }//body
  
  
  module HBVCAM(){
    difference(){
      color("darkslategrey") translate([0,0,PCBThick/2]) cube([hbvDims.x,hbvDims.y,PCBThick],true);
      translate([0,0,-fudge/2]) linear_extrude(PCBThick+fudge) for (pos=drillPos) translate(pos) circle(d=2.6);
    }
    color("ivory")translate([(-hbvDims.x+5)/2,0,3/2+PCBThick]) cube([5,hbvDims.y,3],true);
    translate([0,0,(camDims.z)/2+PCBThick]) cube(camDims,true);
  }
}

*microStepper();
module microStepper(){
  //Machifit GA12BY15
  color("gold") translate([0,0,-9/2]) cube([12,10,9],true); //gearbox
  //
  color("silver"){
    difference(){
      cylinder(d=3,h=10);
      translate([3-0.5,0,1+9/2]) cube([3,3,9+fudge],true);
    }
    cylinder(d=4,h=0.8);
    translate([0,0,-19.8]) cylinder(d=12,h=10.8);
  }

  //poti test
  *translate([0,0,1]) rotate(-90) PT15();
}

module bearing(d=10,D=15,B=4){
  //
  color("silver") difference(){
    cylinder(d=D,h=B,center=true);
    cylinder(d=d,h=B+fudge,center=true);
  }
}

*asusVA24D();
module asusVA24D(){
  //dummy of asus monitor
  ovDims=[539.7,323.55,59.30];
  bezelThck=14.39;
  AADims=[527.04,296.46]; //active area
  AAcntrPos=[0,18.83/2];

  difference(){
    color("darkSlateGrey") translate([0,-AAcntrPos.y,0]) union(){
      translate([0,0,-bezelThck/2+ovDims.z]) cube([ovDims.x,ovDims.y,bezelThck],true);
      translate([0,0,(ovDims.z-bezelThck)/2]) cube([ovDims.x*0.7,ovDims.y*0.5,ovDims.z-bezelThck],true);
    }
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*100/2,iy*100/2,-fudge/2]) cylinder(d=4,h=20);
      color("grey") translate([0,0,ovDims.z]) cube([AADims.x,AADims.y,fudge],true);
    }
  
}