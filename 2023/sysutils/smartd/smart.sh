#!/bin/sh

for drive in /sys/block/sd*; do drive="/dev/$(basename $drive)"; echo "$drive:"; smartctl -l scterc $drive; done

