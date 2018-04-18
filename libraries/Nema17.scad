//kt  Nema 17 motor model

Nema17();

module Nema17(height = 43.3) {
  
  size = 42;   
  bevel1 = 5;
  bevel2 = 10;
  RecessDepth = 0.65;
  CenterRaisedZ = 2.25;
  ShaftCutoutDepth = 5;
  ShaftDiameter = 5;
  ShaftDiamFlat = 4.55;
  ShaftDiamDiff = ShaftDiameter-ShaftDiamFlat;
  ShaftLen = 22; //amount outside motor
  UnflattenedLen = 7;
  FlatLen = ShaftLen-UnflattenedLen+1;
      
  translate([0,0,-height/2+RecessDepth-CenterRaisedZ])
  union() {
    color("Gray")
    difference() {
      cube([size, size, height], center=true); //main block for motor
      union() {  //cut away corner bevels
        translate([size/2, size/2,0])
          rotate([0, 0, 45])
            cube([bevel1, bevel1, height+3], center=true);
        translate([size/2, -size/2,0])
          rotate([0, 0, 45])
            cube([bevel1, bevel1, height+3], center=true);
        translate([-size/2, size/2,0])
          rotate([0, 0, 45])
            cube([bevel1, bevel1, height+3], center=true);
        translate([-size/2, -size/2,0])
          rotate([0, 0, 45])
            cube([bevel1, bevel1, height+3], center=true);
      }  
      union() { //cut away corners of main body
         TopSolid = 10.65;
         BottomSolid = 11.65;
         Diff = abs(BottomSolid-TopSolid);
       
         translate([size/2, size/2, Diff/2])
          rotate([0, 0, 45])
            cube([bevel2, bevel2, height-TopSolid-BottomSolid], center=true);
         translate([size/2, -size/2, Diff/2])
          rotate([0, 0, 45])
            cube([bevel2, bevel2, height-TopSolid-BottomSolid], center=true);
         translate([-size/2, size/2, Diff/2])
          rotate([0, 0, 45])
            cube([bevel2, bevel2, height-TopSolid-BottomSolid], center=true);
         translate([-size/2, -size/2, Diff/2])
          rotate([0, 0, 45])
            cube([bevel2, bevel2, height-TopSolid-BottomSolid], center=true);
      }
      translate([0,0, -height/2-10+3.7])  //cutaway bottom shaft hole
        cylinder(r=8.8/2, h=10);
      translate([0,0,height/2-RecessDepth])  //cutaway top recess
        cylinder(r=32.65/2, h=1);
      translate([size/2-5, size/2-5, height/2-5], $fs=1) //cut away screw hole
        cylinder(r=2.4/2, h=5+1);
      translate([size/2-5, -size/2+5, height/2-5], $fs=1) //cut away screw hole
        cylinder(r=2.4/2, h=5+1);
      translate([-size/2+5, size/2-5, height/2-5], $fs=1) //cut away screw hole
        cylinder(r=2.4/2, h=5+1);
      translate([-size/2+5, -size/2+5, height/2-5], $fs=1) //cut away screw hole
        cylinder(r=2.4/2, h=5+1);
    }
    color("black")
    difference() { //top raised circle, with central shaft hole
      ShaftCutoutDepth = 5;
      translate([0,0,height/2-RecessDepth])
        cylinder(r=22/2, h=CenterRaisedZ);
      translate([0,0, height/2-RecessDepth+CenterRaisedZ-ShaftCutoutDepth+0.1])
        cylinder(r=7.75/2, h=ShaftCutoutDepth);
    }  
    difference() {  //drive shaft
      color("LightGray")
      translate([0, 0, height/2-RecessDepth])
        cylinder(r=ShaftDiameter/2, h=ShaftLen+RecessDepth+CenterRaisedZ, $fs=1);
      translate([ShaftDiameter- ShaftDiamDiff,0, height/2-RecessDepth+CenterRaisedZ+UnflattenedLen + FlatLen/2])
        cube([ShaftDiameter, ShaftDiameter, FlatLen], center=true);
    }  
    color("LightGray")
      translate([0, 0, -height/2+2.5])
        cylinder(r=ShaftDiameter/2, h=2, $fs=1);
    
  }  
}  