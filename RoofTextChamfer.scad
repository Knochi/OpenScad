/* 
  Testing roof function 
  Needs to be activated in advance settings

*/
//https://github.com/openscad/openscad/pull/3486
$fn=50;

//simple roof with text
fudge=0.1;
  
*translate([16,0,0]) chamfDigit();
translate([0,0,0]) chamfDigit(chamfer=-0.5);



module chamfDigit(digit="1",size=12,height=1,chamfer=0.5){
  if (chamfer>0)
    translate([0,0,height]) mirror([0,0,1]) difference(){
      linear_extrude(height,convexity=3) offset(chamfer) digit();
      translate([0,0,-fudge]) roof() 
        difference(){
          offset((chamfer+fudge)*2) digit(); 
          digit();
        }
    }
    
  else if (chamfer<0){
    translate([0,0,-fudge]) roof() 
        difference(){
          offset((-chamfer+fudge)*2) digit(); 
          digit();
        }
      }
    
  
  module digit(){
    text(digit,size=size,valign="center",halign="center"); 
  }
}