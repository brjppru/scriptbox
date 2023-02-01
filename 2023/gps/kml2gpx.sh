#!/bin/bash

# see http://www.gpsies.com/convert.do

for file in *.kml; do 
  gpsbabel -i kml -f "$file" -x track,faketime=201310130001 -o gpx -F "${file}.gpx"
done

