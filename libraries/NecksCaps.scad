// Necks & Caps for DIY projects
// Xavan June 2016
//https://www.thingiverse.com/thing:1654620


//***** Bouchons / Caps *****
//38mm3start ();
//28PCO1810 ();
//28PCO1881 ();
//TestMotif ();

//***** Goulots / Necks *****
//N38mm3start ();
//N28PCO1810 ();
//N28PCO1881 ();

//TestMotif (); // threadform test


//***** ************   *****
$fn=64;

module screw (Sta,End,Pas,Ray){ // filet - thread
Ste=5;//pas angulaire
//Pas mm/360°
//Ray rayon centre du motif
//Sta angle de départ
//End angle de fin   
for (Rz = [Sta:Ste:End]) {//Rz rotation Z
    a= Rz>Sta ? 1: 0;
    b= Rz<End ? 1: 0;
Ap=Pas*(Rz-Sta)/360;//Ap avancement du pas en Z
Ap1=Ap+Pas*Ste/360;//Ap1 avancement du pas en Z+1
hull (){
rotate ([0,0,Rz])translate([Ray,0,Ap])motif (a);
rotate ([0,0,Rz+Ste]) translate([Ray,0,Ap1])motif (b);
}
}
}
  

module motif (a){//trapeze - threadform
//$Z1 largeur base
//$Z2 largeur sommet
//$X1 distance base sommet  
// dans le plan x-z
cube([0.1,0.1,$Z1],true);
translate([-a*$X1,0,0])cube([0.1,0.1,$Z2],true);
} 


module bouchon (Rb,Hb,Ep,Nc){//cap
//Rb ray bouchon interieur
//Hb haut bouchon interieur
//Eb epais bouchon
//Nc nb crans

difference(){
   
translate ([0,0,(Hb+Ep)/2])cylinder(Hb+Ep, r=Rb+Ep, center=true);
        translate ([0,0,(Ep)/2])
        
translate ([0,0,Hb/2+Ep])cylinder(Hb, r=Rb, center=true);  
   
    }
    // crans
for (Rz = [0:360/Nc:360]) {
rotate ([0,0,Rz])translate ([Rb+Ep,0,Hb/2+Ep])cube([Ep/2,Ep,Hb],true);
}
    }
 
 module goulot (Rb,Hb,Ep){//neck
//Rb ray goulot exterieur
//Hb haut goulot 
//Eb epais goulot

difference(){
 union(){  
hull(){//exterieur
    translate ([0,0,Hb/2])cylinder(Hb, r=Rb-Ep/3, center=true);translate ([0,0,(Hb-Ep/3)/2])cylinder(Hb-Ep/3, r=Rb, center=true);
} 
     hull(){//base
    translate ([0,0,Ep/4])cylinder(Ep/2, r=Rb+Ep, center=true);
    translate ([0,0,Ep/2])cylinder(Ep, r=Rb, center=true); 
       }  
}     
translate ([0,0,Hb/2])cylinder(Hb, r=Rb-Ep, center=true); //interieur 
   
    }
    }    

module TestMotif (){
$Z1=2;//largeur base
$Z2=1;//largeur sommet
$X1=1;//distance base sommet (std 1.0)
hull(){
motif (1);
}
}

//****************BOUCHONS-CAPS*********************
module 38mm3start () {
jeu=0.5;//jeu
Ray=38/2+jeu;//rayon centre du motif
Pas=9;//pas de vis
Ep=1.5;//épaisseur bouchon
Ej=0;//épaisseur joint gasket
Dd=1.5+Ej+(Pas/3)/2;//distance demarrage depuis la base
Df=2;//distance fin
    
$Z1=2;//largeur base
$Z2=1;//largeur sommet
$X1=1;//distance base sommet (std 1.0)

translate([0,0,Ep+Dd]){
screw (0,180,Pas,Ray);
screw (120,300,Pas,Ray);
screw (240,420,Pas,Ray);
}
bouchon (Ray,Dd+Pas/2+Df,Ep,32);
}

module 28PCO1810 () {
jeu=0.5;//jeu
Ray=27.43/2+jeu;//rayon centre du motif
Pas=3.18;//pas de vis
Ep=1;//épaisseur bouchon
Ej=0;//épaisseur joint gasket
Dd=1.5+Ej+Pas/2;//distance demarrage depuis la base
Df=2;//distance fin
    
$Z1=2;//largeur base
$Z2=1;//largeur sommet
$X1=1.1;//distance base sommet (std 1.18)
    
translate([0,0,Ep+Dd]){
screw (0,720,Pas,Ray);
}
bouchon (Ray,Dd+2*Pas+Df,Ep,48);
}

module 28PCO1881 () {
jeu=0.5;//jeu
Ray=27.40/2+jeu;//rayon centre du motif
Pas=2.7;//pas de vis
Ep=1;//épaisseur bouchon
Ej=0;//épaisseur joint gasket
Dd=1.5+Ej+Pas/2;//distance demarrage depuis la base
Df=2;//distance fin
    
$Z1=1.8;//largeur base
$Z2=0.8;//largeur sommet
$X1=1.1;//distance base sommet (std 1.165)
    
translate([0,0,Ep+Dd]){
screw (0,650,Pas,Ray);
}
bouchon (Ray,Dd+2*Pas+Df,Ep,48);
}

//******************GOULOTS-NECKS*******************

module N28PCO1810  () {
Ray=25.07/2;//rayon externe
Pas=3.18;//pas de vis
Ep=1.7;//épaisseur bouchon
Dd=13;//hauteur depuis l'épaulement
Df=1.7;//distance fin
    
$Z1=2;//largeur base
$Z2=1;//largeur sommet
$X1=-1;//distance base sommet (std 1.0)

translate([0,0,Dd+Ep-Df-2*Pas-$Z1/2]){
screw (0,720,Pas,Ray);
}
goulot (Ray,Dd+Ep,Ep);
}

module N28PCO1881  () {
Ray=25.07/2;//rayon externe
Pas=2.7;//pas de vis
Ep=1.0;//épaisseur bouchon
Dd=10;//hauteur depuis l'épaulement
Df=1.7;//distance fin
    
$Z1=1.8;//largeur base
$Z2=0.8;//largeur sommet
$X1=-1.1;//distance base sommet (std 1.165)

translate([0,0,Dd+Ep-Df-650*Pas/360-$Z1/2]){
screw (0,650,Pas,Ray);
}
goulot (Ray,Dd+Ep,Ep);
}

module N38mm3start  () {
Ray=36/2;//rayon externe
Pas=9;//pas de vis
Ep=1.4;//épaisseur bouchon
Dd=9.2;//hauteur depuis l'épaulement
Df=1.5;//distance fin
    
$Z1=2;//largeur base
$Z2=1;//largeur sommet
$X1=-1;//distance base sommet (std 1.165)

translate([0,0,Dd+Ep-Df-Pas/2-$Z1/2]){
screw (0,180,Pas,Ray);
screw (120,300,Pas,Ray);
screw (240,420,Pas,Ray);
}
difference(){
    goulot (Ray,Dd+Ep,Ep);
    //biseautage
translate ([0,0,Dd])cylinder(h=2*Ep, r1=Ray-Ep, r2=Ray-Ep/1.5, center=true);
}
}
