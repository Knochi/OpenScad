/* [Dimensions] */
drumDia=30;

/* [Blister] */
blstrRows=10;
blstrCols=5;
blstrStagger=true;
blstrPcktDist=[11,8];



//drum
rotate([0,90,0]) cylinder(d=drumDia,h=50,center=true);

//blister
translate([0,0,-drumDia/2]) blister();

module blister(){

  for (ix=[-(blstrCols-1)/4:(blstrCols-1)/4],iy=[-(blstrRows-1)/4:(blstrRows-1)/4]){
    
    translate([ix*blstrPcktDist.x*2,iy*blstrPcktDist.y*2,0]) pocket();
    if (ix<(blstrCols-1)/4) translate([ix*(blstrPcktDist.x*2)+blstrPcktDist.x,iy*(blstrPcktDist.y*2)+blstrPcktDist.y,0]) pocket();
    }

  module pocket(){
    
    //round
    cylinder(d=9.75,h=4.3);
  }
}
