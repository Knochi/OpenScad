//remix of https://www.printables.com/de/model/761814-tft35-e3-v3-slimline-case-wt-magnetic-mount
//replace magnetic mount by actuated arm

/* [showOriginal] */
showOrigPCB=true;
showOrigMain=true;
showOrigLeft=true;
showOrigRight=true;

/* [Dimensions] */


/* [Hidden] */
fudge=0.1;

if (showOrigPCB)
  color("darkslateGrey") import("TFT35_E3_V3_PCB.stl");
if (showOrigMain)
  color("orange") import("TFT35-MainBody.stl");
if (showOrigLeft)
  color("darkOrange") import("TFT35-lefthand-Cap.stl");
if (showOrigRight)
  color("darkOrange") import("TFT35-righthand-Cap.stl");