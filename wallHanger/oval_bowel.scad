//
// Created by Patrick Bailey iQless.com
//
////////////////////////////////////////
$fn=200;

rim_depth = 15;
bottom_thickness = 5;
fn_num = 8;
top_cut = 35;

difference(){
  difference(){
    hull(){
      translate([-35,0,45]){
        sphere(88, $fn=fn_num);
      }
      translate([35,0,45]){
        sphere(88, $fn=fn_num);
      }
    }

    translate([0,0,-200]){
      cube(400, center=true);
    }
    translate([0,0,200+top_cut]){
      cube(400, center=true);
    }
  }


  translate([0,0,bottom_thickness]){
    difference(){
      hull(){
        translate([-35,0,45]){
          sphere(88-rim_depth, $fn=fn_num);
        }
        translate([35,0,45]){
          sphere(88 - rim_depth, $fn=fn_num);
        }
      }

      translate([0,0,-200]){
        cube(400, center=true);
      }
      translate([0,0,200+top_cut]){
        cube(400, center=true);
      }
    }
  }
}


