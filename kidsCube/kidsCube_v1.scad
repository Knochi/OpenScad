use <eCAD/elMech.scad>
$fn=24; //multiple of four


/* [Dimensions] */
ovDims=[120,120,120];
rad=6;

/* [Hidden] */
fudge=0.1;




cage(ovDims,dia=rad*2);
cube(ovDims+[-rad*2,-rad*2,-rad*2],true);
translate([0,0,ovDims.z/2-rad]) arcadeButton(size=30,panelThck=3,col="yellow");


batDims=[53,45,8];

*cage();
module cage(size=[100,100,100], dia=12){
    
    for (ix=[-1,1],iy=[-1,1],iz=[-1,1]){
        //z-beams
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad),0]) cylinder(d=dia,h=size.x-dia,center=true);
        //x-beams
        translate([0,iy*(size.y/2-rad),iz*(size.z/2-rad)]) rotate([0,90,0]) cylinder(d=dia,h=size.x-dia,center=true);
        //y-beams
        translate([ix*(size.x/2-rad),0,iz*(size.z/2-rad)]) rotate([90,0,0]) cylinder(d=dia,h=size.x-dia,center=true);
    }
    for (rot=[0,90,180,270],iz=[0,1])
        mirror([0,0,iz]) rotate(rot) translate([(size.x/2-rad),(size.y/2-rad),(size.z/2-rad)]) crnrCap();
    //vertical beams
    //for (ix=[-1,1],iy=[-1,1])
    *crnrCap();
    module crnrCap(){
        rotate_extrude(angle=90) intersection(){
            square([rad,rad]);
            circle(d=12);
        }
    }    
    
}

*rndCube(ovDims,6);
module rndCube(size=[10,10,10],rad=3){
    //very slow rendering --> 46s @ fn=50
    hull() for (ix=[-1,1],iy=[-1,1],iz=[-1,1]){
        translate([ix*(size.x/2-rad),iy*(size.y/2-rad),iz*(size.z/2-rad)]) sphere(r=rad);
    }
}