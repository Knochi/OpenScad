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

/* [Lever] */
leverHght=11;
leverWdth=10.8;
showUpperLever=true;
showLowerLever=true;
beamWdth=leverWdth-wallThck*2;
beamLngth=10;
  
/*[ General ] */
spacing=0.1;

/* [Hidden] */
fudge=0.1;

$fn=113;


if (showUpperLever)
  difference(){
    intersection(){
      rotate(90-66.3125) translate([-24.86,-110.2,0]) import("MoerserHebelV3mitFederPin.stl",convexity=3);
      leverCutOuts();
    }
    *translate([0,beamLngth*2,leverHght]) mirror([0,0,1]) rotate(180) leverCutOuts();
  }
  
if (showLowerLever)
  difference(){
    rotate(90-66.3125) translate([-24.86,-110.2,0]) import("MoerserHebelV3mitFederPin.stl",convexity=3);
    leverCutOuts(spacing);
  }

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
        tubeCutOuts(spacing);
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
        tubeCutOuts();
        cylinder(d=outerDia-wallThck-spacing,h=totalHghtTube);
      }
    }
  }

module leverCutOuts(spcng=0){
  translate([0,0,leverHght/2-spcng]) linear_extrude(leverHght/2+spcng+fudge){
    circle(d=beamWdth+spcng*2);
    translate([-leverWdth/4-spcng,0]) square([leverWdth/2+spcng*2,beamLngth]);
    *translate([0,beamLngth-beamWdth/2]) circle(d=beamWdth+spcng*2);
  }
  translate([0,0,-fudge/2]) linear_extrude(leverHght+fudge) translate([-leverWdth,beamLngth-fudge-spcng]) square([leverWdth*2,145]);
}
  
module tubeCutOuts(spcng=0){
  translate([0,0,140]) rotate([0,90,0]) 
    linear_extrude(60) 
      offset(3+spcng*2) square([60,16.5],true);
  translate([0,0,117]) rotate([0,-90,0]) 
    linear_extrude(60) 
      offset(3+spcng*2) square([50,22.5],true);  
}