/* [Dimensions] */
outerDims=[110,44,35];
minWallThck=1.2;
minFloorThck=2;
cornerRad=4;
spcng=0.2;

/* [Sealing] */
sealWdth=+3.0;
sealThck=2;
sealStyle="square";
sealPressThck=2;

/* [Locking] */
lockStyle="screws";
heatInserts="none"; //["none",2: "M2",2.5 : "M2.5", 3 : "M3", 4: "M4", 5: "M5", 6: "M6", 8 : "M8"]
screwDia=3;
screwLen=12;
screwHdDia=6;
screwHdLen=3;

/* [Cutout 1] */
cOut1Side="left"; //["none","left","right","front","back"]
//size of the solid hole
cOut1Size=[3.5,3.5];
//relative size of the sealing hole
cOut1Sealing=0.9; //[0.5:0.01:1]
cOut1RelPos=0; //[-1:0.1:1]

/* [Cutout 2] */
cOut2Side="left"; //["none","left","right","front","back"]
//size of the solid hole
cOut2Size=[3.5,3.5];
//relative size of the sealing hole
cOut2Sealing=0.9; //[0.5:0.01:1]
cOut2RelPos=0; //[-1:0.1:1]

/* [Show] */
quality=48; //[12:4:100]
showLid=true;
showBox=false;
showSeal=true;

/* [Hidden] */

  
//Coutouts into arrays
cOutSides=[cOut1Side,cOut2Side];
cOutSizes=[cOut1Size,cOut2Size];
cOutSealings=[cOut1Sealing,cOut2Sealing];
cOutRelPos=[cOut1RelPos,cOut2RelPos];

$fn=quality;
fudge=0.1;
lidHght=minFloorThck+screwHdLen+spcng;
boxWallThck=sealWdth+2*minWallThck;
insertDia=4.5;

//calculations for routing the seal inside the holes
//sealCrnrRad=min(insertDia/2,screwHdDia/2)+boxWallThck-minWallThck;
sealCrnrRad=insertDia/2+boxWallThck-minWallThck;
smallSealOffset=sealCrnrRad-sealWdth+screwHdDia/2+spcng;

screwDist=[outerDims.x-minWallThck*2-screwHdDia-spcng*2,
           outerDims.y-minWallThck*2-screwHdDia-spcng*2];

if (showLid)
  translate([0,0,outerDims.z]) rotate([180,0,0]) box(lid=true);
if (showBox)
  box(lid=false);
if (showSeal)
  color("blue") translate([0,0,outerDims.z-lidHght]) seal();
  
echo(screwDist);

module box(lid=false){

  boxHght= lid ? lidHght : outerDims.z-lidHght;  
  domeDia= insertDia+boxWallThck*2;
  
  difference(){
    union(){
      //walls
      linear_extrude(boxHght,convexity=3) difference(){
        offset(cornerRad) square([outerDims.x-cornerRad*2,outerDims.y-cornerRad*2],true);
        offset(cornerRad-boxWallThck) square([outerDims.x-cornerRad*2,outerDims.y-cornerRad*2],true);
      }
      //floor
      linear_extrude(minFloorThck,convexity=3) offset(cornerRad) square([outerDims.x-cornerRad*2,outerDims.y-cornerRad*2],true);
      
      //screw&seal Domes
      linear_extrude(boxHght,convexity=3){
        intersection(){
          for (ix=[-1,1],iy=[-1,1])
              translate([ix*screwDist.x/2,iy*screwDist.y/2,0]){
                circle(d=domeDia);
                rotate(atan2(iy,ix)+135) 
                  for (pos=[[smallSealOffset,0],[0,smallSealOffset]])
                    translate(pos)
                      rotate(180) intersection(){
                        difference(){
                          circle(r=screwHdDia/2+spcng-sealWdth);
                          circle(r=screwHdDia/2+spcng-sealWdth-minWallThck);
                        }
                        square(screwHdDia/2+spcng-sealWdth);
                      }
              }
          offset(cornerRad) square([outerDims.x-cornerRad*2,outerDims.y-cornerRad*2],true);
        } 
      }
      if (lid)
        translate([0,0,boxHght]) seal(false,true);
    } //union 
    
    //screw/insert holes
    if (lid){
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*screwDist.x/2,iy*screwDist.y/2,-fudge]){
          cylinder(d=screwHdDia+spcng*2,h=screwHdLen+spcng+fudge);
          cylinder(d=screwDia+spcng*2,h=lidHght+spcng+fudge*2);
        }
      }
    else{
      for (ix=[-1,1],iy=[-1,1])
        if (heatInserts!="none")
          translate([ix*screwDist.x/2,iy*screwDist.y/2,boxHght-screwLen]) 
          linear_extrude(screwLen+fudge) threadInsert(M=heatInserts, cut=true);
        else
          translate([ix*screwDist.x/2,iy*screwDist.y/2,boxHght-screwLen]) 
            linear_extrude(screwLen+fudge) circle(d=screwDia*0.85);
      //main seal cutout
      translate([0,0,boxHght-sealThck]) linear_extrude(sealThck+fudge,convexity=3) seal(true);
      for (i=[0:len(cOutSides)-1])
        translate([0,0,boxHght]) placeOnSide(side=cOutSides[i],relPos=cOutRelPos[i]) cutOut(size=cOutSizes[i]);
    }
  }
}

*seal();
module seal(cut=false, lid=false){

  if (cut)
    shape();
  else if (lid)
    lidPress();
  else{    
    translate([0,0,-sealThck]) linear_extrude(sealThck,convexity=3) shape();
    for (i=[0:len(cOutSides)-1])
      placeOnSide(side=cOutSides[i],relPos=cOutRelPos[i]) cutOut(size=cOutSizes[i],sealing=cOutSealings[i],mode="seal");
  }
  
  module shape(){
    difference(){
      offset(cornerRad-minWallThck) square([outerDims.x-cornerRad*2,outerDims.y-cornerRad*2],true);
      offset(cornerRad-minWallThck-sealWdth) square([outerDims.x-cornerRad*2,outerDims.y-cornerRad*2],true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*screwDist.x/2,iy*screwDist.y/2])
          square(smallSealOffset*2,true);
    }
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*screwDist.x/2,iy*screwDist.y/2]) rotate(atan2(iy,ix)+135) corner();
        
    module corner(){
      //big semicircle
      intersection(){
        difference(){
          circle(r=sealCrnrRad);
          circle(r=sealCrnrRad-sealWdth);
        }
        square(sealCrnrRad);
      }
      //small semicircles
      for (pos=[[smallSealOffset,0],[0,smallSealOffset]])
        translate(pos)
          rotate(180) intersection(){
            difference(){
              circle(r=screwHdDia/2+spcng);
              circle(r=screwHdDia/2+spcng-sealWdth);
            }
          square(screwHdDia/2+spcng);
        }
    }
  }
  
  module lidPress(){
    //corners
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*screwDist.x/2,iy*screwDist.y/2,0])
        rotate(atan2(iy,ix)+135){
        // big semicircles
          rotate_extrude(angle=90) translate([sealCrnrRad-sealWdth/2,0]) circle(d=sealPressThck,$fn=4);
        //small semicircles
          for (pos=[[smallSealOffset,0],[0,smallSealOffset]])
            translate(pos)
              rotate(180) 
                rotate_extrude(angle=90)
                  translate([screwHdDia/2+spcng-sealWdth/2,0]) circle(d=sealPressThck,$fn=4);
        }

    //sides
    for (ix=[-1,1])
      translate([ix*(outerDims.x/2-minWallThck-sealWdth/2),0,0]) 
        rotate([90,0,0]) linear_extrude(screwDist.y-sealCrnrRad*2,center=true) circle(d=sealPressThck,$fn=4);
    for (iy=[-1,1])
      translate([0,iy*(outerDims.y/2-minWallThck-sealWdth/2),0]) 
        rotate([0,90,0]) linear_extrude(screwDist.x-sealCrnrRad*2,center=true) circle(d=sealPressThck,$fn=4);
  }
}


*cutOut(cOut1Size,cOut1Side,cOut1RelPos);
module cutOut(size=[5,5], side="left", relPos=0, sealing=0.9, mode="boxCut"){
  /*
    modes: boxCut-> cutOut for box wall
           seal -> object to add to seal
  */
  translate([0,0,-size.y/2-sealThck]) rotate([-90,0,0]){
    
    if (mode=="boxCut") translate([0,0,-fudge/2]) linear_extrude(boxWallThck+fudge) shape();
    
    translate([0,0,boxWallThck/2]) linear_extrude(sealWdth,center=true,convexity=3) difference(){
      union(){
        intersection(){
          offset(sealWdth) shape();
          translate([0,(size.y/4+sealWdth/2)]) square([sealWdth*2+size.x,size.y/2+sealWdth],true);
        }
        translate([0,-size.y/4-fudge/2]) square([size.x+sealWdth*2,size.y/2+fudge,],true);
      }
      offset(-min(size.x,size.y)*(1-sealing)) shape();
    }
  }
    
  module shape(){
    if (size.x>size.y){
      for (ix=[-1,1])
        translate([ix*(size.x-size.y)/2,0]) circle(d=size.y);
      square([size.x-size.y,size.y],true);
    }
    else if (size.x<size.y){
      for (iy=[-1,1])
        translate([0,iy*(size.y-size.x)/2]) circle(d=size.x);
      square([size.x,size.y-size.x],true);
      }
    else
      circle(d=size.x);
  }
}

module placeOnSide(side="front", relPos=0){
  //assumes a vertical orientated object to align to outer face of box
  rot = side=="front" ? [0,0,0] :
        side=="back"  ? [0,0,180] :
        side=="left"  ? [0,0,-90] :
        [0,0,90];
  xPos = (side=="right") ?  outerDims.x/2:
         (side=="left") ? -outerDims.x/2 :
         (screwDist.x/2-sealCrnrRad)*relPos;
         
  yPos = (side=="front") ?  -outerDims.y/2:
         (side=="back") ? outerDims.y/2 :
         (screwDist.y/2-sealCrnrRad)*relPos;
 
  translate([xPos,yPos,0]) rotate(rot) children();
}

module threadInsert(M=4, short=false, cut=false){
 //render a simple heated thread insert
 //if cut=true returns a 2D circle with appropiate size 
 //https://www.ruthex.de/cdn/shop/files/DE_Ruthex_Galeriebilder_DE_Gewindeeinsaetze_f171f404-4d29-4d0b-80eb-eed4b9843097_600x.jpg
  diaDict=  [//d1
    [2, 3.6],
    [2.5, 4.6],
    [3, 4.6],
    [4, 6.3],
    [5, 7.1],
    [6, 8.7],
    [8, 10.1],
    ]; 
  drillDict= [//d3
    [2,3.2],
    [2.5,4],
    [3, 4],
    [4, 5.6],
    [5, 6.4],
    [6, 8.0],
    [8, 9.6]];
    
  heightStdDict= [[2, 4],
              [2.5, 5.7],
              [3, 5.7],
              [4, 8.1],
              [5, 9.5],
              [6, 12.7],
              [8, 12.7]];
  heightShortDict=[[3, 4],
               [4, 4],
               [5, 5.8],
               [6, 6.8]];
       
  dia=lookup(M,diaDict);
  drillDia=lookup(M,drillDict);
  height= (short) ? lookup(M,heightShortDict): lookup(M,heightStdDict); 
  if (cut)
    circle(d=drillDia);
  else
    color("gold") translate([0,0,-height]) 
      linear_extrude(height) difference(){
        circle(d=dia);
        circle(d=M);
      }
}
