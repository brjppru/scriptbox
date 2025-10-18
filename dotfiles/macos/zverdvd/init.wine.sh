#!/bin/sh

exit 0

winecfg >/dev/null 2>&1 || true

winetricks -q corefonts tahoma
winetricks -q settings fontsmooth=rgb

cat > /tmp/fontfix.reg <<'REG'
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes]
"MS Shell Dlg"="Tahoma"
"MS Shell Dlg 2"="Tahoma"
"Microsoft Sans Serif"="Tahoma"
REG

wine regedit /S /tmp/fontfix.reg
rm -f /tmp/fontfix.reg

winetricks -q gdiplus || true
