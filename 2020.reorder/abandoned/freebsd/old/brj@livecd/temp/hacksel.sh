#!/bin/sh
/usr/bin/dialog --title "brj@livecd - ����� �����" --clear \
--checklist "  ��� ���� ��������� � ��������� �� �����������
��������, ��, ��� �� ������ �������� �� brj@livecd" -1 -1 10 \
"000-required-clean-livecd.sh" "" off \
"000-required-integrate-live-rc.conf.sh" "" off \
"brj-add-mymp3-to-livecd.sh" "" off \
2> /usr/local/brj@livecd/temp/hacks
