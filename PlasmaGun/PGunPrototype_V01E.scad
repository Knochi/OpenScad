use <bezier.scad>


$fn=100;
fudge=0.1;

/*-- [Burner-Dimensions] --*/
pipStrLngth=700; //length of the straight part
pipHndlLngth=80; //length of the straight handle part 
pipBendAng=133;
pipBendRad=90;
pipDia=16;
wThck=0.5;
canDia=80;
canHght=400;

/*-- [Tube-Dimensions] --*/
tubBendRad=80;
tubOutDia=31;
tubInDia=25;
//exhaust
exOutDia=80;
exInDia=70;
exLngth=200;

/* [Adapter Dimensions] */
adaLngth=100;
adaBrim=20;
adaFlange=40;
adaScrwDia=4.2;
adaNumScrws=9;
adaOvLngth=adaLngth+adaBrim+adaFlange;

/* -- [3DP] -- */
minWallThck=2;
//innerSpacing
inSpc=0.2;


/* -- [show] -- */
export="none"; //["none","diaTest","adapter"]


//adapter dia test
if (export=="diaTest")
!translate([0,0,0]) intersection(){
    cylinder(d=exOutDia+minWallThck*2+inSpc*2+fudge,h=20);
    mirror([0,0,1]) union(){
      translate([0,0,-160]) adapter();
      translate([0,0,-20+minWallThck/2]) adapter();
    }
  }
 

if (export=="adapter")
  !translate([0,0,adaOvLngth]) mirror([0,0,1]) adapter();

//adapter crossection
*difference(){
  union(){
    translate([0,0,150]) exhaust();
    adapter();
  }
  translate([0,0,-fudge/2]) 
    color("red") 
      cube([exOutDia/2+minWallThck+fudge+inSpc,exOutDia/2+minWallThck+fudge+inSpc,200]);
}

rotate([0,90,0]) burner(); 
tube();
translate([-50,0,tubOutDia]) rotate([0,-90,0]) adapter();
translate([-200,0,tubOutDia]) rotate([0,-90,0]) exhaust();

module tube(){
  dIn=tubInDia;
  dOut=tubOutDia;
  mRad=tubBendRad;
  
  color("grey",0.5){
    rotate([0,-90,0]) linear_extrude(40) shape();
    translate([-40,0,-mRad]) rotate([90,-90,0]) 
      rotate_extrude(angle=180) translate([mRad,0,0]) shape();
    translate([-40,0,-mRad*2]) rotate([0,90,0]) linear_extrude(pipStrLngth) shape();
    translate([pipStrLngth-40,0,-mRad]) rotate([90,90,0]) 
      rotate_extrude(angle=120) translate([mRad,0,0]) shape();
  }
  
  module shape(){
    difference(){
      circle(d=dOut);
      circle(d=dIn);
    }
  }
}


!adapter();
module adapter(){

  exWallThck=(exOutDia-exInDia)/2;
  
  P0=[tubInDia/2-minWallThck+inSpc,0];
  P1=[tubInDia/2+inSpc,0];
  P2=[tubInDia/2+inSpc,adaFlange-minWallThck*2];
  P3=[tubOutDia/2+inSpc,adaFlange];
  P4=[exOutDia/2+minWallThck+inSpc,adaLngth+adaFlange];
  P5=[exOutDia/2+minWallThck+inSpc,adaLngth+adaBrim+adaFlange];
  P6=[exOutDia/2+inSpc,adaLngth+adaBrim+adaFlange];
  P7=[exOutDia/2+inSpc,adaLngth+adaFlange-inSpc];
  P8=[exOutDia/2-exWallThck,adaLngth+adaFlange-inSpc];
  P9=[tubOutDia/2-minWallThck+inSpc,adaFlange];
  PE=[tubInDia/2-minWallThck+inSpc,adaFlange-minWallThck*2];
  
  //debug
  *color("green") translate([P8.x,0,P8.y]) sphere(0.5);
  difference(){
    rotate_extrude(){ 
      polygon(Bezier([                P0,SHARP(),
                              SHARP(),P1,SHARP(),
                              SHARP(),P2,SHARP(),
    
                              SHARP(),P3,OFFSET([0,50]), 
                      OFFSET([0,-50]),P4,SHARP(), //top right
    
                              SHARP(),P5,SHARP(),
                              SHARP(),P6,SHARP(),
                              SHARP(),P7,SHARP(),
                              SHARP(),P8,OFFSET([0,-50+minWallThck/2]),
                                     
         OFFSET([0,50+minWallThck/2]),P9,SHARP(),
                              SHARP(),PE ]));
      //rounding
    translate([(tubInDia-minWallThck)/2+inSpc,0,0]) circle(d=minWallThck);
    *translate([(exOutDia+minWallThck)/2+inSpc,adaLngth+adaBrim+adaFlange]) circle(d=minWallThck);
    }//rot_ex
    for (ir=[0:360/adaNumScrws:360-360/adaNumScrws])
      rotate(ir) translate([exOutDia/2,0,adaOvLngth-adaBrim/2]) rotate([0,90,0])
        cylinder(d=adaScrwDia,h=minWallThck*1.2);
  }//diff
  
}

module exhaust(){
  color("grey",0.3)
  linear_extrude(exLngth) difference(){
    circle(d=exOutDia);
    circle(d=exInDia);
  }
}

*burner();
module burner(){
  //muzzle
  color("salmon") translate([0,0,-36]) rotate([0,0,0]) muzzle();
  
  color("silver"){
    //long straight part
    linear_extrude(pipStrLngth) shape();
    
    //radius
    translate([pipBendRad,0,pipStrLngth]) rotate([-90,0,180]) 
      rotate_extrude(angle=-pipBendAng) 
        translate([pipBendRad,0,0]) shape();
  }  
    //handle
    translate([pipBendRad,0,pipStrLngth]) rotate([0,-(180-pipBendAng),0]) 
      translate([pipBendRad,0,-pipHndlLngth]){
        color("silver") linear_extrude(pipHndlLngth) shape();
        translate([0,0,-canHght]) can();
      }
    
  
  module shape(){
    difference(){
      circle(d=pipDia);
      circle(d=pipDia-wThck*2);
    }
  }
  
  module can(){
    color("green") cylinder(d=canDia,h=canHght*0.75);
    color("yellow") translate([0,0,canHght*0.75]) cylinder(d=canDia,h=canHght*0.25);
  }
}
*muzzle();
module muzzle(){
  wThck=1;
  
  difference(){
    union(){
      cylinder(d=16+2*wThck,h=53);
      cylinder(d=25,h=35);
      translate([0,0,35]) cylinder(d1=25,d2=18,h=5);
    }
    translate([0,0,-fudge/2]){
      cylinder(d=16,h=53+fudge);
      cylinder(d=25-wThck*2,h=35+fudge);
      translate([0,0,35]) cylinder(d1=25-wThck*2,d2=18-wThck*2,h=5+fudge);
    }
  }
}