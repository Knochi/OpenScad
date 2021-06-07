
/* conical frustum
  V: Volume
  h: height
  R: bigger radius
  r: smaller radius
  phi: angle between base and cone axis
  
  V=(h*PI)/3 * (R²+R*r+r²)
  h=(R-r)/tan(phi)
  
  V=((R-r)*PI/tan(phi)*3) * (R²+R*r+r²)
  R(r,V,phi)=((3 V tan(ϕ°))/π + r^3)^(1/3) //by Wolfram Alpha
  */
/* simple cylinder
V=r^2*h*PI

*/

 foodDensity=0.54; //Density in kg/l
 brimHght=15; //Height of brim
 baseDia=50;
 minWallThck=0.4*3;
 fudge=0.1;
 conical=true;
 
 phi=10;
 V1_ltr=0.150; //liter
 V1_mm3=V1_ltr*1e6; //mm³
 
 r=baseDia/2;
 R=((3*V1_mm3*tan(phi))/PI + r^3)^(1/3);
 echo(R);
 
 h_cyl=V1_mm3/(PI*r^2);
 h_con=(R-r)/tan(phi);
 
 conical();
 
 module conical(){
   cylinder(d1=baseDia,d2=R*2,h=h_con);
 }
 
 
module cylindrical(){
  difference(){ 
    union(){
      cylinder(d1=baseDia+minWallThck*2,d2=baseDia+minWallThck*4,h=h_cyl+minWallThck);
      translate([0,0,h1+minWallThck]) cylinder(d=baseDia+minWallThck*4,h_cyl=brimHght);
    }
    translate([0,0,minWallThck]){
      cylinder(d=baseDia,h=h_cyl+fudge);
      translate([0,0,h1]) cylinder(d=baseDia+minWallThck*2,h=brimHght+fudge);
    }
  }
}