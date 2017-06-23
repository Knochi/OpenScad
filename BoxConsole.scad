use <slotter.scad>

$fn=50;
pi = 3.14159265;
fudge=0.1; 

sheetTh=3; //thickness of the sheet material
sideSheetTh=6;
baseX=150; //size of the base in X
baseY=150; //size of the base in Y

boxHg=50; //overall outer height of the box

//Radi

sideR1=8; //radius of the top edge
sideR2=1; //radius of the lower edge
sideAlpha=70;// angle of the front and back

bendWdth=(sideR1+sheetTh/2)*(pi/180)*sideAlpha; //width of the bend including "stretched length"    

// --- 2 radius geometry --
sideY = boxHg - sideR1 - sideR2; //translation in Y between R1 and R2

sideX1b= (sideR1-sideR2)/sin(sideAlpha); 
sideX2b= sideY / tan(sideAlpha);  
sideX3= sideR2/cos(sideAlpha); //length from center of R2 to tangent
sideX4= sideR2/tan(sideAlpha);

sideX = sideX1b +  sideX2b; //+ sideX3; //translation in X between R1 and R2 CHECK!
echo(sideX);
sideA1b= (sideR1-sideR2) / tan(sideAlpha);  //CHECK!
sideA2b= sideY/sin(sideAlpha); //CHECK!
sideA3= sideR2 / tan(sideAlpha); //CHECK!
sideA4= sideR2/sin(sideAlpha); //CHECK!

sideA = (sideA1b+sideA2b) + (sideA3 + sideA4); //length of the tangent + length to the ground //CHECK!


rotate([0,0,90]) translate([0,0,64.5-31.82]) import("DisplayKey.stl"); //DisplayKey Assembly

//ATSAMD21 EVAL
color("green") translate([0,-baseY/2+sideSheetTh,sideSheetTh/2+3]){
    translate([9.825,0,1.5]) cube([21.375-9.825,6,2.5]); //USB
    difference(){
        cube([60,100,1.5]); //PCB
        translate([2.35,2.35,-0.1]) cylinder(h=2,d=2.7,c=false);
        translate([2.35,100-2.35,-0.1]) cylinder(h=2,d=2.7,c=false);
        translate([60-2.35,2.35,-0.1]) cylinder(h=2,d=2.7,c=false);
        translate([60-2.35,100-2.35,-0.1]) cylinder(h=2,d=2.7,c=false);
    }
}

//!projection()
difference(){
    cube([baseX,baseY,sheetTh],true); //base Plate
    4drills(baseX/2,baseY-sideSheetTh,2.75,sheetTh+fudge,true);
    translate([30,-baseY/2+sideSheetTh+50,0]) 4drills(60-2*2.35,100-2*2.35,1.8,sheetTh+fudge,true);
}


//!projection() rotate([90,0,0]) sideWall();

//sideWall with cutouts for connectors
//!projection() rotate([90,0,0])
color("grey") translate([0,-baseY/2+sideSheetTh/2,0])
    difference(){
     sideWall();
     translate([9.825,(-sideSheetTh-fudge)/2,2+sheetTh/2]) cube([21.375-9.825,sideSheetTh+fudge,8]); //USB
     translate([-50,(-sideSheetTh-fudge)/2,sheetTh/2+3+5]) rotate([-90,0,0]) cylinder(h=sideSheetTh+fudge,d=6,c=false); //Piezo +
     translate([-35,(-sideSheetTh-fudge)/2,sheetTh/2+3+5]) rotate([-90,0,0]) cylinder(h=sideSheetTh+fudge,d=6,c=false); //Piezo -
     translate([-42.5,(-sideSheetTh-fudge)/2,sheetTh/2+3+5+13]) rotate([-90,0,0]) cylinder(h=sideSheetTh+fudge,d=10,c=false); //analog Out (BNC)
     translate([-10,(-sideSheetTh-fudge)/2,sheetTh/2+3+5]) rotate([-90,0,0]) cylinder(h=sideSheetTh+fudge,d=8,c=false); //DC in
        
    }
    
color("grey") translate([0,baseY/2-sideSheetTh/2,]) sideWall();


//!projection()
    color("lightgrey",0.1)
    difference(){
        cover();
        rotate ([0,0,90]) translate([0,0,64.5-31.82]) import("DisplayKey.stl"); //Display Key Assembly
        translate([0,0,boxHg+(-fudge+sheetTh)/2]) 4drills(baseX/2,baseY-sideSheetTh,2.75,sheetTh+fudge); //top drills
        translate([0,0,boxHg+(-fudge+sheetTh)/2]) 4drills(130,baseY-sideSheetTh,2.75,sheetTh+fudge); //side drills
        translate([0,0,boxHg+(-fudge+sheetTh)/2]) 4drills(200,baseY-sideSheetTh,2.75,sheetTh+fudge); //side drills
    }
    
module sideWall(){
    hull(){
        translate([baseX/2-sideR2-sheetTh-sideX,0,sheetTh/2+sideY+sideR2]) //R1 right
            rotate([90,0,0]) 
                //intersection(){
                    cylinder(h=sideSheetTh,r=sideR1,center=true);
                  //  translate([0,sideR1/2,0]) 
                    //    cube([sideR1*2+fudge,sideR1+fudge,5],true);
                //}
                //-(baseX/2-sideX-(sideX3+sideX4)-sideSheetTh)
        translate([-(baseX/2-sideR2-sheetTh)+sideX,0,sheetTh/2+sideY+sideR2]) //R1 left
            rotate([90,0,0]) 
                //intersection(){
                    cylinder(h=sideSheetTh,r=sideR1,center=true);
                  //  translate([0,sideR1/2,0]) 
                    //    cube([sideR1*2+fudge,sideR1+fudge,5],true);
                //}
        // small, bottom circles
        translate([-(baseX/2-sideR2-sheetTh),0,sheetTh/2+sideR2]) rotate([90,0,0]) cylinder(h=sideSheetTh,r=sideR2,center=true); //R2 left
        translate([baseX/2-sideR2-sheetTh,0,sheetTh/2+sideR2]) rotate([90,0,0]) cylinder(h=sideSheetTh,r=sideR2,center=true); //R2 right
        }//hull
        
}//module

module cover(){
    //straight middle part                       
    flatPart_mm = baseX- 2*(sideX-sideX3-sideX4) -sideR1 - 2*sheetTh; //CHECK!
    
    //                   | left side    |      right side           | 
    bendings_mm =             bendWdth    +   bendWdth; //CHECK
    sides_mm =            sideA  +   sideA; //CHECK 
   
    
    coverLength = flatPart_mm + bendings_mm + sides_mm; //CHECK, but without stretched length
    echo("Flat part:", flatPart_mm);
    echo("Cover length:", coverLength);
    //        to the bgn of the flat part - bendwidth - side
    Xtrans = -coverLength/2;
    //-baseX/2 + sheetTh + sideR1 - bendWdth - (sideY+sideR2); //tbverified
    
   translate([Xtrans,0,boxHg+(sheetTh)/2]) {
    //cube([baseX-sideX*2+bendW*2+sideA*2,baseY,sheetTh],center=true);
    difference(){
        translate([0,-baseY/2,0]) cube([coverLength,baseY,sheetTh]);
        
        translate([(coverLength-flatPart_mm-bendWdth/2)/2,0,sheetTh/2])rotate([0,0,90]) slotter(bendWdth,baseY,2,sheetTh,1.5,1.5); //right(front) slots
        translate([(coverLength+flatPart_mm+bendWdth/2)/2,0,sheetTh/2])rotate([0,0,90]) slotter(bendWdth,baseY,2,sheetTh,1.5,1.5); //left(back) slots
    }
  }
} //Cover


module 4drillsQ (square,drill,depth){
     translate([square,square,0]) cylinder(depth+0.1,d=drill,center=true);
   translate([-square,square,0]) cylinder(depth+0.1,d=drill,center=true);
   translate([square,-square,0]) cylinder(depth+0.1,d=drill,center=true);
   translate([-square,-square,0]) cylinder(depth+0.1,d=drill,center=true);
}

module 4drills (sizeX,sizeY,drill,depth,cntr=false){
    translate([sizeX/2,sizeY/2,0]) cylinder(depth,d=drill,center=cntr);
    translate([sizeX/2,-sizeY/2,0]) cylinder(depth,d=drill,center=cntr);
    translate([-sizeX/2,sizeY/2,0]) cylinder(depth,d=drill,center=cntr);
    translate([-sizeX/2,-sizeY/2,0]) cylinder(depth,d=drill,center=cntr);
}