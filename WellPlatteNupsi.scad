$fn=100;
r=24; // radius of waveboard
s=13; //upper dia
hght=14.5;//stump height
h=r-1/2*sqrt(4*pow(r,2)-pow(s,2));//sphere segment height
fudge=0.1;
echo(h);
difference(){
  union(){
  cylinder(d1=14.5,d2=s,h=hght);
  translate([0,0,-r+hght+h]) 
    difference(){
      sphere(r);
      translate([0,0,-(h+fudge)/2]) cylinder(d=r*2+fudge,h=r*2-h+fudge,center=true);
    }
  }
  translate([0,0,-fudge/2]) cylinder(d=4.5,h=hght+h+fudge);
}