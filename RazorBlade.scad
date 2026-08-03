//https://www.badgerandblade.com/forum/threads/my-process-of-measuring-de-razor-blade-dimensions-for-b-b-shavewiki.509238/
/* razorBladeDimensions*/
//Thickness
bldT=0.1;
//Width
bldW=22;
//Length
bldL=43;
//Tab Width
bldTW=12; //?
//Cutting Edge Length
bldCEL=37;
//Recessed Length
bldRL=0;
//Cutout Width
bldCW=2.1;
//Cutout Length
bldCL=36.3;
bldCES="F"; //["F":"Flat","A":"Angled"]
bldCD=5.4;

//Diamond radius
bldDR=0;
//Diamond distance
bldDD=25.4;
bldDW=6.4;

// -- Keyholes --
//keyholes length
bldKL=2;
//inner Keyholes width
bldIKW=6.4;
//inner Keyholes distance
bldIKD=16.7;
//Keyholes radius
bldKR=0;
blOKW=6.4;

/* [Hidden] */
$fn=50;

linear_extrude(bldT) difference(){
  union(){
    square([bldL,bldTW],true);
    square([bldCEL,bldW],true);
  }
  //center hole
  circle(d=bldCD);
  //slot
  square([bldCL,bldCW],true);
  //keys and diamonds
  for (ix=[-1,1]){
    translate([ix*bldIKD/2,0]) square([bldKL,bldIKW],true);
    translate([ix*(bldCL-bldKL)/2,0]) square([bldKL,bldIKW],true);
    translate([ix*bldDD/2,0]) circle(d=bldDW,$fn=4);
  }
}

