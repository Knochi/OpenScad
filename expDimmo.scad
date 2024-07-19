use <eCad/connectors.scad>



/* Mic arrangement */
$fn=50;
r0=13;
r1=20;
r2=27;
radii=[r0,r1,r2];
label=["A","B","C"];
lineWdth=0.2;
pcbThck=1.6;
pcbDia=80;
pcbCorners=6;
portDiaPCB=1;
txtOffset=2;

// --- Mics ---
for (i=[0:2],r=[0:2]){
  rotate(i*120) translate([radii[r],0,0]) PDMMic();
}
 PDMMic();

// Connectors
translate([-26,0,0]) rotate(90) duraClik(5);

//Silkscreen bottom
for (i=[0:2])
  translate([0,0,-pcbThck-0.1]) color("white") linear_extrude(0.1){
    difference(){
      circle(radii[i]+lineWdth/2);
      circle(radii[i]-lineWdth/2);
      for (ir=[0:2],rad=[0:2])
        rotate(ir*120) translate([radii[rad],0,0]) circle(d=portDiaPCB*2);
    }
    rotate(60) translate([radii[i]+txtOffset,0,0]) rotate(90) 
      mirror([1,0,0]) text(text=str(radii[i],"mm"),size=2,valign="center",halign="center");
    //labels
    rotate(i*120) translate([radii[2]+txtOffset*2,0,0])
      rotate(90) 
        mirror([1,0,0]) text(text=str(label[i]),size=2,valign="center",halign="center");
    rotate(-60) translate([txtOffset,0]) text(text="D",size=2,valign="center",halign="center");
    
    //lines
    rotate(i*120)  difference(){
        translate([pcbDia/4,0]) square([pcbDia/2,lineWdth],true);
        for (i=[0:2])
          translate([radii[i],0]) circle(d=portDiaPCB*2);
        translate([radii[2]+txtOffset*2,0]) circle(d=2*2);
        circle(d=radii[0]*2);
      }
    
  }

color("darkgreen") translate([0,0,-pcbThck]) linear_extrude(pcbThck) 
  difference(){
    circle(d=pcbDia,$fn=pcbCorners);
    for (i=[0:2],r=[0:2])
      rotate(i*120) translate([radii[r],0,0]) circle(d=portDiaPCB);
    circle(d=portDiaPCB);
  }
//center





module PDMMic(){
  ovDims=[3.5,2.65,0.98];
  portOffset=[-2.465,-ovDims.y/2,0];
  difference(){
    color("silver") translate([0,0,0]+portOffset) cube(ovDims,0);
    color("black") translate([0,0,-0.1]) cylinder(d=0.325,h=0.2);
  }
}