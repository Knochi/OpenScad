difference(){
    cube([40,50,3],true);
    slotter(25,40,3,3,1.5,1.5);
}

module slotter(linkW, linkL, columns, sheetT, slotW, beamW) { //linkage length/width, sheet thickness, min. clearance, beam width
    $fn=50;
    col=columns;
    fudge=0.1;
    //L = 2*length+2*thickn;
    calcRows = (linkW-beamW-1)/(slotW+beamW)-1;
    echo ("calcRows",calcRows);
    row = ceil(calcRows);
    calcSlotW = slotW; //((linkW-beamW-1)/row)-beamW+1;
    echo("calcSlotW",calcSlotW);
    slotL = linkL/col-beamW*2;
    echo("length of link", linkL);
    echo("link rows",row);
    echo("slot Len",slotL);
    
    intersection(){
        translate([-linkL/2,-(row)*(calcSlotW+beamW)/2,0])
        
        for (j=[0:col]){ //colums
        //echo("j",j);
            for (i=[0:row]){
            //echo("row",i,i%2);
                translate([(beamW*2+slotL)*j+(slotL/2+beamW)*(i%2),i*(beamW+calcSlotW),0])
                
                union(){
                    translate([-(slotL-calcSlotW)/2,0,0]) cylinder(h=sheetT+fudge,d=calcSlotW,center=true);
                    translate([(slotL-calcSlotW)/2,0,0]) cylinder(h=sheetT+fudge,d=calcSlotW,center=true);
                    cube([slotL-calcSlotW,calcSlotW,sheetT+fudge],true);
                    
                    if ((i%2) && (j==0) ){ 
                        translate([-(slotL-calcSlotW)/2,0,0])
                        difference(){
                            cylinder(h=sheetT+fudge,d=calcSlotW*3+beamW*2,center=true);
                            cylinder(h=sheetT+fudge*2,d=calcSlotW+beamW*2,center=true);
                            translate([(calcSlotW*3+beamW*2)/2,0,0]) cube([calcSlotW*3+beamW*2+fudge,calcSlotW*3+beamW*2+fudge,sheetT+fudge*2],true);
                            if (i==row) translate([0,(calcSlotW*3+beamW*2)/2,0]) //if last row
                                            cube([calcSlotW*3+beamW*2+fudge,calcSlotW*3+beamW*2+fudge,sheetT+fudge*2],true);
                        }
                    }
                    if ((i%2) && (j==col-1)){ 
                        translate([(slotL-calcSlotW)/2,0,0])
                        difference(){
                            cylinder(h=sheetT+fudge,d=calcSlotW*3+beamW*2,center=true);
                            cylinder(h=sheetT+fudge*2,d=calcSlotW+beamW*2,center=true);
                            translate([(-calcSlotW*3-beamW*2)/2,0,0]) cube([calcSlotW*3+beamW*2+fudge,calcSlotW*3+beamW*2+fudge,sheetT+fudge*2],true);
                            if (i==row) translate([0,(calcSlotW*3+beamW*2)/2,0]) //if last row
                                            cube([calcSlotW*3+beamW*2+fudge,calcSlotW*3+beamW*2+fudge,sheetT+fudge*2],true);
                        }
                    }
                    if (i==0) { //if first row
                        if (j==col) //if last column
                            translate([-beamW,-calcSlotW/2-beamW,0])
                                difference(){
                                    translate([0,0,-(sheetT+fudge)/2]) cube([beamW+fudge,beamW+fudge,sheetT+fudge]);
                                    cylinder(h=sheetT+fudge*2,d=beamW*2,center=true);
                                }
                        if (j==0) //if first column
                            translate([beamW,-calcSlotW/2-beamW,0])
                                difference(){
                                    translate([-beamW-fudge,0,-(sheetT+fudge)/2]) cube([beamW+fudge,beamW+fudge,sheetT+fudge]);
                                    cylinder(h=sheetT+fudge*2,d=beamW*2,center=true);
                                }
                    }
                    
                    if ((i==row)&& !(i%2)){ //if last row is odd
                        if (j==col) //if last column
                            translate([-beamW,calcSlotW/2+beamW,0])
                                difference(){
                                    translate([0,-beamW-fudge,-(sheetT+fudge)/2]) cube([beamW+fudge,beamW+fudge,sheetT+fudge]);
                                    cylinder(h=sheetT+fudge*2,d=beamW*2,center=true);
                                }
                        if (j==0) //if first column
                            translate([beamW,calcSlotW/2+beamW,0])
                                difference(){
                                    translate([-beamW-fudge,-beamW-fudge,-(sheetT+fudge)/2]) cube([beamW+fudge,beamW+fudge,sheetT+fudge]);
                                    cylinder(h=sheetT+fudge*2,d=beamW*2,center=true);
                                }
                    }
                    
                
                }
      
            }
        }
    cube([linkL+fudge,linkW+fudge,sheetT+fudge],true); //cut slots
    }
}