//pressing carousel for DYMO label tabe

/*maybe it come in handy to calculate the deflection of the tongues (beams)
 starting point: https://mechanicalc.com/reference/beam-deflection-tables
  
  Deflection: δ = -(Fx²/6EI)*(3L-x), δmax=FL³/3EI @x=L
  Slope: Θ = -(Fx / 2EI)*(2L-x), Θmax = (FL² / 2EI) @x=L
  
  L,x: length, position [m]
  F: Force at l [N]
  E: youngs modulus [Pa]
  I: Moment of Inertia [m^4]
  
  Isquare= w*h³/12 |square([w,h]) (deflection in around y)
  
*/


/* [Parameters] */
$fn=30;
charCount=42; //+1 cutter //42 for capital letters + numbers, 35 for lowercase + symbols
//chars = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U"];
chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ-.1234567890X";

/* [Dimensions] */
botDscDia=51.3; //outer Dia of pressing disc (positive)
botDscThck=1.2;  //thickness of pressing disc
botZOffset=2.15; //zOffset of tongues from bottom
bsLneDia=49.2; //dia of the chars baseline on bottom Disc
txtSize=2.5; //height above baseline
embSpcng=0.05; //spacing positive and negative
embHght=0.5; //embossing height
sltWdth=0.6; //width of the slots
topDscDia=55.9; //outer Dia of top disc (negative)
topDscThck=3;
topCntrDia=10.8;

dtntDia=2;
sltCntrDia=22; //dia of nonslotted disc
botCntrDia=13.95; //dia of center cylinder
botCntrHght=5.2; //total height of center cylinder
cntrBore=7.1; 
spcng=0.1; //spacing between parts

/* [show] */
showTopDsc = true;
showBotDsc = true;


/* [Hidden] */
//a polygon to revolute into the disc shape
dscPoly=[[botCntrDia/2,2.15],[sltCntrDia/2,2.15],[37.6/2,2],[38.6/2,3],[botDscDia/2,2], //bottom face
         [botDscDia/2,2+botDscThck],[38.6/2-0.5,3+botDscThck],[37.6/2-0.5,2+botDscThck],[sltCntrDia/2,2.15+botDscThck],[botCntrDia/2,2.15+botDscThck]];
tngAng=360/(charCount+1); //angle of one tongue
charTilt=8.9;
fudge=0.1;
//guide dimensions
gdWdth=2;
lngGuide=botCntrDia+3.3;
shrtGuide=botCntrDia;

if (showTopDsc) topDsc();
if (showBotDsc) botDsc();
//debug tongue cross section
*polygon(dscPoly);

module topDsc(){
  //top disc with negatives
  color("darkSlateGrey") translate([0,0,botCntrHght]) 
    difference(){
      linear_extrude(topDscThck,convexity=3)
        difference(){ //2D difference
          circle(d=topDscDia,$fn=charCount+1);
          //center
          circle(d=topCntrDia);
          //detents
          for (ang=[0:tngAng:360-tngAng]) 
            rotate(ang) translate([topDscDia/2,0,0]) circle(d=dtntDia);
          //guides
          hull() for (ix=[0,1])
            translate([ix*(shrtGuide-gdWdth)/2,0])
              circle(d=gdWdth+spcng);
          hull() for (iy=[0,1])
            translate([0,iy*(lngGuide-gdWdth)/2])
              circle(d=gdWdth+spcng);
            
        }
      //chars
      for (i=[0:len(chars)-1])
        rotate(tngAng*i+tngAng) translate([bsLneDia/2,0,0-0.01]) rotate([0,0,90]) 
          linear_extrude(embHght+0.01) offset(embSpcng) text(chars[i],size=txtSize, halign="center");
    }
}

module botDsc(){
  //disc with tongues and positives
  
  //center dome
  color("ivory") rotate(-tngAng/2) linear_extrude(botCntrHght) difference(){
    circle(d=botCntrDia,$fn=charCount+1);
    circle(d=cntrBore);
  }
  //guides in topDsc
  translate([0,0,botCntrHght]) rotate(-tngAng/2) difference(){
    union(){
      cylinder(d=topCntrDia-fudge*2,h=topDscThck,$fn=charCount+1);  
      //guide bars
      //short
      rotate(tngAng/2){
        hull() for (ix=[0,1])
          translate([ix*(botCntrDia-gdWdth)/2,0,0]){
            cylinder(d=gdWdth,h=topDscThck-gdWdth/2);
            translate([0,0,topDscThck-gdWdth/2]) sphere(d=gdWdth);
          }
        //long
        hull() for (iy=[0,1])
          translate([0,iy*(lngGuide-gdWdth)/2,0]){
            translate([0,0,-(botCntrHght-botZOffset)]) 
              cylinder(d=gdWdth,h=topDscThck-gdWdth/2+(botCntrHght-botZOffset));
            translate([0,0,topDscThck-gdWdth/2]) sphere(d=gdWdth);
          }
        }
      }
      translate([0,0,-botCntrHght-fudge/2]) cylinder(d=cntrBore,h=topDscThck+botCntrHght+fudge);
    }
  
  //pressing disc
  color("ivory") rotate(-tngAng/2) difference(){
    rotate_extrude($fn=charCount+1) polygon(dscPoly);
    //slots
     for (ang=[0:tngAng:360-tngAng]){
      sltLngth=(ang<tngAng*2) ? (botDscDia-sltCntrDia)/2-3 : (botDscDia-sltCntrDia)/2;
      sltOffset = (ang<tngAng*2) ? 3 : 0;
      rotate(ang) translate([(sltCntrDia+sltLngth+fudge)/2+sltOffset,0,botCntrHght/2]) 
        cube([sltLngth+fudge,sltWdth,botCntrHght-fudge],true);
    }
  }
  //anvil
  color("ivory") translate([botDscDia/2+1.4,0,3]) 
    rotate([0,charTilt,0]) translate([-8.3,-1,-botDscThck]) 
      cube([8.3,2,botDscThck+0.7]);
  //chars
  color("ivory") for (i=[0:len(chars)-1])
    rotate(tngAng*i+tngAng) translate([bsLneDia/2,0,3.4]) rotate([charTilt,0,90]) 
      linear_extrude(embHght) text(chars[i],size=txtSize, halign="center");
}





