

/*
Code by Patrick Gaston, 3/2018, who admits he is utter crap at coding. Do not expect elegance, stability, or efficiency in the code that follows. But it generally works.
All thread modules are excerpted from "threads.scad" by Dan Kirshner, used by permission under GNU General Public License. The original file is available at http://dkprojects.net/openscad-threads/
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation.
Last updated: 2018.04.08 - Added ability to render a single blade. Fixed rounding error preventing 7-blade models.
*/


/* [Global] */
//Radius of entire mechanism, in mm.
radius_outer_shell = 42.4; //[15:0.5:100]
//Size of aperture relative to shell. Extreme values may result in impossible mechanisms.
ratio_aperture = 0.65; //[0.3:0.05:0.8]
//Keep blades thin to fit together and move easily. Should be even multiple of print layer height.
thickness_blade = 0.6; //[0.1:0.05:0.4]
//Number of iris blades. A good estimate is 10 times the aperture ratio.
count_blades = 9; //[2:1:8]
//Size of edge curves. Set to zero for no curve.
radius_fillet = 2; //[0:0.2:2]
//Select the part to view or generate.
part = "assembled"; // [assembled:Assembled (unprintable, view only), shell:Shell Only,blades:Blades Only,lid:Lid Only,lever:Lever Only, single_blade: Single Blade, all_parts:All Parts]
//Space between shell and lid to allow rotation
slop_shell_to_lid = 0.5;
//Space between shell and planet gears to free movement.
slop_shell_planet = 0.25; 
//Space between planets (blades) and pegs on lever disk to allow rotation.
slop_planet_to_peg = 0.6;

/* [Hidden] */
epsilon = 0.1; //Fudge, to make preview holes work.
resolution_shell_outer = 50;//Smoothness of the outer surface of the shell
resolution_shell_inner = 64; //Smoothness of the inner surface of the shell
resolution_fillet = 16; //Smoothness of edge curves
resolution_gear = 12; //Smoothness of each gear tooth
resolution_planet = 24; //Smoothness of gear wheel outer surface
resolution_blade = 48; //Smoothness of curve of blade
radius_gear = 1.0;
radius_negative_gear = radius_gear + 0.3;
pitch_screw = 2.5;
thread_size_screw = 2;
thickness_shell_side = 2;
radius_inner_shell = radius_outer_shell - thickness_shell_side;
radius_aperture = ratio_aperture * radius_inner_shell;
thickness_shell_bottom = 2;
height_shell_gear_bottom = thickness_shell_bottom + 4*thickness_blade; //Space for blades to overlap
height_shell_gear_top = height_shell_gear_bottom + 5;
height_shell = height_shell_gear_top + 6;
arclength_shell = 2* (radius_gear + radius_negative_gear);
degrees_to_next_gear_shell = 360 * (arclength_shell/(2 * PI * radius_inner_shell));   
degrees_to_negative_gear_shell = 360 * ((radius_gear + radius_negative_gear)/(2 * PI * radius_inner_shell));
angle_blade = 0;
radius_outer_planet = (radius_inner_shell - radius_gear - radius_aperture)/2;
radius_inner_planet = radius_outer_planet - radius_gear - 1.4;
arclength_planet = 2* (radius_gear + radius_negative_gear);
degrees_to_next_gear = 360 * (arclength_planet/(2 * PI * radius_outer_planet));   
degrees_to_negative_gear = 360 * ((radius_gear + radius_negative_gear)/(2 * PI * radius_outer_planet));
count_blades_gear = round(180/(degrees_to_next_gear + degrees_to_negative_gear));  
height_planet = height_shell_gear_top - height_shell_gear_bottom;
angle_isoceles = atan((radius_aperture + radius_outer_planet)/(radius_aperture + 2*radius_outer_planet));
distance_head_to_tail = pow(pow(radius_aperture + 2*radius_outer_planet,2) + pow(radius_aperture + radius_outer_planet,2),0.5);
blade_R2 = (distance_head_to_tail/2)/cos(angle_isoceles);
blade_R3 = radius_aperture + 2*radius_outer_planet - blade_R2;
radius_planet_disk = radius_inner_shell - 1;
thickness_planet_disk = 2;
radius_planet_disk_peg = radius_inner_planet - slop_planet_to_peg;
radius_orbit_planet = radius_inner_shell - slop_shell_planet - radius_outer_planet - radius_gear;
height_lid = height_shell - height_shell_gear_top - thickness_planet_disk + radius_fillet;
width_handle = radius_outer_shell - radius_planet_disk + 2;

//==============================================================================================


module fillet_outer_quarter_circle(radius_circle, radius_extrusion, resolution_circle, resolution_fillet)
    {
     rotate([0,180,0])   
     rotate_extrude($fn = resolution_fillet, convexity = 10)
     translate([radius_extrusion - radius_circle,-radius_circle,0])   
     difference()  
        {
         square(radius_circle); 
         circle($fn = resolution_circle, r = radius_circle);
        }
    }

module fillet_inner_quarter_circle(radius_circle, radius_extrusion, resolution_circle, resolution_fillet)
    {
     translate([0,0,radius_circle])
     rotate_extrude($fn = resolution_fillet, convexity = 10)
     translate([radius_extrusion,-radius_circle,0])   
     difference()  
        {
         square(radius_circle); 
         translate([radius_circle,radius_circle,0]) circle($fn = resolution_circle, r = radius_circle);
        }
    }

module main_shell ()
    {
     color("SkyBlue")
     union()
        {
         difference()
            {
             //Main shell outer
             translate([0,0,-20]) cylinder($fn = resolution_shell_outer, h = height_shell+20, r = radius_inner_shell + thickness_shell_side); 
             //Main shell inner   
             translate([0,0,thickness_shell_bottom]) cylinder($fn = resolution_shell_inner, h = height_shell, r = radius_inner_shell); 
             //Outer bottom fillet removed for Plasma Gun
//             *fillet_outer_quarter_circle(radius_fillet, radius_inner_shell + thickness_shell_side, resolution_fillet, resolution_shell_outer);   
              translate([0,0,-20])
                translate([0,0,-epsilon]) 
                  cylinder($fn = resolution_shell_inner, r=radius_inner_shell+thickness_shell_side-2,h=20+epsilon);
              
              
             //Inner bottom fillet
             fillet_inner_quarter_circle(radius_fillet, radius_aperture - epsilon, resolution_fillet,resolution_shell_outer);   
             //Aperture opening
             translate([0,0,-epsilon])
             cylinder($fn = resolution_shell_outer, h = thickness_shell_bottom + 2*epsilon, r = radius_aperture);
             //Inner top fillet
             translate([0,0,height_shell + epsilon]) rotate([180,0,0]) fillet_inner_quarter_circle(thickness_shell_side, radius_inner_shell - epsilon, resolution_fillet, resolution_shell_inner);
             //Handle opening
             scale(v = [1, 2, 1])
             translate([0,0,height_shell_gear_bottom + height_planet])
             rotate([0,0,-135])
             cube(size = [radius_outer_shell,radius_outer_shell,height_shell]);
             //Threads
             translate([0,0,height_shell_gear_top + thickness_planet_disk])
             metric_thread (diameter = 2*(radius_inner_shell) + 2, pitch = pitch_screw, length=height_lid, thread_size = thread_size_screw, internal = true);   
            };
        
        //Gear ring
        difference()
            {
             union()
                {
                 difference()
                    {
                     //Gear ring outer
                     translate([0,0,height_shell_gear_bottom])
                     cylinder($fn = resolution_shell_outer, h = height_shell_gear_top - height_shell_gear_bottom, r = radius_inner_shell + thickness_shell_side);
                        
                     //Gear ring inner
                     translate([0,0,height_shell_gear_bottom - epsilon])
                     cylinder($fn = resolution_shell_inner, h = height_shell_gear_top - height_shell_gear_bottom + 2*epsilon, r = radius_inner_shell - radius_negative_gear); 
                        
                     //Shell negative gears
                    for(k = [1 : 1 : count_blades])
                        {
                         rotate([0,0,(-count_blades_gear * degrees_to_next_gear_shell/2) + (k-1) * 360/count_blades])
                         for(i = [1 : 1 : count_blades_gear])
                            {
                             rotate([0,0,i*degrees_to_next_gear_shell -90 -degrees_to_negative_gear_shell]) 
                             translate([radius_inner_shell - radius_negative_gear,0,height_shell_gear_bottom]) 
                             cylinder($fn = resolution_gear, h = height_shell_gear_top - height_shell_gear_bottom, r = radius_negative_gear);
                            }
                        }
                    }
                    //Shell positive gears
                    for(k = [1 : 1 : count_blades])
                        {
                         rotate([0,0,(-count_blades_gear * degrees_to_next_gear_shell/2) + (k-1) * 360/count_blades])
                         for(i = [1 : 1 : count_blades_gear])
                            {
                             rotate([0,0,i*degrees_to_next_gear_shell -90]) 
                             translate([radius_inner_shell - radius_negative_gear,0,height_shell_gear_bottom]) 
                             cylinder($fn = resolution_gear, h = height_shell_gear_top - height_shell_gear_bottom, r = radius_gear);    
                            }
                        }
                   };
                   
               //Cone, to taper off bottom of shell gears    
                translate([0,0,height_shell_gear_bottom - epsilon])
                cylinder($fn = resolution_planet, h = radius_inner_shell, r1 = radius_inner_shell, r2 = 0);     
               }
          }
    }  

module make_planet()
    {
     color("Gray") 
      difference()
        {
         union(){   
          difference(){
            union(){
             make_blade();
             cylinder($fn = resolution_planet, h = height_planet, r = radius_outer_planet);
            };
            translate([0,0,thickness_blade])
              cylinder($fn = resolution_planet, 
                         h = height_planet + epsilon, 
                         r = radius_inner_planet);   
            }//diff
            
             for(i = [1 : 1 : count_blades_gear])
                {
                 rotate([0,0,i*degrees_to_next_gear-45]) 
                    translate([radius_outer_planet,0,0]) 
                      cylinder($fn = resolution_gear, h = height_planet, r = radius_gear);
                };
            };
            {    
            //cut gear
            for(i = [1 : 1 : count_blades_gear]){
              rotate([0,0,i*degrees_to_next_gear -45 -degrees_to_negative_gear]) 
                translate([radius_outer_planet,0,thickness_blade]) 
                  cylinder($fn = resolution_gear, 
                             h = height_planet - thickness_blade + epsilon, 
                             r = radius_negative_gear);
                }
            }
        };
    }
module make_blade()
    {
     //blade
     translate([-radius_orbit_planet,0,0]) rotate([0,0,-90])
      linear_extrude(height = thickness_blade, center = false, convexity = 10)
        {
        //Planet, also head of iris blade
        rotate([0,0,90])
        translate([radius_aperture + radius_outer_planet,0,0])
        circle($fn = resolution_blade, r = radius_outer_planet);

        //Tail of iris blade
        translate([radius_aperture + radius_outer_planet/2,0,0])
        circle($fn = resolution_blade, r = radius_outer_planet/2);

        difference()
            {
            //Arc circle
            translate([0,blade_R3,0])
            circle($fn = resolution_blade, r = blade_R2);

            //Aperture
            circle($fn = resolution_blade, r = radius_aperture);

            //Blocks of negative space
            translate([0,-2*blade_R2,0]) square(2*blade_R2);
            translate([-2*blade_R2,-2*blade_R2,0]) square(size = [2*blade_R2,4*blade_R2]);
            }
        }
    }

  

module place_planets(angle_blade)
    {
     for (i = [0 : (360/count_blades) : 360])
        {
         rotate([0,0,i]) translate([radius_orbit_planet,0,height_shell_gear_bottom])  
            {
             rotate([0,0,-angle_blade])
                {
                 make_planet();
                }
            }
        }
    }

module make_planet_disk()
    {
     color("SpringGreen")   
     union()
        {
         //Disk
         difference() 
            {
             //disk outer
             translate([0,0,height_shell_gear_bottom + height_planet])   
             cylinder($fn = resolution_shell_outer, h = thickness_planet_disk, r = radius_orbit_planet + radius_planet_disk_peg);
             //disk inner
             translate([0,0,height_shell_gear_bottom + height_planet - epsilon])   
             cylinder($fn = resolution_shell_outer, h = thickness_planet_disk + 2*epsilon, r = radius_orbit_planet - radius_planet_disk_peg);   
            }
         //Planet mounts
         for (i = [0 : floor(360/count_blades) : 360])
            {
             rotate([0,0,i]) 
             translate([radius_orbit_planet,0,height_shell_gear_bottom])
             difference()
                {
                 cylinder($fn = resolution_planet, h = height_planet, r = radius_planet_disk_peg);
                 translate([0,0,-epsilon]) 
                 fillet_outer_quarter_circle(height_planet/2, radius_planet_disk_peg + epsilon, resolution_fillet, resolution_shell_outer);
                }
            }
         //Handle
            {
             translate([radius_orbit_planet - radius_planet_disk_peg,-width_handle/2,height_shell_gear_bottom + height_planet])
             cube(size = [radius_planet_disk - radius_orbit_planet + radius_planet_disk_peg + 1.25*width_handle,width_handle,thickness_planet_disk], center = false);
             difference()
                {
                 //Handle peg
                 translate([radius_planet_disk + 1.25*width_handle,0,height_shell_gear_bottom])   
                 cylinder($fn = resolution_fillet, h = height_planet + thickness_planet_disk, r = width_handle/2);
                 //Handle peg fillet
                 translate([radius_planet_disk + 1.25*width_handle,0,height_shell_gear_bottom-epsilon])   
                 fillet_outer_quarter_circle(width_handle/2/2, width_handle/2 + epsilon, resolution_fillet, resolution_shell_outer);
                }
            }
        }
    }

module make_lid()
    {
     color("Salmon")
     difference()
        {
         union()
            {
             //main cylinder
             translate([0,0,height_shell_gear_top + thickness_planet_disk])
             cylinder($fn = resolution_shell_outer, h = height_lid, r = radius_inner_shell - slop_shell_to_lid);
             //lid top cylinder
             translate([0,0,height_shell + radius_fillet])
             rotate([180,0,0])
             difference()
                {
                 cylinder($fn = resolution_shell_outer, h = radius_fillet, r = radius_outer_shell);
                 //minus outer fillet
                 fillet_outer_quarter_circle(radius_fillet, radius_outer_shell + epsilon, resolution_fillet, resolution_shell_outer);
                };   
             //plus inner fillet
             translate([0,0,height_shell])
             rotate([180,0,0])   
             fillet_inner_quarter_circle(thickness_shell_side, radius_inner_shell - slop_shell_to_lid, resolution_fillet, resolution_shell_inner);
             //plus threads
             translate([0,0,height_shell_gear_top + thickness_planet_disk])
             metric_thread (diameter = 2*(radius_inner_shell - slop_shell_to_lid) + 2, pitch = pitch_screw, length=height_lid, thread_size = thread_size_screw);   
            };
         //minus aperture
         translate([0,0,height_shell_gear_top + thickness_planet_disk - epsilon])
         cylinder($fn = resolution_shell_outer, h = height_shell - height_shell_gear_top - thickness_planet_disk + radius_fillet + (2*epsilon), r = radius_aperture);   
         //minus aperture fillet
         translate([0,0,height_shell + radius_fillet + epsilon])
         rotate([180,0,0])   
         fillet_inner_quarter_circle(radius_fillet + (2*epsilon), radius_aperture - epsilon, resolution_fillet, resolution_shell_outer);   
        };
    }
    

module metric_thread (diameter=8, pitch=1, length=1, internal=false, n_starts=1,
                      thread_size=-1, groove=false, square=false, rectangle=0,
                      angle=30, taper=0, leadin=0, leadfac=1.0)
{
   // thread_size: size of thread "V" different than travel per turn (pitch).
   // Default: same as pitch.
   local_thread_size = thread_size == -1 ? pitch : thread_size;
   local_rectangle = rectangle ? rectangle : 1;

   n_segments = segments (diameter);
   h = (square || rectangle) ? local_thread_size*local_rectangle/2 : local_thread_size / (2 * tan(angle));

   h_fac1 = (square || rectangle) ? 0.90 : 0.625;

   // External thread includes additional relief.
   h_fac2 = (square || rectangle) ? 0.95 : 5.3/8;

   tapered_diameter = diameter - length*taper;

   difference () {
      union () {
         if (! groove) {
            metric_thread_turns (diameter, pitch, length, internal, n_starts,
                                 local_thread_size, groove, square, rectangle, angle,
                                 taper);
         }

         difference () {

            // Solid center, including Dmin truncation.
            if (groove) {
               cylinder (r1=diameter/2, r2=tapered_diameter/2,
                         h=length, $fn=n_segments);
            } else if (internal) {
               cylinder (r1=diameter/2 - h*h_fac1, r2=tapered_diameter/2 - h*h_fac1,
                         h=length, $fn=n_segments);
            } else {

               // External thread.
               cylinder (r1=diameter/2 - h*h_fac2, r2=tapered_diameter/2 - h*h_fac2,
                         h=length, $fn=n_segments);
            }

            if (groove) {
               metric_thread_turns (diameter, pitch, length, internal, n_starts,
                                    local_thread_size, groove, square, rectangle,
                                    angle, taper);
            }
         }
      }

      // fillet z=0 end if leadin is 2 or 3
      if (leadin == 2 || leadin == 3) {
         difference () {
            cylinder (r=diameter/2 + 1, h=h*h_fac1*leadfac, $fn=n_segments);

            cylinder (r2=diameter/2, r1=diameter/2 - h*h_fac1*leadfac, h=h*h_fac1*leadfac,
                      $fn=n_segments);
         }
      }

      // fillet z-max end if leadin is 1 or 2.
      if (leadin == 1 || leadin == 2) {
         translate ([0, 0, length + 0.05 - h*h_fac1*leadfac]) {
            difference () {
               cylinder (r=diameter/2 + 1, h=h*h_fac1*leadfac, $fn=n_segments);
               cylinder (r1=tapered_diameter/2, r2=tapered_diameter/2 - h*h_fac1*leadfac, h=h*h_fac1*leadfac,
                         $fn=n_segments);
            }
         }
      }
   }
}



module metric_thread_turns (diameter, pitch, length, internal, n_starts,
                            thread_size, groove, square, rectangle, angle,
                            taper)
{
   // Number of turns needed.
   n_turns = floor (length/pitch);

   intersection () {

      // Start one below z = 0.  Gives an extra turn at each end.
      for (i=[-1*n_starts : n_turns+1]) {
         translate ([0, 0, i*pitch]) {
            metric_thread_turn (diameter, pitch, internal, n_starts,
                                thread_size, groove, square, rectangle, angle,
                                taper, i*pitch);
         }
      }

      // Cut to length.
      translate ([0, 0, length/2]) {
         cube ([diameter*3, diameter*3, length], center=true);
      }
   }
}


module metric_thread_turn (diameter, pitch, internal, n_starts, thread_size,
                           groove, square, rectangle, angle, taper, z)
{
   n_segments = segments (diameter);
   fraction_circle = 1.0/n_segments;
   for (i=[0 : n_segments-1]) {
      rotate ([0, 0, i*360*fraction_circle]) {
         translate ([0, 0, i*n_starts*pitch*fraction_circle]) {
            //current_diameter = diameter - taper*(z + i*n_starts*pitch*fraction_circle);
            thread_polyhedron ((diameter - taper*(z + i*n_starts*pitch*fraction_circle))/2,
                               pitch, internal, n_starts, thread_size, groove,
                               square, rectangle, angle);
         }
      }
   }
}


module thread_polyhedron (radius, pitch, internal, n_starts, thread_size,
                          groove, square, rectangle, angle)
{
   n_segments = segments (radius*2);
   fraction_circle = 1.0/n_segments;

   local_rectangle = rectangle ? rectangle : 1;

   h = (square || rectangle) ? thread_size*local_rectangle/2 : thread_size / (2 * tan(angle));
   outer_r = radius + (internal ? h/20 : 0); // Adds internal relief.
   //echo (str ("outer_r: ", outer_r));

   // A little extra on square thread -- make sure overlaps cylinder.
   h_fac1 = (square || rectangle) ? 1.1 : 0.875;
   inner_r = radius - h*h_fac1; // Does NOT do Dmin_truncation - do later with
                                // cylinder.

   translate_y = groove ? outer_r + inner_r : 0;
   reflect_x   = groove ? 1 : 0;

   // Make these just slightly bigger (keep in proportion) so polyhedra will
   // overlap.
   x_incr_outer = (! groove ? outer_r : inner_r) * fraction_circle * 2 * PI * 1.02;
   x_incr_inner = (! groove ? inner_r : outer_r) * fraction_circle * 2 * PI * 1.02;
   z_incr = n_starts * pitch * fraction_circle * 1.005;
   x1_outer = outer_r * fraction_circle * 2 * PI;
   z0_outer = (outer_r - inner_r) * tan(angle);
   z1_outer = z0_outer + z_incr;

   // Give internal square threads some clearance in the z direction, too.
   bottom = internal ? 0.235 : 0.25;
   top    = internal ? 0.765 : 0.75;

   translate ([0, translate_y, 0]) {
      mirror ([reflect_x, 0, 0]) {
         if (square || rectangle) {
            // Rule for face ordering: look at polyhedron from outside: points must
            // be in clockwise order.
            polyhedron (
               points = [
                         [-x_incr_inner/2, -inner_r, bottom*thread_size],         // [0]
                         [x_incr_inner/2, -inner_r, bottom*thread_size + z_incr], // [1]
                         [x_incr_inner/2, -inner_r, top*thread_size + z_incr],    // [2]
                         [-x_incr_inner/2, -inner_r, top*thread_size],            // [3]
                         [-x_incr_outer/2, -outer_r, bottom*thread_size],         // [4]
                         [x_incr_outer/2, -outer_r, bottom*thread_size + z_incr], // [5]
                         [x_incr_outer/2, -outer_r, top*thread_size + z_incr],    // [6]
                         [-x_incr_outer/2, -outer_r, top*thread_size]             // [7]
                        ],

               faces = [
                         [0, 3, 7, 4],  // This-side trapezoid
                         [1, 5, 6, 2],  // Back-side trapezoid
                         [0, 1, 2, 3],  // Inner rectangle
                         [4, 7, 6, 5],  // Outer rectangle
                         // These are not planar, so do with separate triangles.
                         [7, 2, 6],     // Upper rectangle, bottom
                         [7, 3, 2],     // Upper rectangle, top
                         [0, 5, 1],     // Lower rectangle, bottom
                         [0, 4, 5]      // Lower rectangle, top
                        ]
            );
         } else {

            // Rule for face ordering: look at polyhedron from outside: points must
            // be in clockwise order.
            polyhedron (
               points = [
                         [-x_incr_inner/2, -inner_r, 0],                        // [0]
                         [x_incr_inner/2, -inner_r, z_incr],                    // [1]
                         [x_incr_inner/2, -inner_r, thread_size + z_incr],      // [2]
                         [-x_incr_inner/2, -inner_r, thread_size],              // [3]
                         [-x_incr_outer/2, -outer_r, z0_outer],                 // [4]
                         [x_incr_outer/2, -outer_r, z0_outer + z_incr],         // [5]
                         [x_incr_outer/2, -outer_r, thread_size - z0_outer + z_incr], // [6]
                         [-x_incr_outer/2, -outer_r, thread_size - z0_outer]    // [7]
                        ],

               faces = [
                         [0, 3, 7, 4],  // This-side trapezoid
                         [1, 5, 6, 2],  // Back-side trapezoid
                         [0, 1, 2, 3],  // Inner rectangle
                         [4, 7, 6, 5],  // Outer rectangle
                         // These are not planar, so do with separate triangles.
                         [7, 2, 6],     // Upper rectangle, bottom
                         [7, 3, 2],     // Upper rectangle, top
                         [0, 5, 1],     // Lower rectangle, bottom
                         [0, 4, 5]      // Lower rectangle, top
                        ]
            );
         }
      }
   }
}

function segments (diameter) = min (50, ceil (diameter*6));

module print_part() 
    {
	 if (part == "assembled") 
        {
		 show_assembled();
        }
	 if (part == "shell") 
        {
		 show_shell();
        } 
     else if (part == "blades") 
        {
		 show_blades();
        } 
     else if (part == "lid") 
        {
		 show_lid();
        }
     else if (part == "single_blade") 
        {
		 make_planet();
        }
     else if (part == "lever") 
        {
		 show_lever();
        }
     else if (part == "all_parts") 
        {
		 show_all();
        }        
    }

module show_assembled() 
    {
     main_shell();
     place_planets(angle_blade = 20);
     make_planet_disk();
     *make_lid();	 
    }

module show_shell() 
    {
	 main_shell();
    }

module show_blades() 
    {
     translate([0,0,-height_shell_gear_bottom]) 
     place_planets(angle_blade = 310);
    }    

module show_single_blade()
    {
     make_single_planet();
    }

module show_lid() 
    {
     translate([0,0,height_shell_gear_top + thickness_planet_disk + height_lid]) 
     rotate([0,180,0])
     make_lid();
    }    

module show_lever() 
    {
     translate([0,0,height_shell_gear_bottom + height_planet + thickness_planet_disk]) 
     rotate([0,180,0])
     make_planet_disk();	 
    }

module show_all() 
    {
     main_shell();

     translate([radius_outer_shell * 2.75,0,-height_shell_gear_bottom]) 
     place_planets(angle_blade = 310);

     translate([0,radius_outer_shell * 2.25,height_shell_gear_bottom + height_planet + thickness_planet_disk]) 
     rotate([0,180,0])
     make_planet_disk();

     translate([-radius_outer_shell * 2.25,0,height_shell_gear_top + thickness_planet_disk + height_lid]) 
     rotate([0,180,0])
     make_lid();	 
    }

print_part();
  