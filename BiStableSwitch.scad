/* Print in place bistable swtch */

/* [General] */
minWallThck=2;
cornerRad=3;

/* [Plate] */
pltThck=5.1;
pltWdth=60;
pltHght=28;

/* [Switches] */
swtchKnobDia=6;
swtchKnobHght=5.7;
swtchTrvl=4.5;

/* [Spacings] */
swtch2PltSpcng=0.2;

/* [show] */
showSwitches=true;

/* [Hidden] */
fudge=0.1;
snpNtchRad=2.25;  //notch where the snap logs in
snpNtchDepth=0.6; //deptch of the notches
snpHeadRad=1.8;   //radius of the snap head
snpCntrDist=-0.3;  //distance of the two centers

snpSprngWdth=0.8;

swtchThck=3;
swtchHght=swtchKnobDia+1;
swtchLen=swtchKnobDia*3;

swtchOvWdth=swtchHght+swtchThck;
//the minimum spacing between two switches
swtchMinSpcng=minWallThck*2+swtchLen+swtchTrvl+swtch2PltSpcng*2;
//overall length of the compartment for a switch
swtchCompLen=swtchLen+swtchTrvl+swtch2PltSpcng*2;

$fn=50;

testPlate();

module testPlate(){
  if (showSwitches)
    for (ix=[-1,1])
      translate([ix*swtchMinSpcng/2,0,0]) switch("left",false);
  difference(){
    translate([0,0,-swtchThck/2]) linear_extrude(pltThck) offset(cornerRad) 
      square([pltWdth-cornerRad*2,pltHght-cornerRad*2],true);
    for (ix=[-1,1])
      translate([ix*swtchMinSpcng/2,0,0]) switch("center",true);
   }
}





*switch();
module switch(pos="left", cut=false){

  poly=[[-swtchOvWdth/2,0],[-swtchHght/2,swtchThck/2],[swtchHght/2,swtchThck/2],
        [swtchOvWdth/2,0],[swtchHght/2,-swtchThck/2],[-swtchHght/2,-swtchThck/2]];
  swtchOffset= pos=="left" ? [-swtchTrvl/2,0,0] : 
               pos=="right" ? [swtchTrvl/2,0,0] :
                              [0,0,0]; //center
        
  if (cut){
    rotate([90,0,90]) linear_extrude(swtchCompLen,center=true) offset(swtch2PltSpcng) polygon(poly);
    spring(cut=true);
    //knob opening
    hull() for (ix=[-1,1]) 
      translate([ix*swtchTrvl/2,0,swtchThck/2]) cylinder(d=swtchKnobDia+swtch2PltSpcng*2,h=swtchKnobHght+swtch2PltSpcng);
    
  }
  else{
    translate(swtchOffset) difference(){
      union(){
        //body
        rotate([90,0,90]) linear_extrude(swtchLen,center=true) polygon(poly);
        //knob
        translate([0,0,swtchThck/2]) cylinder(d=swtchKnobDia,h=swtchKnobHght);
      }
    //nudges
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*swtchTrvl/2,iy*(swtchOvWdth/2+snpNtchRad-snpNtchDepth),0]) 
          cylinder(d=snpNtchRad*2,h=swtchThck+fudge,center=true);
    }
    spring();
  }
}

module spring(cut=false){
  snpHeadOffset=swtchOvWdth/2+snpNtchRad-snpNtchDepth+snpCntrDist;
  sprngClrnc= cut ? snpNtchDepth+swtch2PltSpcng : 0;
  
  if (cut)
    linear_extrude(swtchThck+swtch2PltSpcng*2,center=true){
      sprngShape();
      *square([(snpHeadRad+sprngClrnc)*2,(snpHeadOffset+snpHeadRad)*2],true);
    }
  else
    linear_extrude(swtchThck,center=true) 
      sprngShape();
    
  module sprngShape(){
    for (i=[0,1]) mirror([0,i,0]){
      translate([0,snpHeadOffset,0]) circle(snpHeadRad+sprngClrnc/2);
      translate([0,snpHeadOffset+snpHeadRad/2+sprngClrnc/2,0]) 
        square([snpHeadRad*2+sprngClrnc*2,snpHeadRad+sprngClrnc/2],true);
      translate([0,snpHeadOffset+snpHeadRad-snpSprngWdth/2,0]) 
        square([swtchCompLen,snpSprngWdth+sprngClrnc*2],true);
    }
  }
}
