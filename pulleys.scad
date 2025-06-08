include <BOSL2/std.scad>;
include <BOSL2/screws.scad>;

/**
 * Pulley Generator
 *      
 * Author: Jason Koolman  
 * Version: 1.1  
 *
 * Description:
 * This OpenSCAD script generates fully parametric timing belt pulleys with 
 * customizable profiles, dimensions, and tooth configurations. It supports 
 * industry-standard belt types, including MXL, XL, L, GT2, HTD, and T-series. 
 * Features include adjustable flanges, bore types, and chamfers.
 *
 * Technical References:
 * - "Timing Belt & Pulley Design Guide" by SDP/SI:  
 *   https://www.sdp-si.com/PDFS/Technical-Section-Timing.pdf
 * - "Timing Belt Pulleys" by Pfeifer Industries:
 *   https://www.pfeiferindustries.com/timing-belt-pulleys
 *
 * Changelog:
 * [v1.1]:
 * - Added option to override keyway size for custom dimensions.
 * - Added support for UTS (inch-based) screws, including #4 to 3/4" sizes.
 * - Enhanced screw hole placement with adjustable count, angle, and offset.
 *
 * License:
 * This script is licensed under a Standard Digital File License.
 */

/* [⚙️️️ Pulley] */

// Belt profile type.
Type = "XL"; // [MXL, XL, L, 40DP, T2.5, T5, T10, GT2_2mm: GT2 2mm, GT2_3mm: GT2 3mm, GT2_5mm: GT2 5mm, AT5, HTD_3mm: HTD 3mm, HTD_5mm: HTD 5mm, HTD_8mm: HTD 8mm]

// Number of teeth in the pulley.
Teeth = 16; // (standard Mendel T5 belt = 8, od = 11.88)

// Pulley width (same as belt width).
Width = 10;

// Tooth pitch (distance between teeth, 0 = auto).
Pitch = 0;

/* [🛡️ Retainers] */

// Flange placement.
Flange_Sides = "both"; // [top: Top, both: Both, bottom: Bottom]

// Flange height.
Flange_Height = 2;

// Flange thickness (radial offset from pulley).
Flange_Thickness = 1;

// Flange taper ratio (0 = vertical, 1 = fully tapered).
Flange_Taper = 0.5; // [0:0.01:1]

/* [⭕ Bore] */

// Bore type (shaft interface).
Bore_Type = "cylinder"; // [none: None, cylinder: Cylinder, keyway: Keyway, hex: Hex, D]

// Bore size (shaft diameter or WAF for hex bores).
Bore_Size = 8;

// Chamfer bore edges.
Bore_Chamfer = 0.6;

// Override keyway size as [width, height]. 
Keyway_Size = [0, 0];

/* [🔩 Hub] */

// Add a hub?
Hub = false;

// Diameter of the hub.
Hub_Diameter = 20;

// Height of the hub.
Hub_Height = 10;

// Chamfer hub edges.
Hub_Chamfer = 0.6;

// Number of set screws distributed around the hub.
Screw_Count = 1; // [0:1:6]

// Angle between each set screw.
Screw_Angle = 90; // [60: 60°, 90: 90°, 180: 180°]

// Type of set screws.
Screw_Type = "M4"; // [M2, M2.5, M3, M4, M5, M6, M8, M10, M12, M14, M16, M18, M20, #4, #6, #8, #10, #12, 1/4, 5/16, 3/8, 7/16, 1/2, 9/16, 3/4]

// Vertical offset for the set screws along the hub.
Screw_Offset = 0;

// Add screw thread?
Screw_Thread = true;

/* [📷 Render] */

// Toggle debug information.
Debug = false;

// Pulley color.
Color = "#e0e0e0"; // color

/* [Hidden] */

Shiftout = 0.01;

$fa = 2;
$fs = 0.2;

// Render
pulley();

// ====================================================================
// Example 1: HTD 8M 20-Tooth Timing Belt Pulley (8M-20T BF)
// ====================================================================
//
// Based on a real-world product specification.
//
// Product URL:
// https://www.amazon.nl/-/en/Timing-Pulley-8M-20T-Synchronus-Keyway/dp/B0CD9N1MDM
//
// Configuration:
// - Belt Type:          HTD 8M
// - Tooth Count:        20
// - Belt Width:         27mm
// - Flange Sides:       Both
// - Flange Height:      3mm
// - Flange Thickness:   3mm
// - Flange Taper:       0.6
// - Bore Type:          Keyway
// - Bore Size:          10mm
// - Hub Enabled:        Yes
// - Hub Diameter:       38mm
// - Hub Height:         12mm
// - Hub Screw Type:     M5
//
// Notes:
// - The Pulley Generator automatically sets correct keyway dimensions
//   based on standard sizing (ISO 773 / DIN 6885 / ANSI B17.1).
// - The flange is slightly thicker to maintain a minimum 45° angle 
//   for improved 3D printability and structural integrity.

// ====================================================================
// Example 2: RS PRO 27-Tooth Aluminium Timing Belt Pulley (T5mm)
// ====================================================================
//
// Based on a real-world product specification.
//
// Product URL:
// https://nl.rs-online.com/web/p/belt-pulleys/744996
//
// Configuration:
// - Belt Type:          T5
// - Tooth Count:        27
// - Belt Width:         10mm
// - Flange Sides:       Both
// - Flange Height:      3mm
// - Flange Thickness:   2mm
// - Flange Taper:       0.5
// - Bore Type:          Cylinder
// - Bore Size:          8mm
// - Hub Enabled:        Yes
// - Hub Diameter:       28mm
// - Hub Height:         8mm
// - Hub Screw Count:    0

/**
 * Generates a parametric timing pulley.
 *
 * This module creates a pulley designed for use with timing belts, 
 * supporting various industry-standard profiles such as MXL, XL, L, 
 * GT2, HTD, and T-series. It allows for customizable tooth geometry, 
 * flanges, and bore types.
 *
 * @param belt_type        Belt profile type (e.g., "XL", "GT2_5mm").
 * @param belt_teeth       Number of teeth on the pulley.
 * @param belt_width       Width of the pulley (matches belt width).
 * @param tooth_pitch      Distance between adjacent teeth (0 = auto).
 * @param tooth_clearance  Tooth clearance adjustments [x, y].
 * @param flange_height    Height of the pulley flanges.
 * @param flange_thickness Thickness (radial offset) of the flanges.
 * @param flange_taper     Taper ratio of the flanges (0 = vertical, 1 = fully tapered).
 * @param flange_sides     Flange placement ("top", "bottom", or "both").
 * @param anchor           Attachment anchor position.
 * @param spin             Rotational offset of the pulley.
 * @param orient           Orientation of the pulley.
 */
module pulley(
    belt_type = Type,
    belt_teeth = Teeth,
    belt_width = Width,
    tooth_pitch = Pitch,
    tooth_clearance = [0.1, 0],
    flange_height = Flange_Height,
    flange_thickness = Flange_Thickness,
    flange_taper = Flange_Taper,
    flange_sides = Flange_Sides,
    hub_height = Hub_Height,
    anchor = BOTTOM,
    spin = 0,
    orient = UP
) {
    profile = _belt_tooth_profile(belt_type);
    data = _belt_tooth_profile_data[search([belt_type], _belt_tooth_profile_data)[0]];
    
    pitch = is_num(tooth_pitch) && tooth_pitch > 0 ? tooth_pitch : data[1];
    height = is_num(belt_width) && belt_width > 0 ? belt_width : data[3];
    
    tooth_bounds = pointlist_bounds(profile);
    tooth_width = tooth_bounds[1].x - tooth_bounds[0].x;
    tooth_depth = tooth_bounds[1].y;
    tooth_vclearance = force_list(tooth_clearance, n = 2);
    tooth_scale = [
        (tooth_width + tooth_vclearance.x * 2) / tooth_width,
        (tooth_depth + tooth_vclearance.y) / tooth_depth
    ];
    
    pitch_diameter = (belt_teeth * pitch) / PI;
    pulley_height = belt_width + flange_height * 2;
    pulley_od = root_diameter(Type, belt_teeth, pitch);
    tooth_base_radius = sqrt(pow(pulley_od/2, 2) - pow((tooth_width)/2, 2));
    flange_diameter = pulley_od + flange_thickness * 2;

    attachable(anchor, spin, orient, d = pulley_od, h = pulley_height) {
        color(Color)
        difference() {
            // Pulley structure
            union() {
                cylinder(r = pulley_od / 2, h = belt_width, center = true);
                
                flange_angles = flange_sides == "top" ? [180]
                    : flange_sides == "bottom" ? [0]
                    : [0, 180];
                
                // Add flanges
                xrot_copies(flange_angles)
                    down(belt_width / 2)
                        _pulley_flange(pulley_od, flange_height, flange_thickness, flange_height * flange_taper, anchor=TOP);

                // Add hub
                if (Hub) {
                    up(pulley_height / 2)
                        _pulley_hub(anchor = BOTTOM);
                }
            }
                
            // Subtract belt teeth
            linear_extrude(height = belt_width, center  = true) {
                for (i = [0:belt_teeth-1]) {
                    zrot(i/belt_teeth*360)
                    fwd(tooth_base_radius)
                    scale([tooth_scale.x , tooth_scale.y, 1]) {
                        polygon(profile);
                    }
                }
            }
            
            // Subtract bore mask
            bore_offset = Hub ? hub_height : 0;
            up(bore_offset / 2)
                _pulley_bore_mask(pulley_height + bore_offset);
        }
        children();
    }
    
    // Debug info
    if (Debug) {
        fwd(pulley_od / 2 + 6)
        debug_info([
            ["Pulley Height (Belt Width)", belt_width],
            ["Pulley Diameter", pulley_od],
            ["Pitch Diameter", pitch_diameter],
            ["Tooth Pitch", pitch],
            ["Flange Height", flange_height],
            ["Flange Diameter", flange_diameter],
            ["Total Height", pulley_height],
        ]);
    }
}

/**
 * Generates a pulley flange (belt retainer).
 *
 * This module creates a flange that helps retain the timing belt on 
 * the pulley. The flange can be customized in terms of height, 
 * thickness, and taper angle.
 *
 * @param pulley_od  Outer diameter of the pulley.
 * @param height     Total height of the flange.
 * @param thickness  Radial thickness of the flange.
 * @param taper      Taper height (0 = vertical, height = fully sloped).
 * @param anchor     Attachment anchor position (default: CENTER).
 * @param spin       Rotational offset of the flange.
 * @param orient     Orientation of the flange.
 */
module _pulley_flange(pulley_od, height, thickness, taper, anchor = CENTER, spin = 0, orient = UP) {
    flat_height = height - taper;

    attachable(anchor, spin, orient, d = pulley_od, h = height) {
        down(height/2)
        rotate_extrude() {
            polygon([
                [0, 0],                                      // Center
                [pulley_od / 2 + thickness, 0],              // Outer lip
                [pulley_od / 2 + thickness, flat_height],    // Flat section height
                [pulley_od / 2, height],                     // Tapered connection
                [0, height]                                  // Top edge
            ]);
        }
        children();
    }
}

/**
 * Generates a bore cutout for the pulley.
 *
 * This module creates a bore cutout in the pulley for shaft mounting. 
 * It supports multiple bore types, including cylindrical, keyway, 
 * hexagonal, and D-shaped bores, with optional chamfering.
 *
 * @param height        Total height of the bore cutout.
 * @param type          Bore type ("cylinder", "keyway", "hex", "D").
 * @param size          Bore size (shaft diameter or across-flats for hex).
 * @param chamfer       Chamfer depth for smoother edges (default: Bore_Chamfer).
 * @param keyway_size   Keyway size to override the default size.
 */
module _pulley_bore_mask(height, type = Bore_Type, size = Bore_Size, chamfer = Bore_Chamfer, keyway_size = Keyway_Size) {
    h = height + Shiftout;
    
    up(Shiftout / 2) {
        if (type == "cylinder") {
            cyl(d = size, h = h, chamfer = -chamfer);
        } else if (type == "keyway") {
            kw_size = keyway_size(size);
            kw_width = min(size, keyway_size.x > 0 ? keyway_size.x : kw_size.x);
            kw_height = min(kw_width, keyway_size.y > 0 ? keyway_size.y : kw_size.y);
            backing = size / 2;
            cyl(d = size, h = h, chamfer = -chamfer);
            zrot(90)
                back(size / 2 + kw_height / 2 - backing / 2) 
                    cube([kw_width, kw_height + backing, h], center = true);
        } else if (type == "D") {
            flat_depth = size * 0.15;
            difference() {
                cyl(d = size, h = h, chamfer = -chamfer);
                fwd(size / 2 - flat_depth / 2 + chamfer / 2) 
                    cube([size + chamfer * 2, flat_depth + chamfer, h], center = true);
            }
        } else if (type == "hex") {
            regular_prism(6, r = size / sqrt(3), h = h, chamfer=-chamfer);
        }
    }
}

/**
 * Generates a pulley hub with optional set screws.
 *
 * The hub is an extended section for attaching the pulley to a shaft.
 * It optionally includes set screw holes, typically used for grub screw.
 *
 * @param hub_d         Outer diameter of the hub.
 * @param hub_h         Height of the hub.
 * @param hub_chamfer   Chamfer size of the hub edges.
 * @param screw_d       Diameter of the set screw holes.
 * @param screw_count   Number of screws (evenly spaced).
 * @param screw_offset  Vertical offset of screws from hub base.
 * @param anchor        Attachment anchor position.
 */
module _pulley_hub(
    hub_d = Hub_Diameter,
    hub_h = Hub_Height,
    hub_chamfer = Hub_Chamfer,
    screw_type = Screw_Type,
    screw_thread = Screw_Thread,
    screw_count = Screw_Count,
    screw_angle = Screw_Angle,
    screw_offset = Screw_Offset,
    anchor = TOP,
    spin = 0,
    orient = UP,
) {
    attachable(anchor, spin, orient, d = hub_d, h = hub_h) {
        difference() {
            // Hub base cylinder
            cyl(d = hub_d, h = hub_h, chamfer2 = hub_chamfer);

            // Set screw holes
            for (i = [0:1:screw_count-1]) {
                zrot(i * screw_angle)
                fwd(hub_d / 2)
                up(max(-hub_h / 2, min(screw_offset, hub_h / 2)))
                screw_hole(screw_type, 
                    length = hub_d / 2, 
                    thread = screw_thread,
                    head = "none",
                    teardrop = true,
                    anchor = TOP,
                    orient = FWD,
                    $slop = screw_thread ? 0.1 : 0
                );
            }
        }
        children();
    }
}

/**
 * Determines the standard keyway size based on bore diameter.
 *
 * Keyways are typically standardized according to ISO, DIN, or ANSI 
 * specifications. This function returns the recommended keyway width 
 * and depth based on bore diameter, ensuring compatibility with standard 
 * shaft keyway dimensions.
 *
 * Source: 
 * - DIN 6885 / ISO 773 / ANSI B17.1 keyway standards 
 * - Common keyway sizing from mechanical design references
 *
 * @param diameter  Bore diameter in millimeters.
 * @return          Keyway dimensions as [width, depth] in mm.
 */
function keyway_size(diameter) =
    (diameter <= 6)  ? [2, 1.0] :
    (diameter <= 8)  ? [2, 1.2] :
    (diameter <= 10) ? [3, 1.4] :
    (diameter <= 12) ? [3, 1.8] :
    (diameter <= 17) ? [4, 2.3] :
    (diameter <= 22) ? [5, 2.8] :
    (diameter <= 30) ? [6, 3.3] :
    (diameter <= 38) ? [8, 3.3] :
    (diameter <= 44) ? [10, 4.3] :
    (diameter <= 50) ? [12, 4.3] :
    (diameter <= 58) ? [14, 4.9] :
    (diameter <= 65) ? [16, 5.4] :
    (diameter <= 75) ? [18, 6.4] :
    (diameter <= 85) ? [20, 6.4] :
    (diameter <= 95) ? [22, 7.4] :
    (diameter <= 110) ? [25, 8.4] :
    [25, 8.4];

/**
 * Calculates the root diameter of the belt.
 *
 * The root diameter is the effective pulley diameter at the base of 
 * the teeth, below the pitch line. It is calculated using either 
 * a fixed pitch line offset (PLO) or a curve-fitted formula, depending 
 * on the belt type.
 *
 * @param type   Belt type (e.g., "XL", "GT2_5mm").
 * @param teeth  Number of teeth on the pulley.
 * @param pitch  Tooth pitch (distance between adjacent teeth).
 * @return       Root diameter of the belt.
 */
function root_diameter(type, teeth, pitch) =
    (type == "MXL")       ? _root_diam_plo(teeth, pitch, 0.254) :
    (type == "40DP")      ? _root_diam_plo(teeth, pitch, 0.1778) :
    (type == "XL")        ? _root_diam_plo(teeth, pitch, 0.254) :
    (type == "L")         ? _root_diam_plo(teeth, pitch, 0.381) :
    (type == "T2.5")      ? _root_diam_curvefit(teeth, 0.7467, 0.796, 1.026) :
    (type == "T5")        ? _root_diam_curvefit(teeth, 0.6523, 1.591, 1.064) :
    (type == "T10")       ? _root_diam_plo(teeth, pitch, 0.93) :
    (type == "AT5")       ? _root_diam_curvefit(teeth, 0.6523, 1.591, 1.064) :
    (type == "HTD_3mm")   ? _root_diam_plo(teeth, pitch, 0.381) :
    (type == "HTD_5mm")   ? _root_diam_plo(teeth, pitch, 0.5715) :
    (type == "HTD_8mm")   ? _root_diam_plo(teeth, pitch, 0.6858) :
    (type == "GT2_2mm")   ? _root_diam_plo(teeth, pitch, 0.254) :
    (type == "GT2_3mm")   ? _root_diam_plo(teeth, pitch, 0.381) :
    (type == "GT2_5mm")   ? _root_diam_plo(teeth, pitch, 0.5715) :
    undef;
    
/**
 * Calculates the root diameter using a fixed pitch line offset.
 *
 * @param teeth             Number of teeth on the pulley.
 * @param pitch             Distance between adjacent teeth.
 * @param pitch_line_offset Distance from the pitch line to the root.
 * @return                  Root diameter of the belt.
 */
function _root_diam_plo(teeth, pitch, pitch_line_offset) = 
    2 * ((teeth * pitch) / (PI * 2) - pitch_line_offset);

/**
 * Estimates the root diameter using a curve-fitted formula.
 *
 * This method approximates the root diameter for certain belt types 
 * when an exact Pitch Line Offset (PLO) is unavailable.
 *
 * @param teeth  Number of teeth on the pulley.
 * @param b      Curve fit coefficient.
 * @param c      Curve fit coefficient.
 * @param d      Curve fit exponent.
 * @return       Estimated root diameter of the belt.
 */
function _root_diam_curvefit(teeth, b, c, d) = 
    ((c * pow(teeth, d)) / (b + pow(teeth, d))) * teeth;

/**
 * Standard timing belt tooth profile specifications.
 *
 * This lookup table provides the standard pitch, backing thickness, 
 * and default belt width for various timing belt profiles. The data 
 * is referenced from industry sources such as SDP/SI and Misumi.
 */
_belt_tooth_profile_data = [
    // type,        pitch,  backing,    default belt width
	[ "MXL",        2.032,  0.64,       6.35 ],
    [ "XL",         5.08,   1.03,       7.94 ],
	[ "L",          9.525,  1.66,       19.05 ],
    [ "40DP",       2.073,  0.74,       4.7625 ],
	[ "T2.5",       2.5,    0.6,        6 ],
	[ "T5",         5,      1,          10 ],
	[ "T10",        10,     2,          16 ],
	[ "GT2_2mm",    2,      0.76,       6 ],
	[ "GT2_3mm",    3,      1.27,       9 ],    
	[ "GT2_5mm",    5,      1.88,       15 ],
	[ "HTD_3mm",    3,      1.19,       9 ],
	[ "HTD_5mm",    5,      1.73,       9 ],
	[ "HTD_8mm",    8,      2.64,       30 ],
    [ "AT5",        5,      1,          10 ],
];

/**
 * Retrieves the tooth profile for a given belt type.
 *
 * This function returns a 2D polygon representation of the standard 
 * tooth shape for various timing belt profiles, with a resolution
 * of around 0.05-0.1mm for each tooth.
 *
 * Credits:
 * - Vector data was originally extracted by 'droftarts' on Thingiverse.
 *
 * @param type  Belt type (e.g., "MXL", "GT2_5mm").
 * @return      List of 2D coordinate points defining the tooth shape.
 */

function _belt_tooth_profile(type) =
    (type == "MXL") ?
        [[-0.660421,-0.5],[-0.660421,0],[-0.621898,0.006033],[-0.587714,0.023037],[-0.560056,0.049424],[-0.541182,0.083609],[-0.417357,0.424392],[-0.398413,0.458752],[-0.370649,0.48514],[-0.336324,0.502074],[-0.297744,0.508035],[0.297744,0.508035],[0.336268,0.502074],[0.370452,0.48514],[0.39811,0.458752],[0.416983,0.424392],[0.540808,0.083609],[0.559752,0.049424],[0.587516,0.023037],[0.621841,0.006033],[0.660421,0],[0.660421,-0.5]] :
    (type == "XL") ?
        [[-1.525411,-1],[-1.525411,0],[-1.41777,0.015495],[-1.320712,0.059664],[-1.239661,0.129034],[-1.180042,0.220133],[-0.793044,1.050219],[-0.733574,1.141021],[-0.652507,1.210425],[-0.555366,1.254759],[-0.447675,1.270353],[0.447675,1.270353],[0.555366,1.254759],[0.652507,1.210425],[0.733574,1.141021],[0.793044,1.050219],[1.180042,0.220133],[1.239711,0.129034],[1.320844,0.059664],[1.417919,0.015495],[1.525411,0],[1.525411,-1]] :
    (type == "L") ?
        [[-2.6797,-1],[-2.6797,0],[-2.600907,0.006138],[-2.525342,0.024024],[-2.45412,0.052881],[-2.388351,0.091909],[-2.329145,0.140328],[-2.277614,0.197358],[-2.234875,0.262205],[-2.202032,0.334091],[-1.75224,1.57093],[-1.719538,1.642815],[-1.676883,1.707663],[-1.62542,1.764693],[-1.566256,1.813112],[-1.500512,1.85214],[-1.4293,1.880997],[-1.353742,1.898883],[-1.274949,1.905021],[1.275281,1.905021],[1.354056,1.898883],[1.429576,1.880997],[1.500731,1.85214],[1.566411,1.813112],[1.625508,1.764693],[1.676919,1.707663],[1.719531,1.642815],[1.752233,1.57093],[2.20273,0.334091],[2.235433,0.262205],[2.278045,0.197358],[2.329455,0.140328],[2.388553,0.091909],[2.454233,0.052881],[2.525384,0.024024],[2.600904,0.006138],[2.6797,0],[2.6797,-1]] :
    (type == "40DP") ?
        [[-0.612775,-0.5],[-0.612775,0],[-0.574719,0.010187],[-0.546453,0.0381],[-0.355953,0.3683],[-0.327604,0.405408],[-0.291086,0.433388],[-0.248548,0.451049],[-0.202142,0.4572],[0.202494,0.4572],[0.248653,0.451049],[0.291042,0.433388],[0.327609,0.405408],[0.356306,0.3683],[0.546806,0.0381],[0.574499,0.010187],[0.612775,0],[0.612775,-0.5]] :
    (type == "T2.5") ?
        [[-0.839258,-0.5],[-0.839258,0],[-0.770246,0.021652],[-0.726369,0.079022],[-0.529167,0.620889],[-0.485025,0.67826],[-0.416278,0.699911],[0.416278,0.699911],[0.484849,0.67826],[0.528814,0.620889],[0.726369,0.079022],[0.770114,0.021652],[0.839258,0],[0.839258,-0.5]] :
    (type == "T5") ?
        [[-1.632126,-0.5],[-1.632126,0],[-1.568549,0.004939],[-1.507539,0.019367],[-1.450023,0.042686],[-1.396912,0.074224],[-1.349125,0.113379],[-1.307581,0.159508],[-1.273186,0.211991],[-1.246868,0.270192],[-1.009802,0.920362],[-0.983414,0.978433],[-0.949018,1.030788],[-0.907524,1.076798],[-0.859829,1.115847],[-0.80682,1.147314],[-0.749402,1.170562],[-0.688471,1.184956],[-0.624921,1.189895],[0.624971,1.189895],[0.688622,1.184956],[0.749607,1.170562],[0.807043,1.147314],[0.860055,1.115847],[0.907754,1.076798],[0.949269,1.030788],[0.9837,0.978433],[1.010193,0.920362],[1.246907,0.270192],[1.273295,0.211991],[1.307726,0.159508],[1.349276,0.113379],[1.397039,0.074224],[1.450111,0.042686],[1.507589,0.019367],[1.568563,0.004939],[1.632126,0],[1.632126,-0.5]] :
    (type == "T10") ?
        [[-3.06511,-1],[-3.06511,0],[-2.971998,0.007239],[-2.882718,0.028344],[-2.79859,0.062396],[-2.720931,0.108479],[-2.651061,0.165675],[-2.590298,0.233065],[-2.539962,0.309732],[-2.501371,0.394759],[-1.879071,2.105025],[-1.840363,2.190052],[-1.789939,2.266719],[-1.729114,2.334109],[-1.659202,2.391304],[-1.581518,2.437387],[-1.497376,2.47144],[-1.408092,2.492545],[-1.314979,2.499784],[1.314979,2.499784],[1.408091,2.492545],[1.497371,2.47144],[1.581499,2.437387],[1.659158,2.391304],[1.729028,2.334109],[1.789791,2.266719],[1.840127,2.190052],[1.878718,2.105025],[2.501018,0.394759],[2.539726,0.309732],[2.59015,0.233065],[2.650975,0.165675],[2.720887,0.108479],[2.798571,0.062396],[2.882713,0.028344],[2.971997,0.007239],[3.06511,0],[3.06511,-1]] :
    (type == "GT2_2mm") ?
        [[0.747183,-0.5],[0.747183,0],[0.647876,0.037218],[0.598311,0.130528],[0.578556,0.238423],[0.547158,0.343077],[0.504649,0.443762],[0.451556,0.53975],[0.358229,0.636924],[0.2484,0.707276],[0.127259,0.750044],[0,0.76447],[-0.127259,0.750044],[-0.2484,0.707276],[-0.358229,0.636924],[-0.451556,0.53975],[-0.504797,0.443762],[-0.547291,0.343077],[-0.578605,0.238423],[-0.598311,0.130528],[-0.648009,0.037218],[-0.747183,0],[-0.747183,-0.5]] :
    (type == "GT2_3mm") ?
        [[-1.155171,-0.5],[-1.155171,0],[-1.065317,0.016448],[-0.989057,0.062001],[-0.93297,0.130969],[-0.90364,0.217664],[-0.863705,0.408181],[-0.800056,0.591388],[-0.713587,0.765004],[-0.60519,0.926747],[-0.469751,1.032548],[-0.320719,1.108119],[-0.162625,1.153462],[0,1.168577],[0.162625,1.153462],[0.320719,1.108119],[0.469751,1.032548],[0.60519,0.926747],[0.713587,0.765004],[0.800056,0.591388],[0.863705,0.408181],[0.90364,0.217664],[0.932921,0.130969],[0.988924,0.062001],[1.065168,0.016448],[1.155171,0],[1.155171,-0.5]] :
    (type == "GT2_5mm") ?
        [[-1.975908,-0.75],[-1.975908,0],[-1.797959,0.03212],[-1.646634,0.121224],[-1.534534,0.256431],[-1.474258,0.426861],[-1.446911,0.570808],[-1.411774,0.712722],[-1.368964,0.852287],[-1.318597,0.989189],[-1.260788,1.123115],[-1.195654,1.25375],[-1.12331,1.380781],[-1.043869,1.503892],[-0.935264,1.612278],[-0.817959,1.706414],[-0.693181,1.786237],[-0.562151,1.851687],[-0.426095,1.9027],[-0.286235,1.939214],[-0.143795,1.961168],[0,1.9685],[0.143796,1.961168],[0.286235,1.939214],[0.426095,1.9027],[0.562151,1.851687],[0.693181,1.786237],[0.817959,1.706414],[0.935263,1.612278],[1.043869,1.503892],[1.123207,1.380781],[1.195509,1.25375],[1.26065,1.123115],[1.318507,0.989189],[1.368956,0.852287],[1.411872,0.712722],[1.447132,0.570808],[1.474611,0.426861],[1.534583,0.256431],[1.646678,0.121223],[1.798064,0.03212],[1.975908,0],[1.975908,-0.75]] :
    (type == "AT5") ?
        [[-2.134129,-0.75],[-2.134129,0],[-2.058023,0.005488],[-1.984595,0.021547],[-1.914806,0.047569],[-1.849614,0.082947],[-1.789978,0.127073],[-1.736857,0.179338],[-1.691211,0.239136],[-1.653999,0.305859],[-1.349199,0.959203],[-1.286933,1.054635],[-1.201914,1.127346],[-1.099961,1.173664],[-0.986896,1.18992],[0.986543,1.18992],[1.099614,1.173664],[1.201605,1.127346],[1.286729,1.054635],[1.349199,0.959203],[1.653646,0.305859],[1.690859,0.239136],[1.73651,0.179338],[1.789644,0.127073],[1.849305,0.082947],[1.914539,0.047569],[1.984392,0.021547],[2.057906,0.005488],[2.134129,0],[2.134129,-0.75]] :
    (type == "HTD_3mm") ?
        [[-1.135062,-0.5],[-1.135062,0],[-1.048323,0.015484],[-0.974284,0.058517],[-0.919162,0.123974],[-0.889176,0.206728],[-0.81721,0.579614],[-0.800806,0.653232],[-0.778384,0.72416],[-0.750244,0.792137],[-0.716685,0.856903],[-0.678005,0.918199],[-0.634505,0.975764],[-0.586483,1.029338],[-0.534238,1.078662],[-0.47807,1.123476],[-0.418278,1.16352],[-0.355162,1.198533],[-0.289019,1.228257],[-0.22015,1.25243],[-0.148854,1.270793],[-0.07543,1.283087],[-0.000176,1.28905],[0.075081,1.283145],[0.148515,1.270895],[0.219827,1.252561],[0.288716,1.228406],[0.354879,1.19869],[0.418018,1.163675],[0.477831,1.123623],[0.534017,1.078795],[0.586276,1.029452],[0.634307,0.975857],[0.677809,0.91827],[0.716481,0.856953],[0.750022,0.792167],[0.778133,0.724174],[0.800511,0.653236],[0.816857,0.579614],[0.888471,0.206728],[0.919014,0.123974],[0.974328,0.058517],[1.048362,0.015484],[1.135062,0],[1.135062,-0.5]] :
    (type == "HTD_5mm") ?
        [[-1.89036,-0.75],[-1.89036,0],[-1.741168,0.02669],[-1.61387,0.100806],[-1.518984,0.21342],[-1.467026,0.3556],[-1.427162,0.960967],[-1.398568,1.089602],[-1.359437,1.213531],[-1.310296,1.332296],[-1.251672,1.445441],[-1.184092,1.552509],[-1.108081,1.653042],[-1.024167,1.746585],[-0.932877,1.832681],[-0.834736,1.910872],[-0.730271,1.980701],[-0.62001,2.041713],[-0.504478,2.09345],[-0.384202,2.135455],[-0.259708,2.167271],[-0.131524,2.188443],[-0.000176,2.198511],[0.131296,2.188504],[0.259588,2.167387],[0.384174,2.135616],[0.504527,2.093648],[0.620123,2.04194],[0.730433,1.980949],[0.834934,1.911132],[0.933097,1.832945],[1.024398,1.746846],[1.108311,1.653291],[1.184308,1.552736],[1.251865,1.445639],[1.310455,1.332457],[1.359552,1.213647],[1.39863,1.089664],[1.427162,0.960967],[1.467026,0.3556],[1.518984,0.21342],[1.61387,0.100806],[1.741168,0.02669],[1.89036,0],[1.89036,-0.75]] :
    (type == "HTD_8mm") ?
        [[-3.301471,-1],[-3.301471,0],[-3.16611,0.012093],[-3.038062,0.047068],[-2.919646,0.10297],[-2.813182,0.177844],[-2.720989,0.269734],[-2.645387,0.376684],[-2.588694,0.496739],[-2.553229,0.627944],[-2.460801,1.470025],[-2.411413,1.691917],[-2.343887,1.905691],[-2.259126,2.110563],[-2.158035,2.30575],[-2.041518,2.490467],[-1.910478,2.66393],[-1.76582,2.825356],[-1.608446,2.973961],[-1.439261,3.10896],[-1.259169,3.22957],[-1.069074,3.335006],[-0.869878,3.424485],[-0.662487,3.497224],[-0.447804,3.552437],[-0.226732,3.589341],[-0.000176,3.607153],[0.226511,3.589461],[0.447712,3.552654],[0.66252,3.497516],[0.870027,3.424833],[1.069329,3.33539],[1.259517,3.229973],[1.439687,3.109367],[1.608931,2.974358],[1.766344,2.825731],[1.911018,2.664271],[2.042047,2.490765],[2.158526,2.305998],[2.259547,2.110755],[2.344204,1.905821],[2.411591,1.691983],[2.460801,1.470025],[2.553229,0.627944],[2.588592,0.496739],[2.645238,0.376684],[2.720834,0.269734],[2.81305,0.177844],[2.919553,0.10297],[3.038012,0.047068],[3.166095,0.012093],[3.301471,0],[3.301471,-1]] :
        undef;

/**
 * Renders debug info by rendering key/value pairs of a struct.
 *
 * @param data      Struct with info.
 */
module debug_info(data) {
    if (is_struct(data)) {
        lines = [
            str("Pulley for ", Type, " belt"),
            for (key = struct_keys(data))
                let (value = struct_val(data, key, undef))
                    str(key, ": ", value, is_num(value) ? "mm" : "")
                
        ];
    
        color("#AAAAAA")
        linear_extrude(height = 0.1)
            write(lines, size = 2);
    }
}
    
/**
 * Writes multiline text with proper spacing and alignment.
 *
 * @param lines       List of text strings (one per line).
 * @param font        Font name.
 * @param size        Font size.
 * @param spacing     Letter spacing.
 * @param lineheight  Line height.
 * @param halign      Horizontal alignment for each line ("left", "center", "right").
 * @param valign      Vertical alignment for the entire block ("top", "center", "bottom").
 */
module write(lines, font = "Liberation Sans", size = 4, spacing = 1, lineheight = 1, halign = "center", valign = "top") {
    // Compute font metrics and interline spacing
    fm = fontmetrics(size = size, font = font);
    interline = fm.interline * lineheight;
    n = len(lines);

    // Calculate total bounding box dimensions
    bbox = write_bounding_box(lines, font, size, spacing, interline);
    total_height = bbox[1];

    // Determine vertical offset for block alignment
    y_offset = 
        (valign == "top") ? 0 : 
        (valign == "center") ? -total_height / 2 : 
        -total_height;

    // Render text lines with appropriate alignment
    translate([0, -y_offset]) {
        for (i = [0 : n - 1]) {
            translate([0, -(interline * i + interline / 2)])
                text(
                    text = lines[i],
                    font = i == 0 ? str(font, ":style=Bold") : font,
                    size = size,
                    spacing = spacing,
                    halign = halign,
                    valign = "center"
                );
        }
    }
}

/**
 * Calculates the total bounding box for multiline text.
 *
 * @param lines       List of text strings (one per line).
 * @param font        Font name.
 * @param size        Font size.
 * @param spacing     Letter spacing.
 * @param interline   Interline spacing (height between lines).
 * @return A 2D vector containing the total width and height of the text block.
 */
function write_bounding_box(lines, font, size, spacing, interline) =
    [
        // Calculate the widest line
        max([for (line = lines) textmetrics(text = line, font = font, size = size, spacing = spacing).size.x]),
        // Calculate total height
        interline * len(lines)
    ];
