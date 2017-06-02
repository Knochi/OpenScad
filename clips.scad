//clip Dimensions
a=4;  //lever max width
b=2; // lever min width
l=25; //lever lenght
d=2; //hook length/ deflection
E=60; //for Plexiglas GS and XT in MPa
t=3; //thickness

// Equitations and explanations from 
// http://www.deferredprocrastination.co.uk/blog/2013/laser-cut-elastic-clipped-comb-joints/

// Force on the lever
// F=(d*E*t(a-b)³) / (4*l³)
// E is Young's modulus of Material
// t is thickness
F=(d*1e-3*E*t*1e-3*pow(a*1e-3-b*1e-3,3)) / 4*pow(l*1e-3,3); //this should result in 2.46N
echo("F=",F,"N");
// Pull through force (self unclipping)
// P=F*l/d
P=F*(l/d); //this should result in 30.72N
echo("P=",P,"N");

// Maximum Stress at the root
// sigma_max=(6*F*l)/(t*a²)
// 60MPa is stress limit for Acrylic
sigma_max=(6*F*l)/(t*pow(a,2)); //this should result in 7.68MPa
echo("Sigma max=",sigma_max,"MPa");