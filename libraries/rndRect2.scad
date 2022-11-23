/* Rounded Rectangle with drill holes
  This is mainly intended for "Pimoroni-Style" electronics housings.
  These are stagged layers of acrylic sheets with cutouts for PCBs, connecctors, displays etc.
  in each Layer. 
*/
$fn=50;
//rndRect(size=[50,100,3],3,2.1,false,"none","layer1",[0,0]);


rndRect(size=[100+0.5,36+0.5,2],radius=1.25,drill=3,drillOffset=[3,3.5],center=false);

 
module rndRect(size=[10,10,1],radius=1,drill=1,diff="none",label="none",drillOffset=[0,0],center=false) {
  fudge=0.1;
  //set radius to minimum if less then size.x or high
  dims = (size.y==undef) ? [size.x,size.x,size.x] : size;
  comp = (size.x>size.z) ? size.y : size.x; //which value to compare to
  radius = (radius>(comp/2)) ?  comp/2 : radius; //set radius
  
  
  cntrOffset = center ? [0,0,-size.z/2] : [size.x/2,size.y/2,0];
  //cntrOffset = [0,0,-size.z/2];
  echo(cntrOffset);
  
  translate(cntrOffset){
    if (diff=="screws"){ //drill holes
      for (i=[-1,1]){ 
        for (j=[-1,1]){
          translate([i*(dims.x/2-radius-drillOffset.x),j*(dims.y/2-radius-drillOffset.y),-fudge/2]) 
            cylinder(h=dims.z+fudge, d=drill);
        }
      }
    }
    
  //if screwheads
    
    /*else if (drill>=radius*2){//if drill bigger than radius make screw Head cover
      difference(){
        translate([0,0,dims.z/2]) cube(dims,true); //base is cube
          for (i=[-1:2:1]){
            for (j=[-1:2:1]){
              translate([i*(dims.x/2),j*(dims.y/2),-fudge/2])
                rndRect(drill*2,drill*2,dims.z+fudge,drill/2,0,"none");
                //cylinder(h=dims.z+fudge, d=drill);
              
              translate([i*((dims.x/2)-drill*1.25+fudge/2),j*((dims.y/2)-drill/4+fudge/2),dims.z/2]) 
                difference(){
                  cube([drill/2+fudge,drill/2+fudge,dims.z+fudge],true);
                  translate([i*(-drill/4-fudge/2),j*(-drill/4-fudge/2),-dims.z/2-fudge/2]) cylinder(h=dims.z+fudge,d=drill);
                }
              translate([i*((dims.x/2)-drill/4+fudge/2),j*((dims.y/2)-drill*1.25+fudge/2),dims.z/2]) 
              difference(){
                cube([drill/2+fudge,drill/2+fudge,dims.z+fudge],true);
                translate([i*(-drill/4-fudge/2),j*(-drill/4-fudge/2),-dims.z/2-fudge/2]) cylinder(h=dims.z+fudge,d=drill);
              }
            }
          }
        }//diff
    }//else*/
    
    else { //make rounded plate with screw holes
      difference(){
        hull(){
          for (i=[-1,1]){
            for (j=[-1,1]){
              translate([i*(dims.x/2-radius),j*(dims.y/2-radius),0])
                cylinder(h=dims.z, r=radius);//cube
            }
          }
        }
        for (i=[-1,1]){ //drill holes
          for (j=[-1,1]){
            translate([i*(dims.x/2-radius-drillOffset.x),j*(dims.y/2-radius-drillOffset.y),-fudge/2]) 
              cylinder(h=dims.z+fudge, d=drill);
          }
        }
        //label                    rght, lft, btm, top
        /*if (label!="none") // i,j: -1,0 1,0 0,-1 0,1
          for (i=[ [[1, 0],[90,0, 90]],    //right
                   [[-1, 0],[90,0,-90]],    //left
                   [[ 0,-1],[90,0,  0]],    //front
                   [[ 0,1 ],[90,0,180]] ]){  //back
            
            translate([i[0][0]*(dims.x/2-fudge),i[0][1]*(dims.y/2-fudge),dims.z/2]) // 
              rotate(i[1]) //90,0,90 90,0,-90 90,0,0 90,0,180
                linear_extrude(fudge*2,convexity=10)
                  text(label,halign="center",valign="center",dims=0.6*dims.z);
            
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
            translate([i[0][0]*(dims.x/2),i[0][1]*(dims.y/2),dims.z/2]) // 
              rotate(i[1]) //90,0,90 90,0,-90 90,0,0 90,0,180
                  text(label,halign="center",valign="center",dims=0.6*dims.z);
            
          }//if .. for i
         
    
  }//cntrOffset
  
}