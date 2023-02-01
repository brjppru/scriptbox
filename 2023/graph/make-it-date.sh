#!/bin/sh

ARCHIVE=$HOME/photos

for f in "$@"; do
DT=$(exiftool -s -DateTimeOriginal "$f")
YEAR=$(echo $DT|awk '{print $3;}'|awk -F: '{print $1;}')
ISODAY=$(echo $DT|awk '{print $3;}'|sed 's/://g')
TARGET="$ARCHIVE/$YEAR/$ISODAY"
install -d "$TARGET" && \
install "$f" "$TARGET"
echo "$f -> $TARGET"
done

