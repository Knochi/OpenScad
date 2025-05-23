use <Getriebe.scad>

$fn=50;

/*
ressources:

- https://eu.store.bambulab.com/de/collections/makers-supply/products/high-torque-drive-timing-belt

Ideas:
maybe move the servo away by using a belt and pulleys
https://makerworld.com/de/models/1102161-pulley-generator-parametric-timing-belt-pulleys?from=search#profileId-1097545
https://makerworld.com/de/models/1090724-belt-generator-parametric-timing-belts#profileId-1084172
*/

/* [Dimensions] */
binDims=[50,100,50];
plateDims=[150,100,2.4];
gearsThck=3;
smallPulleyDia=10.7;
bigPulleyDia=33.62;
pulleyHght=7;

/*[RackNPinion]*/
modulus=1;
rackLen=150;
pinTeeth=30;

/* [Test] */
binPosition=0; //[-0.5:0.1:0.5]

/*[Hidden]*/
dRitzel=modulus*pinTeeth;
uRitzel=PI*dRitzel;


//multibin plate
%translate([binPosition*rackLen,0,gearsThck+plateDims.z/2]) 
  translate([11.5-148/2,11.5-98/2,-6.4]) import("3x2 - Lite Multibin Panel.stl");

//servo with pulley
translate([150,dRitzel/2,0]) rotate([180,0,90]){
  color("grey") cylinder(d=bigPulleyDia,h=pulleyHght);
  translate([-5.4,0,-27.9]) rotate([90,0,0]) import("9g_servo_motor_with_clutch_prot.stl");
}

//rack
translate([binPosition*rackLen,0,0]) 
  zahnstange(modul=modulus, laenge=rackLen, hoehe=5, breite=gearsThck, eingriffswinkel = 20, schraegungswinkel = 0);


//pinion with pulley
translate([0,dRitzel/2,0]){
  stirnrad(modul=1, zahnzahl=pinTeeth, breite=gearsThck, bohrung=3, 
           eingriffswinkel = 20, schraegungswinkel = 0, optimiert = false);
  color("grey") translate([0,0,-pulleyHght]) cylinder(d=smallPulleyDia,h=pulleyHght);
}

*translate([0,dRitzel/2,5]) stirnrad(modul=1, zahnzahl=12, breite=gearsThck, bohrung=3, eingriffswinkel = 20, schraegungswinkel = 0, optimiert = false);


*translate([0,dRitzel/2+24,5]) stirnrad(modul=1, zahnzahl=36, breite=5, bohrung=3, eingriffswinkel = 20, schraegungswinkel = 0, optimiert = false);

//animate


//m=d/z