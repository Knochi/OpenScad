$fn=50;
fudge=0.1;
use <threads.scad>

/* [Options] */
threadTest=true;
showSectionCut=true;


/* [thread] */
thDia=8;    //Outer diameter of thread
thMinDia=6; //inner minimum Dia of the thread
thSize=2; //Size of thread (default thread pitch)
thRect=1.0; //ratio depth/(axial) width (default 1=square)

/* [threadTest] */
varyX="thDia"; //["none","thDia","threadSize","thMinDia"]
varyY="threadSize"; //["none","thDia","threadSize","thMinDia"]
thSizeVar=0.5;  //the Variation for threat Size 
thDiaVar=0.5;   //the Variation for threat Diameter 
thMinDiaVar=0.5;  //the variation of rect parameter 
thTstODia=11;  //Outer Dia of the cylinders
thTstSpcng=3;
thTstHght=8;

lbDepth=0.4;


/* [Hidden] */
//Dimension for cut
thTstDims=[thTstSpcng*2+thTstODia*3,thTstSpcng*2+thTstODia*3,thTstHght+1];

if (threadTest)
  difference(){
    threadTest();
    if (showSectionCut)
      color("darkRed") translate([0,-thTstDims.y/2,thTstDims.z/2]) cube(thTstDims+[fudge,fudge,fudge],true);
      }
else
  mainBody();



module threadTest(){
  //base
  difference(){
    linear_extrude(2) hull() for (ix=[-1,1], iy=[-1,1])
      translate([ix*(thTstODia+thTstSpcng),iy*(thTstODia+thTstSpcng)]) circle(d=thTstODia);
    
      translate([-(thTstODia+thTstSpcng),-(thTstODia+thTstSpcng),-fudge]) linear_extrude(lbDepth+fudge) circle(d=3);
    }
    
  for (ix=[-1:1], iy=[-1:1]){

    //Variations in X and Y
    curThDia=   (varyX=="thDia") ? thDia+ix*thDiaVar : 
                (varyY=="thDia") ? thDia+iy*thDiaVar :
                thDia;
    curThSize=  (varyX=="threadSize") ? thSize+ix*thSizeVar : 
                (varyY=="threadSize") ? thSize+iy*thSizeVar :
                thSize;
    curThRect=  (varyX=="thRect") ? thRect+ix*thRectVar : 
                (varyY=="thRect") ? thRect+iy*thRectVar :
                thRect;    
    curMinDia=  (varyX=="thMinDia") ? thMinDia+ix*thMinDiaVar : 
                (varyY=="thMinDia") ? thMinDia+ix*thMinDiaVar : 
                thMinDia;    
    
        
    echo(str([ix,iy],": Dia: ",curThDia,",Size: ", curThSize,",MinDia: ",curMinDia));
    
    
    translate([ix*(thTstODia+thTstSpcng),iy*(thTstODia+thTstSpcng),1]) 
      difference(){
        cylinder(d=thTstODia,h=thTstHght);
        metric_thread(diameter=curThDia, 
                      pitch=1.75, 
                      length=thTstHght+fudge, 
                      leadin=1,
                      thread_size=curThSize, 
                      square=true,
                      //rectangle=curThRect, 
                      internal=true);
        cylinder(d=curMinDia,h=thTstHght);
        } 
    }
 
}

module mainBody(){
  mainInHght= 4.6; //6.5 
  mainOutHght= 8.6;
  brim=[1,1,0.8];
  
  mainOutDia = 33.8;
  mainInDia = 30.8;
  
  mainCenterDia=10.7;
  
  difference(){
    union(){
      difference(){
        union(){
          linear_extrude(mainOutHght,convexity=3) mainBodyShape();
          linear_extrude(brim.z,convexity=3) offset(brim.x) 
            mainBodyShape(center=false);
        }
        translate([0,-mainInDia/4,mainInHght-fudge]) mirror([1,0,0]) 
          linear_extrude(0.5) text(str(thDia,",", thSize,",", thAng),size=4,valign="center",halign="center");
        translate([0,0,-fudge]) linear_extrude(mainInHght+fudge) mainBodyShape(true);
      }
      blocker();
    }
    translate([0,0,-fudge/2]) 
      metric_thread(diameter=thDia, pitch=1.75, length=mainOutHght+fudge, thread_size=thSize, rectangle=1, angle=thAng, internal=true);
  }
  
  //collar
  translate([0,0,-1]) linear_extrude(1) difference(){
    circle(d=mainCenterDia);
    circle(d=thDia+fudge*2);
  }
  
  //pin
  pinDia=5.5;
  pinHght=4.85;
  pinDrillDia=3.2;
  pinDrillDepth=5;
  translate([-mainInDia/2+pinDrillDia/2,-mainInDia/2+pinDrillDia/2,-pinHght]) 
    difference(){
      cylinder(d=pinDia,h=mainInHght+pinHght);
      translate([0,0,-fudge]) 
        cylinder(d=pinDrillDia,h=pinDrillDepth+fudge);
    }
    
  module blocker(){
    //blocker
    blkOffset=[1,1,0.3];
    blkDims=[10,4.1,mainInHght-blkOffset.z];
    blkRot=45;
    rotate(blkRot) translate([blkDims.x/2,blkDims.y/2+blkOffset.y,blkDims.z/2+blkOffset.z]) cube(blkDims,true);
  }
  
  
  module mainBodyShape(inner=false, center=true){

    mainDia= inner ? mainInDia : mainOutDia;
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
      if (center && inner) circle(d=mainCenterDia);
    }
    translate(satOutPos) circle(d=satDia);
  }
}

