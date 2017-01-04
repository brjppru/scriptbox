#!/bin/sh

exit

#--debug \
#--debugimap \


/root/bin/mail/imapsync \
--timeout 300 \
--logfile /tmp \
--tmpdir /tmp \
--useuid \
--expunge2 \
--delete2 \
--skipsize \
--subscribe_all \
--delete2duplicates \
--host1 brj.pp.ru --user1 sam@ololo.ru --password1 123 --ssl1 --port1 993 \
--host2 imap.yandex.com --user2 dr@dre.ru --password2 zypLb --ssl2 --port1 993

