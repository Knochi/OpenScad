footDims=[40,40,20];
decorDia=3;
decorOffset=decorDia/(2*sqrt(2));
fudge=0.1;
holeDia=20;
minWallThck=2;
sheetThck=0.4;

$fn=50;

upperDims=[footDims.x-footDims.z,footDims.y-footDims.z];
poly=[[upperDims.x,0],[upperDims.x,upperDims.y],[footDims.x+5,footDims.y+5],[footDims.x+5,0]];

difference(){
  
  union(){
    linear_extrude(footDims.z,scale=0.5) square([footDims.x,footDims.y]);
    for (i=[0,1]) rotate(i*90) mirror([0,i,0])
    intersection(){
      union(){
        translate([footDims.x-decorOffset,0,decorOffset]) rotate([-90,0,0]) cylinder(d=decorDia,h=footDims.y+2);
        translate([footDims.x-footDims.z+decorOffset,0,footDims.z-decorOffset]) rotate([-90,0,0]) cylinder(d=decorDia,h=footDims.y+2);
      }
      linear_extrude(footDims.z+decorDia) polygon(poly);
    }
  }
  translate([-fudge,-fudge,-fudge]) linear_extrude(footDims.z*0.8+fudge,scale=0.5) square(footDims.x*0.8+fudge);
  linear_extrude(footDims.z+fudge)
  intersection(){
    translate([minWallThck,minWallThck]) square(holeDia);
    circle(d=holeDia-minWallThck*2);
  }
  cylinder(d1=3,d2=0.5,h=footDims.z+fudge);
}

translate([0,0,footDims.z]) linear_extrude(sheetThck) 
  intersection(){
    square(holeDia);
    difference(){
      circle(d=holeDia);
      circle(d=holeDia-minWallThck*2);
    }
  }