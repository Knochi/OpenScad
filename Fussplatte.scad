$fn=100;


materialStaerke=3;
fussHintenInnen=70;
fussVorneInnen=90;
fussLaengeInnen=200;

bottomMountingDiameter=4;
backholderhight=50;

hisize=4.8;

show="none"; //["links","rechts"]

fudge=0.1;


if(show=="links"){
difference(){

union(){
footPlate(materialStaerke);
holderLinks();
}


color("green")rotate([90,0,0])translate([(fussHintenInnen/2)-10,backholderhight-10,0])cylinder(h=fussVorneInnen,r=(hisize/2),center=true);

color("green")rotate([90,0,0])translate([fussLaengeInnen/2,(backholderhight/2)-15,0])cylinder(h=fussVorneInnen+10,r=(hisize/2),center=true);


}
}








module holderLinks(){
    
    union(){
    difference(){
    
    // hinten
    color("red")translate([(fussHintenInnen/2),0,(backholderhight/2)-(materialStaerke/2)])rotate([0,0,0])cylinder(h=backholderhight,r=(fussHintenInnen/2),center=true);
    color("red")translate([(fussHintenInnen/2),0,(backholderhight/2)-(materialStaerke/2)])rotate([0,0,0])cylinder(h=backholderhight,r=((fussHintenInnen-(2*materialStaerke))/2),center=true);
    color("pink")translate([(fussHintenInnen),0,(backholderhight/2)-(materialStaerke/2)])rotate([0,0,0])cube([fussHintenInnen+materialStaerke,fussHintenInnen+materialStaerke,backholderhight],center=true);
    }
    
    color("green")hull(){
    color("green")translate([((fussHintenInnen/2)-(materialStaerke/2)),-((fussHintenInnen/2)-(materialStaerke/2))+0.05,((backholderhight/2)/2)])cylinder(h=(backholderhight/2),r=(materialStaerke/2),center=true);
    color("green")translate([(fussLaengeInnen-((fussVorneInnen/2))),-((fussHintenInnen/2)-(materialStaerke/2)),((backholderhight/2)/2)])cylinder(h=(backholderhight/2),r=(materialStaerke/2),center=true);    
    }
    off=((fussVorneInnen)/2)-((fussHintenInnen)/2);
    color("blue")hull(){
    color("blue")translate([((fussHintenInnen/2)-(materialStaerke/2)),((fussHintenInnen/2)-(materialStaerke/2)),((backholderhight/2)/2)])cylinder(h=(backholderhight/2),r=(materialStaerke/2),center=true);
    color("blue")translate([(fussLaengeInnen-((fussVorneInnen/2))),((fussVorneInnen/2)-(materialStaerke/2))+off,((backholderhight/2)/2)])cylinder(h=(backholderhight/2),r=(materialStaerke/2),center=true);    
    }

    
    
    //innen
    //color("green")translate([(fussHintenInnen/2)-(materialStaerke/2),-(fussHintenInnen/2),0])cube([fussLaengeInnen-((fussHintenInnen/2)+(fussVorneInnen/2)),3,backholderhight/2]);
    //außen
    //poshinten=(fussHintenInnen/2)-materialStaerke;
    //posvorne=(fussVorneInnen/2)-materialStaerke;
    //diff=posvorne-poshinten;
    //echo("poshinten: ",poshinten);
    //echo("posvorne: ",posvorne);
    //echo("diff:",diff);
    //posdiff=fussLaengeInnen-((fussVorneInnen/2)+(fussHintenInnen/2));
    //echo("diffpos:",posdiff);
    //color("blue")translate([(fussHintenInnen/2)-(materialStaerke/2),(fussHintenInnen/2)-(materialStaerke),0])rotate([0,0,9.5])cube([fussLaengeInnen-((fussHintenInnen/2)+(fussVorneInnen/2)),3,backholderhight/2]);
    }
}

my= show=="links" ? 0 : 1;
!mirror([0,my,0]) footPlate(materialStaerke);
module footPlate(h,off=0){
    
    linear_extrude(h) difference(){
      platteShape();
      for (a =[-2:6])
        translate([((fussLaengeInnen/2)+-(a*10)),0,0])
          circle(r=(bottomMountingDiameter/2));  
    }
    
    //side guides
    difference(){
      linear_extrude(backholderhight/2,convexity=3) difference(){
        platteShape();
        offset(-materialStaerke) platteShape();
        translate([155,-45]) square([fussVorneInnen+off+fudge,100]);
      }
      translate([ 94.30, 44.48, backholderhight/4 ]) rotate([90,0,10]) cylinder(d=hisize,h=materialStaerke*2,center=true);
      translate([ 94.30, -(fussHintenInnen-materialStaerke)/2, backholderhight/4 ]) 
        rotate([90,0,0]) cylinder(d=hisize,h=materialStaerke*2,center=true);
    }
    
    //heel guide
    difference(){
      linear_extrude(backholderhight,convexity=3) difference(){
        platteShape();
        offset(-materialStaerke) platteShape();
        translate([35,-45]) square([200,100]);
      }
      translate([ 25, 0, backholderhight*0.75 ]) 
        rotate([90,0,0]) cylinder(d=hisize,h=fussHintenInnen+fudge,center=true);
    }
    
    // Bottom Mounting
    
    
    module platteShape(){
      hull(){
        translate([((fussHintenInnen+off)/2),0]) circle((fussHintenInnen+off)/2);
        translate([(fussLaengeInnen+off)-((fussVorneInnen/2)+off),((fussVorneInnen+off)/2)-((fussHintenInnen+off)/2)])
          circle(r=((fussVorneInnen+off)/2));
      }
}
}