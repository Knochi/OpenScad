/**********************************************************/
/* Malolo's screw-less / snap fit Raspberry Pi 4 Model B  */
/* Case                                                   */
/**********************************************************/
/*                                                        */
/* Use this script generator to customize your Raspberry  */
/* Pi case according to your needs.                       */
/*                                                        */
/**********************************************************/
/*                                                        */
/* Visit me on Thingiverse: :                             */
/*   -> https://www.thingiverse.com/Malolo                */
/*                                                        */
/**********************************************************/

/**********************************************************/
/* Configuration                                          */
/**********************************************************/

/* [Case Style] */

// Height

Case_Height = "default"; // [default:Default, _h20:H20 - 20mm board clearance, _h25:H25 - 25mm board clearance]

// Top

Top_Style = "logo_mm3"; // [logo_mm3:Logo - Three Materials, pihole_mm4:Pi-hole Logo - Four Materials]

/* [Fan Features] */

Fan_Type = "30mm"; // [30mm, 40mm]
Fan_Hole = false;
Fan_Mounting = "None"; // [none:None, screws:Screws, rails:Rails]

/* [Accessory Features] */

Cam_Slot = false;

/**********************************************************/
/* Case Generation                                        */
/**********************************************************/

Case_Height_Prefix = (Case_Height == "default") ? "" : Case_Height;

validation();

rotate(180, [0,1,0] ) {
    
    difference() {
        case_mesh();
        cam_slot_mesh();
    }
    
}

/**********************************************************/
/* Modules                                                */
/**********************************************************/

/*--------------------------------------------------------*/
/* Validation                                             */
/*--------------------------------------------------------*/

module validation() {
    
    // This validation aims to rule out combinations that
    // will most likly be problematic to print. Feel free
    // to remove them if you want to give it a try anyway.
    
}

/*--------------------------------------------------------*/
/* Case Style                                             */
/*--------------------------------------------------------*/

// Case

module case_mesh() {
    
    if (Top_Style == "logo_mm3") {
        import(str("z_top", Case_Height_Prefix, "_style_logo_mm3_c3_base.stl"));
    } else if (Top_Style == "pihole_mm4") {
        import(str("z_top", Case_Height_Prefix, "_style_pihole_mm4_c3_base.stl"));
    }
        
}

/*--------------------------------------------------------*/
/* Accessory Features                                     */
/*--------------------------------------------------------*/

module cam_slot_mesh() {

    if (Cam_Slot) {
    
        if (Fan_Type == "40mm" && (Fan_Hole || Fan_Mounting != "none")) {
            import(str("z_top", Case_Height_Prefix, "_cam_slot_fan40_cut.stl"));
        } else {
            import(str("z_top", Case_Height_Prefix, "_cam_slot_cut.stl"));
        }

    }
    
}