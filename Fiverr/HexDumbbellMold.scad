/* [Dimensions] */
dBellHndlDia=20;
dBellOvLngth=390;
dBellHexInDia=105;
dBellHexWdth=125;
moldWallThck=5;


/* [Hidden] */
fudge=0.1;
dBellHexOutDia= ri2ro(dBellHexInDia,6);

dumbbell();

module dumbbell(){
  //Hexagon Ends
  for (ix=[-1,1])
    translate([ix*(dBellOvLngth-dBellHexWdth)/2,0,0]) 
      rotate([90,0,90]) cylinder(d=dBellHexOutDia,h=dBellHexWdth,$fn=6,center=true);
  //handle
  rotate([0,90,0]) cylinder(d=dBellHndlDia,h=dBellOvLngth-2*dBellHexWdth,center=true);
}

//calculate inner radius from outer or vice versa for regular polygons
function ri2ro(r=1,n=$fn)=r/cos(180/n);
function ro2ri(r=1,n=$fn)=r*cos(180/n);