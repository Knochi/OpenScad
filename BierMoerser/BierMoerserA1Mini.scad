/* [ Tube ] */
outerDia=75;
wallThck=2.2;
totalHghtTube=250;
showUpperTube=false;
showLowerTube=false;
cutHght=120;

/* [ Stand ] */
showLowerStand=false;
showUpperStand=false;

/*[ General ] */
spacing=0.1;


$fn=113;

if (showUpperStand)
intersection(){
  translate([-24.96,-8.36,0]) import("MoerserHauptstandbein.stl",convexity=4);
  translate([0,0,100]) cylinder(d=18.0-spacing*2,h=202);
}

if (showLowerStand)
difference(){
  translate([-24.96,-8.36,0]) import("MoerserHauptstandbein.stl",convexity=4);
  translate([0,0,100]) cylinder(d=18.0,h=202);
}
if (showUpperTube)
  difference(){
    translate([-62.25,-75/2,0]) 
      import("MoerserGrundkoerper.stl",convexity=4);
    union(){
      translate([0,0,-0.1]) cylinder(d=130,h=cutHght+0.1+spacing);
      difference(){
        cutOuts(spacing);
        cylinder(d=outerDia-wallThck+spacing,h=totalHghtTube);
      }
    }
  }

//lower part
if (showLowerTube)  
  intersection(){
    translate([-62.25,-75/2,0]) 
      import("MoerserGrundkoerper.stl",convexity=10);
    union(){
      translate([0,0,-0.1]) cylinder(d=130,h=cutHght+0.1);
      difference(){
        cutOuts();
        cylinder(d=outerDia-wallThck-spacing,h=totalHghtTube);
      }
    }
  }

module cutOuts(spcng=0){
  translate([0,0,140]) rotate([0,90,0]) 
    linear_extrude(60) 
      offset(3+spcng*2) square([60,16.5],true);
  translate([0,0,117]) rotate([0,-90,0]) 
    linear_extrude(60) 
      offset(3+spcng*2) square([50,22.5],true);  
}