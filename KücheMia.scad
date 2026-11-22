wallThck=15;

//sockel
color("darkRed") cube([90,1000,120]);

//knoxhult
cube([580,wallThck,880]);
translate([0,600-wallThck,0]) cube([580,wallThck,880]);

//arbeitsplatte
color("brown") translate([0,-10,880]) cube([610,1200/2+20,29]);

//Spülmaschine
cube([])