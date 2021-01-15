use <threads.scad>



cut=false;
thrdLngth=9;
thrdDia=29;
capHght=15;
capDia=32;
neckDia=28;
wallThck=2;
pipInnerDia=3;
pipDist=9;
fudge=0.1;
$fn=50;


  //translate([0,0,capHght]) rotate([180,0,0]) 
  difference(){
    union(){
      cap();
      translate([-pipDist/2,0,capHght]) rotate([180,0,0]) pipe(capHght);
      for (ix=[-1,1])
        translate([ix*pipDist/2,0,capHght]) pipe(capHght);
    }
    for (ix=[-1,1])
        translate([ix*pipDist/2,0,capHght]) cylinder(d=pipInnerDia,h=capHght*2+fudge,center=true);
    if (cut) 
      translate([0,0,-fudge/2]) cube([capDia/2+fudge,capDia/2+fudge,capHght+fudge]);   
    
  }

  

module cap(){
  difference(){
    cylinder(d=capDia,h=capHght);
    translate([0,0,capHght-thrdLngth-wallThck]) 
      metric_thread(diameter=thrdDia, pitch=3.4, length=thrdLngth, internal=true,
                    n_starts=1,thread_size=2.5, groove=false, square=false, 
                    rectangle=0, angle=30, taper=0, leadin=0, leadfac=1.0);
    translate([0,0,-fudge/2]) cylinder(d=neckDia,h=capHght-thrdLngth-wallThck+fudge);
  }
}

*pipe();
module pipe(length=30){
    tipLngth=5.5;
    tipDia=4.5;
    pipDia=5.0;
    //tip
    translate([0,0,length-tipLngth]){
      cylinder(d=tipDia,h=tipLngth);
      cylinder(d1=5.5,d2=tipDia,h=1.5);
      translate([0,0,-0.5]) cylinder(d1=pipDia,d2=5.5,h=0.5);
    }
    
    cylinder(d=pipDia,h=length-tipLngth);
  }
  