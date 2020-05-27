edgeLen=100;
beamWdth=20;
wallThck=2;

//inEdgeLen=edgeLen-beamWdth*2;

$vpr=[55,0,45];
//big cube
SQCube(edgeLen,beamWdth);

//this could have been better, but it's late and I'm tired
translate([-(edgeLen+wallThck)/2,(edgeLen+wallThck)/2,-(edgeLen+wallThck)/2]) 
  for (ir=[[0,0,0],[0,-90,0],[0,0,-90]])
    rotate(ir) translate([edgeLen/2,0,0]) cube([edgeLen+wallThck,wallThck,wallThck],true);

  
//small cube
translate([-(beamWdth)/2,beamWdth/2,-beamWdth/2]) 
  rotate([180,0,90]) SQCube(edgeLen-beamWdth,beamWdth,true);


module SQCube(size=100,beamWdth=25,open=false){
  inSize=size-beamWdth*2;
  wallOffset= open ? wallThck : -wallThck;
  translate([0,0,-(size-wallOffset)/2]) rotate([0,0,-90])  frame();
  translate([-(size-wallOffset)/2,0,0]) rotate([90,0,-90]) frame();
  translate([0,(size-wallOffset)/2,0])  rotate([90,0,0])   frame();


  module frame(){
    dSize=size*sqrt(2);
    dBeamWdth=beamWdth*sqrt(2);
    
    linear_extrude(height=wallThck,center=true){
      difference(){
        square([size,size],true);
        square([inSize,inSize],true);
        if (open){
          rotate(45) translate([0,-dBeamWdth/2]) square([dSize,dBeamWdth]);
        }
      }
      if (open){
        translate([wallThck/2,(size+wallThck)/2]) square([size+wallThck,wallThck],true);
        translate([(size+wallThck)/2,wallThck/2]) square([wallThck,size+wallThck],true);
      }
    }
  }
}