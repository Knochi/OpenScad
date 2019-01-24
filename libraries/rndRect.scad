/* Rounded Rectangle with drill holes
  This is mainly intended for "Pimoroni-Style" electronics housings.
  These are stagged layers of acrylic sheets with cutouts for PCBs, connecctors, displays etc.
  in each Layer. 
*/
$fn=50;
rndRect(50,100,3,3,2.1,true,"none","layer1",[0,5]);

module rndRect(wdth, hght, thick, radius, drill,cntr=true,diff="none",label="none",drillOffset=[0,0]) {
  fudge=0.1;
  //set radius to minimum if less then wdth or high
  comp = (wdth>hght) ? hght : wdth; //which value to compare to
  radius = (radius>(comp/2)) ?  comp/2 : radius; //set radius
  cntrOffset = cntr ? [0,0,0] :[wdth/2,hght/2,0];
  
  translate(cntrOffset){
    if (diff=="screws"){ //drill holes
      for (i=[-1,1]){ 
        for (j=[-1,1]){
          translate([i*(wdth/2-radius+drillOffset.x),j*(hght/2-radius+drillOffset.y),-fudge/2]) 
            cylinder(h=thick+fudge, d=drill);
        }
      }
    }//if screwheads
    
    else if (drill>=radius*2){//if drill bigger than radius make screw Head cover
      difference(){
        translate([0,0,thick/2]) cube([wdth,hght,thick],true); //base is cube
          for (i=[-1:2:1]){
            for (j=[-1:2:1]){
              translate([i*(wdth/2),j*(hght/2),-fudge/2])
                rndRect(drill*2,drill*2,thick+fudge,drill/2,0,"none");
                //cylinder(h=thick+fudge, d=drill);
              
              translate([i*((wdth/2)-drill*1.25+fudge/2),j*((hght/2)-drill/4+fudge/2),thick/2]) 
                difference(){
                  cube([drill/2+fudge,drill/2+fudge,thick+fudge],true);
                  translate([i*(-drill/4-fudge/2),j*(-drill/4-fudge/2),-thick/2-fudge/2]) cylinder(h=thick+fudge,d=drill);
                }
              translate([i*((wdth/2)-drill/4+fudge/2),j*((hght/2)-drill*1.25+fudge/2),thick/2]) 
              difference(){
                cube([drill/2+fudge,drill/2+fudge,thick+fudge],true);
                translate([i*(-drill/4-fudge/2),j*(-drill/4-fudge/2),-thick/2-fudge/2]) cylinder(h=thick+fudge,d=drill);
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
              translate([i*(wdth/2-radius),j*(hght/2-radius),0])
                cylinder(h=thick, r=radius);//cube
            }
          }
        }
        for (i=[-1,1]){ //drill holes
          for (j=[-1,1]){
            translate([i*(wdth/2-radius-drillOffset.x),j*(hght/2-radius-drillOffset.y),-fudge/2]) cylinder(h=thick+fudge, d=drill);
          }
        }
        //label                    rght, lft, btm, top
        /*if (label!="none") // i,j: -1,0 1,0 0,-1 0,1
          for (i=[ [[1, 0],[90,0, 90]],    //right
                   [[-1, 0],[90,0,-90]],    //left
                   [[ 0,-1],[90,0,  0]],    //front
                   [[ 0,1 ],[90,0,180]] ]){  //back
            
            translate([i[0][0]*(wdth/2-fudge),i[0][1]*(hght/2-fudge),thick/2]) // 
              rotate(i[1]) //90,0,90 90,0,-90 90,0,0 90,0,180
                linear_extrude(fudge*2,convexity=10)
                  text(label,halign="center",valign="center",size=0.6*thick);
            
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
            translate([i[0][0]*(wdth/2),i[0][1]*(hght/2),thick/2]) // 
              rotate(i[1]) //90,0,90 90,0,-90 90,0,0 90,0,180
                  text(label,halign="center",valign="center",size=0.6*thick);
            
          }//if .. for i
         
    
  }//cntrOffset
  
}