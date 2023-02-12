#/bin/sh

sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop

# dont forget

exit

/usr/share/applications/ololo

[Desktop Entry]
Type=Application
Name=StartupApps
Comment=View apps starting with the system
GenericName=StartupApps
Icon=preferences-system
Terminal=false
Categories=Gnome;Gtk;System;
Exec=gnome-session-properties