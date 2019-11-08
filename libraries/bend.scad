// bend modifier
// bends an child object along the x-axis
// size: size of the child object to be bend
// angle: angle to bend the object, negative angles bend down
// radius: bend radius, if center= false is measured on the outer if center=true is measured on the mid
// center=true: bend relative to the childrens center
// center=false: bend relative to the childrens lower left edge
// flatten: calculates only the stretched length of the bend and adds a cube accordingly
/*[test]*/
cntr=true;
ang=40;
flt=false;

$fn=50;

bend(size=[50,20,3],angle=ang,flatten=flt,center=cntr) 
  translate([0,0,0]) 
    cube([50,20,3],cntr);

module bend(size=[50,20,2],angle=45,radius=10,center=false, flatten=false){
  alpha=angle*PI/180; //convert in RAD
  strLngth=abs(radius*alpha);
  i = (angle<0) ? -1 : 1;
  
  
  bendOffset1= (center) ? [-size.z/2,0,0] : [-size.z,0,0];
  bendOffset2= (center) ? [0,0,-size.x/2] : [size.z/2,0,-size.x/2];
  bendOffset3= (center) ? [0,0,0] : [size.x/2,0,size.z/2];
  
  childOffset1= (center) ? [0,size.y/2,0] : [0,0,size.z/2*i-size.z/2];
  childOffset2= (angle<0 && !center) ? [0,0,size.z] : [0,0,0]; //check
  
  flatOffsetChld= (center) ? [0,size.y/2+strLngth,0] : [0,strLngth,0];  
  flatOffsetCb= (center) ? [0,strLngth/2,0] : [0,0,0];  
  
  angle=abs(angle);
  
  if (flatten){
    translate(flatOffsetChld) children();
    translate(flatOffsetCb) cube([size.x,strLngth,size.z],center);
  }
  else{
    //move child objects
    translate([0,0,i*radius]+childOffset2) //checked for cntr+/-, cntrN+
      rotate([i*angle,0,0]) 
      translate([0,0,i*-radius]+childOffset1) //check
        children();
    //create bend object
    
    translate(bendOffset3) //checked for cntr+/-, cntrN+/-
      rotate([0,i*90,0]) //re-orientate bend
       translate([-radius,0,0]+bendOffset2)
        rotate_extrude(angle=angle) 
          translate([radius,0,0]+bendOffset1) square([size.z,size.x]);
  }
}