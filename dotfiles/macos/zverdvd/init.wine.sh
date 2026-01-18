#!/bin/sh

if [ "${WINE_INIT_ENABLED:-0}" -ne 1 ]; then
    echo "[init] INFO: init.wine.sh disabled; set WINE_INIT_ENABLED=1 to run"
    exit 0
fi

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
