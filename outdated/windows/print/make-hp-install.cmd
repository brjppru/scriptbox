@echo off

rem C:\WINDOWS\system32\wiaacmgr.exe -SelectDevice

rem psexec.exe \\адрес_ПК -u admin -p pass -e -c install_HP.bat 
rem Либо psexec.exe \\* -u admin -p pass -e -c install_HP.bat на все компы подсети 

rem Удаление всех установленных принтеров 
//cscript %windir%\system32\prnmngr.vbs -x 
rem Удаление порта IP_192.168.0.151 
//cscript %windir%\system32\prnport.vbs -d -r IP_192.168.0.151 
rem Нужное раскомментировать 
 
rem IP адрес принтера 
SET PRINTER_IP=192.168.0.151 
rem Имя порта 
SET PRINTER_PORT=IP_192.168.0.151 
rem Протокол 
SET PRINTER_MODE=LPR 
rem Отображаемое имя принтера 
SET PRINTER_NAME=HP_LJ_M2727_BUH_1 
 
cscript %windir%\system32\prnport.vbs -g -r %PRINTER_PORT%|find "%PRINTER_PORT%" >nul 
If NOT %ERRORLEVEL%==0 ( 
    cscript %windir%\system32\prnport.vbs -a -h %PRINTER_IP% -r %PRINTER_PORT% -o %PRINTER_MODE% 
    rundll32 printui.dll,PrintUIEntry /if /b "%PRINTER_NAME%" /f "\\путь до диска с драйверами\hppcp607.inf" /r "IP_192.168.0.151" /m "HP LaserJet M2727 MFP Series PCL 6" 
    rem Установка принтера по умолчанию 
    rundll32 printui.dll,PrintUIEntry /y /n "%PRINTER_NAME%" 
) 

rem Если что не понятно курим справку по (prnport.vbs), (prnmngr.vbs) и (rundll32 printui.dll,PrintUIEntry) 
