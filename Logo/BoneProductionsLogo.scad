$fn=100;

/* [Dimensions] */
oDia=8;
tiltAng=58;
baseLineDist=8.5;//about 11.34
cptlHghtInput=13.5;
tiltBoneThck=5; //thickness of the "bone =="
strBoneThck=5;
ltrSpcInput=0.5;
stroke=1.5;
fillOffset= 0.12; //gap between shapes
inDia=oDia-stroke*2;
fudge=0.1;

/* [Calc] */
//calculate from baseline distance and tiltangle or letterspacing alone
input="ltrSpcInput"; //["ltrSpcInput","baseLineDist","all"]

/* [Options] */
tiltB=false;
bridgeUN=true;
bridgeTE=true;

/* [show] */
showFill=true;
showStroke=true;
showtiltBone=false;
debug=false;

/* [Colors] */
strokeColor=[0.07,  0.3,    0.12];//"#b0a998";
boneColor=[0.2,   0.17,   0.087];//"#4c4c4c";
fillColor=[0.859, 0.738,  0.496];//"#dbbc7e";

/* [Hidden] */



/* -- ltrSpcInput from baseLineDist Calculations--
 tan(tiltAng)=(B.x-P.x)/(B.y-P.y)
                              B.x                        P.x
 tan(tiltAng)= (oDia/2-cos(tiltAng)*(cptlHght-oDia))-(-oDia-ltrSpcInput*2)/
                              B.y                        P.y
              ((oDia/2+sin(tiltAng)*(cptlHght-oDia))-(-baseLineDist+cptlHght-oDia/2));
              
tan(tiltAng)= (oDia*1.5 - cos(tiltAng)*(cptlHght-oDia) + ltrSpcInput*2)/
              (oDia     + sin(tiltAng)*(cptlHght-oDia) + baseLineDist - cptlHght);              

             oDia*1.5 - cos(tiltAng)*(cptlHght-oDia) + ltrSpcInput*2= 
tan(tiltAng)*(oDia     + sin(tiltAng)*(cptlHght-oDia) + baseLineDist - cptlHght);

*/
//From BaseLineDist and strokeWdth to match "E" and "T"
cptlHght = bridgeTE ? baseLineDist+stroke*2 : cptlHghtInput;
ascenders=cptlHght-oDia;
descenders=ascenders; //not needed
echo(str("Capital Height is ", cptlHght));
// From BaselineDist and tiltAng, oDia, cptlHght
ltrSpcInputFromBaseLineDist=(tan(tiltAng)*(oDia+sin(tiltAng)*(cptlHght-oDia)+baseLineDist-cptlHght)-oDia*1.5+ cos(tiltAng)*(cptlHght-oDia))/2;


ltrSpc =  (input=="baseLineDist") ? ltrSpcInputFromBaseLineDist : ltrSpcInput;

if (ltrSpc<0) echo(str("Letterspacing is negative! (",ltrSpc,")"));
  
prodOffset=[-oDia*1.5-ltrSpc*2,-baseLineDist]; //Offset between 1st and 2nd line
ltrPHght=0; //letter P top center needs to be in line (45) with letter B top center
PtoO=oDia*1.5+ltrSpcInput; //"Productions" P to first o distance

// P to B alignment
P=[-oDia-ltrSpc*2,-baseLineDist+cptlHght-oDia/2]; //Coordinate of center of P upper circle
B=[oDia/2-cos(tiltAng)*(cptlHght-oDia),
   oDia/2+sin(tiltAng)*(cptlHght-oDia)]; //Coordinate of center of B upper circle

   
//echo(str("PtoBAng: ",atan2(B.x-P.x,B.y-P.y)));
if (showtiltBone) color(boneColor) tiltBone();
color(boneColor) strBone();
translate(prodOffset) ProductionsStr();
BoneStr();



if (bridgeUN && showFill) color(fillColor) 
  translate([oDia/2+(oDia+ltrSpc)*2,-(baseLineDist-oDia)/2]) square([inDia-fillOffset*2,baseLineDist],true);

if (debug)
  color("red"){
    translate(P) circle(0.5);
    translate(B) circle(0.5);
}


module strBone(){
  //straight bone behind the bone string
  difference(){
    union(){
      translate([oDia/2,oDia-stroke-strBoneThck/2]) 
        square([(oDia+ltrSpc)*3,strBoneThck]);
      translate([oDia/2+(oDia+ltrSpc)*3+oDia*0.1/2,oDia]) 
        circle(d=oDia*0.9);
    }
    translate([oDia/2,0]) offset(fillOffset) ltrB(cut=true);
    for (i=[1:3]) 
      translate([oDia/2+(oDia+ltrSpc)*i,oDia/2]) 
        offset(fillOffset) circle(d=oDia);
  }
}

//bone
module tiltBone(){
  //tilted bone behind "P" and "r" of Productions
  BBOffset=[cos(tiltAng)*(cptlHght-oDia),sin(-tiltAng)*(cptlHght-oDia)];
  
  difference(){
    union(){
      translate(P) rotate(tiltAng) 
        translate([0,(-cptlHght+oDia-tiltBoneThck)/2]) 
          square([norm(P-B),tiltBoneThck]);
      translate(P+BBOffset) circle(d=oDia);
    }
    translate(P) offset(fillOffset) circle(d=oDia);
    translate([oDia/2,oDia/2]) rotate(tiltAng) translate([0,-oDia/2]) offset(fillOffset) ltrB(true);
    translate(P) offset(fillOffset) circle(d=oDia);
    translate(prodOffset+[oDia*1.5+ltrSpc,0]) offset(fillOffset) ltrR(true);
    *difference(){
      translate(P+BBOffset) offset(fillOffset) circle(d=oDia);
      translate(P+BBOffset) circle(d=oDia);
    }
  }
  
}



module BoneStr(){
  
  if (tiltB) 
    translate([oDia/2,oDia/2]) rotate(tiltAng) translate([0,-oDia/2]) ltrB();
  else translate([oDia/2,0]) ltrB();
  
  translate([oDia/2+(oDia+ltrSpc),0]) ltrO();
  translate([oDia/2+(oDia+ltrSpc)*2,0]) ltrN();
  translate([oDia/2+(oDia+ltrSpc)*3,0]) ltrE();
}

module ProductionsStr(){
  translate([         oDia/2                               ,0]) ltrP();
  translate([         oDia/2            +(oDia+ltrSpc)  ,0]) ltrR(); //R
  translate([                            (oDia+ltrSpc)*2,0]) ltrO();
  translate([                            (oDia+ltrSpc)*3,0]) ltrD(); //D
  translate([                            (oDia+ltrSpc)*4,0]) ltrU();
  translate([                            (oDia+ltrSpc)*5,0]) ltrC();  
  translate([stroke/2       +ltrSpc  +(oDia+ltrSpc)*6,0]) ltrI(); //I
  translate([                            (oDia+ltrSpc)*6,0]) ltrT(); //T swapped with I for color appearance
  translate([stroke  +oDia/2+ltrSpc*2+(oDia+ltrSpc)*6,0]) ltrO(); 
  translate([stroke  +oDia/2+ltrSpc*2+(oDia+ltrSpc)*7,0]) ltrN(); 
  translate([stroke  +oDia/2+ltrSpc*2+(oDia+ltrSpc)*8,0]) ltrS(); //S
}

*ltrI();
module ltrI(){
  if (showStroke) 
    color(strokeColor)difference(){
      intersection(){
        /*hull(){ //roundish shape
          translate([0,oDia/2]) circle(d=oDia);
          translate([0,cptlHght-oDia/2]) circle(d=oDia);
        }*/
        translate([-stroke/2,0]) square([stroke,cptlHght]);
      }
      //gap
      translate([-(stroke+fudge)/2,cptlHght-stroke*2-fillOffset]) 
        square([stroke+fudge,stroke+fillOffset*2]);
    }
  
  if (showFill)
  color(fillColor) translate([-(stroke)/2,cptlHght-stroke*2]) square([stroke,stroke]);
}
*ltrT();
module ltrT(){
  barDims= bridgeTE ? [oDia+ltrSpc,stroke] : [stroke+oDia/2,stroke];
  
  if (showStroke)
  color(strokeColor) translate([0,oDia/2]){
    translate([-oDia/2,0]) square([stroke,cptlHght-oDia/2]);
    difference(){
      translate([-barDims.x,cptlHght-oDia/2-stroke*2]) 
        square(barDims);
      if (bridgeTE) translate([-barDims.x,cptlHght-stroke*2]) offset(fillOffset) circle(d=oDia);
    }
    difference(){
      intersection(){
        circle(d=oDia);
        translate([-oDia/2,-oDia/2]) square(oDia/2);
      }
    circle(d=inDia);
    }
  }
  if (showFill)
  color(fillColor) offset(-fillOffset) translate([0,oDia/2]){
    intersection(){
      circle(d=inDia);
      translate([-inDia/2,-inDia/2]) square(inDia/2+fillOffset);
    }
    translate([-inDia/2,0]) 
      square([inDia/2+fillOffset,cptlHght-oDia/2-stroke*2]);
  }
}
module ltrD(){
  ltrO();
  if (showStroke) color(strokeColor) difference(){
    translate([oDia/2-stroke,oDia/2]) square([stroke,cptlHght-oDia/2]);
    translate([0,baseLineDist+oDia/2]) offset(fillOffset) circle(d=oDia);
  }
}

module ltrR(cut=false){
  if (cut){
    difference(){
      translate([0,oDia/2])
        circle(d=oDia);
        square([oDia/2,oDia]);
      }
    translate([-oDia/2,oDia/2]) square([stroke,oDia/2]);
    }
  else
    difference(){
      ltrN();
      square([oDia/2,oDia]);
    }
  if (showStroke) color(strokeColor) translate([-oDia/2,oDia/2]) square([stroke,oDia/2]);
}

module ltrC(){
  translate([oDia/2,oDia/2]) rotate(90) ltrN();
}
module ltrU(){
  translate([0,oDia]) mirror([0,1]) ltrN();
}

module ltrE(){
  if (showStroke)
  color(strokeColor) translate([0,oDia/2]) {
    difference(){
      circle(d=oDia);
      circle(d=inDia);
      translate([0,-oDia/2+stroke]) square([oDia/2,(inDia-stroke)/2]);
    }
  square([inDia,stroke],true);
  }
  if (showFill)
  color(fillColor) translate([0,oDia/2]) offset(-fillOffset) {
    difference(){
      circle(d=inDia);
      translate([0,0]) square([inDia,stroke],true);
    }
    intersection(){
      translate([0,-oDia/2+stroke]) square([oDia/2+fillOffset,(inDia-stroke)/2]);
      circle(d=oDia+fillOffset*2);
    }
  }
}

module ltrS(){
  if (showStroke)
  color(strokeColor) translate([0,oDia/2]) {
    difference(){
      circle(d=oDia);
      circle(d=inDia);
      translate([-oDia/2,-oDia/2+stroke]) square([oDia/2,(inDia-stroke)/2]);
      translate([0,stroke/2]) square([oDia/2,(inDia-stroke)/2]);
    }
  square([inDia,stroke],true);
  }
  if (showFill)
  color(fillColor) translate([0,oDia/2]) offset(-fillOffset) {
    difference(){
      circle(d=inDia);
      translate([0,0]) square([inDia,stroke],true);
    }
    intersection(){
      circle(d=oDia+fillOffset*2);
      union(){
        translate([-oDia/2,-oDia/2+stroke]) square([oDia/2,(inDia-stroke)/2]);
        translate([0,stroke/2]) square([oDia/2,(inDia-stroke)/2]);
      }
      
    }
  }
}

module ltrN(){
  
  translate([0,oDia/2]){
    if (showStroke)
      color(strokeColor) difference(){
      circle(d=oDia);
      circle(d=inDia);
      translate([0,-oDia/4]) square([inDia,oDia/2],true);
      
    }
    if (showFill)
      color(fillColor) offset(-fillOffset) {
      circle(d=inDia);
      intersection(){
        translate([0,-oDia/4-fillOffset/2])
          square([inDia,oDia/2+fillOffset],true);
        circle(d=oDia+fillOffset*2);
      }
    }
  }
}

*ltrB(true);
module ltrB(cut=false, style="overlapping"){  
    upperBScale=0.9;
    if (cut){
      translate([-oDia*(1-upperBScale)/2,cptlHght-oDia*upperBScale/2]) 
        circle(d=oDia*upperBScale);
      translate([0,oDia/2]) circle(d=oDia);
      translate([-oDia/2,oDia/2]) 
              square([stroke,ascenders+oDia*(1-upperBScale)/2]);
    }
    else if (style=="overlapping"){
      difference(){
        union(){
          translate([-oDia*(1-upperBScale)/2,cptlHght-oDia*upperBScale]) 
            ltrO(upperBScale);
          if (showStroke) color(strokeColor)  
            translate([-oDia/2,oDia/2]) 
              square([stroke,ascenders+oDia*(1-upperBScale)/2]);
        }
        color(strokeColor) translate([0,oDia/2]) 
          offset(fillOffset) circle(d=oDia);
      }
      ltrO();
    }
    else{//"solid"
      ltrU();
      translate([0,cptlHght-oDia]) ltrN();
      if (showStroke) color(strokeColor){
        translate([-oDia/2,oDia/2]) square([stroke,ascenders]);
        translate([-oDia/2+stroke,cptlHght/2-stroke/2]) square([inDia,stroke]);
      }
     
    }
}

module ltrP(){
  translate([0,cptlHght-oDia]) ltrO();
  if (showStroke) difference(){
    color(strokeColor) translate([-oDia/2,0]) square([stroke,cptlHght-oDia/2]);
    translate([0,cptlHght-oDia/2]) offset(fillOffset) circle(d=oDia);
  }
}

*ltrO(0.9);
module ltrO(scle=1){
  // O
  inDia=oDia*scle-stroke*2;
  translate([0,oDia*scle/2]){
    if (showStroke)
      color(strokeColor) difference(){
        circle(d=oDia*scle);
        circle(d=inDia);
      }
  
  if (showFill)
    color(fillColor) offset(-fillOffset) circle(d=inDia);
  }
}
  