 //https://de.wikipedia.org/wiki/Parallelogramm
  
  
  /* useful formulas
  alpha + beta = 180° 
  e² + f² = 2 * (a²+b²)
  e² = a²+b²-2*a*b*cos(beta)
     = a²+b²+2*a*b*cos(alpha)
  -->
  cos(alpha) = (e² - a² - b²) / 2ab
  f² = a²+b²+2*a*b*cos(beta)
     = a²+b²-2*a*b*cos(alpha)
  */


$fn=20;
dims=[20,10];
alpha=80; //[0:90]
debug=true;

pGram(dims.x,dims.y,alpha);
//pgram with displacement factor
module pGram(a=20,b=10,angle=80){
  /*    D      a        C
         o------------o
      b /            /
       /            / b
      o------------o
     A       a      B
  
    e = [AC]
    f = [BD]   */
  
  //initial lenght of diagonal segment e when alpha=90
  alpha=90-angle;
  beta=180-alpha;
  e= sqrt(pow(a,2)+pow(b,2)+2*a*b*cos(alpha));
  f= sqrt(pow(a,2)+pow(b,2)-2*a*b*cos(alpha));
  
  
  ha=b*sin(alpha); //heigt between a-sides
  hha=sqrt(pow(b,2)-(pow(ha,2))); //height on that height
  
  hb=a*sin(beta); //height between b-sides
  hhb=sqrt(pow(a,2)-(pow(hb,2))); //height on that height
  
  B=[hb,hhb];
 
  
  epsilon=atan2(b+hhb,hb); //angle of e
  zeta=atan2(ha,a-hha); //angle between f and [AB] or f and [CD]
  
  echo(alpha,beta,epsilon, zeta);
  //alpha=diag2ang(dis*eInit,a,b);
  //draw e and f
  if (debug){
    color("red") 
      rotate([0,90,epsilon]) cylinder(d=0.5,h=e);
    color("blue") translate([0,b,0]) 
      rotate([0,90,-90+beta-zeta]) cylinder(d=0.5,h=f);
  }
  //draw the joints
  for (iy=[0,1]) 
    translate([0,iy*b,0]){
      joint(); //A,D
      rotate([0,0,angle]) translate([a,0,0]) joint();//B,C
    }
  //draw the bars
  for (ix=[0,1],iy=[0,1]){
    translate([0,iy*b,0]) rotate([0,90,angle]) cylinder(d=1,h=a);
    rotate([-90,0,0]) cylinder(d=1,h=b);
    translate([hb,hhb,0]) rotate([-90,0,0]) cylinder(d=1,h=b);
  }
    
  
  
  module joint(){
    jntThck=1;
    jntDia=3;
    jntBore=1;
    translate([0,0,-jntThck/2]) linear_extrude(jntThck) 
      difference(){
        circle(d=jntDia);
        circle(d=jntBore);
      }
  }
}

function diag2ang(diagLen, a, b)= acos((pow(diagLen,2) - pow(a,2) - pow(b,2))/2*a*b);
  
