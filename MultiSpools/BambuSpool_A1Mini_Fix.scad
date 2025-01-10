$fn=100;
ovDia=176.7;
hexInnerDia=90;
hexOuterDia=ovDia-13;
hexThck=2.2;
fudge=0.1;
addSlots=false;

processPart="B";
//Part A
difference(){
  
  if (processPart=="A") import("A1mini-bambu_spool_hex_A.stl",convexity=4);
  else  import("A1mini-bambu_spool_hex_B.stl");
  
  if (addSlots) translate([ovDia/2,ovDia/2,-fudge/2]) linear_extrude(hexThck+fudge) slots(true);  
}  

  translate([ovDia/2,ovDia/2,0]){
    color("red") linear_extrude(3) difference(){
      circle(d=hexInnerDia);
      circle(d=77);
    }

    color("red") linear_extrude(3.184) difference(){
      circle(d=ovDia-11);
      circle(d=hexOuterDia);
    }
    
    if (addSlots) color("green") linear_extrude(hexThck) slots();
  }
*slot();
module slots(cut=false){
  slotBrim=3;
  slotWidth=5;
  ovWidth=slotBrim*2+slotWidth;
  
  for (ir=[0:90:270])
    rotate(ir) difference(){
      hull(){ 
        translate([0,hexInnerDia/2+ovWidth/2]) circle(d=ovWidth);
        translate([0,hexOuterDia/2-ovWidth/2]) circle(d=ovWidth);
      }
    if (!cut)
      hull(){ 
        translate([0,hexInnerDia/2+ovWidth/2]) circle(d=slotWidth);
        translate([0,hexOuterDia/2-ovWidth/2]) circle(d=slotWidth);
      }
    }
}
