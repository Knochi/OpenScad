/* Sources:
  Design of a Microbiota Sampling Capsule using 3D-Printed Bistable Mechanism
  https://hal-lirmm.ccsd.cnrs.fr/lirmm-02020447/file/Version%20finale%20EMBC%202018.pdf
  Q=h/t ≥ 6
  ftop=1480 x Elh/L³
  fbot=740 x Elh/L³
  
  Fidget Slider
  https://makerworld.com/de/models/559324 - doesn't work!
*/

module bistableBridge(){
  b=2.1;
  t=0.35;
  L=18;
  h=2.4;
}

import("body_fidget.stl");