// Hand Tool to Zwilling Fresh&Save Vacuum Tool
$fn=100;
fudge=0.1;
/*[Dimensions]*/
adaptDia=34.25;
adaptHght=4.95;
adaptStpHght=2.45;
adaptStpDia=37;
wallThck=3;

/*[show]*/
showRubber=true;
showAdapter=true;
showCut=true;

if (showAdapter)
  difference(){
    adapter();
    if (showCut) translate([0,(adaptStpDia/2-fudge)/2,-(19-adaptHght)/2]) cube([adaptStpDia+fudge,adaptStpDia/2+fudge,19+adaptHght+fudge],true);
  }
if (showRubber)
  color("grey") translate([0,0,-19]) handToolRubber();

module adapter(){
  ovWallThck=(adaptStpDia-adaptDia+wallThck*2)/2;
  wallAngle=atan(((adaptStpDia-28.5)/2)/(19-3.75)); //tan(a)=GK/AK
  innerDia=28.5+tan(wallAngle)*5*2-ovWallThck*2;
  echo(wallAngle,innerDia);
  *translate([28.5/2,0,-19+3.75]) rotate([0,wallAngle,0]) cylinder(d=1,h=5);
  //body
  difference(){
    union(){
      translate([0,0,-19+3.75]) cylinder(d1=28.5,d2=adaptStpDia,h=19-3.75);
      cylinder(d=adaptDia,h=adaptHght);
      cylinder(d=adaptStpDia,h=adaptStpHght);
    }
    cylinder(d=adaptDia-wallThck*2,adaptHght+fudge);        
    translate([0,0,-19+3.75-fudge/2]) cylinder(d=10.2,h=19-3.75);
    //translate([0,0,-19+3.75+5-fudge/2]) cylinder(d=15,h=19-3.75-5+fudge);
    translate([0,0,-19+3.75+5-fudge/2]) cylinder(d1=innerDia,d2=adaptDia-wallThck*2,h=19-3.75-5+fudge);
  }
}

module handToolRubber(){
  //remoddeling of the rubber part
  skew=1.6;
  difference(){
    union(){
      cylinder(d1=23,d2=28.5,h=3.75);
      cylinder(d1=23,,d2=28.5,h=3.75);
      cylinder(d=10,h=19);
      translate([0,0,5+3.75]) cylinder(d1=11.5,d2=10,h=2);
    }
    translate([0,0,-fudge]){
      cylinder(d=6.5,h=18+fudge);
      cylinder(d=17.5,h=2.0+fudge);
    }
    translate([0,0,16.75]) for (im=[0,1]) 
      mirror([im,0,0]) rotate([90,0,0]) linear_extrude(10,center=true) polygon([[1.4,0],[1.4,-3],[5,-3-skew],[5,-skew]]);
  }
}