//Denise Lee, 12March2017

/*
//In RC hobby propeller nomenclature
//Propeller diameter X distance travelled per revolution (in silly inches!)
inch_mm = 25.4;
prop_dia = 6; //propeller diameter
prop_dist = 3.8; //propeller distance travelled
blade_radius = prop_dia*inch_mm/2;
pitch_angle = atan(prop_dist*inch_mm/blade_radius);
*/



blade_radius = 60;
pitch_angle = 18; //Converting pitch to twist angle for linear extrude

blade_arch = blade_radius/11; // Curvature of blades, selected straight edge or use ARC module 
apply_curvature = 1; //1 Curve blades, 0 for straight edge

echo("Blade Radius", blade_radius);
echo("Pitch Angle", pitch_angle);
echo("Blade Arch", blade_arch); 

printer_layer_height = 2; //for preview (F5) x20, set this to 0.1 for rendering for export STL(F6)!!!
blade_thickness = 4; //thickness of blade
turbine_height = 15;
num_blades = 5;
rotation_dir = -1; //CCW = -1, CW = 1

pi = 3.14159265359;
blade_cirf = 2*pi*blade_radius;
twist_angle = 360*turbine_height/(blade_cirf*tan(pitch_angle));

echo("Twist Angle: ", twist_angle);

slicing = turbine_height / printer_layer_height; //equal printing slicing height

percent_offset = 40; //Percent of turbine height with blades at blade radius
//offset_slicing must be greater or equal slicing
offset_slicing = round(slicing*(1/((100-percent_offset)/100)));  

echo("Percent Offset:", percent_offset);

layer_h = turbine_height/offset_slicing;

bot_r = blade_radius/6; //Bottom blade radius
//bot_r = 7.5;
top_r= blade_radius;

delta_r = top_r - bot_r;

stem_top_r = 4+2.6;
stem_bot_r = 5+2.6;

shaft_fit_r = 2.6; //Your connecting motor pin to turbine 
shaft_fit_l = turbine_height;


difference() {
union() {

intersection() {



//Blades
linear_extrude(height=turbine_height, center = false, convexity = 10, twist = twist_angle*rotation_dir, slices = slicing)
  for(i=[0:num_blades-1])
    rotate((360*i)/num_blades)
      translate([0,-blade_thickness/2]) { 
        if(apply_curvature != 1) { square([blade_radius, blade_thickness]); }
        else {
            if(rotation_dir == -1) {
                mirror([0,1,0])
                arc(blade_radius, blade_thickness, blade_arch); 
            }
            else {arc(blade_radius, blade_thickness, blade_arch);}
      }}
 

  
//Non-linear extrusion    

//Curve convex
//y = 1 - 1/exp(x)
exp_pow = 3;
end_point = 1 - 1/exp(exp_pow*1); 

union() {
for (i=[0:offset_slicing-1]){
    if (i < slicing) { 
        offset_r = delta_r*((1-1/exp(exp_pow*(i/slicing)))/end_point); //Normalised N
        offset_r_increment = delta_r*((1-1/exp(exp_pow*((i+1)/slicing)))/end_point); //Normalised N+1  
        translate([0,0,i*layer_h])
        cylinder(layer_h, bot_r + offset_r, bot_r + offset_r_increment, center=false, $fn=100);
    }
    else {
        translate([0,0,i*layer_h])
        cylinder(layer_h, top_r, top_r, center=false, $fn=100);    
    }    

}}

/*
//Curve concave    
//y = base^x - 1
//base = exp(1);
base = 3;
end_point = pow(base,1)-1;

union() {
for (i=[0:offset_slicing-1]){
    if (i < slicing) {
        offset_r = delta_r*((pow(base,i/slicing)-1)/end_point); //Normalised N 
        offset_r_increment = delta_r*((pow(base,(i+1)/slicing)-1)/end_point);  //Normalised N+1    
        translate([0,0,i*layer_h])
        cylinder(layer_h, bot_r + offset_r, bot_r + offset_r_increment, center=false, $fn=100);
    }
    else {
        translate([0,0,i*layer_h])
        cylinder(layer_h, top_r, top_r, center=false, $fn=100);    
    }
    //echo("Layer: ", i);    
}}*/

}

cylinder( turbine_height, stem_bot_r, stem_top_r,center=false, $fn=100); //Centre stem

}

cylinder( shaft_fit_l, shaft_fit_r, shaft_fit_r, center=false, $fn=100); } //Push fit cutout




//length and breath of inner arc
module arc(length, width, arch_height){
    //r = (l^2 + 4*b^2)/8*b 
    radius = (pow(length,2) + 4*pow(arch_height,2))/(8*arch_height);
    echo(radius);
    translate([length/2,0,0])
    difference() {
    difference() {
        translate([0,-radius+arch_height,0])
            difference() {
                circle(r=radius+width,$fn=100);
                circle(r=(radius),$fn=100);
            }
        
        translate([-(radius+width),-(radius+width)*2,0,])
            square([(radius+width)*2,(radius+width)*2]);
    }
    union() {
        translate([-length,-arch_height]) 
            square([length/2,arch_height*2]);
        translate([length/2,-arch_height])     
            square([length/2,arch_height*2]);
    }}    
}

