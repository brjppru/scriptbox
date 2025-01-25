C:\PROGRA~1\cmdow.exe @ /HID
@echo off

reg delete HKCU\software\hewlett-packard /f
c:
cd "C:\Program Files (x86)\1cv82\8.2.15.289\bin"
start /wait 1cv8.exe
reg delete HKCU\software\hewlett-packard /f
logoff
