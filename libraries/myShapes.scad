
linear_extrude(1) star(N=36,ri=5,re=6);
translate([15,0,0]) skewedCube([10,10,4],[45,0],center=true);
translate([30,0,0]) linear_extrude(1)  arc(r=10, angle=50);
translate([30,30,0]) rotate_extrude() rotate(30) arc(r=10, angle=60);

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


module calcFacets(r=5){
  echo(r=r,n=($fn>0?($fn>=3?$fn:3):ceil(max(min(360/$fa,r*2*PI/$fs),5))),a_based=360/$fa,s_based=r*2*PI/$fs);
}

module arc(r=1,angle=60){
  //draws a closed arc shape from zero to target angle
  frgFrmFn= ceil(($fn/360)*angle); //fragments for arc calculated from fn
  
  n= ( $fn>0 ?( frgFrmFn>=3 ? frgFrmFn : 3):ceil(max(min(angle/$fa,r*2*PI/$fs),5)));
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




// --- functions ---
function arcPoints(r=1,angle=60,steps=10,poly=[[0,0]],iter)=
  let(
    iter = (iter == undef) ? steps : iter,
    angInc=angle/steps,
    x= r*cos(angInc*iter),
    y= r*sin(angInc*iter)
  )(iter>=0) ? arcPoints(r,angle,steps,concat(poly,[[x,y]]),iter-1) : poly;