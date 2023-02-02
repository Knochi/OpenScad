//2-layer game markers
//marker

dia=20;
botThck=1;
topThck=0.4;

//bot color1
color("darkgreen") cylinder(d=dia,h=botThck);
translate([0,0,botThck]) linear_extrude(topThck)
  difference(){
    circle(d=dia);
    girl();
  }
  
 module girl(label="O"){
  shpOffset=[-5.9/2,-14.2/2];
  lblOffset=[-4,-3.7];
  translate(shpOffset) import("AlienRPG_girl.svg");
  translate(lblOffset) text(label,size=2,valign="center",halign="center",font="arial:style=bold");
 }