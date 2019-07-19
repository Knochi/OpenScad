$fn=100;

dia=23;
xShift=7.5;
yShift=5.8;
wallThick=3;

targetDia=35;
fudge=0.1;

//outer

difference(){
    union(){
        translate([0,0,25]) cylinder(h=38,d=targetDia);
        hull(){
            translate([0,0,20]) cylinder(d=targetDia,h=5);
            linear_extrude(5)
                offset(r=2.75+wallThick) innerAEG();
        }
        translate([0,0,-38]) 
            linear_extrude(38) 
                offset(r=2.75+wallThick) innerAEG();
    }


    //inner
    union(){
        translate([0,0,25-fudge/2]) 
            cylinder(h=38.1,d=targetDia-2*wallThick);
        hull(){
            translate([0,0,20]) 
                cylinder(d=targetDia-2*wallThick,h=5);
            linear_extrude(5) offset(r=2.75) innerAEG();
        }
        translate([0,0,-38-fudge/2]) 
            linear_extrude(38.1) 
                offset(r=2.75) innerAEG();
    }
}

//test
*linear_extrude(5)
    difference(){
        offset(r=2.75+wallThick)
            innerAEG();
        offset(r=2.75)
            innerAEG();
    }

module innerAEG(){
    intersection(){
        intersection(){
            translate([0,5.8]) circle(dia);
            translate([0,-5.8]) circle(dia);
        }
        intersection(){
            translate([xShift,0]) circle(dia);
            translate([-xShift,0]) circle(dia);
        }
    }
}

