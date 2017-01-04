@echo off
rundll32 printui.dll,PrintUIEntry /Xg /n"Canon iR2018 UFRII dLT" /q /f"%temp%\results.txt"
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Print\Printers\Canon iR2018 UFRII LT" %temp%\canon.reg /y
if %errorlevel% == 0 goto end
if %processor_architecture% == AMD64 goto amd-64
regedit /S \\servergw\distr\prn-deploy\port.reg
net stop spooler
net start spooler
rundll32 printui.dll,PrintUIEntry /if /b "Canon iR2018 UFRII LT" /f "\\servergw\distr\driver\CNLB0R.inf" /r "IP_192.168.0.76" /m "Canon iR2018 UFRII LT" /z /u /q
goto end
:amd-64
regedit /S \\servergw\distr\prn-deploy\vista-7.reg
net stop spooler
net start spooler
rundll32 printui.dll,PrintUIEntry /if /b "Canon iR2018 UFRII LT" /f "\\servergw\distr\x64\driver\CNLB0RA64.inf" /r "192.168.0.76" /m "Canon iR2018 UFRII LT" /z /u /q
:end

