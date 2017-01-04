@echo off
regedit /S \\servergw\distr\prn-deploy\port.reg
net stop spooler
net start spooler
rundll32 printui.dll,PrintUIEntry /if /b "Canon iR2018 UFRII LT" /f "\\servergw\distr\driver\CNLB0R.inf" /r "IP_192.168.0.76" /m "Canon iR2018 UFRII LT" /z /u /q
