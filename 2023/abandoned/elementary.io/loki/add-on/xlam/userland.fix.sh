#!/bin/sh

exit 0

# rescect to http://mykubik.blogspot.ru/2016/12/elementary-os-loki.html

### Acceleration - disable animations
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.pantheon.desktop.gala.animations enable-animations false
killall wingpanel

### Double-click on Files
gsettings set org.pantheon.files.preferences single-click false

### Disable dynamic workspaces
gsettings set org.pantheon.desktop.gala.behavior dynamic-workspaces false

### Disable transparency on wingpanel
#gsettings set org.pantheon.desktop.wingpanel use-transparency false

#sudo add-apt-repository ppa:andreas-angerer89/sni-qt-patched
#sudo apt update
#sudo apt install sni-qt hardcode-tray
#hardcode-tray -ug
#hardcode-tray -s 24 -ct Inkscape


### Fix Qt4/Qt5-apps
#sudo apt install libqt4-svg qt5ct
#sudo sh -c "echo 'export QT_QPA_PLATFORMTHEME=qt5ct' > /etc/profile.d/qt-style-override.sh"

### Enable UFW
#sudo sh -c 'echo allow-guest=false >> /etc/lightdm/lightdm.conf'

