#!/bin/sh

export LC_ALL=C

etk_bal()
{

/usr/bin/curl -s -c /tmp/etk-cookie -d "mobnum=$LOGIN&Password=$PASS" 'https://issa.etk.ru/cgi-bin/cgi.exe?function=is_login' > /root/zalupa/login

/usr/bin/curl -s -b /tmp/etk-cookie -d "mobnum=$LOGIN&Password=$PASS" 'https://issa.etk.ru/cgi-bin/cgi.exe?function=is_account' > /root/zalupa/balans

echo "$NAMED" > /root/zalupa/$LOGIN
echo "телефон: $LOGIN" >>/root/zalupa/$LOGIN
cat /root/zalupa/balans | grep ISSABalance | sed 's/=/ = /' | awk ' {print "Баланс: " $3 " руб." } ' >> /root/zalupa/$LOGIN
cat /root/zalupa/$LOGIN | sed ':a; /$/N; s/\n/ /; ta' > /root/zalupa/$LOGIN.txt

rm /root/zalupa/balans
rm /root/zalupa/login
rm /tmp/etk-cookie
rm /root/zalupa/$LOGIN

}

# query etk

LOGIN="9029900000"; PASS="123123"; NAMED="Моя симка"; etk_bal
