// Remix of the model of https://makerworld.com/de/@Avlastuin
// https://makerworld.com/de/models/49607-desk-stand-for-xtouch-using-esp32-2432s028


/*[Variants]*/
modelVar="2432s028"; //["2432s028","2432s028-2USB","custom"]

/*[Positions]*/

/*[Housing Dimensions]*/
frontThck=0.4;
wallThck=1.6;
cornerRad=5.5;

standOffHght=2;

/* [PCB] */
pcbDimsCstm=[85.85,50.2,1.6];
pcbSpcng=0.6;
pcbHoleDistCstm=[78.4,42];
//clearance to keep on back of PCB for components
pcbBackClrnc=6;

/* [Display] */
displayDimsCstm=[69.5,50.1,4.2];
displaySpcng=0.4;
//Offset from lowerleft corner of PCB
displayOffsetCstm=[9.7,1.6];
//Active Area Dimensions
AADimsCstm=[59.9,45.7];
//Offset from lowerLeft Corner of Display
AAOffsetCstm=[12.4,4.6]; 

/* [Cutouts] */
//relative to PCB lower left
sdPosCstm=[50.5,1,6];
sdSize=[15,3];

/*[show]*/
showOriginal=true;
showFront=true;
showBack=true;

/* [Hidden] */
fudge=0.1;
$fn=20;


pcbDims= (modelVar=="2432s028") ? [86,50.5,1.6] : //check!
                                  pcbDimsCstm;
pcbHoleDist = (modelVar=="2432s028") ? [78,42] : //check!
              (modelVar=="2432s028-2USB") ? [] :
              pcbHoleDistCstm;
displayDims = (modelVar=="2432s028") ? [69.8,50.5,4] : //check
              displayDimsCstm;
displayOffset= (modelVar=="2432s028") ? [8.1,0] : //check
              displayOffsetCstm;
              
AADims= (modelVar=="2432s028") ? [59.9,45.7] : //check
         AADimsCstm;
AAOffset= (modelVar=="2432s028") ? [2.7,3.0] : //check
        AAOffsetCstm;
        
//calculate Housing Dimensions from component sizes        
frontHsngDims=[wallThck*2+pcbDims.x+pcbSpcng*2,
               wallThck*2+pcbDims.y+pcbSpcng*2,
               frontThck+displayDims.z+pcbDims.z+pcbBackClrnc];

if (showOriginal)
  %import("Front.stl");

if (showFront)
  front();
  
module front(){
  socketHght=frontThck+displayDims.z-standOffHght;
  
  //tolerance chains
  pcbPos=[wallThck+pcbSpcng,wallThck+pcbSpcng];
  displayPos=[pcbPos.x-displaySpcng,pcbPos.y-displaySpcng]+displayOffset;
  AAPos=displayPos+AAOffset;
  
  difference(){
    linear_extrude(frontHsngDims.z) shape();
    //hollow out
    translate([0,0,socketHght]) linear_extrude(frontHsngDims.z) offset(-wallThck) shape();
    //Display Opening
    translate([0,0,-fudge]) translate(AAPos) 
      linear_extrude(frontHsngDims.z) square(AADims);
    //display Cavity
    translate([0,0,frontThck]) translate(displayPos) linear_extrude(displayDims.z+fudge) 
      square([displayDims.x+displaySpcng*2,displayDims.y+displaySpcng*2]);
  }
  
  //standoffs
  for (ix=[1,-1],iy=[1,-1])
    translate([ wallThck+pcbDims.x/2+pcbSpcng-ix*pcbHoleDist.x/2,
                wallThck+pcbDims.y/2+pcbSpcng-iy*pcbHoleDist.y/2,socketHght]) 
      linear_extrude(standOffHght) difference(){
        circle(d=2.9+wallThck*2);
        circle(d=2.9);
      }
  module shape(){
    translate([cornerRad,cornerRad]) offset(cornerRad) square([frontHsngDims.x-cornerRad*2,frontHsngDims.y-cornerRad*2]);
  }
}