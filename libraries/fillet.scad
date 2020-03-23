/* fillet Tool by Knochi v0.1
  Just provide three points proceed to corner to attach fillet clockwise!
  P1 is corner of first edge
  P2 is corner to attach fillet and intersection of both edges
  P3 is corner of second edge
  radius is the fillet radius, if radius is zero or to big the shorter edge will be totally consumed by filled
  you can also define edges only for the area you want the fillet and let the module calculate the radius
  
  ToDo: 
  - add examples
  - add negative fillets (for edges >180)
  - add chamfers
  - catch errors
  - calculate circles to fit segments into shape
*/

$fn = 100;

showDebug=false;
shape1=[[0,15],[10,12],[13,0],[0,0]]; //Quadrant I defined clockwise
shape2=[[-10,20],[-20,5],[-10,3]]; // Quadrant IV defined anticlockwise
shape3=[[8.8,-4],[12.5,-7],[18,-18],[12,-15],[2.5,-22]];
shape4=[[0,0],[56,0],[7.5,-28]];

translate([0,-30/2]) circle(d=30);
difference(){
  polygon(shape4);
  fillet2D(shape4[0],shape4[1],shape4[2],7);
}

//round off one corner with defined radius
*difference(){
  polygon(shape1);
  fillet2D(shape1[0],shape1[1],shape1[2],3);
}

//round off several corners with different radiuses
*linear_extrude(2) difference(){
  polygon(shape2);
  fillet2D(shape2[2],shape2[1],shape2[0],2);
  fillet2D(shape2[0],shape2[2],shape2[1],3);
  fillet2D(shape2[1],shape2[0],shape2[2],1);
}

//round off with auto-radius
*difference(){
  polygon(shape3);
  fillet2D(shape3[0],shape3[1],shape3[2],0);
}

module fillet2D(p1,p2,p3,radius,fudge=0.1){
  //gives a substraction shape to round a corner
  //p2=corner
  v1=p1-p2;//[p1.x-p2.x,p1.y-p2.y]; //vector of edge1
  v2=p3-p2;//[p3.x-p2.x,p3.y-p2.y]; //vector of edge2
    
  //calculate polar coordinates in P2 (corner)
  beta=angle2Vec(v1,v2); //enclosed angle between edges
  gamma=atan2(p1.y-p2.y,p1.x-p2.x);// angular coordinate of edge1
  delta=atan2(p2.y-p3.y,p2.x-p3.x);; //angular coordinate of edge2
  phi=gamma+beta/2; //angular coordinate of corner radius
  
  //--auto radius--
  pmax=(norm(v1)<norm(v2)) ? p1 : p3;
  angx=(norm(v1)<norm(v2)) ? gamma+90 : delta+90;
  //linear equitations
  m=tan(angx); //px(x) m+x+b from shorter edge
  b=-m*pmax.x+pmax.y;
  n=tan(phi); //p0(x)=n*x+c from corner
  c=-n*p2.x+p2.y;
  //intersection of both lines (https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection)
  P0max=[(c-b)/(m-n),m*((c-b)/(m-n))+b];
  /* reassign variables...
    P=[(d-c)/(a-b),a*((d-c)/(a-b))+c]; a=M
    P=[(d-c)/(M-b),M*((d-c)/(M-b))+c]; c=B
    P=[(d-B)/(M-b),M*((d-B)/(M-b))+B]; b=N
    P=[(C-B)/(M-N),M*((C-B)/(M-N))+B]; d=C
  */
  maxRad=norm(P0max-pmax);
  
  //if auto radius is smaller than given radius or zero use maximum radius
  crnrRad= (maxRad<radius)||(radius==0) ? maxRad : radius; //limit radius to length of shortest edge
  r=radius/sin(beta/2);//radial coordinate
  //if auto radius is smaller than given radius or zero use center for auto-radius
  p0=(maxRad<radius)||(radius==0) ? P0max : [r*cos(phi),r*sin(phi)]+p2; //center of the corner radius
  //P0= (maxRad<radius)||(radius==0) ? P0max : p0;

 
  //add fudge
  fuDist=fudge/sin(beta/2); // radial coordinate (distance) from corner for fudge
  P1=tangent([p1.x,p1.y,0],[p0.x,p0.y,crnrRad])[1];
  P11=P1+pol2crt(fudge,gamma-90); //parallel translated P1
  P2=[fuDist*cos(phi-180),fuDist*sin(phi-180)]+p2; //original P2 translated by fudge
  P3=tangent([p2.x,p2.y,0],[p0.x,p0.y,crnrRad])[1]; 
  P33=P3+pol2crt(fudge,delta-90); //parallel translated P3
  
  
  difference(){
    polygon([P1,P11,P2,P33,P3]);
    translate(p0) circle(crnrRad);
  }
  
  
  if (showDebug){
    echo(str(
      "-Debug-:",
      "\nbeta=",beta,
      "\ngamma=",gamma, 
      "\ndelta=",delta,
      "\nphi=",phi,
      "\nangX=",angx,
      "\nlength p1-p2=", norm(v1),
      "\nlength p2-p3=", norm(v2),
      "\np0=",p0,
      "\nmaxRad=", maxRad,
      "\nP0max=",P0max,
      "\npmax=",pmax));
    echo(str("px(x)=",m,"*x+",b));
    echo(str("p2(x)=",n,"*x+",c));
    
    #hull(){
    color("red") translate(P0max) circle(0.1);
    color("green") translate(P2) circle(0.1);
    }
    
  }
}
     
function tangent(p1, p2) =
    let(
        r1 = p1[2],
        r2 = p2[2],
        dx = p2.x - p1.x,
        dy = p2.y - p1.y,
        d = sqrt(dx * dx + dy * dy), //pythagoras
        theta = atan2(dy, dx) + acos((r1 - r2) / d),
        xa = p1.x +(cos(theta) * r1),
        ya = p1.y +(sin(theta) * r1),
        xb = p2.x +(cos(theta) * r2),
        yb = p2.y +(sin(theta) * r2)
    )[ [xa, ya], [xb, yb] ];

//absolut angle of a vector between two points
function angle2D(a,b)=atan((b.x-a.x)/(b.y-a.y));
//angle between two vectors
function angle2Vec(a,b)=acos((a*b)/(norm(a)*norm(b)));
//polar to cartesian coordinates
function pol2crt(r,phi)=[r*cos(phi),r*sin(phi)];
//cartesian to polar coordinates
function crt2pol(p)=[norm(p),atan2(p.y,p.x)];