$fn=20;

/* [Dimensions] */
oDia=8;
tiltAng=45;
baseLineDist=10.5;//about 11.34
cptlHghtInput=13.5;
boneThck=6;
ltrSpcInput=0.5;
stroke=1.5;
fillOffset= 0.1;
inDia=oDia-stroke*2;
fudge=0.1;

/* [Calc] */
input="baseLineDist"; //["ltrSpcInput","baseLineDist","all"]

/* [Options] */
tiltB=true;
bridgeUN=true;
bridgeTE=true;

/* [show] */
showFill=true;
showStroke=true;
showBone=true;
debug=false;

/* [Colors] */
strokeColor="#b0a998";
boneColor="#4c4c4c";
fillColor="#dbbc7e";

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
if (showBone) color(boneColor) bone();
BoneStr();
translate(prodOffset)ProductionsStr();

if (bridgeUN && showFill) color(fillColor) 
  translate([oDia/2+(oDia+ltrSpc)*2,-(baseLineDist-oDia)/2]) square([inDia-fillOffset*2,baseLineDist],true);


if (debug)
  color("red"){
    translate(P) circle(0.5);
    translate(B) circle(0.5);
}


//bone
module bone(){
  BBOffset=[cos(tiltAng)*(cptlHght-oDia),sin(-tiltAng)*(cptlHght-oDia)];
  difference(){
    union(){
      translate(P) rotate(tiltAng) translate([0,(-cptlHght+oDia-boneThck)/2]) square([norm(P-B),boneThck]);
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

module ltrI(){
  if (showStroke) 
    color(strokeColor)difference(){
      intersection(){
        hull(){
          translate([0,oDia/2]) circle(d=oDia);
          translate([0,cptlHght-oDia/2]) circle(d=oDia);
        }
        translate([-stroke/2,0]) square([stroke,cptlHght]);
      }
      translate([-(stroke+fudge)/2,cptlHght-stroke*2]) square([stroke+fudge,stroke]);
    }
  
  if (showFill)
  color(fillColor) translate([-(stroke)/2,cptlHght-stroke*2+fillOffset]) square([stroke,stroke-fillOffset*2]);
}
*ltrT();
module ltrT(){
  barDims= bridgeTE ? [oDia+ltrSpc,stroke] : [stroke+oDia/2,stroke];
  
  if (showStroke)
  color(strokeColor) translate([0,oDia/2]){
    translate([-oDia/2,0]) square([stroke,cptlHght-oDia/2]);
    difference(){
      translate([-barDims.x,cptlHght-oDia/2-stroke*2]) square(barDims);
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
      translate([-inDia/2,-inDia/2]) square(inDia/2);
    }
    translate([-inDia/2,0]) square([inDia/2,cptlHght-oDia/2-stroke*2]);
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
      translate([0,-oDia/2+stroke]) square([oDia/2,(inDia-stroke)/2]);
      circle(d=oDia);
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
      circle(d=oDia);
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
        translate([0,-oDia/4]) square([inDia,oDia/2],true);
        circle(d=oDia);
      }
    }
  }
}

*ltrB();
module ltrB(cut=false){  
    if (cut){
      translate([0,cptlHght-oDia/2]) circle(d=oDia);
      translate([0,oDia/2]) circle(d=oDia);
      translate([-oDia/2,oDia/2]) square([stroke,ascenders]);
    }
    else{
      difference(){
        union(){
          translate([0,cptlHght-oDia]) ltrO();
          if (showStroke) color(strokeColor) translate([-oDia/2,oDia/2]) square([stroke,ascenders]);
        }
        color(strokeColor) translate([0,oDia/2]) offset(fillOffset) circle(d=oDia);
      }
      ltrO();
    }
    
}

module ltrP(){
  translate([0,cptlHght-oDia]) ltrO();
  if (showStroke) difference(){
    color(strokeColor) translate([-oDia/2,0]) square([stroke,cptlHght-oDia/2]);
    translate([0,cptlHght-oDia/2]) offset(fillOffset) circle(d=oDia);
  }
}

*ltrO();
module ltrO(){
  // O
  translate([0,oDia/2]){
    if (showStroke)
      color(strokeColor) difference(){
        circle(d=oDia);
        circle(d=inDia);
      }
  
  if (showFill)
    color(fillColor) offset(-fillOffset) circle(d=inDia);
  }
}
  