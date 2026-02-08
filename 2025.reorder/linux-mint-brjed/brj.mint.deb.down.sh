#!/bin/bash -x

export DEBIAN_FRONTEND=noninteractive

# need run? fix me

exit 0

mkdir -p /tmp/debs
cd /tmp/debs

rm -rf /tmp/debs/debs.txt

# get my good's

tee <<EOF /tmp/debs/debs.txt >/dev/null
https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
https://zoom.us/client/latest/zoom_amd64.deb
https://www.rescuetime.com/installers/rescuetime_current_amd64.deb
https://mega.nz/linux/MEGAsync/xUbuntu_20.04/amd64/nemo-megasync-xUbuntu_20.04_amd64.deb
https://mega.nz/linux/MEGAsync/xUbuntu_20.04/amd64/megasync-xUbuntu_20.04_amd64.deb
https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-1.24-Update7-Ubuntu-20.04-amd64.deb
https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-console-1.24-Update7-Ubuntu-20.04-amd64.deb
https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
https://github.com/muesli/duf/releases/download/v0.6.2/duf_0.6.2_linux_amd64.deb
https://www.xmind.net/zen/download/linux_deb/
https://github.com/jgraph/drawio-desktop/releases/download/v14.9.6/drawio-amd64-14.9.6.deb
https://github.com/Kong/insomnia/releases/download/core@2021.5.3/Insomnia.Core-2021.5.3.deb
https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_95.0.1020.44-1_amd64.deb
https://github.com/rs/curlie/releases/download/v1.6.7/curlie_1.6.7_linux_amd64.deb
https://github.com/PowerShell/PowerShell/releases/download/v7.2.0/powershell-lts_7.2.0-1.deb_amd64.deb
EOF

aria2c \
    --dir=/tmp/debs --input-file=/tmp/debs/debs.txt -j 5 --connect-timeout=60 \
    --human-readable=true --download-result=full --file-allocation=none \
    --summary-interval=15

echo "pochti. all done"

exit 0

cd /tmp/debs
dpkg -i *.deb
sudo apt -y --fix-broken install
