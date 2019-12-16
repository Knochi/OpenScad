/* Rounded Rectangle with drill holes
  This is mainly intended for "Pimoroni-Style" electronics housings.
  These are stagged layers of acrylic sheets with cutouts for PCBs, connecctors, displays etc.
  in each Layer. 
*/
$fn=50;
rndRect([50,100,3],3,2.1,false,"screws","layer1",[0,5]);

module rndRect(size, radius, drill,cntr=true,diff="none",label="none",drillOffset=[0,0]) {
  fudge=0.1;
  //set radius to minimum if less then size.x or high
  size = (size.y==undef) ? [size.x,size.x,size.x] : size;
  comp = (size.x>size.z) ? size.y : size.x; //which value to compare to
  radius = (radius>(comp/2)) ?  comp/2 : radius; //set radius
  cntrOffset = cntr ? [0,0,-size.z/2] : [size.x * 0.5,size.y *0.5,0];
  echo(cntrOffset);
  translate(cntrOffset){
    if (diff=="screws"){ //drill holes
      for (i=[-1,1]){ 
        for (j=[-1,1]){
          translate([i*(size.x/2-radius-drillOffset.x),j*(size.y/2-radius-drillOffset.y),-fudge/2]) 
            cylinder(h=size.z+fudge, d=drill);
        }
      }
    }//if screwheads
    
    else if (drill>=radius*2){//if drill bigger than radius make screw Head cover
      difference(){
        translate([0,0,size.z/2]) cube(size,true); //base is cube
          for (i=[-1:2:1]){
            for (j=[-1:2:1]){
              translate([i*(size.x/2),j*(size.y/2),-fudge/2])
                rndRect(drill*2,drill*2,size.z+fudge,drill/2,0,"none");
                //cylinder(h=size.z+fudge, d=drill);
              
              translate([i*((size.x/2)-drill*1.25+fudge/2),j*((size.y/2)-drill/4+fudge/2),size.z/2]) 
                difference(){
                  cube([drill/2+fudge,drill/2+fudge,size.z+fudge],true);
                  translate([i*(-drill/4-fudge/2),j*(-drill/4-fudge/2),-size.z/2-fudge/2]) cylinder(h=size.z+fudge,d=drill);
                }
              translate([i*((size.x/2)-drill/4+fudge/2),j*((size.y/2)-drill*1.25+fudge/2),size.z/2]) 
              difference(){
                cube([drill/2+fudge,drill/2+fudge,size.z+fudge],true);
                translate([i*(-drill/4-fudge/2),j*(-drill/4-fudge/2),-size.z/2-fudge/2]) cylinder(h=size.z+fudge,d=drill);
              }
            }
          }
        }//diff
    }//else
    
    else { //make rounded plate with screw holes
      difference(){
        hull(){
          for (i=[-1,1]){
            for (j=[-1,1]){
              translate([i*(size.x/2-radius),j*(size.y/2-radius),0])
                cylinder(h=size.z, r=radius);//cube
            }
          }
        }
        for (i=[-1,1]){ //drill holes
          for (j=[-1,1]){
            translate([i*(size.x/2-radius-drillOffset.x),j*(size.y/2-radius-drillOffset.y),-fudge/2]) 
              cylinder(h=size.z+fudge, d=drill);
          }
        }
        //label                    rght, lft, btm, top
        /*if (label!="none") // i,j: -1,0 1,0 0,-1 0,1
          for (i=[ [[1, 0],[90,0, 90]],    //right
                   [[-1, 0],[90,0,-90]],    //left
                   [[ 0,-1],[90,0,  0]],    //front
                   [[ 0,1 ],[90,0,180]] ]){  //back
            
            translate([i[0][0]*(size.x/2-fudge),i[0][1]*(size.y/2-fudge),size.z/2]) // 
              rotate(i[1]) //90,0,90 90,0,-90 90,0,0 90,0,180
                linear_extrude(fudge*2,convexity=10)
                  text(label,halign="center",valign="center",size=0.6*size.z);
            
          }//if .. for i
          */
      }//difference
    }//else
    //label                    rght, lft, btm, top
        if (label!="none") // i,j: -1,0 1,0 0,-1 0,1
          for (i=[ [[1, 0],[90,0, 90]],    //right
                   [[-1, 0],[90,0,-90]],    //left
                   [[ 0,-1],[90,0,  0]],    //front
                   [[ 0,1 ],[90,0,180]] ]){  //back
            color("white")
            translate([i[0][0]*(size.x/2),i[0][1]*(size.y/2),size.z/2]) // 
              rotate(i[1]) //90,0,90 90,0,-90 90,0,0 90,0,180
                  text(label,halign="center",valign="center",size=0.6*size.z);
            
          }//if .. for i
         
    
  }//cntrOffset
  
}