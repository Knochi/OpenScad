fudge=0.1;
MGN9();
translate([0,-50,0]) MGW12();
translate([0,-100,0]) MGN12();

module MGN9(length=300,pos=0.2,type="H",center=true){
  //KGT rails
  //https://de.aliexpress.com/item/1000007480470.html?spm=a2g0o.cart.0.0.44b33c00RwKj19&mp=1&gatewayAdapt=glo2deu
  
  // travel length is rail_length-block_length(L)!

  //ASY
  H=10; //overall Height
  H1=2; //z-spacing under block
  N=5.5; //y-spacing under block

  //Block Dimensions
  W=20;
  B=15;
  B1=2.5;

  //type "H" or "C"
  C= (type=="H") ? 16 : 10; //Block Drill distance X
  L1=(type=="H") ? 29.9 : 18.9; //Block length of contact plate
  L= (type=="H") ? 39.9 : 28.9; //Block overall length
  Gs=1.4;
  MxL=[3,3];

  travel=length-L;
  if ($children)
    translate([-travel/2+pos*travel,0,0]) children();
  else{
    color("silver") rail();
    color("lightGrey") translate([-travel/2+pos*travel,0,H1]) block();
  }

  module rail(){
    wr=9; //width of rail
    hr=6.5; //height of rail
    P=20; //drill hole Pitch
    E=7.5; //start of drill holes
    d=3.5;
    D=6; //diameter of countersink
    h=3.5; //depth of countersink
    rad=0.5;
    drillStart=length/P;
    cntrOffset= (center) ? [0,0,0] : [length/2,wr/2,hr/2];
    
    translate([0,0,hr/2]) difference(){
      rotate([90,0,90]) rndCube([wr,hr,length],rad,center);
      
      for (ix=[-length/2+E:P:length/2-E]) translate([ix,0,0]+cntrOffset){
        cylinder(d=d,h=hr+fudge,center=true);
        translate([0,0,hr/2-h]) cylinder(d=D,h=h+fudge);
      }
    }
  }

  module block(){
    rad=1;
    
    translate([0,0,(H-H1)/2]) difference(){
      rotate([0,90,0]) rndCube([H-H1,W,L],rad,true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*C/2,iy*B/2,(H-H1)/2-MxL[1]]) cylinder(d=MxL[0],h=MxL[1]+fudge);
    }
  }//block
}

module MGN12(length=300,pos=0.2,type="H",center=true){
  //RDBB/CNA linear rails CNA Store
  //https://de.aliexpress.com/store/group/MGN12-and-MGW12/1452393_259128619.html
  
  // travel length is rail_length-block_length(L)!

  //ASY
  H=13;
  H1=3;
  N=7.5;

  //Block Dimensions
  W=27;
  B=20;
  B1=3.5;
  C= (type=="H") ? 20 : 15; //Block Drill distance X
  L1=(type=="H") ? 32.4 : 21.7; //Block length of contact plate
  L= (type=="H") ? 45.4 : 34.7; //Block overall length
  Gs=2;
  MxL=[3,3.5];

  travel=length-L;
  if ($children)
    translate([-travel/2+pos*travel,0,0]) children();
  else{
    color("silver") rail();
    color("lightGrey") translate([-travel/2+pos*travel,0,H1]) block();
  }

  module rail(){
    wr=12; //width of rail
    hr=8; //height of rail
    P=25; //drill hole Pitch
    E=10; //start of drill holes
    d=3.5;
    D=6; //diameter of countersink
    h=4.5; //depth of countersink
    rad=0.5;
    drillStart=length/P;
    cntrOffset= (center) ? [0,0,0] : [length/2,wr/2,hr/2];
    
    translate([0,0,hr/2]) difference(){
      rotate([90,0,90]) rndCube([wr,hr,length],rad,center);
      
      for (ix=[-length/2+E:P:length/2-E]) translate([ix,0,0]+cntrOffset){
        cylinder(d=d,h=hr+fudge,center=true);
        translate([0,0,hr/2-h]) cylinder(d=D,h=h+fudge);
      }
    }
  }

  module block(){
    rad=1;
    
    translate([0,0,(H-H1)/2]) difference(){
      rotate([0,90,0]) rndCube([H-H1,W,L],rad,true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*C/2,iy*B/2,(H-H1)/2-MxL[1]]) cylinder(d=MxL[0],h=MxL[1]+fudge);
    }
  }//block
}

module MGW12(length=300,pos=0.2,type="H",center=true){
  //RDBB/CNA linear rails 
  //https://de.aliexpress.com/store/group/MGN12-and-MGW12/1452393_259128619.html
  
  //ASY
  H=14;
  H1=3.4;
  N=8;
  
  //Rail
  
  //Block
  W=40;
  B=28;
  B1=6;
  C= (type=="H") ? 28 : 15; //Drill distance X
  L1=(type=="H") ? 45.6 : 31.3; //length of contact plate
  L= (type=="H") ? 60.4 : 46.1; //overall length
  Gs=1.4;
  MxL=[3,3.6];

  travel=length-L;
  if ($children)
    translate([-travel/2+pos*travel,0,0]) children();
  else{
    color("silver") rail();
    color("lightGrey") translate([-travel/2+pos*travel,0,H1]) block();
  }

  module rail(){
    wr=24; //width of rail
    hr=8.5; //height of rail
    P=40; //drill hole Pitch
    E=15; //start of drill holes
    d=3.5;
    D=8; //diameter of countersink
    h=4.5; //depth of countersink
    rad=0.5;
    drillStart=length/P;
    cntrOffset= (center) ? [0,0,0] : [length/2,wr/2,hr/2];
    
    translate([0,0,hr/2]) difference(){
      rotate([90,0,90]) rndCube([wr,hr,length],rad,center);
      
      for (ix=[-length/2+E:P:length/2-E]) translate([ix,0,0]+cntrOffset){
        cylinder(d=d,h=hr+fudge,center=true);
        translate([0,0,hr/2-h]) cylinder(d=D,h=h+fudge);
      }
    }
  }

  module block(){
    rad=1;
   
    
    translate([0,0,(H-H1)/2]) difference(){
      rotate([0,90,0]) rndCube([H-H1,W,L],rad,true);
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*C/2,iy*B/2,(H-H1)/2-MxL[1]]) cylinder(d=MxL[0],h=MxL[1]+fudge);
    }
  }//block
}

module rndCube(size=[20,10,50],rad,center=false){
    cntrOffset= (center) ? [0,0,0] : size/2;
    translate(cntrOffset) linear_extrude(height=size.z,center=true) hull() for (ix=[-1,1],iy=[-1,1])
      translate([ix*(size.x/2-rad),iy*(size.y/2-rad)]) circle(rad);
}