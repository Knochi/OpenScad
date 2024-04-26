
arc();

module arcArc(){
  //inspired from occhio lamps - www.occhio.com
  
}


module arc(r=1,angle=60){
  //draws a closed arc shape from zero to target angle 
  //with same amount of fragments rotate_extrude(angle) would produce but with 2D output

  n= arcFragments(r,angle);
  polygon(arcPoints(r,angle,n));
}

//arc with constant radius
function arcPoints(r=1,angle=60,steps=10,poly=[[0,0]],iter)=
  let(
    iter = (iter == undef) ? steps-1 : iter,
    angInc=angle/(steps-1), //increment per step
    x= r*cos(angInc*iter),
    y= r*sin(angInc*iter)
  )(iter>=0) ? arcPoints(r,angle,steps,concat(poly,[[x,y]]),iter-1) : poly;

*offset(3) union(){
  polygon(arcPointsLinear(3,6,180,30));
  rotate(180) polygon(arcPointsLinear(6,3,180,30));
}

//calculate fragments from radius and angle and $fn,$fs etc.
function arcFragments(r,angle)=
  let(
    cirFrac=360/angle, //fraction of angle
    frgFrmFn= floor($fn/cirFrac), //fragments for arc calculated from fn
    minFrag=3 //minimum Fragments
  ) ($fn>minFrag) ? max(frgFrmFn,minFrag)+1 : ceil(max(min(angle/$fa,r*(2*PI/cirFrac)/$fs),minFrag));