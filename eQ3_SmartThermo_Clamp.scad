$fn=50;
fudge=0.1;
use <threads.scad>

/* [thread] */
thDia=8.2;
thSize=1.75;
thAng=45;



mainBody();

module mainBody(){
  mainInHght= 4.6; //6.5 
  mainOutHght= 8.6;
  brim=[1,1,0.8];
  
  mainOutDia = 33.8;
  mainInDia = 30.8;
  
  difference(){
    union(){
      difference(){
        union(){
          linear_extrude(mainOutHght,convexity=3) mainBodyShape();
          linear_extrude(brim.z,convexity=3) offset(brim.x) 
            mainBodyShape(center=false);
        }
        translate([0,-mainInDia/4,mainInHght-fudge]) mirror([1,0,0]) 
          linear_extrude(0.5) text(str(thDia,",", thSize,",", thAng),size=3,valign="center",halign="center");
        translate([0,0,-fudge]) linear_extrude(mainInHght+fudge) mainBodyShape(true);
      }
      blocker();
    }
    translate([0,0,-fudge/2]) 
      metric_thread(diameter=thDia, pitch=1.75, length=mainOutHght+fudge, thread_size=thSize, rectangle=false, angle=thAng, internal=true);
  }
  
  module blocker(){
    //blocker
    blkOffset=[1,1,0.3];
    blkDims=[10,4.1,mainInHght-blkOffset.z];
    blkRot=45;
    rotate(blkRot) translate([blkDims.x/2,blkDims.y/2+blkOffset.y,blkDims.z/2+blkOffset.z]) cube(blkDims,true);
  }
  //pin
  pinDia=5.5;
  pinHght=4.85;
  pinDrillDia=3.0;
  pinDrillDepth=5;
  translate([-mainInDia/2+pinDrillDia/2,-mainInDia/2+pinDrillDia/2,-pinHght]) 
    difference(){
      cylinder(d=pinDia,h=mainInHght+pinHght);
      translate([0,0,-fudge]) 
        cylinder(d=pinDrillDia,h=pinDrillDepth+fudge);
    }
  
  module mainBodyShape(inner=false, center=true){

    mainDia= inner ? mainInDia : mainOutDia;
    mainCenterDia = inner ? 10.7 : 0;
    mainCrnrRad= inner ? 2.3-(mainOutDia-mainInDia)/2 : 2.3;
    satOutDia = 16;
    satDia= inner ? 12 :  satOutDia;
    
    satOutPos=[38-mainOutDia/2-satOutDia/2,-(39.5-mainOutDia/2-satOutDia/2)];
    difference(){
      hull(){
        circle(d=mainDia);
        for(ix=[-1,1])
          translate([ix*(mainDia/2-mainCrnrRad),-mainDia/2+mainCrnrRad]) 
            circle(mainCrnrRad);
      }
      if (center) circle(d=mainCenterDia);
    }
    translate(satOutPos) circle(d=satDia);
  }
}

