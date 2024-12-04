/* [General] */
quality=50; //[20:10:100]
minWallThck=2;

/* [left Fan] */
fanLftSize="custom"; //["custom","40","60","80","120","140"]
//custom nominal Size of the Fan
fanLftCstmSize=80; 
//custom bore for the mounting holes
fanLftCstmDrillDia=4.5; 
//custom distance of the mounting holes
fanLftCstmDrillDist=71.5; 
//horizontal offset to the left
fanLftHrz=10; 
//vertical offset for the left
fanLftVrt=10;
fanLftChnlRadius=50; //center radius of the left channel

/* [right Fan] */
fanRghtSize="custom"; //["custom","40","60","80","120","140"]
//custom nominal Size of the Fan
fanRghtCstmSize=80; 
//custom bore for the mounting holes
fanRghtCstmDrillDia=4.5; 
//custom distance of the mounting holes
fanRghtCstmDrillDist=71.5; 
//horizontal offset to the right
fanRghtHrz=10; 
//vertical offset for the right
fanRghtVrt=10;
fanRghtChnlRadius=80; //center radius of the right channel

/* [bottom Fan] */
//needs to be same size than the larger of the two others
fanBotSize="largest"; // ["largest","custom","40","60","80","120","140"]
fanBotCstmSize=80; //the nominal Size of the Fan
fanBotCstmDrillDia=4.5; //bore for the mounting holes
fanBotCstmDrillDist=71.5; //distance of the mounting holes

/* [Hidden] */
fudge=0.1;
fanBotDist=10; //straight segment from the bottom
$fn=quality;

//Dictionary
//             0    1    2     3      4
fanSizes=     [40,  60,  80,   120,   140];
fanDrillDists=[32,  50,  71.5, 105, 124.5];
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
//fanBotCstmDrillDist=0;

echo("types",fanRghtType,fanLftType,fanBotType); 
assembly();

module assembly(){
  
  
  lftSize=      (fanLftSize=="custom") ? fanLftCstmSize : fanSizes[fanLftType];
  lftDrillDia=  (fanLftSize=="custom") ? fanLftCstmDrillDia : fanDrillDias[fanLftType];
  lftDrillDist= (fanLftSize=="custom") ? fanLftCstmDrillDist : fanDrillDists[fanLftType];
  
  rghtSize=      (fanRghtSize=="custom") ? fanRghtCstmSize : fanSizes[fanRghtType];
  rghtDrillDia=  (fanRghtSize=="custom") ? fanRghtCstmDrillDia : fanDrillDias[fanRghtType];
  rghtDrillDist= (fanRghtSize=="custom") ? fanRghtCstmDrillDist : fanDrillDists[fanRghtType];
  
  echo(lftSize,rghtSize);
  //bottom fan mount
  botSize=      (fanBotSize=="largest") ? max(lftSize,rghtSize) : 
                (fanBotSize=="custom") ? fanBotCstmSize : 
                (fanBotType<5) ? fanSizes[fanBotType] : fanBotCstmSize;
                
  botDrillDia=  (fanBotSize=="largest") ? max(lftDrillDia,rghtDrillDia) : 
                (fanBotSize=="custom") ? fanBotCstmDrillDia : 
                (fanBotType<5) ? fanDrillDias[fanBotType] : fanBotCstmDrillDia;
                
  botDrillDist= (fanBotSize=="largest") ? max(lftDrillDist,rghtDrillDist) : 
                (fanBotSize=="custom") ? fanBotCstmDrillDist : 
                (fanBotType<5) ? fanDrillDists[fanBotType] : fanBotCstmDrillDist;
  
  //limit the radii
  lRadius= fanLftChnlRadius<(lftSize/2+minWallThck) ? (lftSize/2+minWallThck) : fanLftChnlRadius;
  rRadius= fanRghtChnlRadius<(rghtSize/2+minWallThck) ? (rghtSize/2+minWallThck) : fanRghtChnlRadius;
  
  fanMount(size=botSize, drillDia=botDrillDia, drillDist=botDrillDist);
  
  translate([0,0,minWallThck]) difference(){
    union(){
      //left channel
      channel(dia=lftSize+minWallThck*2, radius=lRadius, dist=[fanLftVrt,fanLftHrz]);
      //right channel
      rotate(180) channel(dia=rghtSize+minWallThck*2, radius=rRadius, dist=[fanRghtVrt,fanRghtHrz]);
    }
    translate([0,0,-minWallThck]) channel(dia=lftSize, radius=lRadius, dist=[fanLftVrt+minWallThck+fudge,fanLftHrz+minWallThck+fudge]);
    rotate(180) translate([0,0,-minWallThck]) channel(dia=rghtSize, radius=rRadius, dist=[fanRghtVrt+minWallThck+fudge,fanRghtHrz+minWallThck+fudge]);
    }
  //left mount
  translate([-lRadius-fanLftHrz,0,lRadius+fanLftVrt+minWallThck]) rotate([0,-90,0]) fanMount(size=lftSize,drillDia=lftDrillDia,drillDist=lftDrillDist);
  //right mount
  translate([rRadius+fanRghtHrz,0,rRadius+fanRghtVrt+minWallThck]) rotate([0,90,0]) fanMount(size=rghtSize,drillDia=rghtDrillDia,drillDist=rghtDrillDist);
  
}


module channel(dia=80,dist=[10,10],radius=64){
  
  //straight start
  linear_extrude(dist[0]) circle(d=dia);
  //bend part
  translate([-(radius),0,dist[0]]) rotate([90,0,0]) rotate_extrude(angle=90) translate([radius,0]) circle(d=dia);
  //straight end
  translate([-radius,0,dist[0]+radius]) rotate([0,-90,0]) linear_extrude(dist[1]) circle(d=dia);
  
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

