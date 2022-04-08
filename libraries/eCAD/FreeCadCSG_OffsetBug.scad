
translate([0,0,10]){
    for (i=[0:3])
       translate([0,i*3,i*5]) coilShape([10,10],5,3);
    cube(10,true);
}

module coilShape(innerDims, thick, width){
    translate([0,0,-width/2]) linear_extrude(width) difference(){
      offset(thick) square(innerDims,true);
      square(innerDims,true);
    }
  }