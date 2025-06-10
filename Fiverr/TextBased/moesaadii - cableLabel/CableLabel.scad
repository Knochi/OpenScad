/* Cable Label for Fiverr user moesaadii - Order #: #FO1D39198D43 from 2025-05-20 */
//source: https://www.youtube.com/watch?v=v5CrDxSlTzA


/* [Text] */
txtString="Moesaadii";
txtSize=10;
txtFont="Liberation Sans";

/* [Dimensions] */
holeDia=4;
minWallThck=0.8;
topBtmSpcng=0.1;
txtEmbossThck=1;
txtOutline=0.2;
txtOffset=+2.5;
txtOffsetThck=0.5;

/* [Positioning] */
yOffset=0;

/* [Colors] */
txtColor="darkRed";
bdyColor="grey";

/* [DoveTail] */
dvSpcng=0.1;
dvAngle=20;
dvSmooth=true;
dv2BdyWidth=0.4; //[0.2:0.01:0.7]

/* [show] */
quality=100; //[16:16:96]
showTop=true;
showBottom=true;
showSection=false;
bdyStyle="txtOffset"; //["box","txtOffset"]
export="none"; //["none","topTxt","topBody","btmBody","btmTxt"]

/* [Hidden] */
tm=textmetrics(text=txtString,size=txtSize,font=txtFont,valign="center");
fudge=0.1;
dvXOffset= (bdyStyle=="box") ? 0 : -txtOffset-txtOutline;

dvThck=max(holeDia/2,minWallThck*2);

//body without text
bdyDims= (bdyStyle=="box") ? [tm.size.x+txtOutline*2,tm.size.y+txtOutline*2,dvThck+holeDia/2+minWallThck] :
                             [tm.size.x+txtOffset*2+txtOutline*2,
                              tm.size.y+txtOffset*2+txtOutline*2,
                              max(txtOffsetThck,dvThck+holeDia/2+minWallThck)]; 

$fn=quality;

if (export=="none"){
  difference(){
    union(){
      if (showTop)
        top();
      if (showBottom)
        bottom();
      }
    if (showSection)
      color("darkRed") translate([bdyDims.x/2-txtOutline-txtOffset,0,bdyDims.z/2]) 
        cube(bdyDims,true);
    }
}

else {
//output handle in modules
  top();
  bottom();
}
  


*translate([0,yOffset,-dvThck]) linear_extrude(bdyDims.z,convexity=10) offset(3) txtLine();

module top(){
  //top part, spacings apply here
  if (export=="topBody")
    !difference(){
    body();
    doveTail();
    }
  else if (export=="topTxt")
    !difference(){  
      txt();
      doveTail();
    }
    
  else {
    difference(){
      body();
      doveTail();
    }
    difference(){  
      txt();
      doveTail();
    }
  }
     
  module txt(){
    color(txtColor) translate([0,yOffset,bdyDims.z-dvThck]) linear_extrude(txtEmbossThck) txtLine();
  }
  
  module body(){
    if (bdyStyle=="box") //box body
      color(bdyColor) translate([bdyDims.x/2,0,bdyDims.z/2-dvThck]) cube(bdyDims,true);
    else //text-outline-body
      color(bdyColor) translate([0,yOffset,-dvThck+topBtmSpcng]) linear_extrude(bdyDims.z-topBtmSpcng,convexity=len(txtString)) offset(txtOffset) txtLine();
  }
  module doveTail(){
    translate([dvXOffset-fudge/2,0,0]) rotate([0,90,0]) 
      linear_extrude(bdyDims.x+fudge,convexity=6){
        circle(d=holeDia);
        offset(dvSpcng) rotate(90) trapezoid(smooth=dvSmooth);
      }
  }
}

module bottom(){
  
  if (export=="btmTxt") //only for box Style!
    !color(txtColor) mirror([0,1,0]) translate([0,0,-dvThck-txtEmbossThck]) 
        linear_extrude(txtEmbossThck) txtLine();
        
  else if (export=="btmBody"){
    !union(){
      color(bdyColor) intersection(){
        doveTail();
          if (bdyStyle=="box")
            translate([bdyDims.x/2,0,bdyDims.z/2-dvThck]) cube(bdyDims,true);
          else
            translate([0,0,-dvThck-txtEmbossThck]) 
              linear_extrude(bdyDims.z,convexity=3) offset(txtOffset) txtLine();
      } 
      if (bdyStyle=="txtOffset")
        color(bdyColor) translate([0,0,-dvThck-txtEmbossThck]) 
          linear_extrude(txtEmbossThck) offset(txtOffset) txtLine();
    }
    
    
    }
  // doveTail for box or offsetText
  color(bdyColor) intersection(){
    doveTail();
    if (bdyStyle=="box")
      translate([bdyDims.x/2,0,bdyDims.z/2-dvThck]) cube(bdyDims,true);
    else
      translate([0,0,-dvThck-txtEmbossThck]) 
        linear_extrude(bdyDims.z,convexity=3) offset(txtOffset) txtLine();
  }
  
  // 
  if (bdyStyle=="box"){
    color(txtColor) mirror([0,1,0]) translate([0,0,-dvThck-txtEmbossThck]) 
      linear_extrude(txtEmbossThck) txtLine();
      }
  else
    color(bdyColor) translate([0,0,-dvThck-txtEmbossThck]) 
      linear_extrude(txtEmbossThck) offset(txtOffset) txtLine();
   

  module doveTail(){
    translate([dvXOffset,0,0]) rotate([90,0,90]) linear_extrude(bdyDims.x,convexity=3) 
      difference(){
        trapezoid();
        circle(d=holeDia);
        }
  }
}


*trapezoid();
module trapezoid(width=bdyDims.y*dv2BdyWidth, height=dvThck,angle=dvAngle, smooth=false){
  btmWdth=width-tan(dvAngle)*height*2;
  poly=[[-btmWdth/2,0],[-width/2,height],[width/2,height],[btmWdth/2,0]];
  
  hull(){   
    translate([0,-height]) polygon(poly);
    if (smooth)
      circle(d=holeDia);
    }
  
}

module txtLine(){
 translate([-tm.position.x,0]) //-bdyDims.y/2-tm.position.y]) 
   offset(txtOutline) text(text=txtString,size=txtSize,font=txtFont,valign="center");
}