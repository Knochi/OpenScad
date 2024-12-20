layerHght=0.08;
baseHght=0.2;
layers=4;

layerColors=["red","blue","green","yellow"];

for (layer=[1:layers])
  color(layerColors[layer-1]) translate([0,0,(layer-1)*layerHght]) 
    linear_extrude(layerHght) import(str("Poisel_Layer",str(layer),".svg"));

