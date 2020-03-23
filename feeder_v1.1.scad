//    feeder.scad 
//     originally from sarman_1998 @ Thingiverse
//    
//    This script creates the two parts of an angled outlet for 3D 
//    printer filament with a mount for a push on connector.  
//    I use it to pass the filament out of a plastic tub where the 
//    spool is stored to keep it from absorbing moisture.  
//    screws and nuts hold it all together.
//
//    If you need to change the fitting size, you can change the values.
//
//    Instructions to create 2 stl's:
//    Render and export the top, 
//    Then change the value of bottom passed into feeder() from false to true.  
//    Render again to get the other half of the part and export it.

// Metric Screw Thread Library
// by Maximilian Karl <karlma@in.tum.de> (2014)
//
// only use module thread(P,D,h,step)
// with the parameters:
// P    - screw thread pitch
// D    - screw thread major diameter
// h    - screw thread height
// step - step size in degree
// 

// Code used for:
//  bolts:   M3x10 DIN 7985 (cross) -> flat at the side of the thread
//  washers: DIN9021 3,2mm washer (optional)
//  nuts:    M3 DIN 985 (nylon locking nut) -> outside measures: 5.5 mm (parallel sides of hex), height 4.0 mm (2.4mm hexagon)


// margin for plastic expansion and some free room
print_margin = 0.3;

/* [base] */
base_height = 2; // 3mm for both
base_length = 45;
base_width = 20;
base_minimum_height = 1.0; // 1.6mm for strength
//thickness of box walls
box_wall_thickness=1.9;
base_size = [base_length, base_width, 2 * base_height + box_wall_thickness];


/* [nut] */
// Nut: M3 DIN 985 (nylon locking nut) -> outside measures: 5.5 mm (parallel sides of hex), height 4.0 mm (2.4mm hexagon)
nut_diameter = 3.0;
nut_height = 4.0;  
nut_height_hexagon = 2.4;
nut_diameter_parallel = 5.5;

/* [mount] */
// cylinder(d = x, $fn = 6), x is from point to point, not from side to side of the hexagon. Divide <from side to side> with sin(60) to get x
mount_hole_diameter = nut_diameter + 2 * print_margin; // M3 (3mm) + 2 x 0.3mm margin
mount_nut_diameter = nut_diameter_parallel / sin(60) + 2 * print_margin;  // approx. 6.95 (tested 6.6: too small. Now I understand)
mount_nut_depth = min(2/3 * nut_height_hexagon, base_height - base_minimum_height); // 2/3 of hexagon height, but keep minimum for strength
mount_base_offset = 15; // use fixed value, to be able to reuse holes for other models.

/* [cylinder] */
cylinder_angle = 45;  // degree
cylinder_outside_diameter = 10; // gross diameter of cylinder
cylinder_inside_diameter = 4.8;
thread_diameter = 6 + 2 * print_margin; // 6.6 tested with success
thread_pitch = 1; // course pitch for M6 is 1mm
thread_length = 6; // max length thread of PC4-M6 connector (one spec defines it as 6mm)
cylinder_bottom = 1 ; // minimum length of (2x) 1 mm
cylinder_length = 2 * (thread_length + cylinder_bottom) + tan(cylinder_angle) * (cylinder_inside_diameter + 1.8); // expecting thread extends diameter of cylinder with 2x 0.9mm.

funnel_height = thread_length;

/* [show] */
showBottom = true;

/* [Hidden] */
echo(fs=$fs);
echo(fa=$fa);
echo(fn=$fn);
$fa=6;
$fs=1.5;
$fn=60;

module screwthread_triangle(P) {
	difference() {
		translate([-sqrt(3)/3*P+sqrt(3)/2*P/8,0,0])
		 rotate([90,0,0])
		 cylinder(r=sqrt(3)/3*P,h=0.00001,$fn=3,center=true);

		translate([0,-P/2,-P/2])
		 cube([P,P,P]);
	}
}

module screwthread_onerotation(P,D_maj,step) {
	H = sqrt(3)/2*P;
	D_min = D_maj - 5*sqrt(3)/8*P;

	for(i=[0:step:360-step])
	hull()
		for(j = [0,step])
            rotate([0,0,(i+j)])
             translate([D_maj/2,0,(i+j)/360*P])
             screwthread_triangle(P);

	translate([0,0,P/2])
	 cylinder(r=D_min/2,h=2*P,$fn=360/step,center=true);
}

module thread(P,D,step,rotations) {
    // added parameter "rotations"
    // as proposed by user bluecamel
	for(i=[0:rotations])
	 translate([0,0,i*P])
	 screwthread_onerotation(P,D,step);
}

// END Metric Screw Thread Library

// START CODE 


feeder( bottom = showBottom );  // change bottom = true to get the other half of the part.

module feeder ( bottom = false ){
    cube_diameter = 2 * max(base_width, base_length); // any factor bigger than 1
    
    top = ( bottom ) ? 1 : -1;
    rotation  = ( bottom ) ? 180 : 0;
    
    rotate([rotation, 0, 0])
    difference()
    {
        feeder_whole();
        translate([0,0,top*(cube_diameter-box_wall_thickness)/2])
            cube([cube_diameter, cube_diameter, cube_diameter], center = true );
    }
}

module feeder_whole()
{
    difference()
    {
        union()
        {
            feeder_base();
            rotate([cylinder_angle, 0, 0]) 
             cylinder(d = cylinder_outside_diameter, h = cylinder_length, center = true);
        }        
    
        rotate([cylinder_angle, 0, 0])
        union()
        {
            fudge = 1;
            cylinder(d = cylinder_inside_diameter, h = cylinder_length + fudge, center = true ); // minimal room for filament
            translate([0, 0, cylinder_length / 2 - thread_length] )
                intersection() { 
                    translate([0,0,thread_length/2 + fudge]) cube([cylinder_outside_diameter,cylinder_outside_diameter,thread_length+2*fudge], center=true); 
                    translate([0,0,-thread_pitch/2]) thread(P=thread_pitch,D=thread_diameter,step=10,rotations=thread_length+2*fudge); 
                }
            translate([0, 0, -cylinder_length/2-0.01])
                cylinder( d1 = cylinder_outside_diameter - 2, d2 = cylinder_inside_diameter, h = funnel_height + 0.01);
        } // union
    } // difference
}

module roundedBox(size = base_size, radius = 0)
{
    cube(size - [2*radius,0,0], true);
    cube(size - [0,2*radius,0], true);
    for (x = [radius-size[0]/2, -radius+size[0]/2],
           y = [radius-size[1]/2, -radius+size[1]/2]) {
      translate([x,y,0]) cylinder(r=radius, h=size[2], center=true);
    }
}

module feeder_base()
{
  difference(){
    roundedBox(size = base_size, radius = base_size.y/3);
      // two screw holes
      for (i = [-1, 1]){
        translate([i*mount_base_offset, 0, 0]){
          translate([0, 0, -2 * base_height])
            cylinder(d = mount_hole_diameter, h = 2 * 2 * base_height ); // factor 2 for no artifacts
                
        // Cutouts for the nuts on bottom side (-1) only.
       
          fudge = 0.1; // 0.1 for no artifacts
          translate([ 0, 0, -1*(base_height - (mount_nut_depth-fudge)/2 + box_wall_thickness/2)])
            rotate([0, 0, 30])
              cylinder( d = mount_nut_diameter, h = mount_nut_depth + fudge, center = true, $fn = 6 );
          translate([ 0, 0, 1*(base_height - (mount_nut_depth-fudge)/2 + box_wall_thickness/2)])
            rotate([0, 0, 30])
              cylinder( d = mount_nut_diameter, h = mount_nut_depth + fudge, center = true);
          
      }
    }
  }
}
