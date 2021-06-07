


/* [Dimensions] */
Outer_Spool_Diameter = 200; //[150:400]
Inner_Spool_Diameter = 80;  //[50:200]
Inner_Spool_Width = 61; //[42:150]
Resolution = 20; //[20:50:200]
Lock_Tolerance = 0.15; //[0.05:0.05:0.2]
/* [Show] */
showLid = false;
showGuides= false;
showMainBin= true;

Split_Guides = true;

/* [Options] */
Bin_Handle = "Flat"; //["None","Flat","Curved"]
makeLid=false;

/* [Hidden] */
$fn=Resolution;

// Common variables
Tolerance = 0 + 0.25;
Max_Measurement = Outer_Spool_Diameter + 1;
Outer_Spool_Radius = Outer_Spool_Diameter / 2;
Inner_Spool_Radius = Inner_Spool_Diameter / 2;

// Core section variables
Core_Edge_Width = 0 + 22.25;
Core_Chamfer_Width = 0 + 4;
Core_Center_Width = Inner_Spool_Width - (Core_Chamfer_Width * 2 + Core_Edge_Width * 2 + Tolerance * 2);
Core_Total_Width = 2 * (Core_Edge_Width + Core_Chamfer_Width + Core_Center_Width/2);
Core_Inset_Radius = Outer_Spool_Radius - Core_Chamfer_Width;
Handle_Width = 0 + 20;

// Track variables
Guide_Track_Radius = Inner_Spool_Radius + Tolerance + 2.5;

Core_Edge_Offset = (Core_Center_Width/2) + Core_Chamfer_Width + (Core_Edge_Width/2);
Core_Chamfer_Offset = (Core_Center_Width/2) + (Core_Chamfer_Width/2);



////// Lid //////
if (showLid) translate([0,0,10]) lid();
if (showMainBin) mainBin();


module lid(){
  difference() {
    union() {
      intersection() {
        union() {
          translate([Inner_Spool_Radius - 10,-Core_Total_Width/2 + 3 + Tolerance / 2,-1]) {
            rotate(-45, [1,0,0]) {
              cube([Max_Measurement, sin(45) * 2, cos(45) * 2]);
            }
          }
          translate([Inner_Spool_Radius - 10,Core_Total_Width/2 - 5 - Tolerance / 2,-1]) {
            rotate(-45, [1,0,0]) {
              cube([Max_Measurement, sin(45) * 2, cos(45) * 2]);
            }
          }
            translate([Inner_Spool_Radius -10,-Core_Total_Width/2 + 4 + Tolerance / 2,-2]) {
              cube([Max_Measurement, Core_Total_Width-8 - Tolerance, 1.75]);
            }
          }
          rotate(90, [1,0,0]) {
            difference() {
              cylinder(Core_Total_Width, Outer_Spool_Radius, Outer_Spool_Radius, true);
              cylinder(Core_Total_Width + 1, Inner_Spool_Radius + 2.5, Inner_Spool_Radius + 2.5, true);
            }
          }
        }
        translate([Inner_Spool_Radius + 2,0, .625 - 1.75]) {
          cube([4, 10 - Tolerance/2, 1.75], true);
        }
      }
      translate([0,-Max_Measurement/2,-.25]) {
        cube([Max_Measurement, Max_Measurement, 10]);
      }
    }
  
}

module mainBin() {
////// MAIN BIN //////
// Union handle with bin.
union() {
  // Form exterior bin shape.
  difference() {
    // Form main bin shape.
    union() {
      // Form right edge section.
      translate([0,Core_Edge_Offset,0]) {
        rotate(90, [1,0,0]) {
          cylinder(Core_Edge_Width, Outer_Spool_Radius, Outer_Spool_Radius, true);
        }
      }
      // Form right chamfer section
      translate([0,Core_Chamfer_Offset,0]) {
        rotate(90, [1,0,0]) {
          cylinder(Core_Chamfer_Width, Outer_Spool_Radius, Core_Inset_Radius, true);
        }
      }
      // Form center section.
      if (Core_Center_Width > 0) {
        rotate(90, [1,0,0]) {
          cylinder(Core_Center_Width, Core_Inset_Radius, Core_Inset_Radius, true);
        }
      }
      // Form left chamfer section.
      translate([0,-Core_Chamfer_Offset,0]) {
        rotate(90, [1,0,0]) {
          cylinder(Core_Chamfer_Width, Core_Inset_Radius, Outer_Spool_Radius, true);
        }
      }
      // Form left edge section.
      translate([0,-Core_Edge_Offset,0]) {
        rotate(90, [1,0,0]) {
          cylinder(Core_Edge_Width, Outer_Spool_Radius, Outer_Spool_Radius, true);
        }
      }
    }
    // Slice off top of Bin.
    translate([-Outer_Spool_Radius,-Outer_Spool_Radius,-Tolerance]) {
      cube([Max_Measurement, Max_Measurement, Max_Measurement]);
    }
    // Slice off bottom of Bin.
    translate([0,-Outer_Spool_Radius,0]) {
      rotate(120, [0,1,0]) {
        translate([0,0,Tolerance]) {
          cube([Max_Measurement, Max_Measurement, Max_Measurement]);
        }
      }
    }
    // Slice off back of Bin.
    translate([0,0,0]) {
      rotate(90, [1,0,0]) {
        cylinder(Max_Measurement, Inner_Spool_Radius + Tolerance, Inner_Spool_Radius, true);
      }
    }
    // Remove remaining scrap from Bin.
    translate([-Max_Measurement,-Outer_Spool_Radius,-Outer_Spool_Radius]) {
      cube([Max_Measurement, Max_Measurement, Max_Measurement]);
    }
    // Carve out right track.
    translate([0,Core_Total_Width/2 - 2,-2.5]) {
      rotate(90, [0,1,0]) {
        linear_extrude(Max_Measurement) {
          polygon([[2,0],[0,2],[14,2],[12,0]]);
        }
      }
    }
    translate([0,Core_Total_Width/2 + 2,0]) {
      rotate(90, [1,0,0]) {
        cylinder(4, Guide_Track_Radius + 4, Guide_Track_Radius, false);
      }
    }
    // Carve out left track.
    translate([0,-Core_Total_Width/2 + 2,-2.5]) {
      rotate(90, [0,1,0]) {
        linear_extrude(Max_Measurement) {
          polygon([[2,0],[0,-2],[14,-2],[12,0]]);
        }
      }
    }
    translate([0,-Core_Total_Width/2 + 2,0]) {
      rotate(90, [1,0,0]) {
        cylinder(4, Guide_Track_Radius, Guide_Track_Radius + 4, false);
      }
    }
    // Form Left Lock Track
    intersection() {
      difference() {
        translate([0,-Core_Total_Width/2 + 20.25]) {
          rotate(90, [1,0,0]) {
            cylinder(20.25, Core_Inset_Radius + 2, Core_Inset_Radius + 2, false);
          }
        }
        translate([0,-Core_Total_Width/2 + 21.25]) {
          rotate(90, [1,0,0]) {
            cylinder(22.25, Core_Inset_Radius, Core_Inset_Radius, false);
          }
        }
       
      }
      translate([0,-Max_Measurement/2,-12.75]) {
        cube([Max_Measurement, Max_Measurement, 6.5]);
      }
    }
    translate([Core_Inset_Radius,-Core_Total_Width/2 + 8.25,-12.75]) {
      cube([Max_Measurement, 10, 6.5]);
    }
 
    // Form Right Lock Track
    intersection() {
      difference() {
        translate([0,Core_Total_Width/2]) {
          rotate(90, [1,0,0]) {
            cylinder(20.25, Core_Inset_Radius + 2, Core_Inset_Radius + 2, false);
          }
        }
        translate([0,Core_Total_Width/2 + 1]) {
          rotate(90, [1,0,0]) {
            cylinder(22.25, Core_Inset_Radius, Core_Inset_Radius, false);
          }
        }
      }
      translate([0,-Max_Measurement/2,-12.75]) {
        cube([Max_Measurement, Max_Measurement, 6.5]);
      }
    }
    translate([Core_Inset_Radius,Core_Total_Width/2 - 18.25,-12.75]) {
      cube([Max_Measurement, 10, 6.5]);
    }

    // Carve out showLid slot
    if (makeLid) {
      difference() {
        union() {
          translate([Inner_Spool_Radius+2,-Core_Total_Width/2 + 3,-1]) 
            rotate([-45,0,0]) 
              cube([Max_Measurement, sin(45) * 2, cos(45) * 2]);
            
          
          translate([Inner_Spool_Radius+2,Core_Total_Width/2 - 5,-1]) 
            rotate([-45,0,0]) 
              cube([Max_Measurement, sin(45) * 2, cos(45) * 2]);
            
          
          translate([Inner_Spool_Radius+2,-Core_Total_Width/2 + 4,-2]) {
            cube([Max_Measurement, Core_Total_Width-8, 3]);
          }
        }
        rotate(90, [1,0,0]) {
          cylinder(Max_Measurement, Inner_Spool_Radius + 2.5, Inner_Spool_Radius + 2, true);
        }
      }
      translate([0,0,Tolerance/2]) {
        cube([Max_Measurement, 10, 4], true);
      }
    } //makeLid


    // Remove bin interior.
    difference() {
      union() {
        rotate(90, [1,0,0]) {
          cylinder(Core_Total_Width - 8, Outer_Spool_Radius - 6, Outer_Spool_Radius - 6, true);
        }
        difference() {
          union() {
            if (Core_Center_Width > 0) {
              translate([0,-Core_Center_Width/2,0]) {
                rotate(90, [1,0,0]) {
                  cylinder(Core_Chamfer_Width, Core_Inset_Radius - 4, Core_Inset_Radius);
                }
              }
              translate([0,Core_Center_Width/2 + 4,0]) {
                rotate(90, [1,0,0]) {
                  cylinder(Core_Chamfer_Width, Core_Inset_Radius, Core_Inset_Radius - 4);
                }
              }
              translate([0,Core_Total_Width/2 - 4,0]) {
                rotate(90, [1,0,0]) {
                  cylinder(Core_Edge_Width - 4, Core_Inset_Radius, Core_Inset_Radius);
                }
              }
              translate([0,-Core_Center_Width/2 - 4,0]) {
                rotate(90, [1,0,0]) {
                  cylinder(Core_Edge_Width - 4, Core_Inset_Radius, Core_Inset_Radius);
                }
              }
            }
          }
          translate([0,-Max_Measurement/2,0]) {
            rotate(15, [0,1,0]) {
              cube([Max_Measurement, Max_Measurement, Max_Measurement]);
            }
          }

        }
      }
      translate([0,0,0]) {
        rotate(90, [1,0,0]) {
          cylinder(Core_Total_Width, Inner_Spool_Radius + Tolerance + 2, Inner_Spool_Radius + Tolerance + 2, true);
        }
      }
      //
      translate([0,-Outer_Spool_Radius,1.5]) {
        rotate(120, [0,1,0]) {
          cube([Max_Measurement, Max_Measurement, Max_Measurement]);
        }
      }
    }
  }

  if (Bin_Handle == "Flat") {
    if (Core_Center_Width > 0) {
      difference() {
        // Form handle
        translate([0,0,0]) {
          rotate(90, [1,0,0]) {
            cylinder(Core_Center_Width + Core_Chamfer_Width * 2, Outer_Spool_Radius, Outer_Spool_Radius, true);
          }
        }
        // Form inside of handle
        translate([0,0,0]) {
          rotate(90, [1,0,0]) {
            cylinder(Core_Center_Width + Core_Chamfer_Width * 2 + 2, Outer_Spool_Radius - 2, Outer_Spool_Radius - 2, true);
          }
        }
        // Form bottom of handle
        translate([0,-Outer_Spool_Radius,0]) {
          rotate(120, [0,1,0]) {
            cube([Max_Measurement, Max_Measurement, Max_Measurement]);
          }
        }
        // Form top of handle
        translate([0,-Outer_Spool_Radius,0]) {
          rotate(20, [0,1,0]) {
            cube([Max_Measurement, Max_Measurement, Max_Measurement]);
          }
        }
        // Remove scrap from handle.
        translate([-Max_Measurement + Outer_Spool_Radius - 16,-Outer_Spool_Radius,-Outer_Spool_Radius]) {
          cube([Max_Measurement, Max_Measurement, Max_Measurement]);
        }
      }
    } else {
    }
  }

  else if (Bin_Handle == "Curved") {
    if (Core_Center_Width > 0) {
      difference() {
        union() {
          // Form handle
          rotate(90, [1,0,0]) {
            cylinder(Core_Center_Width, Outer_Spool_Radius + 4, Outer_Spool_Radius + 4, true);
          }
          translate([0,Core_Center_Width/2 + Core_Chamfer_Width / 2 ,0]) {
            rotate(90, [1,0,0]) {
              cylinder(Core_Chamfer_Width, Outer_Spool_Radius, Outer_Spool_Radius + 4, true);
            }
          }
          translate([0,-Core_Center_Width/2 - Core_Chamfer_Width / 2 ,0]) {
            rotate(90, [1,0,0]) {
              cylinder(Core_Chamfer_Width, Outer_Spool_Radius + 4, Outer_Spool_Radius, true);
            }
          }
        }
        // Form inside of handle
        rotate(90, [1,0,0]) {
          cylinder(Core_Center_Width, Outer_Spool_Radius, Outer_Spool_Radius, true);
        }
        translate([0,-Core_Center_Width/2 - Core_Chamfer_Width / 2,0]) {
          rotate(90, [1,0,0]) {
            cylinder(Core_Chamfer_Width, Outer_Spool_Radius, Core_Inset_Radius, true);
          }
        }
        translate([0,Core_Center_Width/2 + Core_Chamfer_Width / 2 ,0]) {
          rotate(90, [1,0,0]) {
            cylinder(Core_Chamfer_Width, Core_Inset_Radius, Outer_Spool_Radius, true);
          }
        }
        // Form bottom of handle
        translate([0,-Outer_Spool_Radius,0]) {
          rotate(120, [0,1,0]) {
            cube([Max_Measurement, Max_Measurement, Max_Measurement]);
          }
        }
        // Form top of handle
        translate([0,-Outer_Spool_Radius,0]) {
          rotate(20, [0,1,0]) {
            cube([Max_Measurement, Max_Measurement, Max_Measurement]);
          }
        }
        // Remove scrap from handle.
        translate([-Max_Measurement + Outer_Spool_Radius - 16,-Outer_Spool_Radius,-Outer_Spool_Radius]) {
          cube([Max_Measurement, Max_Measurement, Max_Measurement*2]);
        }
        rotate(90, [1,0,0]) {
          cylinder(Core_Total_Width - 8, Outer_Spool_Radius - 6, Outer_Spool_Radius - 6, true);
        }
      }
    } else {
      difference() {
        union() {
          Handle_Width = Core_Edge_Width;
          // Form handle
          rotate(90, [1,0,0]) {
            cylinder(Handle_Width, Outer_Spool_Radius + 4, Outer_Spool_Radius + 4, true);
          }
          translate([0,Handle_Width/2 + Core_Chamfer_Width / 2 ,0]) {
            rotate(90, [1,0,0]) {
              cylinder(Core_Chamfer_Width, Outer_Spool_Radius, Outer_Spool_Radius + 4, true);
            }
          }
          translate([0,-Handle_Width/2 - Core_Chamfer_Width / 2 ,0]) {
            rotate(90, [1,0,0]) {
              cylinder(Core_Chamfer_Width, Outer_Spool_Radius + 4, Outer_Spool_Radius, true);
            }
          }
        }

        // Remove inside of handle
        rotate(90, [1,0,0]) {
          cylinder(Handle_Width - 2, Outer_Spool_Radius + 2, Outer_Spool_Radius + 2, true);
        }
        translate([0, Handle_Width/2, 0]) {
          rotate(90, [1,0,0]) {
            cylinder(Core_Chamfer_Width - 2, Outer_Spool_Radius, Outer_Spool_Radius + 2, true);
          }
        }
        translate([0, -Handle_Width/2, 0]) {
          rotate(90, [1,0,0]) {
            cylinder(Core_Chamfer_Width - 2, Outer_Spool_Radius + 2, Outer_Spool_Radius, true);
          }
        }


        // Form bottom of handle
        translate([0,-Outer_Spool_Radius,0]) {
          rotate(120, [0,1,0]) {
            cube([Max_Measurement, Max_Measurement, Max_Measurement]);
          }
        }
        // Form top of handle
        translate([0,-Outer_Spool_Radius,0]) {
          rotate(20, [0,1,0]) {
            cube([Max_Measurement, Max_Measurement, Max_Measurement]);
          }
        }
        // Remove scrap from handle.
        translate([-Max_Measurement + Outer_Spool_Radius - 16,-Outer_Spool_Radius,-Outer_Spool_Radius]) {
          cube([Max_Measurement, Max_Measurement, Max_Measurement*2]);
        }
        rotate(90, [1,0,0]) {
          cylinder(Core_Total_Width - 8, Outer_Spool_Radius - 6, Outer_Spool_Radius - 6, true);
        }
      }
    }
  }
}
}


////// LOCKS //////

module locks() {
  color("red") translate([20,0,0]) {
    difference() {
      union() {
        // Left and right handle base.
        rotate(90, [1,0,0]) {
            cylinder(Core_Total_Width, Outer_Spool_Radius - 2 - Lock_Tolerance, Outer_Spool_Radius - 2 - Lock_Tolerance, true);
        }

        // Left bump ramp.
        translate([0,-Core_Center_Width/2 - 18.75,0]) {
          rotate(90, [1,0,0]) {
              cylinder(3, Outer_Spool_Radius - 2 + Lock_Tolerance * 2, Outer_Spool_Radius - 2 - Lock_Tolerance, true);
          }
        }
        translate([0,-Core_Center_Width/2 - 14,0]) {
          rotate(90, [1,0,0]) {
              cylinder(2, Outer_Spool_Radius - 2 - Lock_Tolerance, Outer_Spool_Radius - 2 + Lock_Tolerance * 2, true);
          }
        }

        // Right bump ramp.
        translate([0,Core_Center_Width/2 + 18.75,0]) {
          rotate(90, [1,0,0]) {
              cylinder(3, Outer_Spool_Radius - 2 - Lock_Tolerance, Outer_Spool_Radius - 2 + Lock_Tolerance * 2, true);
          }
        }
        translate([0,Core_Center_Width/2 + 14,0]) {
          rotate(90, [1,0,0]) {
              cylinder(2, Outer_Spool_Radius - 2 + Lock_Tolerance * 2, Outer_Spool_Radius - 2 - Lock_Tolerance, true);
          }
        }

        // Left lock handle.
        translate([Core_Inset_Radius + Tolerance,-Core_Center_Width/2 - 15 -2.75,-14.5]) {
          cube([7,2.75,8], false);
        }
        // Right lock handle.
        translate([Core_Inset_Radius + Tolerance,Core_Center_Width/2 + 15,-14.5]) {
          cube([7,2.75,8], false);
        }
      }

      // Slice off inner edge of handle bases.
      rotate(90, [1,0,0]) {
        cylinder(Core_Total_Width, Core_Inset_Radius + Lock_Tolerance, Core_Inset_Radius + Lock_Tolerance, true);
      }
      // Split handle bases.
      cube([Max_Measurement, Core_Center_Width + 26, Max_Measurement], true);
      // Slice off top of locks.
      translate([0,0,Max_Measurement/2 - 6.5]) {
        cube([Max_Measurement*2, Max_Measurement, Max_Measurement], true);
      }
      // Slice off bottom of locks.
      translate([0,0,-Outer_Spool_Radius-13]) {
        cube([Max_Measurement*2, Max_Measurement, Max_Measurement], true);
      }
      // Slice off rest of locks.
      translate([0,0,-Max_Measurement/2 - 130.5]) {
        cube([Max_Measurement*2, Max_Measurement, Max_Measurement], true);
      }
      translate([-8,0,0]) {
        cube([Max_Measurement, Max_Measurement, Max_Measurement], true);
      }
      // Add notch to indicate top
      translate([Core_Inset_Radius + 2,0,-4]) {
        rotate(45, [0,1,0]) {
          cube([2,Core_Total_Width,8], true);
        }
      }
    }
  }
}


////// GUIDES //////
module guides(){
translate([0,Inner_Spool_Width + 20,0]){
  difference() {
    intersection() {
      union() {
        for(i=[0:1:11]) {
          rotate(30 * i, [0,1,0]) {
            difference() {
              union() {
                translate([0,Core_Total_Width/2 - 2,-2.5]) {
                  rotate(90, [0,1,0]) {
                    linear_extrude(Max_Measurement) {
                      polygon([[2,0],[0,2],[14,2],[12,0]]);
                    }
                  }
                }
                translate([0,-Core_Total_Width/2 + 2,-2.5]) {
                  rotate(90, [0,1,0]) {
                    linear_extrude(Max_Measurement) {
                      polygon([[2,0],[0,-2],[14,-2],[12,0]]);
                    }
                  }
                }
              }
              intersection() {
                difference() {
                  rotate(90, [1,0,0]) {
                    cylinder(Max_Measurement, Core_Inset_Radius + 2, Core_Inset_Radius + 2, true);
                  }
                  rotate(90, [1,0,0]) {
                    cylinder(Max_Measurement, Core_Inset_Radius, Core_Inset_Radius, true);
                  }
                }
                translate([0,-Max_Measurement/2,-12.75]) {
                  cube([Max_Measurement, Max_Measurement, 6.5]);
                }
                translate([0,-Max_Measurement/2,-12.75]) {
                  cube([Max_Measurement, Max_Measurement, 6.5]);
                }
              }
            }
          }
        }
        // Left
        translate([0,Core_Total_Width/2 - 1,0]) {
          rotate(90, [1,0,0]) {
            cylinder(2, Inner_Spool_Radius + 2 + Tolerance * 2, Inner_Spool_Radius + 2 + Tolerance * 2, true);
          }
        }
        translate([0,Core_Total_Width/2 - 1,0]) {
          rotate(90, [1,0,0]) {
            cylinder(2, Inner_Spool_Radius + 4 + Tolerance * 2, Inner_Spool_Radius + 2 + Tolerance * 2, true);
          }
        }
        // Right
        translate([0,-Core_Total_Width/2 + 1,0]) {
          rotate(90, [1,0,0]) {
            cylinder(2, Inner_Spool_Radius + 2 + Tolerance * 2, Inner_Spool_Radius + 2 + Tolerance * 2, true);
          }
          rotate(90, [1,0,0]) {
            cylinder(2, Inner_Spool_Radius + 2 + Tolerance * 2, Inner_Spool_Radius + 4 + Tolerance * 2, true);
          }
        }

      }
      rotate(90, [1,0,0]) {
        cylinder(Max_Measurement, Outer_Spool_Radius, Outer_Spool_Radius, true);
      }
    }
    // Trim central core.
    rotate(90, [1,0,0]) {
      cylinder(Max_Measurement, Inner_Spool_Radius + Tolerance / 2, Inner_Spool_Radius + Tolerance / 2, true);
    }
    // Split guide.
    if (Split_Guides) {
      translate([2.5,0,Max_Measurement/2]) {
        cube([Tolerance,Max_Measurement,Max_Measurement], true);
      }
    }
  }
}
}
