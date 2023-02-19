//remix of https://www.thingiverse.com/thing:16510

/* [Dimensions] */
size= 30;
pillars= [3,4,5,6];
topThck=2;
botThck=3;
botHole=5;
emboss=1;
cstmLblTxt="0.4,200°C";
cstmLblyOffset=5;
cstmLblSize=4;

/* [Labels] */
cstmLbl=true;
xLbl=true;
diaLbls=true;

/* [hidden] */
fudge=0.1;
$fn=20;
txtSize=(size-botHole)/2;
txtOffset=size/2-(size-botHole)/4;


//top with hole and labels (deacrtivated)
*difference(){
translate([0,0,size-topThck]) 
  linear_extrude(topThck,convexity=3) difference(){
    square(size,true);
    circle(d=topHole);
  }
  if (xLbl) translate([0,-txtOffset,size-emboss]) linear_extrude(emboss+fudge) text("←x→",size=txtSize*0.8,valign="center",halign="center");
  if (cstmLbl) translate([0,txtOffset,size-emboss]) linear_extrude(emboss+fudge) text(cstmLblTxt,size=cstmLblSize,valign="center",halign="center");
  if (diaLbls) translate([topHole/2,0,size-emboss]) linear_extrude(emboss+fudge) text(str("Ø",topHole),size=((size-topHole)/5)*0.8,valign="center");
}

//bottom
difference(){
  linear_extrude(botThck,convexity=2) difference() {
    square(size,true);
    circle(d=botHole);
  }
  if (diaLbls) translate([botHole/2,0,botThck-emboss]) linear_extrude(emboss+fudge) text(str("Ø",botHole),size=((size-botHole)/5)*0.8,valign="center");
  if (xLbl) translate([0,-txtOffset,botThck-emboss]) linear_extrude(emboss+fudge) text("←x→",size=size*0.2,valign="center",halign="center");
  if (cstmLbl) translate([0,cstmLblyOffset,botThck-emboss]) linear_extrude(emboss+fudge) text(cstmLblTxt,size=cstmLblSize,valign="center",halign="center");
}

//pillars & top
for (i=[0:3]){
  nxt= i<3 ? i+1 : 0;
  quad= [[-1,-1],[ 1,-1],[ 1, 1],[-1, 1]];
  //pillars
  translate([quad[i].x*(size-pillars[i])/2,quad[i].y*(size-pillars[i])/2,botThck]) linear_extrude(size-topThck-botThck) square(pillars[i],true);
  //top structure
  hull(){
    translate([quad[i].x*(size-pillars[i])/2,quad[i].y*(size-pillars[i])/2,size-topThck]) linear_extrude(topThck) square(pillars[i],true);
    translate([quad[nxt].x*(size-pillars[nxt])/2,quad[nxt].y*(size-pillars[nxt])/2,size-topThck]) linear_extrude(topThck) square(pillars[nxt],true);
  }
  
}
