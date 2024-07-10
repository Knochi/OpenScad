
hooverDummy();

module hooverDummy(){
  headWidth=305;
  headHght=55;
  maxBodyWdth=120;
  
  //head
  linear_extrude(headHght) hull(){
    translate([-105,45]) circle(25);
    translate([105,45]) circle(25);
    translate([-123,115]) circle(7);
    translate([123,115]) circle(7);
    translate([-maxBodyWdth/2,0]) square([maxBodyWdth,10]);
  }
  
}