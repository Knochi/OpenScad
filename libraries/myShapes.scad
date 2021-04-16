

translate([0,20,0]) linear_extrude(1) star(N=36,ri=5,re=6);
translate([15,0,0]) skewedCube([10,10,4],[45,0],center=true);
translate([30,0,0]) linear_extrude(1)  arc(r=10, angle=50);
translate([30,30,0]) rotate_extrude() rotate(30) arc(r=10, angle=60);


//-- compare facet handling of arc with rotate_extrude
//$fs=0.2;

translate([60,0,2]){
   $fn=ceil(rands(0,50,1)[0]);
   color("red") rotate_extrude(angle=90) arc(3,90);
   color("lightblue") rotate([0,-90,0]) rotate_extrude(angle=90) square([3,10]);
   color("lightblue") translate([0,0,-11]) rotate_extrude(angle=90) square([3,10]);
   color("green") translate([0,0,-1]) cylinder(r=3,h=1);
}
/* -- openSCAD's calculation of fragments in a circle
fn: total number of fragments
fa: minimum angle per fragment
fs: minimum size of a fragment

int get_fragments_from_r(double r, double fn, double fs, double fa)
      {
             if (r < GRID_FINE) return 3;
             if (fn > 0.0) return (int)(fn >= 3 ? fn : 3);
             return (int)ceil(fmax(fmin(360.0 / fa, r*2*M_PI / fs), 5));
      }
      defaults: $fn=0; $fa=12, $fs=2
*/



//draw an arc with 2 radiusses
//$fn=50;
*arcDualRad([0,0],73,15,12,50);
module arcDualRad(M1,r1,r2,angle1,angle2){
/* two arcs with tangential transistion
/  give: center(M1) and radius(r1) of first arc
/        radius(r2) of 2nd arc
/        angle of both arc segments(alpha1,alpha2)
*/
  //if (M1.x<0) assert("ERROR","x-Values needs to be positive")
  
  alpha=90-angle1;
  M2=[sin(alpha)*(r1-r2),cos(alpha)*(r1-r2)];

  //draw two arcs
  *translate(M1) arc(r1,angle1);
  *translate(M2) rotate(angle1) arc(r2,angle2);
  //generate Polygon
  n1=arcFragments(r1,angle1);
  n2=arcFragments(r2,angle2);
  arc1Poly=translatePoints(arcPoints(r1,angle1,n1,poly=[]),M1);
  arc2Poly=translatePoints(rotatePoints(arcPoints(r2,angle2,n2,poly=[]),angle1) ,M2);
  echo(arc2Poly);
  polygon(concat([M1],arc2Poly,arc1Poly));
  
}

module calcFacets(r=5){
  echo(r=r,n=($fn>0?($fn>=3?$fn:3):ceil(max(min(360/$fa,r*2*PI/$fs),5))),a_based=360/$fa,s_based=r*2*PI/$fs);
}

module arc(r=1,angle=60){
  //draws a closed arc shape from zero to target angle 
  //with same amount of fragments rotate_extrude(angle) would produce but with 2D output

  n= arcFragments(r,angle);
  polygon(arcPoints(r,angle,n));
}


module star(N=5, ri=15, re=30) {
    polygon([
        for (n = [0 : N-1], in = [true, false])
            in ? 
                [ri*cos(-360*n/N + 360/(N*2)), ri*sin(-360*n/N + 360/(N*2))] :
                [re*cos(-360*n/N), re*sin(-360*n/N)]
    ]);
}

module skewedCube(size=[1,1,1],skew=[45,45],center=false){
  skwDstX= tan(skew.x) ? size.z/tan(skew.x) : 0;
  skwDstY= tan(skew.y) ? size.z/tan(skew.y) : 0;
  skewDist= [skwDstX,skwDstY];
  centerOffset= center ? [-(size.x+skewDist.x)/2,-(size.x+skewDist.y)/2,-size.z/2]: [0,0,0];
  
  polys= // -- bottom --
         [[0,0,0],          //0
         [size.x,0,0],      //1
         [size.x,size.y,0], //2
         [0,size.y,0],      //3
         // -- top --
         [skewDist.x,skewDist.y,size.z],             //4
         [size.x+skewDist.x,skewDist.y,size.z],      //5
         [size.x+skewDist.x,size.y+skewDist.y,size.z], //6
         [skewDist.x,size.y+skewDist.y,size.z]];       //7
  
  faces=[[0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
  
  translate(centerOffset) polyhedron(polys,faces);
}

// give two or three 2D points to draw a circle
module circFromPoints(points=[],showPoints=false){
  //using trigonometric approach from
  //https://www.weltderfertigung.de/suchen/lernen/mathematik/punktberechnung-kreismittelpunkt-und-radius.php
  p1=points[0];
  p2=points[1];
  p3=points[2];

  //first triangle from 2 points
  a1=p2.y-p1.y;
  b1=p2.x-p1.x;
  c1=norm(p1-p2); //diameter of first circle

  //center of circle from 2 points
  M1=[p1.x+b1/2,p1.y+a1/2];
  
  //done when only 2 points are given
  if (len(points)==2)
    translate(M1) circle(c/2);
  else{ //continue with radius and center from 3 points
    //2nd right triangle between p1 and p3
    a2=p3.y-p1.y;
    b2=p3.x-p1.x;
    c2=norm(p1-p3); //diameter of 2nd circle

    M2=[p1.x+b2/2,p1.y+a2/2];

    //3rd right triangle betwee p2 and p3

    a3=p3.y-p2.y;
    b3=p3.x-p2.x;
    //c3=norm(p2-p3); 

    M3=[p2.x+b3/2,p2.y+a3/2];
    echo("M3",M3);

    //the last triangle is between M1, M3 and 
    //"M" the center of the circle which has to be determined
    //calculate beta of this tri
    W1=atan2(a1,b1);
    W2=atan2((M3.y-M1.y),(M3.x-M1.x));
    W3=atan2((p2.y-M3.y),(p3.x-M3.x));
    W4=atan2((M3.y-M1.y),(M3.x-M1.x));
    beta=90-(W1-W2);
    gamma=90-W3-W4;
    alpha=180-beta-gamma;
    a=norm(M3-M1);
    c=(a*sin(gamma))/sin(alpha);
    alpha2=90-(beta-W2);
    M1M=[sin(alpha2)*c,cos(alpha2)*c];//Offset between M1 and M
    M=[M1.x+M1M.x,M1.y-M1M.y];
    r=norm(p1-M); //distance between center and one of the points
    translate(M) circle(r);
    if (showPoints) echo(str("radius: ",r,"\n center: ",M));
  }

  if (showPoints){
    color("red") translate(p1) circle();
    color("red") translate(p2) circle();
    if (p3) color("red") translate(p3) circle();
   
  }
}


// --- functions ---
function arcPoints(r=1,angle=60,steps=10,poly=[[0,0]],iter)=
  let(
    iter = (iter == undef) ? steps-1 : iter,
    angInc=angle/(steps-1), //increment per step
    x= r*cos(angInc*iter),
    y= r*sin(angInc*iter)
  )(iter>=0) ? arcPoints(r,angle,steps,concat(poly,[[x,y]]),iter-1) : poly;

function arcFragments(r,angle)=
  let(
    cirFrac=360/angle, //fraction of angle
    frgFrmFn= floor($fn/cirFrac), //fragments for arc calculated from fn
    minFrag=3 //minimum Fragments
  ) ($fn>minFrag) ? max(frgFrmFn,minFrag)+1 : ceil(max(min(angle/$fa,r*(2*PI/cirFrac)/$fs),minFrag));


function translatePoints(points=[[0,0],[1,1]],vector=[2,2],output=[],iter)=
  let(
    iter=(iter == undef) ? 0 : iter
  )
  (iter<=len(points)-1) ? translatePoints(points,vector,concat(output,[points[iter]+vector]),iter=iter+1) : output;



echo(rotatePoints());
function rotatePoints(points=[[0,0],[1,1],[5,5]],angle=90,output=[],iter)=
  let(
    iter=(iter == undef) ? 0 : iter,
    x2= cos(angle)*points[iter].x-sin(angle)*points[iter].y,
    y2= sin(angle)*points[iter].x+cos(angle)*points[iter].y
  )
  (iter<len(points)-1) ? rotatePoints(points,angle,concat(output,[[x2,y2]]),iter=iter+1) : concat(output,[[x2,y2]]);
