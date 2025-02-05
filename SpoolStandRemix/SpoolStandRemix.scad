/* [show] */
showStand=true;
showLabel=true;
showCut=true;
showSwatch=true;
variant="normal"; //["normal","narrow"]
/* [Dimensions] */
ovDims= variant=="narrow" ? [72,150,35] : [74,150,35];
lblDims=[29.6,1.2,15];
lblSpcng=0.1;
lblLidLen=2;
lblLidWdth=24;

lblVertPos=[ovDims.x/2,0.8,1.0];

/* [label] */
Text="PLA";
Text_Style="Emboss"; //["Emboss", "Engrave", "Inset"]
Text_Size=8;
Text_Depth=0.4;
Text_Color="#000000"; //color
Back_Color="#00EEFF"; //color
Font_Face="Liberation Sans"; // ["Aldo", "Anton", "Archivo Black", "Asap", "Bangers", "Black Han Sans", "Bubblegum Sans", "Bungee", "Changa One", "Chewy", "Concert One", "Fruktur", "Gochi Hand", "Griffy", "HarmonyOS Sans SC", "Inter", "Inter Tight", "Itim", "Jockey One", "Kanit", "Kavoon", "Komikazoom", "Lato", "Liberation Sans", "Lilita One", "Lobster", "Lora", "Luckiest Guy", "Merriweather", "Merriweather Sans", "Mitr", "Montserrat", "Montserrat Alternates", "Montserrat Subrayada", "Nanum Pen", "Norwester", "Noto Emoji", "Noto Sans", "Noto Sans Adlam", "Noto Sans Adlam Unjoined", "Noto Sans Anatolian Hieroglyphs", "Noto Sans Arabic", "Noto Sans Arabic UI", "Noto Sans Armenian", "Noto Sans Avestan", "Noto Sans Balinese", "Noto Sans Bamum", "Noto Sans Bassa Vah", "Noto Sans Batak", "Noto Sans Bengali", "Noto Sans Bengali UI", "Noto Sans Bhaiksuki", "Noto Sans Brahmi", "Noto Sans Buginese", "Noto Sans Buhid", "Noto Sans Canadian Aboriginal", "Noto Sans Carian", "Noto Sans Caucasian Albanian", "Noto Sans Chakma", "Noto Sans Cham", "Noto Sans Cherokee", "Noto Sans Chorasmian", "Noto Sans Coptic", "Noto Sans Cuneiform", "Noto Sans Cypriot", "Noto Sans Cypro Minoan", "Noto Sans Deseret", "Noto Sans Devanagari", "Noto Sans Devanagari UI", "Noto Sans Display", "Noto Sans Duployan", "Noto Sans Egyptian Hieroglyphs", "Noto Sans Elbasan", "Noto Sans Elymaic", "Noto Sans Ethiopic", "Noto Sans Georgian", "Noto Sans Glagolitic", "Noto Sans Gothic", "Noto Sans Grantha", "Noto Sans Gujarati", "Noto Sans Gujarati UI", "Noto Sans Gunjala Gondi", "Noto Sans Gurmukhi", "Noto Sans Gurmukhi UI", "Noto Sans HK", "Noto Sans Hanifi Rohingya", "Noto Sans Hanunoo", "Noto Sans Hatran", "Noto Sans Hebrew", "Noto Sans Imperial Aramaic", "Noto Sans Indic Siyaq Numbers", "Noto Sans Inscriptional Pahlavi", "Noto Sans Inscriptional Parthian", "Noto Sans JP", "Noto Sans Javanese", "Noto Sans KR", "Noto Sans Kaithi", "Noto Sans Kannada", "Noto Sans Kannada UI", "Noto Sans Kawi", "Noto Sans Kayah Li", "Noto Sans Kharoshthi", "Noto Sans Khmer", "Noto Sans Khmer UI", "Noto Sans Khojki", "Noto Sans Khudawadi", "Noto Sans Lao", "Noto Sans Lao Looped", "Noto Sans Lao UI", "Noto Sans Lepcha", "Noto Sans Limbu", "Noto Sans Linear A", "Noto Sans Linear B", "Noto Sans Lisu", "Noto Sans Lycian", "Noto Sans Lydian", "Noto Sans Mahajani", "Noto Sans Malayalam", "Noto Sans Malayalam UI", "Noto Sans Mandaic", "Noto Sans Manichaean", "Noto Sans Marchen", "Noto Sans Masaram Gondi", "Noto Sans Math", "Noto Sans Mayan Numerals", "Noto Sans Medefaidrin", "Noto Sans Meetei Mayek", "Noto Sans Mende Kikakui", "Noto Sans Meroitic", "Noto Sans Miao", "Noto Sans Modi", "Noto Sans Mongolian", "Noto Sans Mono", "Noto Sans Mro", "Noto Sans Multani", "Noto Sans Myanmar", "Noto Sans Myanmar UI", "Noto Sans NKo", "Noto Sans NKo Unjoined", "Noto Sans Nabataean", "Noto Sans Nag Mundari", "Noto Sans Nandinagari", "Noto Sans New Tai Lue", "Noto Sans Newa", "Noto Sans Nushu", "Noto Sans Ogham", "Noto Sans Ol Chiki", "Noto Sans Old Hungarian", "Noto Sans Old Italic", "Noto Sans Old North Arabian", "Noto Sans Old Permic", "Noto Sans Old Persian", "Noto Sans Old Sogdian", "Noto Sans Old South Arabian", "Noto Sans Old Turkic", "Noto Sans Oriya", "Noto Sans Oriya UI", "Noto Sans Osage", "Noto Sans Osmanya", "Noto Sans Pahawh Hmong", "Noto Sans Palmyrene", "Noto Sans Pau Cin Hau", "Noto Sans PhagsPa", "Noto Sans Phoenician", "Noto Sans Psalter Pahlavi", "Noto Sans Rejang", "Noto Sans Runic", "Noto Sans SC", "Noto Sans Samaritan", "Noto Sans Saurashtra", "Noto Sans Sharada", "Noto Sans Shavian", "Noto Sans Siddham", "Noto Sans SignWriting", "Noto Sans Sinhala", "Noto Sans Sinhala UI", "Noto Sans Sogdian", "Noto Sans Sora Sompeng", "Noto Sans Soyombo", "Noto Sans Sundanese", "Noto Sans Syloti Nagri", "Noto Sans Symbols", "Noto Sans Symbols 2", "Noto Sans Syriac", "Noto Sans Syriac Eastern", "Noto Sans TC", "Noto Sans Tagalog", "Noto Sans Tagbanwa", "Noto Sans Tai Le", "Noto Sans Tai Tham", "Noto Sans Tai Viet", "Noto Sans Takri", "Noto Sans Tamil", "Noto Sans Tamil Supplement", "Noto Sans Tamil UI", "Noto Sans Tangsa", "Noto Sans Telugu", "Noto Sans Telugu UI", "Noto Sans Thaana", "Noto Sans Thai", "Noto Sans Thai Looped", "Noto Sans Thai UI", "Noto Sans Tifinagh", "Noto Sans Tirhuta", "Noto Sans Ugaritic", "Noto Sans Vai", "Noto Sans Vithkuqi", "Noto Sans Wancho", "Noto Sans Warang Citi", "Noto Sans Yi", "Noto Sans Zanabazar Square", "Nunito", "Nunito Sans", "Open Sans", "Open Sans Condensed", "Open Sans Hebrew", "Open Sans Hebrew Condensed", "Orbitron", "Oswald", "Palanquin Dark", "Passion One", "Patrick Hand", "Paytone One", "Permanent Marker", "Playfair Display", "Playfair Display SC", "Plus Jakarta Sans", "PoetsenOne", "Poppins", "Rakkas", "Raleway", "Raleway Dots", "Roboto", "Roboto Condensed", "Roboto Flex", "Roboto Mono", "Roboto Serif", "Roboto Slab", "Rubik", "Rubik 80s Fade", "Rubik Beastly", "Rubik Broken Fax", "Rubik Bubbles", "Rubik Burned", "Rubik Dirt", "Rubik Distressed", "Rubik Doodle Shadow", "Rubik Doodle Triangles", "Rubik Gemstones", "Rubik Glitch", "Rubik Glitch Pop", "Rubik Iso", "Rubik Lines", "Rubik Maps", "Rubik Marker Hatch", "Rubik Maze", "Rubik Microbe", "Rubik Mono One", "Rubik Moonrocks", "Rubik One", "Rubik Pixels", "Rubik Puddles", "Rubik Scribble", "Rubik Spray Paint", "Rubik Storm", "Rubik Vinyl", "Rubik Wet Paint", "Russo One", "Saira Stencil One", "Shrikhand", "Source Sans 3", "Spicy Rice", "Squada One", "Titan One", "Ubuntu", "Ubuntu Condensed", "Ubuntu Mono", "Ubuntu Sans", "Ubuntu Sans Mono", "Work Sans"]
Font_Style="Bold"; //["Light", "Regular", "Medium", "Bold", "ExtraBold"]

/* [Hidden] */
fudge=0.1;


if (showStand)
  difference(){
    stand();
    if (showCut) color("darkred") translate([ovDims.x,ovDims.y/2,ovDims.z/2]) cube(ovDims+[0.1,0.1,0.1],true);
    }
    
if (showLabel)
  color("grey") translate(lblVertPos+[-lblDims.x/2,0,0]) rotate([90,-90,180]) import("LabelToBeCustomized.stl");
  
module stand(){
  difference(){
    union(){
      if (variant=="narrow")
        import("SpoolStandNarrow.stl",convexity=4);
      else
        import("SpoolStand.stl",convexity=4);
      //close the angled slot
      *translate([ovDims.x/2,3.94,3.00]) cube([29,3.2,4],true);
    }
    
    //add an angled slot (but more to the back)
    *translate([ovDims.x/2,5.05,3.89]) rotate([-25,0,0]) cube([28,1.2,5],true);
    //cut out for front label
    translate([lblVertPos.x,(lblDims.y+lblVertPos.y)/2,5-(5-lblVertPos.z-2-fudge)/2]) 
      cube([lblDims.x+lblSpcng,lblDims.y+lblVertPos.y+lblSpcng*2,5-lblVertPos.z-2+fudge],true);
    translate(lblVertPos+[0,lblDims.y/2,1]) cube([24+lblSpcng*2,lblDims.y+lblSpcng*2,2+lblSpcng*2],true);
  }
}

!label();
module label(){
  rad=3;

  $fn=32;
  difference(){
    color(Back_Color) linear_extrude(lblDims.y){
      translate([0,lblLidLen]) square([lblDims.x,lblDims.z-lblLidLen-rad]);
      translate([rad,lblDims.z-rad]) square([lblDims.x-rad*2,rad]);
      for (ix=[0,1])
        translate([rad+ix*(lblDims.x-rad*2),lblDims.z-rad]) circle(r=rad);
      translate([(lblDims.x-lblLidWdth)/2,0]) square([lblLidWdth,lblLidLen]);
      
    }
  if (Text_Style=="Engrave") color(Text_Color) 
    translate([0,0,lblDims.y-Text_Depth]) linear_extrude(Text_Depth+fudge,convexity=3) txtLine();
  if (Text_Style=="Inset") color(Back_Color)
    translate([0,0,lblDims.y-Text_Depth*2]) linear_extrude(Text_Depth*2+fudge,convexity=3) txtLine();
  }
  if (Text_Style=="Emboss") color(Text_Color) 
    translate([0,0,lblDims.y]) linear_extrude(Text_Depth) txtLine();
  if (Text_Style=="Inset") color(Text_Color)
    translate([0,0,lblDims.y-Text_Depth*2]) linear_extrude(Text_Depth,convexity=3) txtLine();
  
}


module txtLine() {
    translate([lblDims.x/2,(lblDims.z+lblLidLen)/2,0]) 
        text(
            text = Text,
            font = str(Font_Face, ":style=", Font_Style),
            size = Text_Size,
            valign = "center",
            halign = "center"
        );
}


