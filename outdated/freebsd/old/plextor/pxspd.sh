#!/bin/sh

# this script set speed Plextor Ultraplex40Max cdrom speed
# (c) Roman Y. Bogdanov

camcontrol cmd cd1 -v -c "15 10 0 0 8 0" -o 8 "0 0 0 0 31 2 04 0"

