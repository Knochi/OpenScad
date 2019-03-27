$fn=100;
ovWdth=13;
ovLngth=172;
ovThck=1.1;
inThck=0.8;
inWdth=ovWdth-1.4*2;
fudge=0.1;

color("lightgrey")
difference(){
  union(){
    translate([0,0,-ovThck/2]) difference(){
      union(){
        translate([0,-ovWdth/2,0]) cube([ovLngth-3,13,1.1]);
        translate([0,-2.75/2,-(2-ovThck)/2]) cube([2.6+3,2.75,2]);
        hull(){
          translate([ovLngth-3,0,0]) cylinder(d=6,h=ovThck);
          translate([ovLngth-3,-ovWdth/2+fudge,0]) cylinder(d=fudge*2,h=ovThck);
          translate([ovLngth-3,ovWdth/2-fudge,0]) cylinder(d=fudge*2,h=ovThck);
        }
      }
      translate([72,-inWdth/2,-fudge]) cube([ovLngth-72+fudge,inWdth,(ovThck-inThck)/2+fudge]);
      translate([72,-inWdth/2,ovThck-(ovThck-inThck)/2]) cube([ovLngth-72+fudge,inWdth,(ovThck-inThck)/2+fudge]);
    }  
    translate([2.6+3,0,0]) cylinder(d=6,h=3.4,center=true);
    translate([ovLngth-3,0,0]) cylinder(d=6,h=3.4,center=true);
  }
  translate([2.6+3,0,0]) cylinder(d=4.5,h=3.4+fudge,center=true);
  translate([ovLngth-3,0,0]) cylinder(d=4.5,h=3.4+fudge,center=true);
}
  
