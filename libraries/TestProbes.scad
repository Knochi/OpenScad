//Fixtest Prüfkontakte - https://www.fixtest.de/produkte/federkontakte/ictfct-zoellig/
Series_S27(travel="none");

module Series_S27(tip="02.20", contact="W", travel="typ"){
  //fix ring heights above PCB:
  //no travel:  7.5 + 8.85 = 16.35mm
  //typ travel: 7.5 + (8.85-4.2) = 12.15mm
  //max travel: 7.5 + (8.85-6.35) = 10mm
  
  $fn=50;
  ovHght=40;
  fudge=0.1;
  shimHght=1.5;
  travelTyp=4.2;
  travelMax=6.35;
  zOffset=16.35;
  travel= travel=="typ" ? travelTyp : travel=="max" ? travelMax : 0;
  
  color("gold")
  translate([0,0,8.85-zOffset]) union(){ //the housing
    if (contact == "W"){
      translate([0,0,30.5+9.5/2]) cube([0.64,0.64,9.5+fudge],true);
      translate([0,0,24.9]) cylinder(d=2.15,h=30.5-24.9);
    }
    
    if (contact == "L")
   
    translate([0,0,24.9]) cylinder(d=2.15,h=6.4);
    difference(){
      translate([0,0,0]) cylinder(d=2.7,h=24.9-shimHght);
      translate([0,0,-fudge]) cylinder(d=2.1,h=24);
    }
    translate([0,0,24.9-shimHght]) cylinder(d1=2.7,d2=2.15,h=shimHght);
    translate([0,0,7.6]) rotate_extrude() translate([2.82/2-0.25,0]) circle(d=0.5);
  }
  
  color("silver") translate([0,0,-zOffset+travel])
  if (tip=="02.20"){
    cylinder(d1=0,d2=2,h=4);
    translate([0,0,4]) cylinder(d=2,h=8.85-2);
  
  }
}

translate([10,0,0]) RSPro19("typ");
module RSPro19(travel="typ"){
  //fix ring heights above PCB:
  //no travel:  2.5 + 3.35 =        5.85mm
  //typ travel: 2.5 + (3.35-2.45) = 3.4mm
  //max travel: 2.5 + (3.35-3.35) = 2.5mm
  
  $fn=50;
  fudge=0.1;
  ovHght=17.4+3.35;
  shimHght=0.5; //height of diameter reducing shim
  travelTyp=2.45;
  travelMax=3.35;
  tipLength=3.35;
  
  zOffset=5.85; //no Travel fix ring height
  travel= travel=="typ" ? travelTyp : travel=="max" ? travelMax : 0;
  
  color("gold")
  
  translate([0,0,tipLength-zOffset]) union(){ //the housing
        
    translate([0,0,12.7]) cylinder(d=1.2,h=4.7); //solder/crimp top
    difference(){
      translate([0,0,0]) cylinder(d=1.31,h=12.7-shimHght); //outer shell
      translate([0,0,-fudge]) cylinder(d=1.0,h=24);//hole
    }
    translate([0,0,12.7-shimHght]) cylinder(d1=1.31,d2=1.2,h=shimHght);//shim
    translate([0,0,2.5]) rotate_extrude() translate([1.44/2-0.15,0]) circle(d=0.3);//fix ring
  }
  
  color("silver") translate([0,0,-zOffset+travel]){ //the Tip
    cylinder(d1=0,d2=0.77,h=tipLength/2);
    translate([0,0,tipLength/2]) cylinder(d=0.77,h=12-2);}
}