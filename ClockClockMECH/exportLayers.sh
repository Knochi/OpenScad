#!/bin/bash

for i in {0..4}; do
  echo "exporting Layer $i"
  flatpak run org.openscad.OpenSCAD -o clockClock24_L${i}.svg -D "export=\"Layer$i\"" ClockClock24_MECH.scad
done
