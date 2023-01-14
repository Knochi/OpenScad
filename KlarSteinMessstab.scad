/* [Parameters] */
barDims=[25,1000,2]; //Dimensions of the raw bar to engrave
subStrokeDims=[10,0.3];
mainStrokeDims=[20,0.6];
firstStrokeOffset=7;
textOffset=[0,1];
textSize=8;
kettleDia=280;
litresPerDiv=1; //litres per division
litresPerSubdiv=0.2; //litres per sub-division
maxLitres=30; //maximum litres

/* [Hidden] */
mmPerDiv=litres2height(litresPerDiv,kettleDia);
mmPerSubdiv=litres2height(litresPerSubdiv,kettleDia);


color("grey") cube(barDims);
color("lightgrey") translate([0,0,barDims.z]) linear_extrude(0.1)
for (i=[1:(maxLitres/litresPerSubdiv)]){
  //if (mmPerDiv/i*mmPerSubDiv)
  if (i*litresPerSubdiv%(litresPerDiv)) //subDiv
    translate([0,i*mmPerSubdiv-subStrokeDims.y/2]) square(subStrokeDims);
  else //mainDiv
    translate([0,i*mmPerSubdiv]){
      translate([0,-mainStrokeDims.y/2]) square(mainStrokeDims);
      translate([subStrokeDims.x,0]+textOffset) text(str(i*litresPerSubdiv),size=textSize);
    }
}

echo(mm2Litres(470,280));

echo(litres2height(28.9,280));

function mm2Litres(height,dia)=pow(dia/200,2)*PI*height/100;

function litres2height(litres,dia)=litres/(pow(dia/200,2)*PI/100);