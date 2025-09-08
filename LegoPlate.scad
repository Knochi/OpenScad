// Simple LEGO pattern


/* [studs] */
studCount=[5,5];
studDia=4.85;
studHght=1.85;
studSpcng=8;

/* [Hidden] */
$fn=48;

plateDims=[studCount.x*studSpcng,studCount.y*studSpcng,1.2];
plateRad=studSpcng/2;

linear_extrude(plateDims.z) hull() for (ix=[-1,1],iy=[-1,1])
  translate([ix*(plateDims.x/2-plateRad),iy*(plateDims.y/2-plateRad)]) circle(plateRad);

translate([0,0,plateDims.z]) studs(studCount,true);
  
  
module studs(count=[4,4], center=true){
  cntrOffset= center ? [-studSpcng*(count.x-1)/2,-studSpcng*(count.y-1)/2,0] : [0,0,0];
  translate(cntrOffset)
    for (ix=[0:count.x-1],iy=[0:count.y-1])
      translate([ix*studSpcng,iy*studSpcng,0]) cylinder(d=studDia,h=studHght);
}