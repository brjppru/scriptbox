#!/bin/sh

# --------------->
# MTS query
# --------------->

mts_bal()
{

curl -s --ssl -L -c /tmp/mts-cookie --data-urlencode username=$LOGIN --data-urlencode password=$PASS https://ihelper.sib.mts.ru/SelfCarePda/Security.mvc/LogOn?returnLink=https%3A%2F%2Fihelper.sib.mts.ru%2FSelfCarePda%2FHome.mvc > /root/zalupa/balans.txt

echo "$NAMED" > /root/zalupa/$LOGIN
cat /root/zalupa/balans.txt | grep телефон | sed 's/[a-z<>\/]//g' | sed 's/^.*телефон/телефон/' >> /root/zalupa/$LOGIN
cat /root/zalupa/balans.txt | grep Баланс | sed 's/[a-z<>\/]//g' | sed 's/^.*Баланс/Баланс/' >> /root/zalupa/$LOGIN
cat /root/zalupa/$LOGIN | sed ':a; /$/N; s/\n/ /; ta' > /root/zalupa/$LOGIN.txt

curl -s --ssl -L -b /tmp/mts-cookie https://ihelper.sib.mts.ru/SelfCarePda/Security.mvc/LogOff --output /dev/null
rm /tmp/mts-cookie
rm /root/zalupa/balans.txt
rm /root/zalupa/$LOGIN
}

# query mts

LOGIN="9139139133"; PASS="123123"; NAMED="Моя симка"; mts_bal
