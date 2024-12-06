// Simple magnet holder by Knochi

/* [Dimensions] */
//number of facets
$fn=150;
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


/* [Hidden] */
magnetDisc=magnetDia+magnetBrim*2;
holeDisc=holeDia+holeBrim*2;
ovThck=magnetThck;
outerRndRad=min(magnetBrim-spcng,holeBrim,ovThck/2);
fontStyle=str(lblFont,":style=",lblStyle);
fudge=0.1;
echo(fontStyle);

magnetKey();


echo(outerRndRad);

module magnetKey(){
  if (roundOuterEdges)
    difference(){
      hull(){
        translate([-(length-magnetDisc)/2,0,0]) 
          roundedDisc(magnetDisc,ovThck,outerRndRad);
        translate([(length-holeDisc)/2,0,0]) 
          roundedDisc(holeDisc,ovThck,outerRndRad);
      }
      translate([-(length-magnetDisc)/2,0,0]) 
          cylinder(d=magnetDia+spcng*2,h=ovThck+fudge,center=true);
        translate([(length-holeDisc)/2,0,0]) 
          cylinder(d=holeDia+ovThck,h=ovThck+fudge,center=true);
     labels();
    }
  else
    linear_extrude(magnetThck,center=true) difference(){
      hull(){
        translate([-(length-magnetDisc)/2,0]) 
          circle(d=magnetDisc);
        translate([(length-holeDisc)/2,0]) 
          circle(d=holeDisc);
      }
      translate([-(length-magnetDisc)/2,0]) 
          circle(d=magnetDia);
      translate([(length-holeDisc)/2,0]) 
          circle(d=holeDia+ovThck);
    }
    
  //round inner edge of hole
  translate([(length-holeDisc)/2,0,0])
    intersection(){
      rotate_extrude() 
        translate([(holeDia+ovThck)/2,0])
          circle(d=ovThck);
      cylinder(d=holeDia+ovThck+fudge,h=ovThck+fudge,center=true);
    }
}

*roundedDisc(holeDisc,ovThck,outerRndRad);
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

module labels(){
  translate([0,0,ovThck/2-lblThck]) linear_extrude(lblThck+fudge) 
    text(lblTopTxt,size=lblTopSize,valign="center",halign="center",font=fontStyle);
  translate([0,0,-ovThck/2-fudge]) linear_extrude(lblThck+fudge) 
    mirror([0,1]) text(lblBotTxt,size=lblBotSize,valign="center",halign="center",font=fontStyle);
}