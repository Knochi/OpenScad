/* [Dimensions] */
//Diameter of the handle
dBellHndlDia=20;
//Overall Length of the dumbbell
dBellOvLngth=390;
//Diameter of the weights face to face
dBellHexInDia=105;
//width of the weights
dBellHexWdth=125;
//radius of the roundings
filletRad=2;
//minimum wall thickness for mold
moldMinWallThck=7;
//diameter of the alignment holes
moldAlignmentHoleDia=8;
//diameter of the pour holes
moldPourHoleDia=20;
//add additional alignment holes?
moldAddAlignmentHoles=true;

/* [show] */
showDumbBell=true;
showTopMold=true;
showBotMold=true;
//export for 3Dprint
export="none"; //["none","topMold","bottomMold","dumbbell"]

/* [Hidden] */
fudge=0.1;
dBellHexOutDia= ri2ro(dBellHexInDia,6);
dBellZOffset= dBellHexInDia/2+moldMinWallThck;
dBellHndlLngth=dBellOvLngth-dBellHexWdth*2;

$fn=50;

if (export=="topMold")
  !render() mold(topMold=true);
if (export=="bottomMold")
  !render() mold(topMold=false);
if (export=="dumbbell")
  !render() dumbbell();

if (showDumbBell)
  color("grey") translate([0,0,dBellZOffset]) dumbbell();
if (showBotMold)
  color("darkGrey") mold(false);
if (showTopMold)
  color("lightGrey") translate([0,0,dBellHexInDia+moldMinWallThck*2]) rotate([180,0,0]) mold(true);
  
module mold(topMold=true){
  stemDia=moldAlignmentHoleDia+moldMinWallThck*2;
  difference(){
    linear_extrude(dBellHexInDia/2+moldMinWallThck,convexity=3){ 
      difference(){
        union(){
          offset(moldMinWallThck) projection(cut=true) dumbbell();
          //alignment Holes stems
          for (ix=[-1,1],iy=[-1,1]){
            rot = (iy <0) ? 45 : 135;
            translate([ix*(dBellOvLngth/2+moldMinWallThck),iy*(dBellHexOutDia/2+moldMinWallThck),0]){ 
              circle(d=stemDia);
              rotate(ix*rot) translate([-stemDia/2,0]) square(stemDia);
              }
            //add additional holes
            if (moldAddAlignmentHoles)
              translate([ix*(dBellHndlLngth/2-moldMinWallThck-moldAlignmentHoleDia/2),
                         iy*(dBellHndlDia/2+moldMinWallThck+moldAlignmentHoleDia/2),0]) 
                circle(d=stemDia);
          }
        }
        //mounting holes
        for (ix=[-1,1],iy=[-1,1]){
          translate([ix*(dBellOvLngth/2+moldMinWallThck),iy*(dBellHexOutDia/2+moldMinWallThck),0]) 
            circle(d=moldAlignmentHoleDia);
           //add additional holes
          if (moldAddAlignmentHoles)
            translate([ix*(dBellHndlLngth/2-moldMinWallThck-moldAlignmentHoleDia/2),
                       iy*(dBellHndlDia/2+moldMinWallThck+moldAlignmentHoleDia/2),0]) 
              circle(d=moldAlignmentHoleDia);
            }
        if (topMold) for (ix=[-1,1])
          translate([ix*(dBellOvLngth-dBellHexWdth)/2,0]) circle(d=moldPourHoleDia);
      }
    }
    translate([0,0,dBellZOffset]) dumbbell();
    }
}  
  
  
module dumbbell(){
  //Hexagon Ends
  for (ix=[-1,1])
    translate([ix*(dBellOvLngth-dBellHexWdth)/2,0,0]) 
      rotate([90,0,90]) roundedHexPrism(dBellHexOutDia/2,dBellHexWdth,filletRad,center=true);
  //handle
  rotate([0,90,0]) cylinder(d=dBellHndlDia,h=dBellOvLngth-2*dBellHexWdth+fudge,center=true);
  //fillets
  for (im=[0,1])
    mirror([im,0,0]) translate([(dBellOvLngth/2-dBellHexWdth),0,0]) 
      rotate([0,-90,0]) fillet();
}


module roundedHexPrism(radius=10, height=7, cornerRadius=1, center=true){
  centerOffset= center ? [0,0,0] : [0,0,height/2];
  translate(centerOffset){
    *linear_extrude(height,center=true) offset(cornerRadius) circle(radius-cornerRadius,$fn=6);
    hull() for (iz=[-1,1],ir=[0:60:300])
      rotate(ir) translate([radius-cornerRadius,0,iz*(height/2-cornerRadius)]) sphere(cornerRadius);
  }
}


module fillet(){
  rotate_extrude() translate([dBellHndlDia/2,0]) difference(){
        translate([-fudge,-fudge]) square(filletRad+fudge);
        translate([filletRad,filletRad]) circle(filletRad);
      }
}
//calculate inner radius from outer or vice versa for regular polygons
function ri2ro(r=1,n=$fn)=r/cos(180/n);
function ro2ri(r=1,n=$fn)=r*cos(180/n);