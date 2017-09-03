#!/bin/bash

# https://www.atareao.es/ubuntu/raspberry-como-servidor-de-impresion/

if [ "$(whoami)" != "root" ]; then
    echo "Run script as ROOT please. (sudo !!)"
    exit
fi

echo "=== Updating Raspberry ==="
apt update -y
apt upgrade -y

echo "=== Installing cups ==="
apt install -y cups cups-pdf printer-driver-gutenprint

echo "=== our user pi in lpadmin group ==="
usermod -aG lpadmin pi

echo "=== Configure cups to listen on the LAN"
sed -i "s|Listen localhost:631|Port 631|g" /etc/cups/cupsd.conf

echo "=== Allow LAN access to CUPS"
sed -i "s|</Location>|Allow all\n</Location>|g" /etc/cups/cupsd.conf

echo "=== Enable print sharing and remote administration ==="
cupsctl --share-printers --remote-admin
sed -i "s|Shared No|Shared Yes|g" /etc/cups/printers.conf
lpoptions -d PDF -o printer-is-shared=true

echo "=== Enable automatic retrying of failed print jobs ==="
sed -i -e "s|BrowseAddress|ErrorPolicy retry-job\nJobRetryInterval 30\nBrowseAddress|g" /etc/cups/cupsd.conf

echo "=== Restart cups ==="
/etc/init.d/cups restart
