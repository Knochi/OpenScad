
//dummy of a stone
color("Grey")  stone();
module stone(){
  hull(){
    scale([1,50/70,40/70]) sphere(d=70,$fn=10);
    translate([5,-10,-5]) rotate(-15) scale([30/50,1,25/50]) sphere(d=50,$fn=10);
  }
}

