

module star(N=6,od=10,id=7,iter=0,poly=[]){
  if (iter<N){
    xo=od/2*cos((iter*360)/N);
    yo=od/2*sin((iter*360)/N);
    xi=id/2*cos((iter*360+180)/N);
    yi=id/2*sin((iter*360+180)/N);
    poly=concat(poly,[[xo,yo],[xi,yi]]);
    star(N,od,id,iter+1,poly);
  }
  else{
    polygon(poly);
  }
}