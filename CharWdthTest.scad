/* [Text] */
text="HOLDENXXX";
maxWdth=50;

/* [Hidden] */
$fn=20;
charWdth=25/3; //width of one Monospace char with height of 10
textWdth=charWdth*len(text);

//limit to maximum width by scaling
sclng = (textWdth>maxWdth) ? maxWdth/textWdth : 1;
//reduce length of bars if textwidth is less than maxWdth
barLen= (textWdth>maxWdth) ? maxWdth : textWdth;
//text
translate([0,5,0]) 
  linear_extrude(3) 
    scale([sclng,1]) 
      text(text,font="Liberation Mono:style=Bold",valign="center");
//bars
translate([0,6.6,1.5]) rotate([0,90,0]) cylinder(d=2,h=barLen);
translate([0,3.3,1.5]) rotate([0,90,0]) cylinder(d=2,h=barLen);
