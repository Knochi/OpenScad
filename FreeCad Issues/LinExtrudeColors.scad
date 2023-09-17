union(){
  translate([-7,21,2])
    color("green")
      linear_extrude(2)
        square(10,true);
        
  translate([7,21,2]) 
  color("red") 
    linear_extrude(2) 
      square(10,true);
}

translate([0,7,2]){
  translate([-7,0,0])
    color("green")
      linear_extrude(2)
        square(10,true);
        
  translate([7,0,0]) 
  color("red") 
    linear_extrude(2) 
      square(10,true);
}

translate([0,-7,3]){
  translate([-7,0,0])
    color("green")
      cube([10,10,2],true);
        
  translate([7,0,0]) 
  color("red") 
    cube([10,10,2],true);
}