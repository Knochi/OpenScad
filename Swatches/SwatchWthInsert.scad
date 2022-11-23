
/* [Dimensions] */
//overall dimensions
ovDims=[85,54,4.5]; 
//corner Radius
crnRad=8; 
insrtDims=[35.6,18.6,3];
insrtSpcng=[0.2,0.2,0.25];
//cavities square dimension
cavSize=8;
//cavities radius 
cavRad=2; 
//cavities depth
cavZ=[[3,3.5,4],[1.5,2,2.5]]; //bottom left to top right
nudgeCnt=3;
nudgeRad=3.5;
nudgeDeep=1.5;
nudgeOffset=12.5; 

/* [Text] */
txtFont="Exo";
txtStyle="Black";
txtLine1="HALO";
txtLine2="Black Hole Sun";
txtLine3="PLA";

/* [Hidden] */
fudge=0.1;
cavPitch=[11.8,11];
cavOffset=[8,2.5,0];
insOffset=[43.3,2.5,1];
txt1Offset=[7,42.1,3.5];
txt2Offset=[7,34.1,3.5];
txt3Offset=[7,26,3.5];
txt1Size=7.3;
txt2Size=5.8;
txt3Size=5.8;
$fn=50;

//the sample
sample();

//the insert
translate([-insrtDims.z-3,0,0]) rotate([90,0,90]) cube(insrtDims);

module sample(){
    difference(){
      //body
      rndRect(ovDims,crnRad,0);
      //cavities
      for (ix=[0:2],iy=[0,1]){
        zOffset=ovDims.z-cavZ[iy][ix];
        translate([ix*cavPitch.x,iy*cavPitch.y,zOffset]+cavOffset) linear_extrude(cavZ[iy][ix]+fudge) cavity();
      }
      //insert
      translate(insOffset) cube(insrtDims+insrtSpcng*2+[0,0,fudge]);
      //text line 1 (Manufacturer)
      translate(txt1Offset) linear_extrude(ovDims.z+fudge,convexity=5) text(text=txtLine1,size=txt1Size,font=str(txtFont,":style=",txtStyle));
      //text line 2 (Name)
      translate(txt2Offset) linear_extrude(ovDims.z+fudge,convexity=5) text(text=txtLine2,size=txt2Size,font=str(txtFont,":style=",txtStyle));
      //text line 3 (Material)
      translate(txt3Offset) linear_extrude(ovDims.z+fudge,convexity=5) text(text=txtLine3,size=txt3Size,font=str(txtFont,":style=",txtStyle));
      //nudge
      for (ix=[0:nudgeCnt-1])
        translate([nudgeOffset+ix*nudgeRad*2,ovDims.y+nudgeRad-nudgeDeep,-fudge/2]) cylinder(r=nudgeRad,h=ovDims.z+fudge);
      //hole
      translate([ovDims.x-crnRad,ovDims.y-crnRad,-fudge/2]) cylinder(d=crnRad,h=ovDims.z+fudge);
    }
}

*cavity();
module cavity(size=[8,8],rad=2){
    square([size.x-rad,size.y-rad]);
    translate([rad,rad]) square([size.x-rad,size.y-rad]);
    translate([rad,size.y-rad]) circle(rad);
    translate([size.x-rad,rad]) circle(rad);
}
module rndRect(size=[10,10,2],radius=3,drillDia=1,center=false){
  //set to cube if size.y not defined
  dims = (size.y==undef) ? [size.x,size.x,size.x] : size;
  comp = (size.x>size.y) ? size.y : size.x; //which value to compare to
  radius = (radius>(comp/2)) ?  comp/2 : radius; //set and limit radius
  cntrOffset = center ? len(size)<3 ? [0,0] : // center && len(size)<3
                                      [0,0,-size.z/2] : //else if center
                                      [size.x/2,size.y/2,0]; //else
  echo(cntrOffset);
  if (len(size)<3)
    translate(cntrOffset) shape();
  else
    translate(cntrOffset) linear_extrude(size.z)  shape();

  module shape(){
    difference(){
      hull() for (ix=[-1,1], iy=[-1,1])
        translate([ix*(dims.x/2-radius),iy*(dims.y/2-radius)])
          circle(r=radius);//cube

      if (drillDia) for (ix=[-1,1],iy=[-1,1]) //drill holes
          translate([ix*(dims.x/2-radius),iy*(dims.y/2-radius)]) 
            circle(d=drillDia);
    }
  }
}