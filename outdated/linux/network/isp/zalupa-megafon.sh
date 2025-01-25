#!/bin/sh

export LC_ALL=C

# --------------->
# MEGA query
# --------------->

mega_bal()
{

curl -s "https://sibsg.megafon.ru/ROBOTS/SC_TRAY_INFO?X_Username=$LOGIN&X_Password=$PASS" > /root/zalupa/balans

echo "$NAMED" > /root/zalupa/$LOGIN
echo "телефон: $LOGIN" >>/root/zalupa/$LOGIN
cat /root/zalupa/balans | grep BALANCE | head -n 1 | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | awk ' {print "Баланс: " $1 " руб." } ' >> /root/zalupa/$LOGIN
cat /root/zalupa/$LOGIN | sed ':a; /$/N; s/\n/ /; ta' > /root/zalupa/$LOGIN.txt

rm /root/zalupa/balans
rm /root/zalupa/$LOGIN

}

# ------------->
# query mega
# ------------->

LOGIN="9291111111"; PASS="111111"; NAMED="баланс мегафон"; mega_bal

