#! /bin/bash

zbarimg -q --raw $1

exit 0

FILENAME="$TMPDIR$RANDOM.png"   # Generates a file name
pngpaste "$FILENAME"            # Paste screenshot into file
zbarimg -q --raw "$FILENAME"    # Will try to decode QR-code
rm -rf "$FILENAME"              # Removi
