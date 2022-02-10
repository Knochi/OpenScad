/*
  two-circular-arc cam generator by Knochi (mail@knochi.de)
  design from dimensionless variables based on research article of Emre Arabaci
  https://ms.copernicus.org/articles/10/497/2019/ms-10-497-2019.html
*/

$fn=150;
sMax=15; //maximum lift

/* [Dimensionless Design Variables] */
//λ=r2/r
lambda=0.48; //[0.00:0.01:1.00]
//µ=θmax/π
mu=0.42;     //[0.00:0.01:0.50]
//ψ=sMax/r (ψ>λ)
psi=0.6;    //[0.00:0.01:1.00] 


linear_extrude(2) twoCircArcCam(sMax,lambda,mu,0.4);

module twoCircArcCam(sMax=15,lambda=0.48,mu=0.42,psi=0.6){
  
  //constrain design variables
  lambda = (lambda<1) ? lambda : 1;
  mu = (mu<1) ? mu : 0.5;
  psi = (psi<1) ? (psi>lambda) ? psi : lambda : 1; //must be smaller than 1 but larger then lambda
  
  //calc from design variables
  r=sMax/psi;    //check!
  r2=r*lambda;   //check!
  theta0=mu*180; //check!

  //dimensions
  b2=sMax+r-r2; //check!

  b1Cntr=sMax*(2*b2-sMax);
  b1Dnmtr=2*(b2*(1-cos(theta0))-sMax);
  b1=b1Cntr/b1Dnmtr;      

  //angles
  theta1=asin(sin(theta0)*b2/(b1+r-r2));
  theta2=asin(sin(theta0)*b1/(b1+r-r2));
  
  //center of 1st Arc
  M1=polToCart(90-theta0,b1);
  
  circle(r);
  translate([0,b2]) circle(r2);

  for (im=[0,1])
    mirror([im,0]) intersection(){
      square([r,b2+r2]);
      translate(-M1) rotate(90-theta0) arc(b1+r,theta1);
    }
}

module arc(r=1,angle=60){
  //draws a closed arc shape from zero to target angle 
  //with same amount of fragments rotate_extrude(angle) would produce but with 2D output

  n= arcFragments(r,angle);
  polygon(arcPoints(r,angle,n));
}


// -- functions --
//harmonic motion
function sFromPhi(phi,sMax,beta)=
  sMax/2*(1-cos((PI*phi)/beta));

function polToCart(phi,r)= 
[r* cos(phi), r* sin(phi)];
  

function arcFragments(r,angle)=
  let(
    cirFrac=360/angle, //fraction of angle
    frgFrmFn= floor($fn/cirFrac), //fragments for arc calculated from fn
    minFrag=3 //minimum Fragments
  ) ($fn>minFrag) ? max(frgFrmFn,minFrag)+1 : ceil(max(min(angle/$fa,r*(2*PI/cirFrac)/$fs),minFrag));

//arc with constant radius
function arcPoints(r=1,angle=60,steps=10,poly=[[0,0]],iter)=
  let(
    iter = (iter == undef) ? steps-1 : iter,
    angInc=angle/(steps-1), //increment per step
    x= r*cos(angInc*iter),
    y= r*sin(angInc*iter)
  )(iter>=0) ? arcPoints(r,angle,steps,concat(poly,[[x,y]]),iter-1) : poly;
  
