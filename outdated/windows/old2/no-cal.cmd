@echo off

echo "kill all cal license from desktop"

reg delete "HKLM\SOFTWARE\Microsoft\MSLicensing" /f
reg delete "HKLM\SOFTWARE\Microsoft\MSLicensing" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\MSLicensing" /f

pause


