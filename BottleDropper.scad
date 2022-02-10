
/* [Dimensions] */
rotation=0; //[0:90]
distance=80;
tipDia=7;
mainDia=20;
cutDia=100;
width=120;

/* [Hidden] */  
fudge=0.1;

color("red"){
translate([0,mainDia/2+distance/2,0]) rod();
mirror([0,1,0]) translate([0,mainDia/2+distance/2,0]) rod();
}

translate([0,0,30]) cone();

module cone(){
  difference(){
    union(){
      cylinder(d1=104,d2=204,h=150);
      translate([0,0,150]) cylinder(d=204,h=45);
    }
  translate([0,0,-fudge/2]) cylinder(d1=100,d2=200,h=150+fudge);
  translate([0,0,150]) cylinder(d=200,h=45+fudge);
  }
}

module rod(combined=true){
  
  if (distance==0)
    rotate([-rotation-90,0,0]) difference(){
        rotate([0,90,0]) cylinder(d=mainDia,h=200,center=true);
        translate([0,mainDia/2,0]) cylinder(d=cutDia,h=mainDia,center=true);
      }
  else if (combined)
    rotate([rotation,0,0])
    difference(){
      hull(){
        rotate([0,90,0]) cylinder(d=mainDia,h=width,center=true);
        translate([0,-(mainDia+distance)/2+5,-(mainDia-tipDia)/2]) 
          rotate([0,90,0]) cylinder(d=tipDia,h=width,center=true);
      }
       translate([0,0,50]) rotate([90,0,0]) cylinder(d=100,h=width,center=true);
    }
  else
  rotate([rotation,0,0]) 
    hull(){
      rotate([0,90,0]) cylinder(d=mainDia,h=200,center=true);
      translate([0,-(mainDia+distance)/2+5,(mainDia-tipDia)/2]) 
        rotate([0,90,0]) cylinder(d=tipDia,h=200,center=true);
    }
}