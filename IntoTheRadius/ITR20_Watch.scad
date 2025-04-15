/* Game prop for the game Into The Radius from CM Games 
  V2.0beta  watch is looking same as later 1.0 versions
*/


/* [Dimensions] */
ovDims=[52,70,20];
crnrRad=3;
edgeRad=0.5;
ledCnt=10;
ledRad=0.9;
curveRad=70;
bdyMinThck=15.8;

minWallThck=0.8;
frntAng=45;
frntWdth=15;
frntHght=5;

/*[show] */
showLCD=false;
$fn=100;

/* [Hidden] */
fudge=0.1;
ledDims=[(ovDims.x-minWallThck*2*2-minWallThck*(ledCnt-1))/(ledCnt),4.5];
ledPitch=[ledDims.x+minWallThck,ledDims.y+minWallThck*2];
ledOffset=[0,-ovDims.y/2+frntWdth/2-1.6,2];
lcdOffset=[0,3,bdyMinThck- 3];
bdyDims=[ovDims.x,ovDims.y-frntWdth,ovDims.z-5];


*translate([0,0,ovDims.z/2]) cube(ovDims,true);
color("olive") body();
*translate(ledOffset) leds();
if (showLCD)
  translate(lcdOffset) LCD();
color("silver") translate([-31,6,7]) rotate([90,0,0]) cylinder(d=6.5,h=52,center=true);

module body(){
  poly=[[-ovDims.y/2,0],[-ovDims.y/2,ovDims.z-frntWdth],[-ovDims.y/2+frntWdth,ovDims.z],
        [ovDims.y/2,ovDims.z],[ovDims.y/2,0]];
        
  //2D sketch on the Y-Z plane
  *translate([ovDims.x/2,-(bdyDims.y-frntWdth)/2+crnrRad,0]) rotate([90,0,90]) linear_extrude(0.1){
    translate([0,-curveRad,0]) circle(curveRad,$fn=100);
  }
  
  
  
  difference(){
    union(){
      //main body
      hull() for (ix=[-1,1],iy=[-1,1]){
        rad= (iy<0) ? edgeRad : crnrRad;
        translate([ix*(bdyDims.x/2-rad),iy*(bdyDims.y/2-rad)+frntWdth/2,bdyDims.z/2]) 
          pill(d=rad*2,h=bdyDims.z,r=edgeRad);
          }
      
      hull() for (ix=[-1,1]){
        //angled front edge
        translate([0,-bdyDims.y/2+frntWdth/2+crnrRad,-curveRad])
          rotate([+10,0,0]) translate([ix*(ovDims.x/2-crnrRad),0,curveRad+frntHght/2]) 
            angPill(d=crnrRad*2,h=frntHght,r=edgeRad,a=40.0);
        //connect to body
        translate([ix*(ovDims.x/2-edgeRad),-bdyDims.y/2+frntWdth/2+edgeRad,bdyDims.z/2]) 
          pill(d=edgeRad*2,h=bdyDims.z,r=edgeRad);    
      }
    }
    //curvature
    *translate([0,0,-curveRad-bdyMinThck+ovDims.z]) rotate([0,90,0]) 
      cylinder(r=curveRad,h=ovDims.x+fudge,center=true);
   
    //leds
    translate(ledOffset) linear_extrude(ovDims.z,convexity=4) leds();
    
    //LCD
    translate(lcdOffset) linear_extrude(bdyMinThck) LCD(true);
  }
}

module leds(cut=true){
  for (ix=[-(ledCnt-1)/2:(ledCnt-1)/2],iy=[0,1])
    translate([ix*ledPitch.x,iy*ledPitch.y]) offset(ledRad) square([ledDims.x-ledRad*2,ledDims.y-ledRad*2],true);
}

*pill();
module pill(d=5,h=10,r=1){
  //a pill object to help with modelling
  
  for (iz=[-1,1]){
    dwn = (iz<0) ? -r : 0;
    translate([0,0,iz*(h/2-r)])
      rotate_extrude() translate([d/2-r,0]) 
        intersection(){
          circle(r);
          translate([0,dwn]) square(r);
          }
    }
  cylinder(d=d,h=h-r*2,center=true);
  //fill the center
  cylinder(d=d-r*2,h=h,center=true);
}

*angPill();
module angPill(d=5,h=10,r=1,a=+12){
  //an angled pill
  //the top surface is angled in x
  
  
  hull() for (iz=[-1,1]){
    dwn = (iz<0) ? -r : 0;
    ang = (iz<0) ? 0 : a;
    yScl = (iz<0) ? 1 : d/((d-r*2)*cos(a)+r*2);
    translate([0,0,iz*(h/2-r)]) scale([1,yScl]) rotate([ang,0,0])
      rotate_extrude() translate([d/2-r,0]) 
        intersection(){
          circle(r);
          translate([0,-r]) square([r,r*2]);
          }
    }
}

*LCD();
module LCD(cut=false){
  /*
  // https://newhavendisplay.com/128x64-graphic-cog-lcd-fstn-display-with-no-backlight/
  1.74"
  AA=[39.64,19.8];
  VA=[44,24];
  glass=[48,36];
  */
  
  
  // https://www.lcsc.com/product-detail/LCD-Screen_HS-HS12864TG10B_C18198252.html
  // U8G2: https://github.com/olikraus/u8g2/wiki/u8g2setupcpp#st7567-jlx12864-1
  // 1.9"
  AA=[41.58,20.14];
  VA=[43.6,22.4];
  LCD=[46,29,1.7];
  LED=[47.5,30.5,1.5];
  
  if (cut)
    translate([0,LCD.y/2-VA.y/2-2.05]) square(VA,true);
  else{
    //LCD
    color("#888888") linear_extrude(LCD.z)
      difference(){
        square([LCD.x,LCD.y],true);
        translate([0,LCD.y/2-VA.y/2-2.05]) square(VA,true);
      }
    
    color("#222222") linear_extrude(LCD.z)
      difference(){
        translate([0,LCD.y/2-VA.y/2-2.05]) square(VA,true);
        translate([0,LCD.y/2-AA.y/2-3.18]) square(AA,true);
      }
    color("#224433") linear_extrude(LCD.z)
      translate([0,LCD.y/2-AA.y/2-3.18]) square(AA,true);
  }
  
}