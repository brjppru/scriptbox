#!/bin/bash -x

export DEBIAN_FRONTEND=noninteractive

# need run? fix me

exit 0

# data format for clock
# [%V/%j] %Y-%m-%d  %H:%M

sudo systemctl enable fstrim.timer

sudo update-alternatives --config editor
sudo update-alternatives --config x-terminal-emulator
gsettings set org.gnome.rhythmbox.plugins.iradio initial-stations-loaded false

mkdir ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys

git config --global user.name "Grzegorz Brzęczyszczykiewicz"
git config --global user.email sam@brj.pp.ru
git config --global color.ui true
git config --global core.editor mcedit

# fuse for sshfs
sudo groupadd fuse
sudo usermod -aG fuse $USER

# pulseaudiofix
sudo usermod -aG davfs2 $USER

#2todo sed replace
#В " _/etc/pulse/daemon.conf_ " прописать
#
#> default-sample-rate = 48000  
#> avoid-resampling = yes

#systemctl enable fstrim.timer

echo "all done"