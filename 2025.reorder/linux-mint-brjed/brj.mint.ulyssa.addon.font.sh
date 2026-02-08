#!/bin/bash -x

export DEBIAN_FRONTEND=noninteractive

# need run? fix me

exit 0

# https://github.com/ryanoasis/nerd-fonts/releases

mkdir -p ~/.local/share/fonts/
cd ~/.local/share/fonts/
mkdir -p /tmp/fonts
cd /tmp/fonts

# get the goods

tee <<EOF /tmp/fonts/fonts.txt >/dev/null
https://github.com/be5invis/Iosevka/releases/download/v4.5.0/ttf-iosevka-4.5.0.zip
https://github.com/be5invis/Iosevka/releases/download/v4.5.0/ttf-iosevka-fixed-4.5.0.zip
https://github.com/microsoft/cascadia-code/releases/download/v2106.17/CascadiaCode-2106.17.zip
https://github.com/tonsky/FiraCode/releases/download/5.2/Fira_Code_v5.2.zip
https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/IBMPlexMono.zip
EOF

aria2c \
    --dir=/tmp/fonts --input-file=/tmp/fonts/fonts.txt -j 5 --connect-timeout=60 \
    --human-readable=true --download-result=full --file-allocation=none \
    --summary-interval=15

unzip -j '*.zip'

cp -Rv /tmp/fonts/*.ttf ~/.local/share/fonts/

echo "copy font to ~/.local/share/fonts/"
echo "unpack and run fc-cache -fv"

fc-cache -fv

echo "all done"
