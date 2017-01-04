#!/bin/sh

# mylogin ololo
# mypass ololo

rm /root/zalupa/balans.txt
curl -d"login=ololoev&pass=djigurda"  https://stat.orionnet.ru/ > /root/zalupa/balans.txt
balan=`cat /root/zalupa/balans.txt | grep руб | /usr/bin/sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | head -n 1`

curl -d "text=орион чокопай, л/с 1234, баланс $balan" http://sms.ru/sms/send\?api_id=ololo
echo "орион чокопай, л/с 1234, баланс $balan" | mail -s "орион чокопай, л/с 1234, баланс $balan" ololoev@djigurda.ru
rm /root/zalupa/balans.txt

