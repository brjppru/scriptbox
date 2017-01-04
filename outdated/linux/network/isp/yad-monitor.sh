#!/bin/sh

# yandex direct monitor balance

# Баланс ЯД: 340.54 у.е.
# Ср. расход за день, у.е. 26.18 у.е.
# Ср. цена клика за день 0.42 у.е.

# define login here

ULOGIN="ololoev"
LOGIN="ololoev"%"40yandex.ru"
PASS="djigurda"
CMPNUM="1005002"

# end defune

# авторизовались
/usr/bin/curl -s -c /tmp/yam-cookie "https://passport.yandex.ru/passport?mode=auth" --data "login=$LOGIN&passwd=$PASS&retpath="

# вытащили баланс
/usr/bin/curl -s -b /tmp/yam-cookie "https://direct.yandex.ru/registered/main.pl?cmd=showCampStat&detail=Yes&types=days&cid=$CMPNUM&ulogin=$ULOGIN" > /root/yad-proem/yad.html

# дампаем в текст, что вытащили 
links -dump /root/yad-proem/yad.html > /root/yad-proem/yad.txt

echo "Балансы ЯД [$CMPNUM] `date`" > /root/yad-proem/fin-balance.txt
echo " " >> /root/yad-proem/fin-balance.txt

cat /root/yad-proem/yad.txt | grep "Ostalos" | awk ' {print "Баланс ЯД: " $4 " у.е." }' >> /root/yad-proem/fin-balance.txt
cat /root/yad-proem/yad.txt | grep "Vsego po kampanii" -A 3 > /root/yad-proem/yad-clck.txt
cat /root/yad-proem/yad-clck.txt | sed 'N;s/\n/ - /' | sed 'N;s/\n/ - /' | awk ' {print "Ср. расход за день, у.е. " $28 " у.е." }' >> /root/yad-proem/fin-balance.txt
cat /root/yad-proem/yad-clck.txt | sed 'N;s/\n/ - /' | sed 'N;s/\n/ - /' | awk ' {print "Ср. цена клика за день " $35 " у.е." }' >> /root/yad-proem/fin-balance.txt

rm /root/yad-proem/yad.txt
rm /root/yad-proem/yad.html
rm /root/yad-proem/yad-clck.txt

cat /root/yad-proem/fin-balance.txt | mail -s "[баланс] ЯД [$CMPNUM] `date`" ololoev@djigurda.ru

rm /root/yad-proem/fin-balance.txt

rm /tmp/yam-cookie
