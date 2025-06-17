/* [tileGenerator] */
count=[5,5];
tileVariant="corner"; //["corner","side","core"]

//upload remixing files from multiboard.io
tileMultiHoleFile="Remixing Files/Tile Multihole Component.stl"; //change to default.stl before uploading to makerworld!
tilePegBoardHoleFile="Remixing Files/Tile Pegboard Hole Component.stl"; //change to default.stl before uploading to makerworld!

/* [show] */
export="MBArm";//["MBTile","MBArm"]
/* [Hidden] */
pitch=25;

if (export=="MBArm")
  MBArm();
else if (export=="MBGrid")
  tileGenerator();

module tileGenerator(){
  for (ix=[0:count.x-1],iy=[0:count.y-1]) translate([ix*pitch,iy*pitch]){
    import(tileMultiHoleFile);
    //pegboard component depends on tileVariant
    if ((((ix<count.x-1) && (iy<count.y-1)) || 
        (tileVariant=="core")) || 
        ((tileVariant=="side")&&(ix<count.x-1)&&(iy==count.y-1))
        )
      import(tilePegBoardHoleFile);
  }
}

module MBArm(length=5){
  //this tries to render an arm for camera/phone holders from multiboard parts
  for (i=[0:length-1])
  translate([i*pitch*sqrt(2),0]) rotate(-45){
    import(tileMultiHoleFile);
    if (i<length-1) import(tilePegBoardHoleFile);
    }
}

