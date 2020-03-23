use <ttf/DINCondensed-Bold.ttf>

$fn=20;
fudge=0.1;
matThck= 2;

/*-- [show] -- */
export="none"; //["none","outline","mask","silkscreen"]

/*-- [label] --*/
lineWdth=0.4;
lblColor="gold";
plateColor="black";

/*-- [Link] -- */
jackXPos=[-36.68-6.1,-22.08-6.1,-5.68-6.1,8.92-6.1,25.32-6.1,39.92-6.1]; //xPos from center
jackYOffset=5.1;
LEDsXPos=[-14.7-6.1,16.3-6.1,47.3-6.1];
jackTxt=[["IN" ,"OUT","IN" ,"IN" ,"IN" ,"IN" ],
         ["OUT","OUT","OUT","OUT","IN" ,"OUT"]];
txtOffset=[0,5.5];
txtSize=2;
txtFont="DIN Condensed:style=Bold";
lblPos=[-33,16,matThck/2];
lblSize=3;
sepXOffset=3.1/2+2.5; //seprator lines Offset from LEDs
sepDims=[0.8,23]; //separator line dimensions width x height
color("darkslategrey") translate([0,0,-11.65]) import("euroLinks1U.stl");


if (export=="none")
  translate([0,0,matThck/2]) linkPanel(layer="all");
else if (export=="outline")
  !projection() linkPanel(layer="outline");
else if (export=="mask")
  !projection() linkPanel(layer="label");
else if (export=="drill")
  !projection() linkPanel(layer="drill");

//washers
for (i=[0:len(jackXPos)-1],iy=[-1,1])
  color("silver") 
    translate([jackXPos[i],iy*jackYOffset,matThck])
      washer();


module linkPanel(layer="all"){
  //layers: "all", "outline", "label", "drill"
  
 
 difference(){
    color(plateColor) panel1U(HP=20,center=true);
    // jack holes
    for (i=[0:len(jackXPos)-1],iy=[-1,1])
      translate([jackXPos[i],iy*jackYOffset,0]){
        if (layer=="all" || layer=="outline") cylinder(d=6.1,h=matThck+fudge,center=true);
        labels();
    }
    if (layer=="all" || layer=="drill") for (ix=LEDsXPos) 
      translate([ix,0,0]){
        cylinder(d=3.1,h=matThck+fudge,center=true);
      }
    if (layer=="all" || layer=="label") color(lblColor){
      // icons
      translate([jackXPos[0]+(jackXPos[1]-jackXPos[0])/2,0,matThck/2]) 
        linear_extrude(0.2,center=true)
          arrows(size=[6,6],type="1to3",w=lineWdth,center=true);
      translate([jackXPos[2]+(jackXPos[3]-jackXPos[2])/2,0,matThck/2]) 
        rotate(-90) linear_extrude(0.2,center=true)
          arrows(size=[6,6],type="2to2",w=lineWdth,center=true);
      translate([jackXPos[4]+(jackXPos[5]-jackXPos[4])/2,0,matThck/2]) 
        rotate(90) linear_extrude(0.2,center=true)
          arrows(size=[6,6],type="3to1",w=lineWdth,center=true);
      //separator lines
      translate([LEDsXPos[0]+sepXOffset,0,matThck/2]) //separator Lines
          linear_extrude(0.2,center=true) sepLine(sepDims.y,sepDims.x); 
      translate([LEDsXPos[1]+sepXOffset,0,matThck/2]) //separator Lines
          linear_extrude(0.2,center=true) sepLine(sepDims.y,sepDims.x); 
      //label
      translate(lblPos) linear_extrude(0.2,center=true)
        text("L1NKS",size=lblSize,halign="center",valign="center", font=txtFont);
    }
    
      
  }//diff
  
  module labels(){
    for (i=[0:len(jackXPos)-1],iy=[-1,1])
      translate([jackXPos[i],iy*jackYOffset,0]){
        color(lblColor) { 
          if (iy>0) translate([txtOffset.x,txtOffset.y,matThck/2])
            linear_extrude(0.2,center=true) 
              text(jackTxt[0][i],size=txtSize,halign="center",valign="center", font=txtFont);
          if (iy<0) translate([txtOffset.x,-txtOffset.y,matThck/2])
            linear_extrude(0.2,center=true) 
              text(jackTxt[1][i],size=txtSize,halign="center",valign="center", font=txtFont);
        }
      }
  }
}

module panel1U(HP=20,center=false){
  ovHght=39.65;
  ovWdth= HP*5.08; 
  holeSpc=[7.5,3]; //spacing hole-edge
  
  cntrOffset= center ? [0,0,0] : [ovWdth/2, ovHght/2, matThck/2];
  translate(cntrOffset)
    difference(){
      cube([ovWdth,ovHght,matThck],true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(ovWdth/2-holeSpc.x),iy*(ovHght/2-holeSpc.y),0]) 
          cylinder(d=3.2,h=matThck+fudge,center=true);
    }
}

module sepLine(length=10,width=0.8){
  hull(){
    for (iy=[-1,1])
      translate([0,iy*(length-width)/2,0]) circle(d=width);
  }
}

*arrows(type="1to3",center=true);
module arrows(size=[10,10],type="1to3",w=0.5,spc=1, points=0.5, center=false){

  cntrOffset= center ? [-size.x/2,-size.y/2] : [0,0];
  translate(cntrOffset){
    if (type=="1to3"){
      arrow([0,size.y],[0,0],width=w,spacing=spc);
      arrow([0,size.y],[size.x,size.y],width=w,spacing=spc);
      arrow([0,size.y],[size.x,0],width=w,spacing=spc);
    }
    if (type=="3to1"){
      arrow([size.x,size.y],[0,0],width=w,spacing=spc);
      arrow([0,size.y],[0,0],width=w,spacing=spc);
      arrow([size.x,0],[0,0],width=w,spacing=spc);
    }
    if (type=="2to2"){
      arrow([0,0],[size.x,0],width=w,spacing=spc);
      arrow([0,size.y],[size.x,size.y],width=w,spacing=spc);
      arrow([0,0],[size.x,size.y],width=w,spacing=spc);
      arrow([0,size.y],[size.x,0],width=w,spacing=spc);
    }
    if (points) for (ix=[0,size.x],iy=[0,size.y])
        translate([ix,iy]) circle(points);
  }
}

*arrow(start=[0,0],end=[0,-10],width=0.5,spacing=3);
module arrow(start=[0,0],end=[15,15],width=0.5,spacing=3){
  //draws an arrow on a line between start and end with spacing to start/endpoints
  x=(end.x-start.x);
  y=(end.y-start.y);
  Q2= (x>0 && y<0) ? 270 : 0;
  Q3= (x<=0 && y<=0) ? 180 : 0;
  Q4= (x<0 && y>0) ? 90 :0;
  angle=abs(atan(y/x))+Q2+Q3+Q4;
  //angle=atan2(norm(cross(start,end)),start*end);
  echo("angle",atan((end.y-start.y)/(end.x-start.x)),angle);
  hyp=norm(end-start);
  tipLen=4;
  tipWdth=1.5;
  //shaft
  translate(start) rotate(angle) translate([spacing,0])
  hull(){
    circle(d=width);
    translate([hyp-spacing*2,0]) circle(d=width);
  }
  //tip
  translate(start) rotate(angle) translate([hyp-spacing,0,0]) hull(){
    translate([-width*tipLen,width*tipWdth]) circle(d=width);
    circle(d=width);
    translate([-width*tipLen,-width*tipWdth]) circle(d=width);
  }
}

module washer(dia=7.5,thck=0.6){
  difference(){
    cylinder(d=dia,h=thck);
    translate([0,0,-fudge/2]) cylinder(d=6.1,h=thck+fudge);
  }
}