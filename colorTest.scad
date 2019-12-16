$fn=50;

spDia=6.8;
col1="darkSlateGrey";
col2="salmon";
col3="gold";


//color before translate
color(col1)
  translate([0,0,2.5])
    difference(){
      cube(5,true);
      sphere(d=spDia,true);
    } 
  
color("gold")
  translate([0,0,2.5])
    cube(2,true);

//color inside group
translate([spDia,0,0]){
  color(col1)
  translate([0,0,2.5])
    difference(){
      cube(5,true);
      sphere(d=spDia,true);
    }
    
  color("gold")
  translate([0,0,2.5])
    cube(2,true);
}

//color after translate
translate([-spDia,0,0]){
  
  translate([0,0,2.5])
    color(col1)
      difference(){
        cube(5,true);
        sphere(d=spDia,true);
      }
    

  translate([0,0,2.5])
    color("gold")
      cube(2,true);
}

//color outside group
color(col1)
translate([-spDia*2,0,0]){
  
  translate([0,0,2.5])
    color("darkSlateGrey")
      difference(){
        cube(5,true);
        sphere(d=spDia,true);
      }
    

  translate([0,0,2.5])
    color("gold")
      cube(2,true);
}

//color before primitive

translate([spDia*2,0,0]){
  translate([0,0,2.5])
      difference(){
        color(col1) cube(5,true);
        color(col2) sphere(d=spDia,true);
      }
    

  translate([0,0,2.5])
    color(col3)
      cube(2,true);
}