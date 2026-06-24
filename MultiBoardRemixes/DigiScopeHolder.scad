$fn=50;
pocketScope();
module pocketScope(){
  //2.0" IPS Digital Magnifier 500x
  //https://de.aliexpress.com/item/1005009145564080.html
  dScreen=67;
  dLens=45;
  ovDims=[127.5,dScreen,23.5];
  bdyThck=16;
  linear_extrude(bdyThck) beanShape(d1=dScreen,d2=dLens,r=100,dist=ovDims.x-(dScreen+dLens)/2);
}

*beanShape();
module beanShape(d1=70,d2=50,r=50,dist=70){
  //two circles connected by tangential radius
  //a²=b²+c²-2*b*c*cos(alpha)
  a=r+d2/2;
  b=r+d1/2;
  c=dist;
  alpha=acos((a^2-b^2-c^2)/(-2*b*c));
  beta=acos((b^2-a^2-c^2)/(-2*a*c));
  gamma=180-alpha-beta;
  y
  Prad=[cos(alpha)*b,sin(alpha)*b];
  P1=[cos(alpha)*d1/2,sin(alpha)*d1/2];
  P2=[-cos(beta)*d2/2,sin(beta)*d2/2];
  
  difference(){
    union(){
      circle(d=d1);
      translate([dist,0]) circle(d=d2);
      polygon([P1,[P2.x+dist,P2.y],[P2.x+dist,-P2.y],[P1.x,-P1.y]]);
    }
    translate(Prad) circle(r);
    translate([Prad.x,-Prad.y]) circle(r);
  }
}