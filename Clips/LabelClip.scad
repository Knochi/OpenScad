$fn=100;

textThck=2;
textChamf=0.5;
txtSize=30;
txtStr="8";

alignWdth=1;
alignOffset=0.4;
alignRot=45;

showNumber=true;
showClip=true;

spcng=-0.1;

if (showClip) 
  linear_extrude(30,center=true) projection() import("bin+bag+clip.stl");

translate([7.5,36,0]) rotate([0,90,0]){
  if (showClip) alignmentCross(spcng);
  if (showNumber) !difference(){
    label();
    alignmentCross();
  }
}

module label(){
  linear_extrude(textThck-textChamf,convexity=3) text(txtStr,size=txtSize,valign="center",halign="center");
  translate([0,0,textThck-textChamf]) difference(){
    roof(convexity=3) text(txtStr,size=txtSize,valign="center",halign="center");
    translate([0,0,textChamf+txtSize/2]) cube(txtSize,center=true);
    }
}

*alignmentCross();
module alignmentCross(spcng=0){
  
  roof() intersection(){
    offset(-alignOffset+spcng) text(txtStr,size=txtSize,valign="center",halign="center");
    rotate(alignRot) union(){
      square([txtSize,alignWdth],true);
      square([alignWdth,txtSize],true);
    }
    
  }
}