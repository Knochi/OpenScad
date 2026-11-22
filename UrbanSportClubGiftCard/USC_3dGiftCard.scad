

filenames=["USC_GiftCard_Bottom.svg","USC_GiftCard_Black.svg","USC_GiftCard_Yellow Thick.svg","USC_GiftCard_Yellow Thinn.svg","USC_GiftCard_YellowOnBlack.svg"];
colors=["white","black","khaki","lightgoldenrodyellow"];
zPos=[0,1.2,1.2,1.2,1.8];
layerThck=[1.2,0.6,0.6,0.2,0.2];

for (i=[0:len(filenames)-1])
  translate([0,0,zPos[i]]) color(colors[i]) linear_extrude(layerThck[i]) import(filenames[i]);
