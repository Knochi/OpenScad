/* [Config] */
Series="P100"; //["P50","P100","P125"]
scktType="solder"; //["solder","crimp","wireWrap"]
ndlType="round"; //["round","spear","concave"]
scktbulgePos=7.5; //[2.5,7.5]

series=       ["P50","P100","P125"];
scktOvLens=   [17.5,   30, 29.3];
scktMainDias= [0.86, 1.67, 2.36];
scktBulgeDias=[0.97, 1.83, 2.54];
scktShftLens= [12.5,   25, 24.7]; //distance from tip to end of main dia

scktCntctDias=[0.75, 1.47,];
scktCntctLens=[   5,    0,] ;


*testNeedle_P100();
module testNeedle_P100(){
  // pogo Pin P100 series
  //https://dirtypcbs.com/uploads/store/pogo-pin-P100-series.png

  //Socket R100-4S
    scktOvLen=30;
  scktMainDia=1.67;
 scktBulgeDia=1.83;
  scktShftLen=25;
 //scktBulgePos=7.5;   //distance of the bulge from the top
   scktTipDia=1.47;

  //Needle P100-J1
  ndlOvLen=33.35;
  ndlLengths=[2.0,6.35,25];
  ndlBdyDia=1.36;
  ndlShftDia=1.0;
  ndlShftLen=25;
  ndlTipDia=1.0;

  //socket
  color("gold") translate([0,0,scktBulgePos]){
    translate([0,0,-30]) cylinder(d=scktTipDia,h=5.0);
    translate([0,0,-scktShftLen]) cylinder(d=scktMainDia,h=scktShftLen);
    translate([0,0,-scktBulgePos]) cylinder(d=scktBulgeDia,h=0.5);
  }

  //needle
  color("silver") translate([0,0,-scktShftLen+scktBulgePos]){
    cylinder(d=ndlBdyDia,h=25);
    translate([0,0,25]) cylinder(d=ndlShftDia,h=6.35);
    translate([0,0,25+6.35]) cylinder(d=ndlTipDia,h=1);
    translate([0,0,25+6.35+1]) sphere(d=1);
  }
}

*testNeedle_P50();
module testNeedle_P50(){
  // pogo Pin P50 series
  //https://de.aliexpress.com/item/1005003507829887.html
  
  //Socket P50-2S
  scktOvLen=17.5;
  scktMainDia=0.86;
  scktBulgeDia=0.97;
  scktShftLen=12.5;
  //scktBulgePos=2.5; //distance of the bulge from the top
  scktCntctDia=0.75;
  scktCntctLen=5;
  
  //Needle P50-J1
  ndlOvLen=16.55;
  ndlBdyDia=0.68;
  ndlBdyLen=13;
  ndlShftDia=0.48;
  ndlShftLen=2.65;
  ndlTipDia=0.48;
  ndlTipLen=0.9;
  
  //socket
  color("gold") translate([0,0,scktBulgePos]){
    translate([0,0,-scktOvLen]) cylinder(d=scktCntctDia,h=scktCntctLen);
    translate([0,0,-scktShftLen]) cylinder(d=scktMainDia,h=scktShftLen);
    translate([0,0,-scktBulgePos]) cylinder(d=scktBulgeDia,h=0.5);
  }
  
  //needle
  translate([0,0,-scktShftLen+scktBulgePos]){
    //body
    color("gold") 
      cylinder(d=ndlBdyDia,h=ndlBdyLen);
    //tip
    color("silver")
      translate([0,0,ndlBdyLen]){
        cylinder(d=ndlShftDia,h=ndlShftLen);
        translate([0,0,ndlShftLen]){
          cylinder(d=ndlTipDia,h=ndlTipLen);
          translate([0,0,ndlTipLen]) sphere(d=ndlTipDia);
          }
        }
        }
}