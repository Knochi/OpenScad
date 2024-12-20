ovDims=[82,178];
layerHght=0.08;
baseHght=0.2;
layers=4;

/* [show] */
showLayer="all"; //["all":0,1,2,3,4]
layerColors=["black","red","blue","green","yellow"];

if (showLayer=="all"){
  for (layer=[0:layers])
    oneLayer(layer);
}
else
  oneLayer(showLayer);

module oneLayer(layer=1){
  if (layer==0)
    linear_extrude(baseHght) square(ovDims);
  else
  color(layerColors[layer]) translate([0,0,(layer-1)*layerHght+baseHght]) 
    linear_extrude(layerHght) import(str("Poisel_Layer",str(layer),".svg"));
}