fudge=0.1;
/* [show] */
showBox=true;

/* [Dimensions] */
boxDims=[228,288,52];
boxWallThck=1.8;
minWallThck=1.8;
boxSpacing=0.5;

/* [Cards] */
sleeveDims = [68,94,0.46];
cardDims= [63.5,88,0.355];
isSleeved=true;
cardGripDia=25;
cardSpacing=0.5;

/* [Hidden] */


translate([-8,0,0]) import ("Alien_RPG_card_tray_x2.stl");
translate([-9,-39,0]) import ("Alien_RPG_card_and_token_tray.stl");
translate([-8,0,0]) import ("Alien_RPG_dice_insert_optional.stl");


if (showBox)
  color("darkslategrey") AlienRPGBox();
  
module AlienRPGBox(){
  ovDims=boxDims; //outer Dimensions
  wallThck=boxWallThck;
  translate([0,0,ovDims.z/2-wallThck]) difference(){
    cube(ovDims,true);
    translate([0,0,wallThck/2]) cube([ovDims.x-wallThck*2,ovDims.y-wallThck*2,ovDims.z-wallThck+fudge],true);
  }
}

module cards(stack=10){
  ovDims= isSleeved ? [sleeveDims.x,sleeveDims.y,sleeveDims.z*stack] : [cardDims.x,cardDims.y,cardDims.z*stack];
  translate([0,0,stack*cardDims.z/2]) cube(ovDims,true);
}

!tripleCards();
module tripleCards(height=20){
  cDims= isSleeved ? [sleeveDims.x,sleeveDims.y] : [cardDims.x,cardDims.y];
  ovDims=[boxDims.x-boxSpacing*2,cDims.y+minWallThck*2+cardSpacing*2,height];
  
  translate([0,0,height/2]) difference(){
    cube(ovDims,true);
    for (ix=[-1:1]){
      translate([ix*(cDims.x+minWallThck+cardSpacing*2),0,(minWallThck+fudge)/2]) 
        cube([cDims.x+cardSpacing*2,cDims.y+cardSpacing*2,height-minWallThck+fudge],true);
      for (iy=[-1,1])
      translate([ix*(cDims.x+minWallThck+cardSpacing*2),iy*ovDims.y/2,0]) 
        cylinder(d=cardGripDia,h=height+fudge,center=true);
    }
  }
}
