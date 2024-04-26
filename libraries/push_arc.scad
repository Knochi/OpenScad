//debug "missing segment issue"
// sometimes there are less segments than calculated when $fn is divisible by 4
// -- findings
// - combinations of certain radii with certain $fn
// - push_arc alone shows issue
// - independen from start and and parameters
$fn=20;

//Test-Parameters
dbgFacets();
module dbgFacets(){
  /*
  body(topDims=[boxTopDims.x-wallThck*2,boxTopDims.y-wallThck*2],
            lwrDims=flrDims,
            height=boxDims.z-footDims.z-wallThck+fudge,
            crnrRad=boxCrnrRad-wallThck);
  */
  // findings
  // combinations of certain radii with certain $fn
  
  goodRad=20;
  badRad=17;
  dims= [60,60];
  
  color("red") translate([0,0,1]) linear_extrude(1) 
    push_arc_Dbg(start=[dims.x/2-goodRad,dims.y/2],
                  end=[dims.x/2,dims.y/2-goodRad],
                  r=goodRad);
  color("green")  linear_extrude(1) 
    push_arc_Dbg(start=[dims.x/2-badRad,dims.y/2],
                  end=[dims.x/2,dims.y/2-badRad],
                  r=badRad);
}


module push_arc_Dbg(start, end, r, sweep=1, poly=[], iter=0){
  chord = norm(start-end);
  r = (r<chord/2) ? chord/2 : r; //limit the radius to half the chord length, doesn't work
  cc = c_centers(start,end,r);
  center=cc[sweep];
  dir = sweep ? -1 : 1;
  //calulate start and end angle with atan2 to address all quadrants
  sa = atan2(start.y-center.y,start.x-center.x); //atan2(y/x) 
  ea = atan2(end.y-center.y,end.x-center.x); //atan2(y/x) 
  u= center-start;
  v= center-end;
  angle = acos(u * v / (norm(u)*norm(v)));
  //facets= arcFragments(r,abs(angle)); //total facets
  facets= floor($fn/(360/round(angle)))+1; //total facets
  echo(str("facets: ",facets,", radius: ", r, ", angle: ", angle,", $fn: ", $fn));
  echo (angle==90?true:false);
  angInc=(dir*angle)/(facets-1);
  x = center.x+r*cos(sa+angInc*iter);
  y = center.y+r*sin(sa+angInc*iter);
  if (iter<facets) 
    push_arc_Dbg(start,end,r, sweep, poly=concat(poly,[[x,y]]),iter=iter+1);
  else
    polygon(poly);
}

//calculate two centers from two points and a radius (when 3rd Point is missing there are two solutions)
//from https://lydxlx1.github.io/blog/2020/05/16/circle-passing-2-pts-with-fixed-r/
function c_centers(P1, P2, r)= let(
  q = sqrt(pow((P2.x-P1.x),2) + pow((P2.y-P1.y),2)),
  x3 = (P1.x + P2.x) /2,
  y3 = (P1.y + P2.y) /2,
  xx = sqrt(pow(r,2) - pow(q/2,2))*(P1.y-P2.y)/q,
  yy = sqrt(pow(r,2) - pow(q/2,2))*(P2.x-P1.x)/q
) [[x3 + xx, y3+yy], [x3-xx,y3-yy]];


// OpenSCAD loft module, with n layers.

module loft(upper_points, lower_points, number_of_layers){
  echo(len(upper_points),len(lower_points));
  assert(len(upper_points)==len(lower_points),"[loft] upper and lower must be equal in length");
  
  polyhedron( 
      points = [
          for (i = [0 : number_of_layers])
              for (j = [0 : len(upper_points) - 1])
                  [((upper_points[j][0] * (number_of_layers - i) / number_of_layers)
                  + (lower_points[j][0] * i / number_of_layers)), //X
                  ((upper_points[j][1] * (number_of_layers - i) / number_of_layers)
                  + (lower_points[j][1] * i / number_of_layers)), //Y
                  ((upper_points[j][2] * (number_of_layers - i) / number_of_layers)
                  + (lower_points[j][2] * i / number_of_layers))] //Z
      ],
      faces = [
          [for (i= [0 : len(upper_points)-1]) i], // Upper plane.
          for (i = [0 : number_of_layers -1])
              for (j = [0 : len(upper_points) - 1]) // Towards lower points.
                  [len(upper_points) * i + (j+1)%len(upper_points), 
                  len(upper_points) * i + j, 
                  len(upper_points) * (i+1) + j],
          for (i = [1 : number_of_layers])
              for (j = [0 : len(upper_points) - 1]) // Towards upper points.
                  [len(upper_points) * i + j, 
                  len(upper_points) * i + (j+1) % len(upper_points), 
                  len(upper_points) * (i-1) + (j+1) % len(upper_points)],
          [for (i= [len(upper_points) * (number_of_layers+1) -1  : -1 : len(upper_points) * number_of_layers ]) i], // Lower plane.
      ]
  );
}

