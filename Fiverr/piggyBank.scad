// Use preview just for checking the font style, size... Change it to print before exporting the STL, so it is ready to print in place.
mode = "preview";  // [preview, print]
name = "Anton";
font = "Anton"; // [Anton, Archive Black, Asap, Bangers, Black Han Sans, Bubblegum Sans, Bungee, Change One, Chewy, Concert One, Fruktur, Gochi Hand, Griffy, Harmony OS Sans SC, Inter, Item, Jockey One, Jungle Fever, Kanit, Kavoon, Komikazoom, Lato, Lilita One, Lora, Luckiest Guy, Merriweather Sans, Mitr, Montserrat, Nanum Pen Script, Noto Sans SC, Nunito, Open Sans, Oswald, Palanquin Dark, Passion One, Patrick Hand, Paytone One, Permanent Marker, Playfair Display, Plus Jakarta Sans, Poetesen, Poppins, Rakkas, Raleway, Roboto, Rowdies, Rubik, Russo One, Saira Stencil One, Shrikhand, Source Sans 3, Squada One, Titan One, Ubuntu Sans, Work Sans]
textSize = 40;

// The height of the box
extrudeHeight = 40;  // Adjusted for a hucha

// Diameter of the hole for adding the leds
coinLidHoleDiameter = 30;

// Width of the coin slot
coinSlotWidth = 5;
// Length of the coin slot
coinSlotLength = 35;

// If enabled, will fill the gaps in the text when a space is added
flatBase = false;

/* [Colors options] */
// Color for the box
boxColor = "#9DC7C8"; // color
// Color for the font
fontColor = "#F39237"; // color

/* [Expert options] */
baseWidth = 1.5;
offsetValue = textSize / 4; // Increase/decrease the space surrounding the text
coinHoleXOffset = 0;  // Offset for the coin hole in the X-axis
coinHoleYOffset = 0;  // Offset for the coin hole in the Y-axis
coinSlotYOffset = 0; // Y offset for the coin slot
lidStep = 5;
nameLayerHeight = 0.8;  // Height of the layer containing the text
lidSecureClipLength = 5; // Length of the clips that hold the coins lid
lidSecureClipWidth = 10;
coinLidBaseWidth = 0.5;
coinLidBaseExtraRadius = 5;
coinLidHeight = baseWidth - 1;
notchHeight = 4;
// Modify it for adjusting the tolerance between the box and the coin lid
coinLidTolerance = 0.15;
// If enabled, will fill the gaps in the text
fillGaps = true;

/* [Hidden] */
$fn = 100;  // Increase the resolution of the circle
offsetDecrease = 2;  // Configuration for the new smaller offset
notchLength = (lidSecureClipLength - 1);
notchWidth = lidSecureClipWidth / (30/coinLidHoleDiameter);

metrics = textmetrics(name, size = textSize, font = font);
text_width = metrics.size.x;
text_height = metrics.size.y;
descent = -metrics.descent;
ascent = metrics.ascent;
position = metrics.position;
half_text_width = text_width / 2;
x_translation = -half_text_width - position.x;
y_translation = -textSize * 2 - 5 + position.y;

lowMetrics = textmetrics("-", size = textSize, font = font);
lowAscent = lowMetrics.ascent;

fudge=0.1;

*text("HALLO",font="Anton");

//box 
translate([x_translation, 0, 0]) {
    color(boxColor) {
        union() {
            difference(){
                //body
                union(){
                    difference() {
                        extruded_text(extrudeHeight - lidStep, offsetValue);
                        #translate([0, 0, baseWidth]) {
                            extruded_text(extrudeHeight - baseWidth - nameLayerHeight, offsetValue - offsetDecrease);
                        }
                        //coin slot
                        translate([half_text_width + coinSlotYOffset, ascent / 2, (extrudeHeight - coinSlotLength) / 2]) {
                            coin_slot();
                        }
                    }
                    translate([half_text_width + position.x + coinHoleXOffset, coinLidHoleDiameter / 2 + coinHoleYOffset, baseWidth]) {
                        rotate([0,0,50]){
                            translate([(-coinLidHoleDiameter - lidSecureClipLength - 5) / 2, -coinLidHoleDiameter / 4, 0]) {
                                cube([coinLidHoleDiameter + lidSecureClipLength + 5, lidSecureClipWidth, baseWidth*2.5]);
                            }
                        }
                    }
                }
                translate([half_text_width + position.x + coinHoleXOffset, coinLidHoleDiameter / 2 + coinHoleYOffset, 0]) {  
                    center_circle();
                }
            }
            translate([0, 0, extrudeHeight - lidStep]) {
                difference() {
                    extruded_text(lidStep, offsetValue - offsetDecrease / 2);
                    extruded_text(lidStep+fudge, offsetValue - offsetDecrease);
                }
            }
        }
    }
}

//coin lid
translate([0, text_height + coinLidHoleDiameter + 10, 0]) {
    coin_lid();
}


//box lid in two modes
if (mode != "preview") {
    translate([x_translation, y_translation/2, lidStep + nameLayerHeight]) {
        rotate([180, 0, 0]) {
            difference() {
                extruded_text(lidStep, offsetValue);
                translate([0, 0, 0]) {
                    extruded_text(lidStep, offsetValue - offsetDecrease / 2 + 0.05);
                }
            }
            translate([0.01 /2, 0, lidStep]) {
                offset_text_piece();
                translate([0, 0, 0.02]) {
                    text_with_color();
                }
            }
        }
    }
} else {
    translate([x_translation, y_translation, 0]) {
        difference() {
            extruded_text(lidStep, offsetValue);
            translate([0, 0, 0]) {
                extruded_text(lidStep, offsetValue - offsetDecrease / 2 + 0.05);
            }
        }
        translate([0, 0, lidStep]) {
            offset_text_piece();
            text_with_color();
        }
    }
}

module extruded_text(extrude_h, offset_v) {
    color(boxColor) {
        linear_extrude(extrude_h,convexity=4) {
            offset(offset_v) {
                fill(){
                    text(name, size = textSize, font = font);
                }
                if (flatBase == true) {
                    draw_base_rectangle();
                } 
                if (fillGaps == true) {
                    draw_gaps_rectangle();
                }
            }
        }
    }
}

module text_with_color() {
    color(fontColor) {
        linear_extrude(nameLayerHeight + 0.01) {
            text(name, size = textSize, font = font);
        }
    }
}

module offset_text_piece() {
    difference() {
        extruded_text(nameLayerHeight, offsetValue);
        text_with_color();
    }
}

module center_circle() {
    union() {
        cylinder(h = baseWidth * 4, d = coinLidHoleDiameter, center = false);
        translate([(-coinLidHoleDiameter - lidSecureClipLength) / 2, -coinLidHoleDiameter / 4, 0]) {
            cube([coinLidHoleDiameter + lidSecureClipLength, coinLidHoleDiameter / 2, baseWidth * 4]);
        }
    }
}

module draw_base_rectangle() {
    translate([position.x, position.y, 0]) {
        square([text_width, descent]);
    }
}

module draw_gaps_rectangle() {
    startFinishOffset = offsetValue;
    translate([position.x + startFinishOffset, position.y + descent + lowAscent / 2, 0]) {
        square([text_width - startFinishOffset * 2, lowAscent]);
    }
}

module coin_slot() {
    cube([coinSlotWidth, ascent, coinSlotLength]);
}

module notch(){
    translate([0, 0, coinLidBaseWidth + coinLidHeight]){
        rotate_extrude(angle= widthtoangle(notchWidth)){
            translate([coinLidHoleDiameter/2 - 1.5, 0, 0]){
                polygon([[0,0],[0,notchHeight],[notchLength,notchHeight]]);
            }
        }
    }
}
function widthtoangle(width) = width/(PI*coinLidHoleDiameter/2/180);

module coin_lid() {
    color(boxColor) {
        difference(){
            union(){
                cylinder(coinLidBaseWidth + coinLidHeight + notchHeight, d = coinLidHoleDiameter - coinLidTolerance);
                linear_extrude(height = coinLidBaseWidth){
                    circle(d = coinLidHoleDiameter + coinLidBaseExtraRadius * 2);
                }
                for(i = [0:2]){
                    rotate([0,0,i*(360/2)]){
                        notch();
                    }
                }
            };
            translate([0, 0, -1]){
                linear_extrude(height = 4){
                    difference(){
                        circle(d = coinLidHoleDiameter-5);
                        square([coinLidHoleDiameter-5, 5], true);
                    }
                }
            };
        }
    }
}


