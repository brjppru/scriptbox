#!/bin/sh
/usr/bin/dialog --title "brj@livecd - выбор хаков" --clear \
--checklist "  Это хаки доступные к установке на дистрибутив
Выберите, те, что вы хотите добавить на brj@livecd" -1 -1 10 \
"000-required-clean-livecd.sh" "" off \
"000-required-integrate-live-rc.conf.sh" "" off \
"brj-add-mymp3-to-livecd.sh" "" off \
2> /usr/local/brj@livecd/temp/hacks
