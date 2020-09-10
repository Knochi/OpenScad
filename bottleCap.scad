use <threads.scad>

fudge=0.1;
$fn=50;

translate([0,0,15]) rotate([180,0,0]) cap();

module cap(dia=30,height=15){
  difference(){
    cylinder(d=dia,h=height);
    translate([0,0,-fudge]) metric_thread(diameter=27.4, pitch=3, length=12, internal=true, n_starts=1,
                      thread_size=2.2, groove=false, square=false, rectangle=0,
                      angle=40, taper=0, leadin=0, leadfac=1.0);
  }
}