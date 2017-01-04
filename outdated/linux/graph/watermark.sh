#!/bin/sh

mkdir converted

for i in *.[jJ][pP][gG]
do
convert $i -resize 800x600 -font helvetica -pointsize 16 -draw «gravity SouthEast fill gray text 0,1 'www.slk.by' fill white text 1,0 'www.slk.by' » converted/`basename "$i" .JPG`.jpg && \
exiftool -overwrite_original -Copyright='www.slk.by' converted/`basename "$i" .JPG`.jpg
done

