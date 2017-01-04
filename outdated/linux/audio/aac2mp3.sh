#!/bin/bash

for f in *.aac; do
    newf=`echo $f | sed -e 's/\.aac/\.mp3/'`
    echo "$f -> $newf"
    faad -q -o - "$f" | lame -h -b 192 - "$newf"
done
