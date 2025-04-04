/*
 * 2020profile.scad
 * v1.0.2 21st December 2017
 * Written by landie @ Thingiverse (Dave White)
 *
 * This script is licensed under the Creative Commons - Attribution license.
 * https://www.thingiverse.com/thing:2722504
 *
 * A parametised and customizable profile generator for 2020 and 2040 profiles
 * v1.0 2020 and 2040 profiles
 * v1.0.1 added 2080 profile
 * v1.0.2 made slot width customizable
 */
 
// The type of extrusion, 2020 or 2040
extrusionSize = "4040"; // [2020, 2040, 2080]

// The length of the extrusion
extrusionLength = 50;  // [1:300]

// The slot gap width
slotWidth = 6; //[4,5,6,7,8]

// The slot Style
slotStyle = "V-Slot"; //[T-Slot, V-Slot]

// The radius of the extrusion outer 4 corners
cornerRadius = 1.5;

// The diameter of the hole in the center(s) of the profile
centerDia = 4.19;

// The gap at the outside edge of each slot
slotGap = slotWidth + 0.26;

// The width at the largest point of each slot
slotMax = 11.99;

// The width and height of the square in the center of each profile
centerSquare = 7.31;

// The thickness of the outer walls 
outerWallThickness = 1.8;

// The thickness of the inner walls
innerWallThickness = 1.5;

wallThickness = 1.5;

// The width of the profile(s)
extrusionWidth = 20;

// The height of the profile(s)
extrusionHeight = 20;

/* [Hidden] */

if (extrusionSize == "2020") {
    linear_extrude(extrusionLength)
    profile2020();
}

if (extrusionSize == "2040") {
    linear_extrude(extrusionLength)
    profile2040();
}

if (extrusionSize == "2080") {
    linear_extrude(extrusionLength)
    profile2080();
}

if (extrusionSize == "4040") {
    linear_extrude(extrusionLength)
    profile4040();
}

module profile2020() {
  
    centerDia = (slotStyle=="V-Slot") ? 4.2 : centerDia;
    difference() {
        hull() {
            translate([-extrusionWidth / 2 + cornerRadius, extrusionHeight / 2 - cornerRadius])
            circle(r=cornerRadius, $fn = 60);
            translate([extrusionWidth / 2 - cornerRadius, extrusionHeight / 2 - cornerRadius])
            circle(r=cornerRadius, $fn = 60);
            translate([-extrusionWidth / 2 + cornerRadius, -extrusionHeight / 2 + cornerRadius])
            circle(r=cornerRadius, $fn = 60);
            translate([extrusionWidth / 2 - cornerRadius, -extrusionHeight / 2 + cornerRadius])
            circle(r=cornerRadius, $fn = 60);
        }
        circle(d = centerDia, $fn = 60);
        if (slotStyle == "T-Slot")
          for (angle = [45, 135, 225, 315]) {
              rotate(angle)
              translate([0, centerDia / 2])
              circle(d = innerWallThickness, $fn = 60);
          }
        for (angle = [0,90,180,270]) {
            rotate(angle)
            slot();
        }
    }
}

module profile2040() {
    difference() {
        union() {
            translate([0,extrusionHeight / 2])
                profile2020();
            translate([0,-extrusionHeight / 2])
                profile2020();
            roundedSquare(outerWallThickness / 4, extrusionWidth, slotGap);
        }
        joiner2CutOut();
    }
}

module profile4040() {
    difference() {
        union() {
            for (ix=[-1,1],iy=[-1,1]){
            translate([ix*extrusionHeight/2,iy*extrusionHeight / 2])
                profile2020();
            }
            
            roundedSquare(outerWallThickness / 4, extrusionWidth*2, slotGap);
            roundedSquare(outerWallThickness / 4, slotGap, extrusionWidth*2);
        }
        joiner4CutOut();
    }
}

module profile2080() {
    difference() {
        union() {
            translate([0,extrusionHeight])
                profile2040();
            translate([0,-extrusionHeight])
                profile2040();
            roundedSquare(outerWallThickness / 4, extrusionWidth, slotGap);
        }
        joiner2CutOut();
    }
}

module joiner2CutOut() {
        centerGap = ((extrusionWidth - slotMax) / 2 - innerWallThickness) * 2;
        roundedSquare(wallThickness / 4, extrusionWidth - wallThickness * 2, centerGap);
        difference() {
            circle(d = extrusionWidth - wallThickness, $fn = 4);
            roundedSquare(wallThickness / 4, extrusionWidth, centerGap);
            translate([0, extrusionHeight / 2])
            roundedSquare(wallThickness / 4, centerSquare, centerSquare);
            translate([0, -extrusionHeight / 2])
            roundedSquare(wallThickness / 4, centerSquare, centerSquare);
        }
}

module joiner4CutOut() {
        centerGap = ((extrusionWidth - slotMax) / 2 - innerWallThickness) * 2;
        
        for (ir=[0:90:270]) 
            rotate(ir) translate([extrusionWidth/2,0]){
                roundedSquare(wallThickness / 4, extrusionWidth - wallThickness * 2, centerGap);
                difference() {
                circle(d = extrusionWidth - wallThickness, $fn = 4);
                roundedSquare(wallThickness / 4, extrusionWidth, centerGap);
                translate([0, extrusionHeight / 2])
                    roundedSquare(wallThickness / 4, centerSquare, centerSquare);
                translate([0, -extrusionHeight / 2])
                    roundedSquare(wallThickness / 4, centerSquare, centerSquare);
                }
        }
        circle(d=extrusionWidth*2-centerSquare*sqrt(2),$fn=4);
}

module slot() {
  
    slotGap = (slotStyle=="V-Slot") ? 5.68 : slotGap;
  
    totalHeight = extrusionHeight / 2 - centerSquare / 2;
    difference() {
        translate([0,totalHeight / 2 + centerSquare / 2])
          square([slotMax, totalHeight], center = true);
        rotate(45)
            square([innerWallThickness, extrusionHeight * 1.5], center = true);
        rotate(-45)
            square([innerWallThickness, extrusionHeight * 1.5], center = true);
        translate([-extrusionWidth / 4 - slotGap / 2, totalHeight + centerSquare / 2 - outerWallThickness / 2])
            roundedSquare(outerWallThickness / 4, extrusionWidth / 2, outerWallThickness);
        translate([extrusionWidth / 4 + slotGap / 2, totalHeight + centerSquare / 2 - outerWallThickness / 2])
            roundedSquare(outerWallThickness / 4, extrusionWidth / 2, outerWallThickness);
    }
}

module roundedSquare(radius, width, height) {
    hull() {
        translate([width / 2 - radius, height / 2 - radius])
        circle(r = radius, $fn = 60);
        translate([-width / 2 + radius, height / 2 - radius])
        circle(r = radius, $fn = 60);
        translate([width / 2 - radius, -height / 2 + radius])
        circle(r = radius, $fn = 60);
        translate([-width / 2 + radius, -height / 2 + radius])
        circle(r = radius, $fn = 60);
    }
}