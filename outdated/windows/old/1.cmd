@echo off

rem ���������� ������� ��������� CP866, � �� �������� ������ �����
chcp 866

rem ������� tester � ������� ����
net user tester huev /add

rem ���������� ������� ������ Admin � ������ ��������������
net localgroup �������������� tester /add

rem ������� ����� ������� ��������
net localgroup "������������ ���������� �������� �����" tester /add

rem ������ �� ��� ������
net user tester /expires:15.09.2013

rem ����� ������ � 1� 
net user tester /scriptpath:logon.bat

rem �������� ��� ������
net user tester

pause
