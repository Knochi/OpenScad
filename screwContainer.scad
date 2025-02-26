use <threads.scad>

/* [Dimensions] */
contHght=24;
contInDia=24;
wallThck=1.2;
lidHght=4;
flrThck=1.2;

/* [show] */
showLid=true;
showContainer=true;
showCut=true;

/* [Hidden] */
ovDia=contInDia+2*wallThck;
ovHght=contHght+flrThck+lidHght;

fudge=0.1;
threadDia=contInDia+wallThck;
$fn=64;
threadPitch=1.5;
threadSize=1.0;
threadSpcng=0.2;

difference(){
  union(){
    if (showContainer)
      container();
    if (showLid)
      translate([0,0,ovHght-lidHght-fudge/2]) lid();
  }
  if (showCut)
    color("darkRed") translate([ovDia/4,0,ovHght/2]) 
      cube([ovDia/2+fudge,ovDia+fudge,ovHght+fudge],true);
  }

module container(){
  //floor
  cylinder(d=ovDia,h=flrThck);
  //container
  translate([0,0,flrThck]) linear_extrude(contHght) difference(){
    circle(d=ovDia);
    circle(d=contInDia);
  }

  //container thread
  translate([0,0,flrThck+contHght]) difference(){
    cylinder(d=ovDia,h=lidHght);
    translate([0,0,-fudge/2]) 
      metric_thread(diameter=threadDia,
                    pitch=threadPitch,
                    thread_size=threadSize,
                    length=lidHght+fudge,
                    internal=true,
                    leadin=1,
                    leadfac=1.5);
   }
}

module lid(){
  difference(){
    metric_thread(diameter=threadDia-threadSpcng*2,
                  pitch=threadPitch,
                  thread_size=threadSize,
                  length=lidHght,
                  internal=false,
                  leadin=2,
                  leadfac=1.5);
                  
    translate([0,0,flrThck]) linear_extrude(lidHght-flrThck+fudge) difference(){
      circle(d=ovDia-4*wallThck);
      square([ovDia,wallThck],true);
      }
  }
}
