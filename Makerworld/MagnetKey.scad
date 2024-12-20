// Simple magnet holder by Knochi

/* [Dimensions] */
magnetDia=8;
magnetThck=2.5;
magnetBrim=1.2;
holeDia=8;
holeBrim=5;
length=40;
spcng=0.2;


/* [Label] */
lblTopTxt="N";
lblBotTxt="S";
lblTopSize=7;
lblBotSize=7;
lblFont="Liberation Mono"; //["Liberation Mono", "Liberation Sans","Liberation Serif"]
lblStyle="Bold"; //["Bold","Italic","Regular"]
lblThck=0.5;

/* [Options] */
roundOuterEdges=true;
embeddMagnet=true;
//how much material to add on each side
embeddAddition=0.6;
//how much spacing to add in Z
embeddSpcng=0.2;
//split in to halfes for coloring
export="noSplit"; //["noSplit","Top","Bottom"]


/* [Hidden] */
magnetDisc=magnetDia+magnetBrim*2;
holeDisc=holeDia+holeBrim*2;
ovThck= embeddMagnet ? magnetThck+embeddAddition*2+embeddSpcng*2 : magnetThck;
ovWdth= max(magnetDisc,holeDisc);
outerRndRad=min(magnetBrim,holeBrim);
fontStyle=str(lblFont,":style=",lblStyle);
fudge=0.1;
$fn=48; 

if (export=="noSplit")
  magnetKey();
else if (export=="Top")
  color("darkred") difference(){
    magnetKey();
    translate([0,0,-(ovThck/2+fudge)/2]) cube([length+fudge,ovWdth+fudge,ovThck/2+fudge],true);
  }
else if (export=="Bottom")
  color("darkgreen") difference(){
    magnetKey();
    translate([0,0,(ovThck/2+fudge)/2]) cube([length+fudge,ovWdth+fudge,ovThck/2+fudge],true);
  }


module magnetKey(){
  
    difference(){
      //body
      hull(){
        translate([-(length-magnetDisc)/2,0,0]) 
          if (roundOuterEdges) roundedDisc(magnetDisc,ovThck,outerRndRad);
          else cylinder(d=magnetDisc,h=ovThck,center=true);
          
        translate([(length-holeDisc)/2,0,0]){
          if (roundOuterEdges) roundedDisc(holeDisc,ovThck,outerRndRad);
          else cylinder(d=holeDisc,h=ovThck,center=true);
          }
      }
      //magnet hole
      translate([-(length-magnetDisc)/2,0,0]) 
          cylinder(d=magnetDia+embeddSpcng*2,h=magnetThck+fudge,center=true);
      
      //hole
        translate([(length-holeDisc)/2,0,0]) 
          cylinder(d=holeDia+ovThck,h=ovThck+fudge,center=true);
      
      //text
      translate([0,0,ovThck/2-lblThck]) linear_extrude(lblThck+fudge) 
        text(lblTopTxt,size=lblTopSize,valign="center",halign="center",font=fontStyle);
      translate([0,0,-ovThck/2-fudge]) linear_extrude(lblThck+fudge) 
        mirror([0,1]) text(lblBotTxt,size=lblBotSize,valign="center",halign="center",font=fontStyle);
    }
    
  //round inner edge of hole
  translate([(length-holeDisc)/2,0,0])
    intersection(){
      rotate_extrude() 
        translate([(holeDia+ovThck)/2,0])
          circle(d=ovThck);
      cylinder(d=holeDia+ovThck+fudge*+0,h=ovThck+fudge,center=true);
    }
}

*roundedDisc(holeDisc,ovThck,1);
module roundedDisc(dia,thick,rad){
  
  hull() for (m=[0,1]){
    mirror([0,0,m]) translate([0,0,thick/2-rad]) 
      halfDisc();
  }
  module halfDisc(){
    rotate_extrude() 
      translate([dia/2-rad,0]) 
        intersection(){
          circle(rad);
          square(rad);
        }
  }
}