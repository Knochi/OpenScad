


drawPoly=true;
$fn=50;

push_arcTest();
module push_arcTest(){
  //[-0.63,0.95],[-0.64,1.25],0.15,1
  arcStart=[1,5];
  arcEnd=[3,7];
  arcChord = norm(arcEnd-arcStart); //chord length
  arcRadius=3;
  arcSweep=0;
  center=c_centers(arcStart,arcEnd,arcRadius);
  dbgCircleRad=arcRadius/20;
  echo(arcChord,arcRadius);
  
  //debug print
  echo("center, sa, ea, angle, facets");
  echo(push_arc(start=arcStart,end=arcEnd,r=arcRadius,sweep=arcSweep,debug=true));
  normS = norm(arcStart);
  normE = norm(arcEnd);
  denom= normS*normE;
  echo(str("normS: ",normS,"normE: ",normE));
  
  angle=acos(arcStart*arcEnd/(norm(arcStart)*norm(arcEnd)));
  echo(str("angle: ",angle));

  //color("orange") translate(center[arcSweep]) circle(arcRadius+0.5);

  //draw a poly utilizing the arc
  if (drawPoly){
    poly=concat([[0,0],[0,arcStart.y]],
                push_arc(start=arcStart,end=arcEnd,r=arcRadius,sweep=arcSweep),
                [[arcEnd.x,0]]);
    color("lightgreen") linear_extrude(dbgCircleRad/2) polygon(poly);
  }
  //draw the arc alone
  else 
    polygon(concat([center[arcSweep]],push_arc(start=arcStart,end=arcEnd,r=arcRadius,sweep=arcSweep)));

    color("red") linear_extrude(dbgCircleRad) translate(center[0]){
      circle(dbgCircleRad);
      translate([dbgCircleRad,dbgCircleRad]) text(str("C0:",roundVec(center[0],2)),size=dbgCircleRad*2);
    }
    
    color("green") linear_extrude(dbgCircleRad) translate(center[1]){
      circle(dbgCircleRad);
      translate([dbgCircleRad,dbgCircleRad]) text(str("C1:",roundVec(center[1],2)),size=dbgCircleRad*2);
    }
    color("blue") linear_extrude(dbgCircleRad) translate(arcStart){
      circle(dbgCircleRad);
      translate([dbgCircleRad,dbgCircleRad]) text(str("S:",roundVec(arcStart,2)),size=dbgCircleRad*2);
    }
    color("purple") linear_extrude(dbgCircleRad) translate(arcEnd){
      circle(dbgCircleRad);
      translate([dbgCircleRad,dbgCircleRad]) text(str("E:",roundVec(arcEnd,2)),size=dbgCircleRad*2);
    }
  
}


//arc function simlar to svg path command "a/A" (https://www.w3.org/TR/SVG11/paths.html#PathData)
function push_arc(start, end, r, sweep=1, poly=[], iter=0,debug=false)=let(
  chord = norm(start-end),
  r = (r<chord/2) ? chord/2 : r, //limit the radius to half the chord length, doesn't work
  cc = c_centers(start,end,r),
  center=cc[sweep],
  dir = sweep ? -1 : 1,
  //calulate start and end angle with atan2 to address all quadrants
  sa = atan2(start.y-center.y,start.x-center.x), //atan2(y/x) 
  ea = atan2(end.y-center.y,end.x-center.x), //atan2(y/x) 
  //angle = sweep ? ea+sa : ea-sa, //enclosed angle
  u= center - start,
  v= center -end,
  angle = acos(u * v / (norm(u)*norm(v))),
  facets= arcFragments(r,abs(angle)), //total facets
  angInc=(dir*angle)/(facets-1),
  x = center.x+r*cos(sa+angInc*iter),
  y = center.y+r*sin(sa+angInc*iter)
  ) (debug) ? [center,sa,ea,angle,facets,angInc] : 
    (iter<facets) ? push_arc(start,end,r, sweep, poly=concat(poly,[[x,y]]),iter=iter+1) : 
    poly;


//Calculate fragments from r, angle and $fn, $fr or $fa 
//from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features
function arcFragments(r,angle)=
  let(
    cirFrac=360/angle, //fraction of angle
    frgFrmFn= floor($fn/cirFrac), //fragments for arc calculated from fn
    minFrag=3 //minimum Fragments
  ) ($fn>minFrag) ? ceil(max(frgFrmFn,minFrag)+1) : ceil(max(min(angle/$fa,r*(2*PI/cirFrac)/$fs),minFrag));

//calculate two centers from two points and a radius
//from https://lydxlx1.github.io/blog/2020/05/16/circle-passing-2-pts-with-fixed-r/
function c_centers(P1, P2, r)= let(
  q = sqrt(pow((P2.x-P1.x),2) + pow((P2.y-P1.y),2)),
  x3 = (P1.x + P2.x) /2,
  y3 = (P1.y + P2.y) /2,
  xx = sqrt(pow(r,2) - pow(q/2,2))*(P1.y-P2.y)/q,
  yy = sqrt(pow(r,2) - pow(q/2,2))*(P2.x-P1.x)/q
) [[x3 + xx, y3+yy], [x3-xx,y3-yy]];

echo(roundVec([10.235453,11.8435675,3.56],2));

function roundVec(Vec,digits)= let(
  x = round(Vec.x*pow(10,digits))/pow(10,digits),
  y = round(Vec.y*pow(10,digits))/pow(10,digits),
  z = (len(Vec) > 2) ? round(Vec.z*pow(10,digits))/pow(10,digits) : 0
) (len(Vec) > 2) ? [x,y,z] : [x,y];
