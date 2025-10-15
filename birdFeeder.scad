// simple bird feeder
// by Knochi

/* [Dimensions] */
//overall Width
ovWidth=120;
//overall extrusion depth
ovDepth=80;
//overall Height
ovHght=140;
//diameter of Logs
logDia=5;
//the minimum Overlap
logMinOverlap=1;
//the desired roof angle
roofAngle=90;


/* [Hidden] */
$fn=50;
//how much logs to fit into the width
btmLogCnt=ceil(ovWidth/(logDia-logMinOverlap));
//adjust log overlap
logOverlap=logDia-((ovWidth-logDia)/(btmLogCnt-1));
logDist=logDia-logOverlap;

//roof lenght with given roof angle
roofLen=(ovWidth-logDia)/cos(roofAngle); //tan(a)=GK/AK, sin(a)=GK/HYP, cos(a)=AK/HYP

//adjusted lengths
roofLogCnt=round(roofLen/logDist);
adjRoofLen=(roofLogCnt-1)*logDist;
adjRoofAng=acos((ovWidth-logDia)/adjRoofLen);
echo(adjRoofAng);


rotate([90,0,0]) linear_extrude(ovDepth,center=true)
//floor
for (ix=[-(btmLogCnt-1)/2:(btmLogCnt-1)/2])
  translate([ix*(logDia-logOverlap),0]) circle(d=logDia);





