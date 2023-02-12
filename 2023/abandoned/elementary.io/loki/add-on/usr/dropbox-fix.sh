#!/bin/sh

sudo apt --purge remove -y dropbox*
sudo apt -y install git python-gpgme
git clone https://github.com/zant95/elementary-dropbox /tmp/elementary-dropbox
sudo bash /tmp/elementary-dropbox/install.sh

cd /home/brj

sudo chown -R brj:brj .dropbox-bin 
sudo chown -R brj:brj .dropbox-dist

cd /home/brj/bin
curl -v https://linux.dropbox.com/packages/dropbox.py > /home/brj/bin/drb
chmod 755 drb

echo do chmod for `whoami`
