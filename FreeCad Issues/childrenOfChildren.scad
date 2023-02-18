



shiftX(2) cube();
translate([0,2,0])  shiftX(2){
   shiftX(2){
    shiftX(2) cube();;
   }
}
//place cube and move by dist
module shiftX(dist){
  linear_extrude(2) square();
  translate([dist,0,0]) children();
}

