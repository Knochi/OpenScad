$fn=50;


AnkerMagSafe();

module AnkerMagSafe(){
  ovDia=59.8;
  ovThck=10.4;
  inDia=57.85;
  brimThck=0.75;
  cableDia=3.5;
  cableZOffset=6.7-5.2/2;
  strRelfLen=10.7; //strainRelief
  strRelfDia=5.2;
  
  
  
  //not forming the back slope atm
  cylinder(d=ovDia,h=ovThck-brimThck);
  cylinder(d=inDia,h=ovThck);
  //cable
  translate([0,0,cableZOffset]) rotate([-90,0,0]){
    cylinder(d=strRelfDia,h=ovDia/2+strRelfLen);
    cylinder(d=cableDia,h=ovDia/2+strRelfLen*2);
  }
}