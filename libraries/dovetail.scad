//DoveTail library to connect split objects
//apply a spacing using the buildin offset() function

/* [DoveTail Test] */
dTTestSize=[5,10];
dTTestAngle=60;
dTTestRadius=0.7;
dTTestStart=0.2;
dTTestInc=0.2;
dTTestThick=2;
showPositive=true;
showLabel=true;

/* [Hidden] */
fudge=0.1;

//a piece to test doveTail spacing
doveTailTest();
module doveTailTest(startSpacing=dTTestStart, increment=dTTestInc, isPositive=showPositive, label=showLabel){
  sSpcng=startSpacing;
  inc=increment;
  cntrSize=[dTTestSize.y*3-(sSpcng*2+inc*2)/2,
            dTTestSize.y*3-(sSpcng*2+inc*4)/2];
  cntrOffset=[inc/2,inc/2];        
  
  difference(){
    linear_extrude(dTTestThick){
      difference(){
        union(){
          translate(cntrOffset) square(cntrSize,true);
          if (isPositive)
            for (i=[0:3]){
              spcng=sSpcng+i*inc;
              rotate(i*90) translate([dTTestSize.y*3/2,0])
                doveTail(dTTestSize,dTTestAngle,dTTestRadius,spcng);
          }
        }
        if (!isPositive)
          for (i=[0:3]){
            spcng=sSpcng+i*inc;
            rotate(i*90)
              translate([dTTestSize.y*3/2,0]) 
                rotate(180) offset(spcng) doveTail(dTTestSize,dTTestAngle,dTTestRadius,0);    
          }
      }
    }
    if (label){
      dx= isPositive ? 0 : dTTestSize.x;
      for (i=[0:3]){
              spcng=sSpcng+i*inc;
              rotate(i*90) translate([dTTestSize.y*3/2-spcng-0.5-dx,0,dTTestThick/2]) linear_extrude(dTTestThick/2+fudge)
                rotate(90) text(str(spcng),size=dTTestSize.y*0.4,halign="center");
          }
    }
  }

}

//-- a dovetail shape to link objects
*doveTail();
module doveTail(size=[5,10],angle=60,radius=0.5,flap=1){
  dy= (size.x-radius)/tan(angle); //y offset of narrow part //tan(alpha)=GK/AK
  cy= (radius/cos(90-angle))-radius; //correction of width because of radii //cos(alpha)=GK/HYP
  difference(){
    mirror([1,0]) hull()for (ix=[0,1],iy=[-1,1])
      translate([ix*(size.x-radius)-size.x+radius,iy*(size.y/2-radius-ix*dy)]) circle(radius,$fn=50);
    //cut away left part
    translate([-(radius+fudge)/2,0]) square([radius+fudge,size.y+fudge],true);
  }
  if (flap)
    square([flap*2,size.y-dy*2+cy*2],true);
}