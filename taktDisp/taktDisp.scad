
intersection(){
  color("ivory")scale([1,1,0.1]) surface("Maut64nInv.png",center=true, invert=false);
  cylinder(d=46,h=46,center=true);
}




module ID3(){
  ID_Dim=[113,245.5];

  intersection(){
    rotate([90,0,90]) linear_extrude(113,center=true,convexity=4) import("IDSilouette.svg");
    translate([-ID_Dim.x/2,ID_Dim.y,0]) rotate([90,0,0]) linear_extrude(ID_Dim.y,convexity=4) import("IDSilouetteFront.svg");
  }
}