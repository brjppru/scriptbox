#!/bin/sh

find . -depth -maxdepth 1 -type f | while read -r name; do mv -v "$name" "`echo $name |tr '[A-Z]' '[a-z]'`"; done