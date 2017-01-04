@echo off

rem установить кодовую стараницу CP866, а то русскому придет пизда
chcp 866

rem завести tester с паролем хуев
net user tester huev /add

rem Добавление учетной записи Admin в группу Администраторы
net localgroup Администраторы tester /add

rem тестеру можно входить удаленно
net localgroup "Пользователи удаленного рабочего стола" tester /add

rem тестер на две недели
net user tester /expires:15.09.2013

rem логон скрипт к 1С 
net user tester /scriptpath:logon.bat

rem показать что завели
net user tester

pause
