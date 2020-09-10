//use <threads.scad>

//resolution
$fn=80;
//spacing to make the threats work
spcng=0.2;


/* [show] */

//deactivate to speed up rendering
showThreats=true; 
//what to show/export
export="all"; //["all","screw","nut"]

/* [Dimensions] */
//Diameter of your spoolholder
innerDia=30;
//Minimum thickness of walls
minWallThck=2;
//Maximum inner diameter of spool
maxSpoolDia=54;
//Minimum inner diameter of spool
minSpoolDia=50;
//Maximum width of spool
maxSpoolWidth=44;
//Minimum width of spool
minSpoolWidth=42;
//Height of each endCap
capHght=7;
//Count of grip cutOuts
gripCnt=6;
//Diameter/size of grip cutouts
gripDia=12;


/* [Hidden] */
minDia=innerDia+minWallThck*2;
fudge=0.1;

isNut = (export=="nut") ? true : false;

endCap(isNut);

if (export=="all") translate([0,0,minSpoolWidth+minWallThck*2+capHght]) 
  rotate([180,0,0]) endCap(true);

module endCap(nut=true){
  threadDeep=cos(30)/0.5; 
  //threat length have to cover minimum spool width at maximum spool diameter up to the
  //maximum spool width with minimum spool diameter
  threadLength=capHght*2+minWallThck*2+maxSpoolWidth-minSpoolWidth;
  
  difference(){
    union(){
      translate([0,0,minWallThck]) 
        cylinder(d1=maxSpoolDia,d2=max(minSpoolDia,minDia),h=capHght);
      cylinder(d=maxSpoolDia,h=minWallThck);
      translate([0,0,minWallThck/2]) rotate_extrude() 
        translate([maxSpoolDia/2,0]) circle(d=minWallThck);
    }
    //if this is the nut, cut a threat, else just a hole
    translate([0,0,-fudge/2]) 
      if (nut){
        if (showThreats) 
          metric_thread(diameter=minDia+spcng*2,
                      pitch=2,
                      length=capHght+minWallThck+fudge,
                      internal=true,
                      leadin=0);
        else
          cylinder(d=minDia+spcng*2,h=capHght+minWallThck+fudge);
        
        translate([0,0,-fudge/2]) 
          cylinder(d1=minDia+threadDeep/2+spcng, d2=minDia-threadDeep,h=1);
      }
      else
        cylinder(d=innerDia,h=capHght+minWallThck+fudge);
    
    for (ir=[0:360/gripCnt:360-(360/gripCnt)])
      rotate(ir) translate([(maxSpoolDia+minWallThck)/2,0,-fudge/2]) 
        cylinder(d=gripDia,h=capHght+minWallThck+fudge);
  }
  //attach the screw part if this is not the nut
  if (!nut){
    difference(){
      union(){
        translate([0,0,capHght+minWallThck]) cylinder(d=minDia,h=minSpoolWidth-capHght-minWallThck);
       
        translate([0,0,minSpoolWidth]) 
          if (showThreats)  metric_thread(diameter=minDia,
                                        pitch=2,
                                        length=threadLength,
                                        leadin=1);
        else color("cyan") cylinder(d=minDia,h=threadLength);
      }
    translate([0,0,capHght+minWallThck-fudge/2]) 
      cylinder(d=innerDia,h=capHght+minWallThck+maxSpoolWidth+fudge);
    //cutouts to save material
    translate([0,0,(minWallThck+capHght+minSpoolWidth+fudge)/2]){
      rotate([0,90,0]) bar([minSpoolWidth-capHght*2,innerDia/2,minDia+fudge]);
      rotate([0,90,90]) bar([minSpoolWidth-capHght*2,innerDia/2,minDia+fudge]);
    }
    }
  }
}

*bar();
module bar(size=[15,5,5]){
  hull() for (ix=[-1,1])
    translate([ix*(size.x-size.y)/2,0,0]) cylinder(d=size.y,h=size.z,center=true);
}

// --- threads library by Dan Kirshner ---
function segments (diameter) = min (50, ceil (diameter*6));

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

      // chamfer z=0 end if leadin is 2 or 3
      if (leadin == 2 || leadin == 3) {
         difference () {
            cylinder (r=diameter/2 + 1, h=h*h_fac1*leadfac, $fn=n_segments);

            cylinder (r2=diameter/2, r1=diameter/2 - h*h_fac1*leadfac, h=h*h_fac1*leadfac,
                      $fn=n_segments);
         }
      }

      // chamfer z-max end if leadin is 1 or 2.
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


// ----------------------------------------------------------------------------
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

   /*
    (angles x0 and x3 inner are actually 60 deg)

                          /\  (x2_inner, z2_inner) [2]
                         /  \
   (x3_inner, z3_inner) /    \
                  [3]   \     \
                        |\     \ (x2_outer, z2_outer) [6]
                        | \    /
                        |  \  /|
             z          |[7]\/ / (x1_outer, z1_outer) [5]
             |          |   | /
             |   x      |   |/
             |  /       |   / (x0_outer, z0_outer) [4]
             | /        |  /     (behind: (x1_inner, z1_inner) [1]
             |/         | /
    y________|          |/
   (r)                  / (x0_inner, z0_inner) [0]

   */

   x1_outer = outer_r * fraction_circle * 2 * PI;

   z0_outer = (outer_r - inner_r) * tan(angle);
   //echo (str ("z0_outer: ", z0_outer));

   //polygon ([[inner_r, 0], [outer_r, z0_outer],
   //        [outer_r, 0.5*pitch], [inner_r, 0.5*pitch]]);
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
