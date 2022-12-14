use <bezier.scad>

/*[Dimensions] */
rimOuterDia=75;
rimInnerDia=65;
rimHght=3;
glassHght=46;
spcng=[0.3,0.2]; //inner,outer
strpWdth=10; //width of the soaked fabric strip
fudge=0.1;


/* [show] */
showGlass=true;
showBowl=true;

/*[hidden] */
$fn=50;

if (showGlass) color("grey",0.3) glass();
if (showBowl) color("burlyWood") bowl();

module bowl(){
  zOffset= (showGlass) ? glassHght : 0;
  wallThck=2;
  deep=4;
  opnDims=[2,strpWdth,wallThck+deep+fudge];
  opnDist=7;

  bezPoly=[               [0,-deep],                         OFFSET([15,0]),
              LINE(),        [rimInnerDia/2-spcng[0],-deep],   LINE(),
              LINE(),        [rimInnerDia/2-spcng[0],0],          LINE(),
              LINE(),        [rimOuterDia/2+spcng[1],0],          LINE(),
              LINE(),        [rimOuterDia/2+spcng[1],-rimHght],   LINE(),
              LINE(),        [rimOuterDia/2+spcng[1]+wallThck,-rimHght],   LINE(),
              LINE(),        [rimOuterDia/2+spcng[1]+wallThck,wallThck],   OFFSET([-15,0]),
              OFFSET([15,0]),        [0,wallThck-4]
  ];

  //body
  translate([0,0,zOffset]){
    difference(){
      rotate_extrude() 
        polygon(Bezier(bezPoly,precision=0.05));
    //watering openings
    for (ir=[0,120,240])
      rotate(ir) translate([rimInnerDia*0.33,0,-deep]){
      for (ix=[-1,1])
         translate([ix*opnDist/2,0,opnDims.z/2-fudge/2]) cube(opnDims,true);
      }
    }
    for (ir=[0,120,240])
      rotate(ir) translate([rimInnerDia*0.33,0,])
        rotate([90,0,0]) cylinder(d=opnDist-opnDims.x,h=opnDims.y,center=true);
  }
  
}

module glass(){
  rimOuterDia=75;
  rimInnerDia=65;
  rimHght=3;
  wallThck=2;
  
  //        control,       point ,                         control 
  bezPoly=[                [0,0],                          LINE(),         
           LINE(),         [35,0],                         OFFSET([15,0]),       
           OFFSET([-5,0]), [35,glassHght-rimHght],          LINE(),
           LINE(),         [35-wallThck,glassHght-rimHght], OFFSET([-5,0]),
           OFFSET([15,0]), [35-wallThck,wallThck],         LINE(),
           LINE(),         [0,wallThck]
           ];      
  //body
  rotate_extrude() polygon(Bezier(bezPoly,precision=0.05));
  //rim
  translate([0,0,glassHght-rimHght]) linear_extrude(rimHght) difference(){
    circle(d=rimOuterDia);
    circle(d=rimInnerDia);
  }  
}
