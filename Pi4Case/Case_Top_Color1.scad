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

Top_Style = "logo_sm"; // [base_sm:Plain - Single Material, base_mm2:Plain - Two Materials, logo_sm:Logo - Single Material, logo_mm2:Logo - Two Materials, logo_mm3:Logo - Three Materials, hex_sm:Hexagons - Single Material, hex_mm2:Hexagons - Two Materials, slots_sm:Slots - Single Material, mesh_sm:Mesh - Single Material, pihole_sm:Pi-hole Logo - Single Material, pihole_mm4:Pi-hole Logo - Four Materials]

// Front

Front_Style = "slots"; // [none>:None, slots:Slots, mesh:Mesh]

// Left

Left_Style = "rear_slots"; // [none>:None, rear_slots:Rear Slots, slots:Slots, mesh:Mesh]

// Right

Right_Style = "rear_slots"; // [none>:None, rear_slots:Rear Slots, slots:Slots, mesh:Mesh]

/* [Fan Features] */

Fan_Type = "30mm"; // [30mm, 40mm]
Fan_Hole = false;
Fan_Mounting = "None"; // [none:None, screws:Screws, rails:Rails]

/* [Accessory Features] */

Cam_Slot = false;
Disp_Slot = false;
Pin_Slot = false;

/**********************************************************/
/* Case Generation                                        */
/**********************************************************/

Case_Height_Prefix = (Case_Height == "default") ? "" : Case_Height;

validation();

rotate(180, [0,1,0] ) {
    
    difference() {
     
        union() {
            
            case_mesh();
            
            fan_hole_border_mesh();
            fan_screws_border_mesh();
            fan_rails_mesh();
            
            cam_slot_border_mesh();
            disp_slot_border_mesh();
            pin_slot_border_mesh();
            
        }
        
        front_mesh();
        left_mesh();
        right_mesh();
        
        fan_hole_mesh();
        fan_screws_mesh();
        
        cam_slot_mesh();
        disp_slot_mesh();
        pin_slot_mesh();
        
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
    
    assert(!Fan_Hole || Top_Style != "logo_sm", "Fan Hole can not be used with Logo style");
    
    assert(!Fan_Hole || Top_Style != "logo_mm2", "Fan Hole can not be used with Logo style");    
    
    assert(!Fan_Hole || Top_Style != "logo_mm3", "Fan Hole can not be used with Logo style");

    assert(!Fan_Hole || Top_Style != "pihole_sm", "Fan Hole can not be used with Logo style");

    assert(!Fan_Hole || Top_Style != "pihole_mm4", "Fan Hole can not be used with Logo style");

    assert(!Fan_Mounting != "rails" || Top_Style != "mesh_sm", "Fan Rails can not be used with Mesh style");
    
    assert(!Fan_Mounting != "rails" || Fan_Type != "40mm", "Pin Slot can not be used with 40mm Fan Rails");
    
}

/*--------------------------------------------------------*/
/* Case Style                                             */
/*--------------------------------------------------------*/

// Case

module case_mesh() {
    
    difference() {
        
        import(str("z_top", Case_Height_Prefix, "_base_sm.stl"));
        
        if (Top_Style == "logo_sm") {
            
            import(str("z_top", Case_Height_Prefix, "_style_logo_sm_cut.stl"));
            
        } else if (Top_Style == "logo_mm2") {
            
            import(str("z_top", Case_Height_Prefix, "_style_logo_mm2_c1_cut.stl"));
            
        } else if (Top_Style == "logo_mm3") {
            
            import(str("z_top", Case_Height_Prefix, "_style_logo_mm3_c1_cut.stl"));
            
        } else if (Top_Style == "hex_sm") {
            
            if (Fan_Hole) {
                
                if (Fan_Type == "30mm") {
                    import(str("z_top", Case_Height_Prefix, "_style_hex_sm_fan30_cut.stl"));
                } else {
                    import(str("z_top", Case_Height_Prefix, "_style_hex_sm_fan40_cut.stl"));
                }
                
            } else {
                
                import(str("z_top", Case_Height_Prefix, "_style_hex_sm_cut.stl"));
                
            }
            
        } else if (Top_Style == "hex_mm2") {
            
            if (Fan_Hole) {
                
                if (Fan_Type == "30mm") {
                    import(str("z_top", Case_Height_Prefix, "_style_hex_mm2_c1_fan30_cut.stl"));
                } else {
                    import(str("z_top", Case_Height_Prefix, "_style_hex_mm2_c1_fan40_cut.stl"));
                    
                }
                
            } else {

                import(str("z_top", Case_Height_Prefix, "_style_hex_mm2_c1_cut.stl"));
                
            }
            
        } else if (Top_Style == "slots_sm") {
            
            if (Fan_Hole) {
                
                if (Fan_Type == "30mm") {

                    if (Pin_Slot) {
                        import(str("z_top", Case_Height_Prefix, "_style_slots_sm_fan30_pin_slot_cut.stl"));
                    } else {
                        import(str("z_top", Case_Height_Prefix, "_style_slots_sm_fan30_cut.stl"));
                    }
                        
                } else {

                    if (Pin_Slot) {
                        import(str("z_top", Case_Height_Prefix, "_style_slots_sm_fan40_pin_slot_cut.stl"));
                    } else {
                        import(str("z_top", Case_Height_Prefix, "_style_slots_sm_fan40_cut.stl"));
                    }
                    
                }
                
            } else {
                
                if (Pin_Slot) {
                    import(str("z_top", Case_Height_Prefix, "_style_slots_sm_pin_slot_cut.stl"));
                } else {
                    import(str("z_top", Case_Height_Prefix, "_style_slots_sm_cut.stl"));
                }
                
            }
            
        } else if (Top_Style == "mesh_sm") {
            
            import(str("z_top", Case_Height_Prefix, "_style_mesh_sm_cut.stl"));
            
        } else if (Top_Style == "pihole_sm") {
            
            import(str("z_top", Case_Height_Prefix, "_style_pihole_sm_cut.stl"));
            
        } else if (Top_Style == "pihole_mm4") {
            
            import(str("z_top", Case_Height_Prefix, "_style_pihole_mm4_c1_cut.stl"));
            
        }
        
    }
        
}

// Front

module front_mesh() {
    
    if (Front_Style == "slots") {
        
        import(str("z_top", Case_Height_Prefix, "_front_slots_cut.stl"));
        
    } else if (Front_Style == "mesh") {
    
        import(str("z_top", Case_Height_Prefix, "_front_mesh_cut.stl"));
    
    }
    
}

// Left

module left_mesh() {
    
    if (Left_Style == "rear_slots") {
    
        import(str("z_top", Case_Height_Prefix, "_left_rear_slots_cut.stl"));
        
    } else if (Left_Style == "slots") {
    
        import(str("z_top", Case_Height_Prefix, "_left_slots_cut.stl"));
    
    } else if (Left_Style == "mesh") {
    
        import(str("z_top", Case_Height_Prefix, "_left_mesh_cut.stl"));
    
    }
    
}

// Right

module right_mesh() {
    
    if (Right_Style == "rear_slots") {
    
        import(str("z_top", Case_Height_Prefix, "_right_rear_slots_cut.stl"));
        
    } else if (Right_Style == "slots") {
    
        import(str("z_top", Case_Height_Prefix, "_right_slots_cut.stl"));
    
    } else if (Right_Style == "mesh") {
    
        import(str("z_top", Case_Height_Prefix, "_right_mesh_cut.stl"));
    
    }
    
}

/*--------------------------------------------------------*/
/* Fan Features                                           */
/*--------------------------------------------------------*/

module fan_hole_mesh() {
    
    if (Fan_Hole) {

        if (Fan_Type == "30mm") {
            
            if (Top_Style == "base_mm2" || Top_Style ==  "hex_mm2") {
                import(str("z_top", Case_Height_Prefix, "_fan30_hole_border_mm2_c1_cut.stl"));
            } else {
                import(str("z_top", Case_Height_Prefix, "_fan30_hole_cut.stl"));
            }
            
        } else {

            if (Top_Style == "base_mm2" || Top_Style ==  "hex_mm2") {
                import(str("z_top", Case_Height_Prefix, "_fan40_hole_border_mm2_c1_cut.stl"));
            } else {
                import(str("z_top", Case_Height_Prefix, "_fan40_hole_cut.stl"));
            }
        }

    }
    
}

module fan_hole_border_mesh() {
    
    if (Fan_Hole) {
        
        if (Fan_Type == "30mm") {
          import(str("z_top", Case_Height_Prefix, "_fan30_hole_border_sm.stl"));
        } else {
            import(str("z_top", Case_Height_Prefix, "_fan40_hole_border_sm.stl"));
        }
        
    }
    
}

module fan_screws_mesh() {
    
    if (Fan_Mounting == "screws") {
        
        if (Fan_Type == "30mm") {
            import(str("z_top", Case_Height_Prefix, "_fan30_screws_cut.stl"));
        } else {
            import(str("z_top", Case_Height_Prefix, "_fan40_screws_cut.stl"));
        }
            
    }
    
}

module fan_screws_border_mesh() {

    if (Fan_Mounting == "screws") {

        if (Fan_Type == "30mm") {
            import(str("z_top", Case_Height_Prefix, "_fan30_screws_border.stl"));
        } else {
            import(str("z_top", Case_Height_Prefix, "_fan40_screws_border.stl"));
        }

    }

}

module fan_rails_mesh() {
    
    if (Fan_Mounting == "rails") {
        
        if (Fan_Type == "30mm") {
            import(str("z_top", Case_Height_Prefix, "_fan30_rails.stl"));
        } else {
            import(str("z_top", Case_Height_Prefix, "_fan40_rails.stl"));
        }
            
    }
    
}

/*--------------------------------------------------------*/
/* Accessory Features                                     */
/*--------------------------------------------------------*/

module cam_slot_mesh() {
    
    if (Cam_Slot) {
        
        if (Top_Style == "hex_sm" || Top_Style == "hex_mm2") {
            
            if (Fan_Type == "40mm" && (Fan_Hole || Fan_Mounting != "none")) {
                import(str("z_top", Case_Height_Prefix, "_cam_slot_style_hex_fan40_cut.stl"));
            } else {
                import(str("z_top", Case_Height_Prefix, "_cam_slot_style_hex_cut.stl"));
            }
            
        } else if (Top_Style == "slots_sm") {

            if (Fan_Type == "40mm" && (Fan_Hole || Fan_Mounting != "none")) {
                import(str("z_top", Case_Height_Prefix, "_cam_slot_style_slots_fan40_cut.stl"));
            } else {
                import(str("z_top", Case_Height_Prefix, "_cam_slot_style_slots_cut.stl"));
            }

        } else {

            if (Fan_Type == "40mm" && (Fan_Hole || Fan_Mounting != "none")) {
                import(str("z_top", Case_Height_Prefix, "_cam_slot_fan40_cut.stl"));
            } else {
                import(str("z_top", Case_Height_Prefix, "_cam_slot_cut.stl"));
            }

        }
        
    }
    
}

module cam_slot_border_mesh(show) {

    if (Cam_Slot) {
        
        if (Top_Style == "mesh_sm") {
            
            if (Fan_Type == "40mm" && (Fan_Hole || Fan_Mounting != "none")) {
                import(str("z_top", Case_Height_Prefix, "_cam_slot_fan40_border.stl"));
            } else {
                import(str("z_top", Case_Height_Prefix, "_cam_slot_border.stl"));
            }
            
        }
        
    }

}

module disp_slot_mesh() {
    
    if (Disp_Slot) {
        
        import(str("z_top", Case_Height_Prefix, "_disp_slot_cut.stl"));
        
    }
    
}

module disp_slot_border_mesh() {
    
    if (Disp_Slot) {
        
        if (Top_Style == "mesh_sm") {
            import(str("z_top", Case_Height_Prefix, "_disp_slot_border.stl"));
        }
        
    }
    
}

module pin_slot_mesh() {
    
    if (Pin_Slot) {
        
        import(str("z_top", Case_Height_Prefix, "_pin_slot_cut.stl"));
        
    }
    
}

module pin_slot_border_mesh() {
    
    if (Pin_Slot) {
        
        if (Top_Style == "mesh_sm") {
            import(str("z_top", Case_Height_Prefix, "_pin_slot_border.stl"));
        }
            
    }
    
}