// Remix of JST Pliers from 
// https://www.printables.com/de/model/367156-jst-connector-pliers

opnAng=0; //[0:45]
$fn=50;
debug=false;
debugHndl=false;
showHndl=true;
showCntr=true;
ovHght=10;
fudge=0.1;

*color("red") rotate([-90,0,opnAng/2]) translate([-12.67,-5.2,-32.55]) import("JST.STL");
if (debug)
  %rotate([-90,0,-opnAng/2]) translate([0-26,-5.25,-32.55]) import("JST 2.STL");

if (showHndl)
  handle();
if (showCntr)
  center();

module center(){
  chamfer=0.5;
  translate([0,0,ovHght/4]) pill(23,ovHght/2,chamfer);
}

module handle(iter=0){
  dias=[15.5,15,14.8,14.4,13.94,13.6,13,12.7,12]; //diameters 
  pos=[[-17.9,68.8],//0
       [-18.3,54.37],
       [-17.97,46.7],
       [-17.2,39.0],
       [-16.24,32.61],
       [-14.96,26.1],
       [-13.4,20.08],
       [-11.8,14.52],
       [-8.95,6.17]]; //X,Y pos'

  chamfer=2;
  
  if (debugHndl)
    for (i=[0:len(pos)-1]) difference(){
      translate([pos[i].x,pos[i].y,0]) difference(){
        pill(dias[i],ovHght,chamfer);
        translate([0,0,ovHght/2-1]) linear_extrude(1+fudge) 
          text(str(i),valign="center",size=(dias[i]-chamfer*2)*0.8,halign="center");
      }
    }
  //chainhull operation
  else if (iter<(len(pos)-1)){
    color("grey") hull(){
      translate([pos[iter].x,pos[iter].y,0]) pill(dias[iter],ovHght,chamfer);
      translate([pos[iter+1].x,pos[iter+1].y,0]) pill(dias[iter+1],ovHght,chamfer);
    }
    handle(iter=iter+1); //recursion
  }  
}

module pill(dia=10,height=ovHght,chamfer=1){
  translate([0,0,-height/2]) 
    cylinder(d1=dia-chamfer*2,d2=dia,h=chamfer);
  translate([0,0,0]) 
    cylinder(d=dia,h=height-chamfer*2,center=true);
  translate([0,0,+height/2-chamfer]) 
    cylinder(d2=dia-chamfer*2,d1=dia,h=chamfer);
}