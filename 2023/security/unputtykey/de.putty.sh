#!/bin/sh

mkdir -p ~/.ssh/

for X in *.ppk; do puttygen $X -L > ~/.ssh/$(echo $X | sed 's,./,,' | sed 's/.ppk//g').pub; 
puttygen $X -O private-openssh -o ~/.ssh/$(echo $X | sed 's,./,,' | sed 's/.ppk//g').pvk; 
done;

