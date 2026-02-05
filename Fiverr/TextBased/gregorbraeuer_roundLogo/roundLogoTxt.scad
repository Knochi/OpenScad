include <BOSL2/std.scad>

/*
  Fiverr Order from gregorbraeuer Order No #FO8291A4AEDC4
  You need to install the latest openSCAD developer snapshot (https://openscad.org/downloads.html#snapshots) and activate "textmetrics".
  Open Edit -> Preferences -> Features and check "textmetrics"
*/
/* [Text] */
txtStrng="QEGOR Kilop";
txtFont="Arial:style=Regular"; //font
txtSizeAbs=6; 
txtSizeRel=0.8; //[0:0.1:1]
txtVAlign="baseline"; //["center","baseline"]
txtAutoSize=true;


/* [Logo] */
logoFileName="defa3ult.svg";
logoSelect="PRLogo"; //["import"]

/* [Dimensions] */
baseThck=2;
baseChamfer=0.5;
txtThck=0.6;
outerDia=56;
innerDia=40;
conDims=[2.4,2.4,2];
conRad=0.5;
conDist=50;
conYOffset=3;


/* [Colors] */
txtColor="#DDDDDD"; //color
baseColor="#222222"; //color

/* [Hidden] */
brimWdth=(outerDia-innerDia)/2-baseChamfer;
fudge=0.1;
txtHghtAbs= textmetrics(txtStrng,size=txtSizeAbs,halign="center",valign=txtVAlign, font=txtFont).size.y;
txtSizeAuto = brimWdth*txtSizeRel*txtSizeAbs/txtHghtAbs;
txtSize = txtAutoSize ? txtSizeAuto : txtSizeAbs;
txtHght= textmetrics(txtStrng,size=txtSize,halign="center",valign=txtVAlign, font=txtFont).size.y;
txtDescent=textmetrics(txtStrng,size=txtSize,halign="center",valign=txtVAlign, font=txtFont).descent;

debug=false;

echo(str("TextSize=",txtSize));

$fn=50;

module PRLogo(){
  
  // use the BOSL2 bezier functions: 
  // https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad
  
  //-- outline
  oM = [26.2222,30.4335];
  oC1 = [
    [25.7965,29.8171],
    [25.273,29.3414],
    [24.6512,29]
    ]; 
  oh1 = [6.4787,0];
  ol1 = [-2.6814,19.2234];
  oh2 = [4.12,0];
  ol2 = [1.1535,-8.281];
  oh3 = [1.6781,0]; 
  
  oBez1=concat([oM],oC1);
  oCurve1=bezpath_curve(oBez1,N=3,20);
  //debug_bezier(oBez1,N=3,0.2);
  oP1=last(oBez1)+oh1;
  oP2=oP1 + ol1;
  oP3=oP2 + oh2;
  oP4=oP3 + ol2;
  oP5=oP4 + oh3;
  
  
  poly1=concat(oCurve1,[oP1],[oP2],[oP3],[oP4],[oP5]);
  
  oc1 = [
    [0.9686,0],
    [1.6603,0.1364],
    [2.0676,0.4057],
    [0.6655,0.4401],
    [1.3268,1.3132],
    [1.9792,2.6002],
    [1.215,2.3965],
    [2.0338,4.1564],
    [2.4668,5.2751]
  ]; 
  oh4= [4.4202,0];
  
  oBez2=path2Bez(oc1,last(poly1));
  oCurve2=bezpath_curve(oBez2,N=3,20);
  oP6=last(oBez2)+oh4;
  
  poly2=concat(oCurve2,[oP6]);
  
  oc2= [
    [-1.3318,-2.8513],
    [-2.5095,-5.0614],
    [-3.5422,-6.6247],
    [-0.5083,-0.7696],
    [-1.057,-1.3971],
    [-1.6088,-1.8746],
    [2.0419,-0.2592],
    [3.5358,-0.9414],
    [4.4778,-2.0498],
    [0.9362,-1.1017],
    [1.3564,-2.5068],
    [1.2371,-4.2122],
    [-0.083,-1.1869],
    [-0.4264,-2.1964],
    [-1.0069,-3.0404]
    ]; 
    
  oBez3=path2Bez(oc2,last(poly2));
  oCurve3=bezpath_curve(oBez3,N=3,20);
  poly3=oCurve3;
  
  oC2= [
    [45.4671,29.8056],
    [44.9549,29.332],
    [44.3664,29]
   ];
   
  oH1= 54.5;
  oV1= 27; 
  oH2= 1.5000003;
  ov1= [0,2]; 
  oH3= 12.3986;
  oL1= [9.7172102,48.2234]; 
  oH4= 13.8373;
  ol3= [1.0629,-7.6262];
  oh5= [2.633,0];
  
  oP7= [oH1,last(oC2).y];
  oP8= [oP7.x,oV1];
  oP9= [oH2,oP8.y];
  oP10= oP9+ov1;
  oP11= [oH3,oP10.y];
  oP12= oL1;
  oP13= [oH4,oP12.y];
  oP14= oP13+ol3;
  oP15= oP14+oh5;
  
  oBez4=concat([last(poly3)],oC2);
  oCurve4=bezpath_curve(oBez4,N=3,20);
  poly4=concat(oCurve4,[oP7],[oP8],[oP9],[oP10],[oP11],[oP12],[oP13],[oP14],[oP15]);
  
  oc3= [
    [1.7735,0],
    [2.9712,-0.0409],
    [3.6202,-0.1324],
    [1.0937,-0.1541],
    [1.9652,-0.3724],
    [2.5991,-0.6725],
    [0.6338,-0.3002],
    [1.2036,-0.7367],
    [1.7365,-1.3097],
    [0.5329,-0.573],
    [0.957,-1.337],
    [1.2798,-2.2943],
    [0.3213,-0.9526],
    [0.4572,-1.9349],
    [0.3866,-2.94445]
   ];
  
   
  oC3= [
    [27.0791,32.1524],
    [26.7687,31.2247],
    [26.2222,30.4335]
    ];
    
  oBez5=concat(path2Bez(oc3,last(poly4)),oC3);
  oCurve5=bezpath_curve(oBez5,N=3,20);
  poly5=oCurve5;
  
  outlinePoly=concat(poly1,poly2,poly3,poly4,poly5);
  
  
  // - hole of letter "P"
  pIn_m = [16.6192,37.282];
  pIn_h1 = -1.2687;
  pIn_l = [0.8106,-5.7708];
  pIn_h2= 2.9468;
  
  pIn_c=  [
      [1.337, 0],        //0 c3.1       
      [2.2022, 0.0819],  //1 c3.2       
      [2.5937, 0.2183],  //2 p4         
      [0.3916, 0.1364],  //3 c4.1       
      [0.7079, 0.3684],  //4 c4.2
      [0.9441, 0.6708],  //5 p5
      [0.2433, 0.3115],  //6 c5.1
      [0.3801, 0.7071],  //7 c5.2
      [0.4135, 1.1846],  //8 p6
      [0.0506, 0.7231],  //9
      [-0.1219, 1.3779], //10
      [-0.494, 1.975],   //11 p7
      [-0.3762, 0.6035], //12
      [-0.9186, 1.04],   //13
      [-1.6236, 1.3106], //14 p8
      [-0.7166, 0.2751], //15 c1      
      [-2.1532, 0.4115], //16 c2        
      [-4.3224, 0.4115]  //17 p9 end    
           //                           
  ];    
  //other points
  pIn_P1=pIn_m;
  pIn_P2=[pIn_m.x+pIn_h1,pIn_m.y]; 
  pIn_P3=pIn_P2+pIn_l;
  pIn_P4=[pIn_P3.x+pIn_h2,pIn_P3.y];
  
  pIn_BEZ = path2Bez(pIn_c,pIn_P4);
  pIn_curve = bezpath_curve(pIn_BEZ,N=3,19);
  
  pIn_poly = concat([pIn_P1,pIn_P2,pIn_P3],pIn_curve);
  
  // - hole of the letter "R"
  rIn_m = [34.1397,36.941];
  rIn_l = [0.7428,-5.3752];
  rIn_h = [4.5294,0];
  rIn_c = [
    [1.2005,0],
    [1.9994,0.1092],
    [2.3799,0.3332],
    [0.6155,0.3626],
    [0.9538,0.9083],
    [1.0044,1.6313],
    [0.0439,0.6276],
    [-0.1198,1.2142],
    [-0.4865,1.7759],
    [-0.3726,0.5707],
    [-0.917,0.9799],
    [-1.6193,1.2451],
    [-0.7066,0.2669],
    [-2.1578,0.3897],
    [-4.3679,0.3897]
   ];
   
  rIn_P1=rIn_m;
  rIn_P2=rIn_P1+rIn_l;
  rIn_P3=rIn_P2+rIn_h;
  
  rIn_BEZ= path2Bez(rIn_c,rIn_P3);
  rIn_curve = bezpath_curve(rIn_BEZ,N=3,19);
  
  rIn_poly = concat([rIn_P1,rIn_P2],rIn_curve);
  
  translate([-1.5-53/2,54-26]) 
    mirror([0,1]) difference(){  
      polygon(outlinePoly);  
      polygon(pIn_poly);
      polygon(rIn_poly);
    }
  
  for (m=[0,1]){
    mirror([m,0]) translate([-53/2,2]) weights();
    mirror([m,0]) mirror([0,1]) translate([-53/2,2]) weights();
  }
  
  
  module weights(){
    square([1.2,3.6]);
    translate([1+1.2,0]) square([1.2,5.6]);
    translate([2+1.2*2,0]) square([1.2,7.6]);
  }
}

/*
//this is just to debug the function below
module path2Bez(c=[],start=[0,0],bez=[],iter=0){
  pidx= iter==len(c)-1 ? 2 : 3;
  p = (iter>=3 && iter<=len(c))? bez[iter-pidx]+c[iter-pidx+2] : start;
  c1 = (iter<len(c)-1) ? p + c[iter] : 0;
  c2 = (iter<len(c)-1) ? p + c[iter+1] : 0;
  con = (iter==len(c)-1) ? [p] : [p,c1,c2];
  inc = (iter<len(c)-3) ? 3 : 2;
  
  if (iter<len(c)){
    echo(iter, inc,pidx);
    echo(str("P: ", p, ",C1: ",c1,",C2: ",c2));
    path2Bez(c,start,concat(bez,con),iter+inc) ;
    }
  else{
    echo(iter, inc,pidx);
    echo(str("BEZ:",bez,",LEN: ",len(bez)));
    }
  }
*/

//this converts a relative svg path (c) into bezoer coordinates for BOSL2 bezier functions
//in the form [pstart, c1, c2, p1, c1, c2, pend]

function path2Bez(c=[],start=[0,0],bez=[],iter=0)=let(
  pidx= iter==len(c)-1 ? 2 : 3,
  p = (iter>=3 && iter<=len(c))? bez[iter-pidx]+c[iter-pidx+2] : start,
  c1 = (iter<len(c)-1) ? p + c[iter] : 0,
  c2 = (iter<len(c)-1) ? p + c[iter+1] : 0,
  con = (iter==len(c)-1) ? [p] : [p,c1,c2],
  inc = (iter<len(c)-3) ? 3 : 2
  ) (iter<len(c)) ? path2Bez(c,start,concat(bez,con),iter+inc) : bez;

function last(list)=list[len(list)-1];


color(baseColor) base();
color(txtColor) foreGround();


module logo(){
  if (logoSelect=="import")
        translate([-outerDia/2,-outerDia/2]) import(file=logoFileName);
      else
        PRLogo();
}

module base(){
  difference(){
    ring();
    translate([0,0,baseThck-txtThck]) linear_extrude(txtThck+fudge){
      circularText();
      logo();
    }
  }
  //back for Logo
  linear_extrude(baseThck-txtThck) intersection(){
    circle(d=innerDia);
    logo();
  }
  //attach studs
  for (ix=[-1,1])
    translate([ix*(conDist)/2,conYOffset,-conDims.z]) stud();
}

module foreGround(){
  //txt and logo
  translate([0,0,baseThck-txtThck]) linear_extrude(txtThck){
    circularText();
    logo();
  }
}
  
module ring(){
  difference(){
    union(){
      cylinder(d=outerDia,h=baseThck-baseChamfer);
      translate([0,0,baseThck-baseChamfer]) cylinder(d1=outerDia,d2=outerDia-baseChamfer*2,h=baseChamfer);
    }
    translate([0,0,-fudge/2]) cylinder(d=innerDia,h=baseThck+fudge);
  }  
}


module stud(){
  linear_extrude(conDims.z) 
    offset(conRad) square([conDims.x-conRad*2,conDims.y-conRad*2],true);
}
  

*circularText();
module circularText(rad=innerDia/2, angles=[], iter=0){
  charAng=16;
  yOffset= (txtVAlign=="center") ? brimWdth/2 : brimWdth/2-txtHght/2-txtDescent;
  charPos=getCharPositions(txtStrng,txtSize,txtFont,1,"center");
  
  echo(charPos);
  
  if (debug)
    for (i=[0:len(txtStrng)-1]){
      trailing=textmetrics(txtStrng[i], size=txtSize,font=txtFont,halign="center",spacing=1).position.x;
      translate([charPos[i]-trailing,outerDia/2]){
        text(txtStrng[i], size=txtSize,font=txtFont,halign="center");
        translate([trailing,0]) color("red") circle(0.7);
      }
  }
  
  for (i=[0:len(txtStrng)-1]){
    trailing=textmetrics(txtStrng[i], size=txtSize,font=txtFont,halign="center",spacing=1).position.x;
    thisAng=atan(((charPos[i])-trailing)/innerDia)*2;
    rotate(-thisAng) translate([0,rad+yOffset]) text(txtStrng[i],size=txtSize,halign="center",valign=txtVAlign, font=txtFont);
  }
}

//get the absolute positions of each char in a string
function getCharPositions(string,size,font="",spacing=1, halign="center",offsets=[],iter=0)=let(
  //get the absolute start pos of the whole string
  stringPos=textmetrics(text=string,size=size,font=font, halign=halign, spacing=spacing).position.x,
  //if previous char was a whitespace calculate the width from three chars (two chars or just " " won't work)
  prvChrSz= iter ? ((string[iter-1]==" ") && (iter>1)) ? 
    getCharSizeFromString(string,size=size,font=font,halign=halign,spacing=spacing,index=iter-1) :
    textmetrics(string[iter-1],size=size,font=font, halign=halign,spacing=spacing).size.x : 0,
  //if current char is a whitespace calculate the width from three chars
  thisChrSz=((string[iter]==" ") && iter) ? 
    getCharSizeFromString(string,size=size,font=font,halign=halign,spacing=spacing,index=iter) :
    textmetrics(string[iter],size=size,font=font, halign=halign, spacing=spacing).size.x,
    
  subStrng= iter ? str(string[iter-1],string[iter]) : string[iter], 
  subStrngSz=iter ? 
    textmetrics(subStrng,size=size,font=font, halign=halign,spacing=spacing).size.x : thisChrSz,
  charSpcng=subStrngSz-thisChrSz-prvChrSz,
  chrOffset= (iter==0) ? stringPos : (string[iter]==" ") ? 
    offsets[iter-1]+prvChrSz+thisChrSz : offsets[iter-1]+prvChrSz+charSpcng,
    
) iter<(len(string)) ? getCharPositions(string,size,font,spacing,halign,concat(offsets,chrOffset),iter=iter+1) : offsets;

function getCharSizeFromString(string,size,font="",spacing=1, halign="left", index)= (index>0) && (index<len(string)-1) ?
  //this considers three chars, if possible, to get the size of whitespaces
  textmetrics(str(string[index-1],string[index],string[index+1]),
      size,font=font,spacing=spacing, halign=halign).size.x -
    textmetrics(string[index-1],size,font=font,spacing=spacing, halign=halign).size.x -
    textmetrics(string[index+1],size,font=font,spacing=spacing, halign=halign).size.x : 
    (index == 0) ?
    textmetrics(str(string[0],string[1]),size,font=font,spacing=spacing, halign=halign).size.x -
    textmetrics(string[index-1],size,font=font,spacing=spacing, halign=halign).size.x : 
    textmetrics(str(string[index-1],string[index]),size,font=font,spacing=spacing, halign=halign).size.x -
    textmetrics(string[index-1],size,font=font,spacing=spacing, halign=halign).size.x;
