/* [General] */
quality=50; //[20:10:100]
minWallThck=2;

/* [left Fan] */
fanLftSize="custom"; //["custom","40","60","80","120","140"]
//custom nominal Size of the Fan
fanLftCstmSize=80; 
//custom bore for the mounting holes
fanLftCstmDrillDia=4.5; 
//custom lengthsance of the mounting holes
fanLftCstmdrillDists=71.5; 
//horizontal offset to the left
fanLftHrzOffset=10; 
//vertical offset for the left
fanLftVrtOffset=10;
fanLftChnlRadius=50; //center radius of the left channel

/* [right Fan] */
fanRghtSize="custom"; //["custom","40","60","80","120","140"]
//custom nominal Size of the Fan
fanRghtCstmSize=80; 
//custom bore for the mounting holes
fanRghtCstmDrillDia=4.5; 
//custom lengthsance of the mounting holes
fanRghtCstmdrillDists=71.5; 
//horizontal offset to the right
fanRghtHrzOffset=10; 
//vertical offset for the right
fanRghtVrtOffset=10;
fanRghtChnlRadius=80; //center radius of the right channel

/* [bottom Fan] */
//needs to be same size than the larger of the two others
fanBotSize="largest"; // ["largest","custom","40","60","80","120","140"]
//the nominal Size of the Fan
fanBotCstmSize=80; 
//bore for the mounting holes
fanBotCstmDrillDia=4.5; 
//lengthsance of the mounting holes
fanBotCstmdrillDists=71.5; 
//how much extra length to add at the bottom
fanBotVertOffset=10;
//how much room to use for fusing the two channels together
fuseHght=30; 


/* [Hidden] */
fudge=0.1;
fanBotlengths=10; //straight segment from the bottom
$fn=quality;

//Dictionary
//             0    1    2     3      4
fanSizes=     [40,  60,  80,   120,   140];
fandrillDistss=[32,  50,  71.5, 105, 124.5];
fanDrillDias= [3.5, 3.7, 4.5,  4.5,   4.5];

fanBotType =  (fanBotSize=="40") ? 0 : 
  (fanBotSize=="60") ? 1 :
  (fanBotSize=="80") ? 2 :
  (fanBotSize=="120") ? 3 :
  (fanBotSize=="140") ? 4 : 5;
  
fanLftType =  (fanLftSize=="40") ? 0 : 
  (fanLftSize=="60") ? 1 :
  (fanLftSize=="80") ? 2 :
  (fanLftSize=="120") ? 3 :
  (fanLftSize=="140") ? 4 : 5;

fanRghtType =  (fanRghtSize=="40") ? 0 : 
  (fanRghtSize=="60") ? 1 :
  (fanRghtSize=="80") ? 2 :
  (fanRghtSize=="120") ? 3 :
  (fanRghtSize=="140") ? 4 : 5;  //5 is custom
//fanBotCstmDrillDia=0;
//fanBotCstmdrillDists=0;

echo("types",fanRghtType,fanLftType,fanBotType); 
assembly();

module assembly(){
  
  //left Fan
  lftSize=      (fanLftSize=="custom") ? fanLftCstmSize : fanSizes[fanLftType];
  lftDrillDia=  (fanLftSize=="custom") ? fanLftCstmDrillDia : fanDrillDias[fanLftType];
  lftdrillDists= (fanLftSize=="custom") ? fanLftCstmdrillDists : fandrillDistss[fanLftType];
  
  //right Fan
  rghtSize=      (fanRghtSize=="custom") ? fanRghtCstmSize : fanSizes[fanRghtType];
  rghtDrillDia=  (fanRghtSize=="custom") ? fanRghtCstmDrillDia : fanDrillDias[fanRghtType];
  rghtdrillDists= (fanRghtSize=="custom") ? fanRghtCstmdrillDists : fandrillDistss[fanRghtType];
  
  //bottom Fan 
  botSize=      (fanBotSize=="largest") ? max(lftSize,rghtSize) : 
                (fanBotSize=="custom") ? fanBotCstmSize : 
                (fanBotType<5) ? fanSizes[fanBotType] : fanBotCstmSize;
                
  botDrillDia=  (fanBotSize=="largest") ? max(lftDrillDia,rghtDrillDia) : 
                (fanBotSize=="custom") ? fanBotCstmDrillDia : 
                (fanBotType<5) ? fanDrillDias[fanBotType] : fanBotCstmDrillDia;
                
  botdrillDists= (fanBotSize=="largest") ? max(lftdrillDists,rghtdrillDists) : 
                (fanBotSize=="custom") ? fanBotCstmdrillDists : 
                (fanBotType<5) ? fandrillDistss[fanBotType] : fanBotCstmdrillDists;
                
  //When Bottom is not largest
  lftOffset= (botSize>lftSize) ? -(botSize-lftSize)/2 : 0;
  rghtOffset= (botSize>lftSize) ? (botSize-rghtSize)/2 : 0;
  
  //limit the radii
  lRadius= fanLftChnlRadius<(lftSize/2+minWallThck) ? (lftSize/2+minWallThck) : fanLftChnlRadius;
  rRadius= fanRghtChnlRadius<(rghtSize/2+minWallThck) ? (rghtSize/2+minWallThck) : fanRghtChnlRadius;
  
  fanMount(size=botSize, drillDia=botDrillDia, drillDist=botdrillDists);
  
  translate([0,0,fuseHght+fanBotVertOffset]) difference(){
    union(){
      //left channel
      translate([lftOffset,0,0]) 
        channel(dia=lftSize+minWallThck*2, radius=lRadius, lengths=[fanLftVrtOffset,fanLftHrzOffset]);
      //right channel
      rotate(180) translate([-rghtOffset,0,0])
        channel(dia=rghtSize+minWallThck*2, radius=rRadius, lengths=[fanRghtVrtOffset,fanRghtHrzOffset]);
    }
    //left channel
    translate([lftOffset,0,-minWallThck]) 
      channel(dia=lftSize, radius=lRadius, lengths=[fanLftVrtOffset+minWallThck+fudge,fanLftHrzOffset+minWallThck+fudge]);
    //right channel
    rotate(180) translate([-rghtOffset,0,-minWallThck]) 
      channel(dia=rghtSize, radius=rRadius, lengths=[fanRghtVrtOffset+minWallThck+fudge,fanRghtHrzOffset+minWallThck+fudge]);
    }
  //left mount
  translate([0,0,fuseHght+fanBotVertOffset]){
    translate([-lRadius-fanLftHrzOffset+lftOffset,0,lRadius+fanLftVrtOffset]) 
      rotate([0,-90,0]) fanMount(size=lftSize,drillDia=lftDrillDia,drillDist=lftdrillDists);
    //right mount
    translate([rRadius+fanRghtHrzOffset+rghtOffset,0,rRadius+fanRghtVrtOffset]) 
      rotate([0,90,0]) fanMount(size=rghtSize,drillDia=rghtDrillDia,drillDist=rghtdrillDists);
  }
  //connect bottom with left and right channels
  color("red") translate([0,0,fanBotVertOffset]) difference(){
    fuse(lftSize+minWallThck*2,rghtSize+minWallThck*2,botSize+minWallThck*2,fuseHght);
    translate([0,0,-fudge/2]) fuse(lftSize,rghtSize,botSize,fuseHght+fudge);
  }
  
  //add the bottom extra length
  color("green") linear_extrude(fanBotVertOffset) difference(){
    circle(d=botSize+minWallThck*2);
    circle(d=botSize);
  }
}


module channel(dia=80,lengths=[10,10],radius=64){
  //straight start
  color("orange")linear_extrude(lengths[0]) circle(d=dia);
  //bend part
  translate([-(radius),0,lengths[0]]) rotate([90,0,0]) rotate_extrude(angle=90) translate([radius,0]) circle(d=dia);
  //straight end
  color("purple") 
    translate([-radius,0,lengths[0]+radius]) rotate([0,-90,0]) linear_extrude(lengths[1]) circle(d=dia);
}

//test
*difference(){
  fuse(60+4,80+4,120+4,50);
  translate([0,0,-fudge/2]) fuse(length=50+fudge);
}
module fuse(lftDia=60,rghtDia=80,botDia=120,length=50){
  lftOffset= (botDia>lftDia) ? -(botDia-lftDia)/2 : 0;
  rghtOffset= (botDia>lftDia) ? (botDia-rghtDia)/2 : 0;
  
  hull(){    
    linear_extrude(0.1,scale=0.1) circle(d=botDia);
    translate([lftOffset,0,length]) linear_extrude(0.1,scale=0.1) circle(d=lftDia);
  }
  hull(){  
    linear_extrude(0.1,scale=0.1) circle(d=botDia);
    translate([rghtOffset,0,length]) linear_extrude(0.1,scale=0.1) circle(d=rghtDia);  
  }
}

module fanMount(size=80,drillDia=4.5,drillDist=71.5){
  minOffset= ((size-drillDist-drillDia/2)<0) ? drillDia/2 : (size-drillDist)/2;
  linear_extrude(minWallThck) difference() {
    offset(minOffset+minWallThck) square(drillDist,true);
    circle(d=size);
    for (ix=[-1,1],iy=[-1,1])
      translate([ix*drillDist/2,iy*drillDist/2]) circle(d=drillDia);
  }
}

