@echo off

echo Y | del d:\file.backup\*.rar

C:\WINDOWS\backup\rar.exe a -r -m0 d:\file.backup\document-%date:~-10%.rar f:\document
C:\WINDOWS\backup\rar.exe a -r -m0 d:\file.backup\1c.rar-%date:~-10%.rar f:\1c
C:\WINDOWS\backup\rar.exe a -r -m0 d:\file.backup\right.rar-%date:~-10%.rar f:\right
C:\WINDOWS\backup\rar.exe a -r -m0 d:\file.backup\katalog-%date:~-10%.rar f:\katalog

"c:\Program Files\WinRAR\Rar.exe" a -r -agDD-MM-YY -dh -m0 -Y -ep2 c:\backup\1C- r:\
rem "c:\Program Files\WinRAR\Rar.exe" a -r -agDD-MM-YY -dh -m0 -Y -ep2 -x*.mp3 -x*.avi -x*.mp4 c:\backup\docs x:\

